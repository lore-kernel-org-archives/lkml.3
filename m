Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3KKRSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:18:43 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44384 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KKRSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:18:36 -0500
Date: Mon, 11 Nov 2013 18:18:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v3.13
Message-ID: <20131111171832.GA13179@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-cleanups-for-linus

   # HEAD: 122498738417c73943b71294c60ec34fc110f5d6 x86, msr: Use file_inode(), not f_mapping->host

Two small cleanups.

 Thanks,

	Ingo

------------------>
Andre Richter (1):
      x86, msr: Use file_inode(), not f_mapping->host

Geyslan G. Bem (1):
      x86: mkpiggy.c: Explicitly close the output file


 arch/x86/boot/compressed/mkpiggy.c | 16 ++++++++++------
 arch/x86/kernel/msr.c              |  2 +-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/mkpiggy.c b/arch/x86/boot/compressed/mkpiggy.c
index 958a641..b669ab6 100644
--- a/arch/x86/boot/compressed/mkpiggy.c
+++ b/arch/x86/boot/compressed/mkpiggy.c
@@ -36,11 +36,12 @@ int main(int argc, char *argv[])
 	uint32_t olen;
 	long ilen;
 	unsigned long offs;
-	FILE *f;
+	FILE *f = NULL;
+	int retval = 1;
 
 	if (argc < 2) {
 		fprintf(stderr, "Usage: %s compressed_file\n", argv[0]);
-		return 1;
+		goto bail;
 	}
 
 	/* Get the information for the compressed kernel image first */
@@ -48,7 +49,7 @@ int main(int argc, char *argv[])
 	f = fopen(argv[1], "r");
 	if (!f) {
 		perror(argv[1]);
-		return 1;
+		goto bail;
 	}
 
 
@@ -58,12 +59,11 @@ int main(int argc, char *argv[])
 
 	if (fread(&olen, sizeof(olen), 1, f) != 1) {
 		perror(argv[1]);
-		return 1;
+		goto bail;
 	}
 
 	ilen = ftell(f);
 	olen = get_unaligned_le32(&olen);
-	fclose(f);
 
 	/*
 	 * Now we have the input (compressed) and output (uncompressed)
@@ -91,5 +91,9 @@ int main(int argc, char *argv[])
 	printf(".incbin \"%s\"\n", argv[1]);
 	printf("input_data_end:\n");
 
-	return 0;
+	retval = 0;
+bail:
+	if (f)
+		fclose(f);
+	return retval;
 }
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 88458fa..05266b5 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -46,7 +46,7 @@ static struct class *msr_class;
 static loff_t msr_seek(struct file *file, loff_t offset, int orig)
 {
 	loff_t ret;
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
 
 	mutex_lock(&inode->i_mutex);
 	switch (orig) {
