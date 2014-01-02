Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaABMP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:15:59 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61952 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaABMIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH, RFC 01/30] ataflop: fix sleep_on races
Date: Thu,  2 Jan 2014 13:07:25 +0100
Message-Id: <1388664474-1710039-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:QL9gb/OF1I+va902k025AMamn8lrxWOgNWMDIhVHKJP
 G/F742V5bCb84ZzGqxNPKTvQ2nnu7vH06Kd9QTBhDRBh2rCyiN
 H/nhDxj7n49TSZTtrHUXkbYXJYT/NfbSxpNfqupqH3egBdVLQF
 xR4Ll8+9eoLtT//nvrAkHGHZNdqV7nAvs17s1MAMla0bSHKy4V
 M4RO8L5R7xPIxnFHaxaiZrQ7xqNnXWxXY+Vq9Qn2ll96KiylSh
 qDCLJjZoIu5eD8sKVwD7A6w63PXXbZZpJYT9TTQut+HLeBZxIN
 bep+B7QpTmzAI8r3xgpO7ZH9ohtVbRq3WCE4Nuuvgxfs5qu0Tc
 2Qkk4tlgOWbcZpvDzC2bFnHQ9o60fEfHBt3sILx/e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on() is inherently racy, and has been deprecated for a long time.
This fixes two instances in the atari floppy driver:

* fdc_wait/fdc_busy becomes an open-coded mutex. We cannot use the
  regular mutex since it gets released in interrupt context. The
  open-coded version using wait_event() and cmpxchg() is equivalent
  to the existing code but does the checks atomically, and we can
  now safely check the condition with irqs enabled.

* format_wait becomes a completion, which is the natural structure
  here. The format ioctl waits for the background task to either
  complete or abort.

This does not attempt to fix the preexisting bug of calling schedule
with local interrupts disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/ataflop.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 0e30c6e..96b629e 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -68,6 +68,8 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/completion.h>
+#include <linux/wait.h>
 
 #include <asm/atafd.h>
 #include <asm/atafdreg.h>
@@ -301,7 +303,7 @@ module_param_array(UserSteprate, int, NULL, 0);
 /* Synchronization of FDC access. */
 static volatile int fdc_busy = 0;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
-static DECLARE_WAIT_QUEUE_HEAD(format_wait);
+static DECLARE_COMPLETION(format_wait);
 
 static unsigned long changed_floppies = 0xff, fake_change = 0;
 #define	CHECK_CHANGE_DELAY	HZ/2
@@ -608,7 +610,7 @@ static void fd_error( void )
 	if (IsFormatting) {
 		IsFormatting = 0;
 		FormatError = 1;
-		wake_up( &format_wait );
+		complete(&format_wait);
 		return;
 	}
 
@@ -650,9 +652,8 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	DPRINT(("do_format( dr=%d tr=%d he=%d offs=%d )\n",
 		drive, desc->track, desc->head, desc->sect_offset ));
 
+	wait_event(fdc_wait, cmpxchg(&fdc_busy, 0, 1) == 0);
 	local_irq_save(flags);
-	while( fdc_busy ) sleep_on( &fdc_wait );
-	fdc_busy = 1;
 	stdma_lock(floppy_irq, NULL);
 	atari_turnon_irq( IRQ_MFP_FDC ); /* should be already, just to be sure */
 	local_irq_restore(flags);
@@ -706,7 +707,7 @@ static int do_format(int drive, int type, struct atari_format_descr *desc)
 	ReqSide  = desc->head;
 	do_fd_action( drive );
 
-	sleep_on( &format_wait );
+	wait_for_completion(&format_wait);
 
 	redo_fd_request();
 	return( FormatError ? -EIO : 0 );	
@@ -1229,7 +1230,7 @@ static void fd_writetrack_done( int status )
 		goto err_end;
 	}
 
-	wake_up( &format_wait );
+	complete(&format_wait);
 	return;
 
   err_end:
@@ -1497,8 +1498,7 @@ repeat:
 void do_fd_request(struct request_queue * q)
 {
 	DPRINT(("do_fd_request for pid %d\n",current->pid));
-	while( fdc_busy ) sleep_on( &fdc_wait );
-	fdc_busy = 1;
+	wait_event(fdc_wait, cmpxchg(&fdc_busy, 0, 1) == 0);
 	stdma_lock(floppy_irq, NULL);
 
 	atari_disable_irq( IRQ_MFP_FDC );
-- 
1.8.3.2

