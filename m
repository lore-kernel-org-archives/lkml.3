Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3K0A6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab3K0A6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 3.12 028/116] lkdtm: isolate stack corruption test
Date: Tue, 26 Nov 2013 16:56:41 -0800
Message-Id: <20131127005738.887480864@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 629c66a22c21b692b6e58b9c1d8fa56a60ccb52d upstream.

When tests were added to lkdtm that grew the stack frame, the stack
corruption test stopped working. This isolates the test in its own
function, and forces it not to be inlined.

Signed-off-by: Kees Cook <keescook@chromium.org>
Fixes: cc33c537c12f ("lkdtm: add "EXEC_*" triggers")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/lkdtm.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -297,6 +297,14 @@ static void do_nothing(void)
 	return;
 }
 
+static noinline void corrupt_stack(void)
+{
+	/* Use default char array length that triggers stack protection. */
+	char data[8];
+
+	memset((void *)data, 0, 64);
+}
+
 static void execute_location(void *dst)
 {
 	void (*func)(void) = dst;
@@ -327,13 +335,9 @@ static void lkdtm_do_action(enum ctype w
 	case CT_OVERFLOW:
 		(void) recursive_loop(0);
 		break;
-	case CT_CORRUPT_STACK: {
-		/* Make sure the compiler creates and uses an 8 char array. */
-		volatile char data[8];
-
-		memset((void *)data, 0, 64);
+	case CT_CORRUPT_STACK:
+		corrupt_stack();
 		break;
-	}
 	case CT_UNALIGNED_LOAD_STORE_WRITE: {
 		static u8 data[5] __attribute__((aligned(4))) = {1, 2,
 				3, 4, 5};


