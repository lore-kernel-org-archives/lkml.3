Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab3IQKCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:02:22 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53333 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab3IQKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:02:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] kexec: Let slurp_file_len() return the number of bytes read
Date: Tue, 17 Sep 2013 12:01:34 +0200
Message-Id: <1379412095-7213-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional output parameter to slurp_file_len() so it can return the
actual number of bytes read.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kexec/arch/i386/crashdump-x86.c |    5 ++---
 kexec/kexec.c                   |    4 +++-
 kexec/kexec.h                   |    2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kexec/arch/i386/crashdump-x86.c b/kexec/arch/i386/crashdump-x86.c
index e44fceb..e2da50b 100644
--- a/kexec/arch/i386/crashdump-x86.c
+++ b/kexec/arch/i386/crashdump-x86.c
@@ -121,7 +121,7 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
 	struct mem_ehdr ehdr;
 	struct mem_phdr *phdr, *end_phdr;
 	int align;
-	unsigned long size;
+	off_t size;
 	uint32_t elf_flags = 0;
 
 	if (elf_info->machine != EM_X86_64)
@@ -131,8 +131,7 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
 		return 0;
 
 	align = getpagesize();
-	size = KCORE_ELF_HEADERS_SIZE;
-	buf = slurp_file_len(kcore, size);
+	buf = slurp_file_len(kcore, KCORE_ELF_HEADERS_SIZE, &size);
 	if (!buf) {
 		fprintf(stderr, "Cannot read %s: %s\n", kcore, strerror(errno));
 		return -1;
diff --git a/kexec/kexec.c b/kexec/kexec.c
index b863d2a..2b98ef0 100644
--- a/kexec/kexec.c
+++ b/kexec/kexec.c
@@ -537,7 +537,7 @@ char *slurp_file(const char *filename, off_t *r_size)
 /* This functions reads either specified number of bytes from the file or
    lesser if EOF is met. */
 
-char *slurp_file_len(const char *filename, off_t size)
+char *slurp_file_len(const char *filename, off_t size, off_t *nread)
 {
 	int fd;
 	char *buf;
@@ -575,6 +575,8 @@ char *slurp_file_len(const char *filename, off_t size)
 		die("Close of %s failed: %s\n",
 			filename, strerror(errno));
 	}
+	if (nread)
+		*nread = progress;
 	return buf;
 }
 
diff --git a/kexec/kexec.h b/kexec/kexec.h
index 715b568..5844b42 100644
--- a/kexec/kexec.h
+++ b/kexec/kexec.h
@@ -237,7 +237,7 @@ extern void die(const char *fmt, ...)
 extern void *xmalloc(size_t size);
 extern void *xrealloc(void *ptr, size_t size);
 extern char *slurp_file(const char *filename, off_t *r_size);
-extern char *slurp_file_len(const char *filename, off_t size);
+extern char *slurp_file_len(const char *filename, off_t size, off_t *nread);
 extern char *slurp_decompress_file(const char *filename, off_t *r_size);
 extern unsigned long virt_to_phys(unsigned long addr);
 extern void add_segment(struct kexec_info *info,
-- 
1.7.9.5

