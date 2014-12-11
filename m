Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaLKOXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:23:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552AbaLKOXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:23:05 -0500
Message-ID: <5489A8B9.5000303@redhat.com>
Date: Thu, 11 Dec 2014 15:22:49 +0100
From: Jan Stancek <jstancek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: acme@redhat.com, jolsa@kernel.org, dsahern@gmail.com,
        cjashfor@linux.vnet.ibm.com, dsahern@gmail.com, fweisbec@gmail.com,
        mingo@kernel.org, namhyung@kernel.org, paulus@samba.org,
        a.p.zijlstra@chello.nl, adrian.hunter@intel.com
Subject: perf test "object code reading" occasionally fails
Content-Type: multipart/mixed;
 boundary="------------040209040301050401010008"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040209040301050401010008
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

I see this testcase occasionally failing. After reproducing it with
verbose output and checking objdump output I found at least 3 scenarios
where data read from objdump output does not match:

1. same byte is repeated in objdump output
Note that byte at ffffffff815cf071 is in output twice

    ffffffff815cf06e <sysret_check+0x4b>:
    ffffffff815cf06e:       24 2f                   and    $0x2f,%al
    ffffffff815cf070:       00 0f                   add    %cl,(%rdi)

    ffffffff815cf071 <sysret_careful>:
    ffffffff815cf071:       0f ba e2 03             bt     $0x3,%edx
    ffffffff815cf075:       73 11                   jae

2. objdump output can span across multiple sections
For example in case of libcrc32c.ko and start_address=8 .text
sections ends at 6b, but test continues to read output from
.init.text:

Disassembly of section .text:
  0000000000000008 <crc32c+0x8>:
     8:	48 89 e5             	mov    %rsp,%rbp
     b:	53                   	push   %rbx
     c:	8b 01                	mov    (%rcx),%eax
  ...
    6b:	90                   	nop

  Disassembly of section .init.text:
  0000000000000008 <init_module+0x8>:
     8:	00 00                	add    %al,(%rax)
     a:	00 00                	add    %al,(%rax)
     c:	48 89 e5             	mov    %rsp,%rbp

3. gaps in output
For example, note that byte at ffffffff81670500 is missing:

ffffffff816704fe <sysret_check+0x4b>:
ffffffff816704fe:	7b 34                	jnp    ffffffff81670534 <sysret_signal+0x1c>
	...

ffffffff81670501 <sysret_careful>:
ffffffff81670501:	0f ba e2 03          	bt     $0x3,%edx
ffffffff81670505:	73 11                	jae    ffffffff81670518 <sysret_signal>

My idea to fix this (attached) was to change objdump output reading
from sequential to offset-based - to take into account offset of
each line. And if offset starts going backwards, stop reading.

Comments/other ideas are welcome.

Regards,
Jan

--------------040209040301050401010008
Content-Type: text/x-patch;
 name="perf_test23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf_test23.patch"

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index f671ec3..4c3d87c 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -33,20 +33,20 @@ static unsigned int hex(char c)
 	return c - 'A' + 10;
 }
 
-static void read_objdump_line(const char *line, size_t line_len, void **buf,
-			      size_t *len)
+static size_t read_objdump_line(const char *line, size_t line_len, void *buf,
+			      size_t len)
 {
 	const char *p;
-	size_t i;
+	size_t i, j = 0;
 
 	/* Skip to a colon */
 	p = strchr(line, ':');
 	if (!p)
-		return;
+		return 0;
 	i = p + 1 - line;
 
 	/* Read bytes */
-	while (*len) {
+	while (j < len) {
 		char c1, c2;
 
 		/* Skip spaces */
@@ -65,20 +65,24 @@ static void read_objdump_line(const char *line, size_t line_len, void **buf,
 		if (i < line_len && line[i] && !isspace(line[i]))
 			break;
 		/* Store byte */
-		*(unsigned char *)*buf = (hex(c1) << 4) | hex(c2);
-		*buf += 1;
-		*len -= 1;
+		*(unsigned char *)buf = (hex(c1) << 4) | hex(c2);
+		buf += 1;
+		j++;
 	}
+	/* return number of succesfully read bytes */
+	return j;
 }
 
-static int read_objdump_output(FILE *f, void **buf, size_t *len)
+static int read_objdump_output(FILE *f, void *buf, size_t *len, u64 start_addr)
 {
 	char *line = NULL;
-	size_t line_len;
+	size_t line_len, off, off_last = 0, read_bytes, written_bytes;
 	ssize_t ret;
 	int err = 0;
+	u64 addr, last_addr = start_addr;
+	unsigned char tmp[BUFSZ];
 
-	while (1) {
+	while (off_last < *len) {
 		ret = getline(&line, &line_len, f);
 		if (feof(f))
 			break;
@@ -87,9 +91,33 @@ static int read_objdump_output(FILE *f, void **buf, size_t *len)
 			err = -1;
 			break;
 		}
-		read_objdump_line(line, ret, buf, len);
+
+		/* read objdump data into temporary buffer */
+		read_bytes = read_objdump_line(line, ret, tmp, sizeof(tmp));
+		if (!read_bytes)
+			continue;
+
+		if (sscanf(line, "%"PRIx64, &addr) != 1)
+			continue;
+		if (addr < last_addr) {
+			pr_debug("addr going backwards, read beyond section?\n");
+			break;
+		}
+		last_addr = addr;
+
+		/* copy it from temporary buffer to 'buf' according
+		 * to address on current objdump line */
+		off = addr - start_addr;
+		if (off >= *len)
+			break;
+		written_bytes = MIN(read_bytes, *len - off);
+		memcpy(buf + off, tmp, written_bytes);
+		off_last = off + written_bytes;
 	}
 
+	/* len returns number of bytes that could not be read */
+	*len -= off_last;
+
 	free(line);
 
 	return err;
@@ -103,7 +131,8 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 	FILE *f;
 	int ret;
 
-	fmt = "%s -d --start-address=0x%"PRIx64" --stop-address=0x%"PRIx64" %s";
+	/* -z parameter helps to avoid gaps in objdump output */
+	fmt = "%s -z -d --start-address=0x%"PRIx64" --stop-address=0x%"PRIx64" %s";
 	ret = snprintf(cmd, sizeof(cmd), fmt, "objdump", addr, addr + len,
 		       filename);
 	if (ret <= 0 || (size_t)ret >= sizeof(cmd))
@@ -120,7 +149,7 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 		return -1;
 	}
 
-	ret = read_objdump_output(f, &buf, &len);
+	ret = read_objdump_output(f, buf, &len, addr);
 	if (len) {
 		pr_debug("objdump read too few bytes\n");
 		if (!ret)
@@ -132,6 +161,18 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 	return ret;
 }
 
+static void dump_buf(unsigned char *buf, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		pr_debug("0x%02x ", buf[i]);
+		if (i % 16 == 15)
+			pr_debug("\n");
+	}
+	pr_debug("\n");
+}
+
 static int read_object_code(u64 addr, size_t len, u8 cpumode,
 			    struct thread *thread, struct state *state)
 {
@@ -234,6 +275,10 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 	/* The results should be identical */
 	if (memcmp(buf1, buf2, len)) {
 		pr_debug("Bytes read differ from those read by objdump\n");
+		pr_debug("buf1:\n");
+		dump_buf(buf1, len);
+		pr_debug("buf2:\n");
+		dump_buf(buf2, len);
 		return -1;
 	}
 	pr_debug("Bytes read match those read by objdump\n");

--------------040209040301050401010008--
