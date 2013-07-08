Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab3GHRCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:02:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42980 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab3GHRCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:02:11 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ankita Garg <ankita@in.ibm.com>,
        Simon Kagstrom <simon.kagstrom@netinsight.net>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/4] lkdtm: fix stack protector trigger
Date: Mon,  8 Jul 2013 10:01:30 -0700
Message-Id: <1373302893-4990-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The -fstack-protector compiler flag will only build stack protections if
a character array is seen. Additionally, the offset to the saved
instruction pointer changes based on architecture, so stomp much harder
(64 bytes) when corrupting the stack.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 08aad69..adb6bde 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -295,10 +295,10 @@ static void lkdtm_do_action(enum ctype which)
 		(void) recursive_loop(0);
 		break;
 	case CT_CORRUPT_STACK: {
-		volatile u32 data[8];
-		volatile u32 *p = data;
+		/* Make sure the compiler creates and uses an 8 char array. */
+		volatile char data[8];
 
-		p[12] = 0x12345678;
+		memset((void *)data, 0, 64);
 		break;
 	}
 	case CT_UNALIGNED_LOAD_STORE_WRITE: {
-- 
1.7.9.5

