Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3JGWVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:21:15 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:50984 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3JGWVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:21:10 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] x86: mkpiggy.c: fix resource leakage
Date: Mon,  7 Oct 2013 19:16:59 -0300
Message-Id: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though the resource is released when the application is closed or
when returned from main function, modified to make it in accordance.
Now FILE pointer is always verified.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 arch/x86/boot/compressed/mkpiggy.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

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
-- 
1.8.4

