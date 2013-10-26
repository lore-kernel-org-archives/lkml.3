Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3JZPtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 11:49:12 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6731 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JZPtJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 11:49:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sat, 26 Oct 2013 08:44:19 -0700
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Sat, 26 Oct 2013 21:19:03 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7OgkWMheezb37yT0m7uJgt2cF4TgD4DwoQ
Message-ID: <113ACA888B71994BB56E5CF3704953486D6612FB5B@BGMAIL02.nvidia.com>
References: <113ACA888B71994BB56E5CF3704953486D65F419AE@BGMAIL02.nvidia.com>
 <Pine.LNX.4.44L0.1310211321320.1185-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1310211321320.1185-100000@iolanthe.rowland.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Here is the new patch:

From: Vishal Annapurve <vannapurve@nvidia.com>
Date: Sat, 26 Oct 2013 21:10:11 +0530
Subject: [PATCH] usb: storage: Proper cmd result assignment

This change replaces DID_ABORT with DID_TIMEOUT as a command result
whenever US_FLIDX_TIMED_OUT bit is set.

This change is made to bring USB storage inline with a recent change:

commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8

[SCSI] Handle disk devices which can not process medium access commands
We have experienced several devices which fail in a fashion we do not
currently handle gracefully in SCSI. After a failure these devices will
respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.)
but any command accessing the storage medium will time out.

As the USB storage was setting command result as aborted rather than
timed out, SCSI layer was not recognizing the above mentioned failure
pattern.

Change-Id: Ic58e2247fed11649f4dbea56382354ba2fe0be1b
---
 drivers/staging/keucr/transport.c   | 6 +++---
 drivers/staging/keucr/usb.c         | 5 +++--
 drivers/usb/storage/cypress_atacb.c | 1 +
 drivers/usb/storage/isd200.c        | 2 +-
 drivers/usb/storage/transport.c     | 8 ++++----
 drivers/usb/storage/usb.c           | 9 +++++----
 6 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index 1a8837d..ac0e3c2 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -312,7 +312,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
-		srb->result = DID_ABORT << 16;
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
@@ -371,7 +371,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			/* pr_info("-- auto-sense aborted\n"); */
-			srb->result = DID_ABORT << 16;
+			srb->result = DID_TIME_OUT << 16;
 			goto Handle_Errors;
 		}
 		if (temp_result != USB_STOR_TRANSPORT_GOOD) {
@@ -447,7 +447,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
-		srb->result = DID_ABORT << 16;
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index 66aad3a..79405be 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -200,7 +200,7 @@ static int usb_stor_control_thread(void * __us)
 		/* has the command timed out *already* ? */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags))
 		{
-			us->srb->result = DID_ABORT << 16;
+			us->srb->result = DID_TIME_OUT << 16;
 			goto SkipForAbort;
 		}
 
@@ -234,7 +234,8 @@ static int usb_stor_control_thread(void * __us)
 		scsi_lock(host);
 
 		/* indicate that the command is done */
-		if (us->srb->result != DID_ABORT << 16)
+		if ((us->srb->result != DID_ABORT << 16) &&
+			(us->srb->result != DID_TIME_OUT << 16))
 		{
 			us->srb->scsi_done(us->srb);
 		}
diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index c844718..af24894 100644
--- a/drivers/usb/storage/cypress_atacb.c
+++ b/drivers/usb/storage/cypress_atacb.c
@@ -168,6 +168,7 @@ static void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
 	 */
 	if ((srb->result != (DID_ERROR << 16) &&
 				srb->result != (DID_ABORT << 16)) &&
+				srb->result != (DID_TIME_OUT << 16) &&
 			save_cmnd[2] & 0x20) {
 		struct scsi_eh_save ses;
 		unsigned char regs[8];
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index ffc4193..28b688b 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -705,7 +705,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	/* abort processing: the bulk-only transport requires a reset
 	 * following an abort */
 	Handle_Abort:
-	srb->result = DID_ABORT << 16;
+	srb->result = DID_TIME_OUT << 16;
 
 	/* permit the reset transfer to take place */
 	clear_bit(US_FLIDX_ABORTING, &us->dflags);
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index b2697dc..f68e4c6 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -608,8 +608,8 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * short-circuit all other processing
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-		US_DEBUGP("-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		US_DEBUGP("-- command was aborted because of timeout\n");
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
@@ -721,8 +721,8 @@ Retry_Sense:
 		scsi_eh_restore_cmnd(srb, &ses);
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			US_DEBUGP("-- auto-sense aborted\n");
-			srb->result = DID_ABORT << 16;
+			US_DEBUGP("-- auto-sense aborted due to timeout\n");
+			srb->result = DID_TIME_OUT << 16;
 
 			/* If SANE_SENSE caused this problem, disable it */
 			if (sense_size != US_SENSE_SIZE) {
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index c0d0915..64eaca6 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -290,7 +290,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* has the command timed out *already* ? */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			us->srb->result = DID_ABORT << 16;
+			us->srb->result = DID_TIME_OUT << 16;
 			goto SkipForAbort;
 		}
 
@@ -344,18 +344,19 @@ static int usb_stor_control_thread(void * __us)
 		scsi_lock(host);
 
 		/* indicate that the command is done */
-		if (us->srb->result != DID_ABORT << 16) {
+		if ((us->srb->result != (DID_TIME_OUT << 16)) &&
+			(us->srb->result != (DID_ABORT << 16)))  {
 			US_DEBUGP("scsi cmd done, result=0x%x\n", 
 				   us->srb->result);
 			us->srb->scsi_done(us->srb);
 		} else {
 SkipForAbort:
-			US_DEBUGP("scsi command aborted\n");
+			US_DEBUGP("scsi command aborted due to timeout\n");
 		}
 
 		/* If an abort request was received we need to signal that
 		 * the abort has finished.  The proper test for this is
-		 * the TIMED_OUT flag, not srb->result == DID_ABORT, because
+		 * the TIMED_OUT flag, not srb->result == DID_TIME_OUT, because
 		 * the timeout might have occurred after the command had
 		 * already completed with a different result code. */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-- 
1.8.4

Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu] 
Sent: Monday, October 21, 2013 7:23 PM
To: Vishal Annapurve
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

On Sat, 19 Oct 2013, Vishal Annapurve wrote:

> Hi,
> 
> Attaching the new patch which will replace all the occurrences of 
> DID_ABORT with DID_TIMOUT in USB Storage whenever it sees 
> US_FLIDX_TIMED_OUT bit is set.

It seems okay, but you forgot to update the isd200.c and cypress_atacb.c files.

Also, in the future please put your patches inline with the rest of the email, not as a separate attachment.

Alan Stern

