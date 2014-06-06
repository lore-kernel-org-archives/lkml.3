Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFFJN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:13:26 -0400
Received: from mail-wg0-f73.google.com ([74.125.82.73]:62841 "EHLO
	mail-wg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaFFJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:13:00 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 5/5] tools: ffs-test: add compatibility code for old kernels
Date: Fri,  6 Jun 2014 11:12:56 +0200
Message-Id: <1402045976-26580-5-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402045976-26580-1-git-send-email-mina86@mina86.com>
References: <1402045976-26580-1-git-send-email-mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If ffs-test is used with a kernel prior to 3.14, which do not
support the new descriptors format, it will fail when trying to
write the descriptors.  Add a function that converts the new
descriptors to the legacy ones and use it to retry writing the
descriptors using the legacy format.

Also add “-l” flag to ffs-test which will cause the tool to
never try the new format and instead immediatelly try the
legacy one.  This should be useful to test whether parsing
of the old format still works on given 3.14+ kernel.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 tools/usb/ffs-test.c | 84 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 79 insertions(+), 5 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 708d317..407c828 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -29,6 +29,7 @@
 #include <fcntl.h>
 #include <pthread.h>
 #include <stdarg.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -172,6 +173,61 @@ static const struct {
 	},
 };
 
+static size_t descs_to_legacy(void **legacy, const void *descriptors) {
+	__u32 length, flags, fs_count = 0, hs_count = 0, count;
+	const unsigned char *descs = descriptors, *usb_descs;
+	unsigned char *out;
+
+	if (get_unaligned_le32(descs) != FUNCTIONFS_DESCRIPTORS_MAGIC_V2)
+		return 0;
+
+	length = get_unaligned_le32(descs + 4);
+	if (length < 8)
+		return 0;
+	descs += 8;
+	length -= 8;
+
+#define GET_LE32(ret) do {				\
+		if (length < 4)				\
+			return 0;			\
+		ret = get_unaligned_le32(descs);	\
+		descs += 4;				\
+		length -= 4;				\
+	} while (0)
+
+	GET_LE32(flags);
+	if (flags & FUNCTIONFS_HAS_FS_DESC)
+		GET_LE32(fs_count);
+	if (flags & FUNCTIONFS_HAS_HS_DESC)
+		GET_LE32(hs_count);
+	if (!fs_count && !hs_count)
+		return 0;
+	if (flags & FUNCTIONFS_HAS_SS_DESC)
+		GET_LE32(count);  /* The value is ignored later on anyway. */
+	if (flags)
+		return 0;
+
+#undef GET_LE32
+
+	usb_descs = descs;
+	for (count = fs_count + hs_count; count; --count) {
+		if (length < *descs)
+			return 0;
+		length -= *descs;
+		descs += *descs;
+	}
+
+	length = 16 + (descs - usb_descs);
+	out = malloc(length);
+	put_unaligned_le32(FUNCTIONFS_DESCRIPTORS_MAGIC, out);
+	put_unaligned_le32(length, out + 4);
+	put_unaligned_le32(fs_count, out + 8);
+	put_unaligned_le32(hs_count, out + 12);
+	memcpy(out + 16, usb_descs, length - 16);
+	*legacy = out;
+	return length;
+}
+
 
 #define STR_INTERFACE_ "Source/Sink"
 
@@ -491,12 +547,29 @@ ep0_consume(struct thread *ignore, const void *buf, size_t nbytes)
 	return nbytes;
 }
 
-static void ep0_init(struct thread *t)
+static void ep0_init(struct thread *t, bool legacy_descriptors)
 {
+	void *legacy;
 	ssize_t ret;
+	size_t len;
+
+	if (legacy_descriptors) {
+		info("%s: writing descriptors\n", t->filename);
+		goto legacy;
+	}
 
-	info("%s: writing descriptors\n", t->filename);
+	info("%s: writing descriptors (in v2 format)\n", t->filename);
 	ret = write(t->fd, &descriptors, sizeof descriptors);
+
+	if (ret < 0 && errno == EINVAL) {
+		warn("%s: new format rejected, trying legacy\n", t->filename);
+legacy:
+		len = descs_to_legacy(&legacy, &descriptors);
+		if (len) {
+			ret = write(t->fd, legacy, len);
+			free(legacy);
+		}
+	}
 	die_on(ret < 0, "%s: write: descriptors", t->filename);
 
 	info("%s: writing strings\n", t->filename);
@@ -507,14 +580,15 @@ static void ep0_init(struct thread *t)
 
 /******************** Main **************************************************/
 
-int main(void)
+int main(int argc, char **argv)
 {
+	bool legacy_descriptors;
 	unsigned i;
 
-	/* XXX TODO: Argument parsing missing */
+	legacy_descriptors = argc > 2 && !strcmp(argv[1], "-l");
 
 	init_thread(threads);
-	ep0_init(threads);
+	ep0_init(threads, legacy_descriptors);
 
 	for (i = 1; i < sizeof threads / sizeof *threads; ++i)
 		init_thread(threads + i);
-- 
2.0.0.526.g5318336

