Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaFMNiV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 09:38:21 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:59661 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaFMNiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 09:38:14 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv4 5/6] tools: ffs-test: add compatibility code for old kernels
Date: Fri, 13 Jun 2014 15:38:08 +0200
Message-Id: <1402666689-4971-6-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402666689-4971-1-git-send-email-mina86@mina86.com>
References: <1402666689-4971-1-git-send-email-mina86@mina86.com>
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
 tools/usb/ffs-test.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 5 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index 708d317..88d5e71 100644
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
@@ -172,6 +173,89 @@ static const struct {
 	},
 };
 
+static size_t descs_to_legacy(void **legacy, const void *descriptors_v2)
+{
+	const unsigned char *descs_end, *descs_start;
+	__u32 length, fs_count = 0, hs_count = 0, count;
+
+	/* Read v2 header */
+	{
+		const struct {
+			const struct usb_functionfs_descs_head_v2 header;
+			const __le32 counts[];
+		} __attribute__((packed)) *const in = descriptors_v2;
+		const __le32 *counts = in->counts;
+		__u32 flags;
+
+		if (le32_to_cpu(in->header.magic) !=
+		    FUNCTIONFS_DESCRIPTORS_MAGIC_V2)
+			return 0;
+		length = le32_to_cpu(in->header.length);
+		if (length <= sizeof in->header)
+			return 0;
+		length -= sizeof in->header;
+		flags = le32_to_cpu(in->header.flags);
+		if (flags & ~(FUNCTIONFS_HAS_FS_DESC | FUNCTIONFS_HAS_HS_DESC |
+			      FUNCTIONFS_HAS_SS_DESC))
+			return 0;
+
+#define GET_NEXT_COUNT_IF_FLAG(ret, flg) do {		\
+			if (!(flags & (flg)))		\
+				break;			\
+			if (length < 4)			\
+				return 0;		\
+			ret = le32_to_cpu(*counts);	\
+			length -= 4;			\
+			++counts;			\
+		} while (0)
+
+		GET_NEXT_COUNT_IF_FLAG(fs_count, FUNCTIONFS_HAS_FS_DESC);
+		GET_NEXT_COUNT_IF_FLAG(hs_count, FUNCTIONFS_HAS_HS_DESC);
+		GET_NEXT_COUNT_IF_FLAG(count, FUNCTIONFS_HAS_SS_DESC);
+
+		count = fs_count + hs_count;
+		if (!count)
+			return 0;
+		descs_start = (const void *)counts;
+
+#undef GET_NEXT_COUNT_IF_FLAG
+	}
+
+	/*
+	 * Find the end of FS and HS USB descriptors.  SS descriptors
+	 * are ignored since legacy format does not support them.
+	 */
+	descs_end = descs_start;
+	do {
+		if (length < *descs_end)
+			return 0;
+		length -= *descs_end;
+		descs_end += *descs_end;
+	} while (--count);
+
+	/* Allocate legacy descriptors and copy the data. */
+	{
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+		struct {
+			struct usb_functionfs_descs_head header;
+			__u8 descriptors[];
+		} __attribute__((packed)) *out;
+#pragma GCC diagnostic pop
+
+		length = sizeof out->header + (descs_end - descs_start);
+		out = malloc(length);
+		out->header.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC);
+		out->header.length = cpu_to_le32(length);
+		out->header.fs_count = cpu_to_le32(fs_count);
+		out->header.hs_count = cpu_to_le32(hs_count);
+		memcpy(out->descriptors, descs_start, descs_end - descs_start);
+		*legacy = out;
+	}
+
+	return length;
+}
+
 
 #define STR_INTERFACE_ "Source/Sink"
 
@@ -491,12 +575,29 @@ ep0_consume(struct thread *ignore, const void *buf, size_t nbytes)
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
@@ -507,14 +608,15 @@ static void ep0_init(struct thread *t)
 
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

