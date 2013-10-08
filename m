Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab3JHSkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 14:40:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab3JHSkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 14:40:19 -0400
Date: Tue, 8 Oct 2013 11:39:44 -0700
From: "tip-bot for Geyslan G. Bem" <tipbot@zytor.com>
Message-ID: <tip-49449c30c4d1514486364d1e0dbea6938914b86f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, geyslan@gmail.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, geyslan@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
References: <1381184219-10985-1-git-send-email-geyslan@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: mkpiggy.c:
  Explicitly close the output file
Git-Commit-ID: 49449c30c4d1514486364d1e0dbea6938914b86f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 11:39:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49449c30c4d1514486364d1e0dbea6938914b86f
Gitweb:     http://git.kernel.org/tip/49449c30c4d1514486364d1e0dbea6938914b86f
Author:     Geyslan G. Bem <geyslan@gmail.com>
AuthorDate: Mon, 7 Oct 2013 19:16:59 -0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 8 Oct 2013 11:36:09 -0700

x86: mkpiggy.c: Explicitly close the output file

Even though the resource is released when the application is closed or
when returned from main function, modify the code to make it obvious,
and to keep static analysis tools from complaining.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
Link: http://lkml.kernel.org/r/1381184219-10985-1-git-send-email-geyslan@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
