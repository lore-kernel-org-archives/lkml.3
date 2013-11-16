Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3KPG4I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 01:56:08 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:17613 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3KPG4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 01:56:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Nov 2013 22:50:14 -0800
From: Vishal Annapurve <vannapurve@nvidia.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Date: Sat, 16 Nov 2013 12:25:47 +0530
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Topic: [PATCH] usb-storage: scsiglue: Changing the command result
Thread-Index: Ac7imGOIxlzb1uH0RzmEJSvnbbUPZwAAEHLQAAAMOaA=
Message-ID: <113ACA888B71994BB56E5CF3704953486D664FCD44@BGMAIL02.nvidia.com>
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

Hi,

[PATCH 3/3] usb: storage: uas: Proper cmd result assignment

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

Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>
---
 drivers/usb/storage/uas.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index d966b59..3a4a44e 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -271,7 +271,10 @@ static int uas_try_complete(struct scsi_cmnd *cmnd, const char *caller)
 	usb_free_urb(cmdinfo->data_out_urb);
 	if (cmdinfo->state & COMMAND_ABORTED) {
 		scmd_printk(KERN_INFO, cmnd, "abort completed\n");
-		cmnd->result = DID_ABORT << 16;
+		/* Better to check for US_FLIDX_TIMED_OUT
+		 * bit settings.
+		 */
+		cmnd->result = DID_TIME_OUT << 16;
 	}
 	cmnd->scsi_done(cmnd);
 	return 0;
-- 
1.8.4.2

Regards,
Vishal

-----Original Message-----
From: Vishal Annapurve 
Sent: Saturday, November 16, 2013 12:25 PM
To: 'Alan Stern'
Cc: 'Ming Lei'; 'Linux Kernel Mailing List'; 'linux-usb'
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

Hi,

[PATCH 2/3] keucr: Proper cmd result assignment

This change replaces DID_ABORT with DID_TIMEOUT as a command result whenever US_FLIDX_TIMED_OUT bit is set.

This change is made to bring USB storage inline with a recent change:

commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8

[SCSI] Handle disk devices which can not process medium access commands We have experienced several devices which fail in a fashion we do not currently handle gracefully in SCSI. After a failure these devices will respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.) but any command accessing the storage medium will time out.

As the USB storage was setting command result as aborted rather than timed out, SCSI layer was not recognizing the above mentioned failure pattern.

Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>
---
 drivers/staging/keucr/transport.c | 6 +++---
 drivers/staging/keucr/usb.c       | 5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index aeb2186..6f61c20 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -353,7 +353,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
-		srb->result = DID_ABORT << 16;
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
@@ -412,7 +412,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			/* pr_info("-- auto-sense aborted\n"); */
-			srb->result = DID_ABORT << 16;
+			srb->result = DID_TIME_OUT << 16;
 			goto Handle_Errors;
 		}
 		if (temp_result != USB_STOR_TRANSPORT_GOOD) { @@ -488,7 +488,7 @@ void ENE_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 		we need to short-circuit all other processing */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 		/* pr_info("-- command was aborted\n"); */
-		srb->result = DID_ABORT << 16;
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c index a84ee63..26ec64c 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -181,7 +181,7 @@ static int usb_stor_control_thread(void *__us)
 
 		/* has the command timed out *already* ? */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			us->srb->result = DID_ABORT << 16;
+			us->srb->result = DID_TIME_OUT << 16;
 			goto SkipForAbort;
 		}
 
@@ -209,7 +209,8 @@ static int usb_stor_control_thread(void *__us)
 		scsi_lock(host);
 
 		/* indicate that the command is done */
-		if (us->srb->result != DID_ABORT << 16) {
+		if ((us->srb->result != DID_ABORT << 16) &&
+			(us->srb->result != DID_TIME_OUT << 16)) {
 			us->srb->scsi_done(us->srb);
 		} else {
 SkipForAbort:
--
1.8.4.2

Regards,
Vishal

-----Original Message-----
From: Vishal Annapurve
Sent: Saturday, November 16, 2013 12:24 PM
To: 'Alan Stern'
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

Hi,

Here are the updated patches:	

[PATCH 1/3] usb: storage: Proper cmd result assignment

This change replaces DID_ABORT with DID_TIMEOUT as a command result whenever US_FLIDX_TIMED_OUT bit is set.

This change is made to bring USB storage inline with a recent change:

commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8

[SCSI] Handle disk devices which can not process medium access commands We have experienced several devices which fail in a fashion we do not currently handle gracefully in SCSI. After a failure these devices will respond to the SCSI primary command set (INQUIRY, TEST UNIT READY, etc.) but any command accessing the storage medium will time out.

As the USB storage was setting command result as aborted rather than timed out, SCSI layer was not recognizing the above mentioned failure pattern.

Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>
---
 drivers/usb/storage/cypress_atacb.c |  1 +
 drivers/usb/storage/isd200.c        |  2 +-
 drivers/usb/storage/transport.c     |  8 ++++----
 drivers/usb/storage/usb.c           | 10 ++++++----
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/storage/cypress_atacb.c b/drivers/usb/storage/cypress_atacb.c
index 8514a2d..3477ca19 100644
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
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c index 599d8bf..ffd5d58 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -703,7 +703,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	/* abort processing: the bulk-only transport requires a reset
 	 * following an abort */
 	Handle_Abort:
-	srb->result = DID_ABORT << 16;
+	srb->result = DID_TIME_OUT << 16;
 
 	/* permit the reset transfer to take place */
 	clear_bit(US_FLIDX_ABORTING, &us->dflags); diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c index 22c7d43..6a90161 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -607,8 +607,8 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	 * short-circuit all other processing
 	 */
 	if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-		usb_stor_dbg(us, "-- command was aborted\n");
-		srb->result = DID_ABORT << 16;
+		usb_stor_dbg("-- command was aborted because of timeout\n");
+		srb->result = DID_TIME_OUT << 16;
 		goto Handle_Errors;
 	}
 
@@ -717,8 +717,8 @@ Retry_Sense:
 		scsi_eh_restore_cmnd(srb, &ses);
 
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			usb_stor_dbg(us, "-- auto-sense aborted\n");
-			srb->result = DID_ABORT << 16;
+			usb_stor_dbg("-- auto-sense aborted due to timeout\n");
+			srb->result = DID_TIME_OUT << 16;
 
 			/* If SANE_SENSE caused this problem, disable it */
 			if (sense_size != US_SENSE_SIZE) {
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c index 5c4fe07..04a68eb 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -325,7 +325,7 @@ static int usb_stor_control_thread(void * __us)
 
 		/* has the command timed out *already* ? */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
-			us->srb->result = DID_ABORT << 16;
+			us->srb->result = DID_TIME_OUT << 16;
 			goto SkipForAbort;
 		}
 
@@ -379,7 +379,8 @@ static int usb_stor_control_thread(void * __us)
 		scsi_lock(host);
 
 		/* indicate that the command is done */
-		if (us->srb->result != DID_ABORT << 16) {
+		if ((us->srb->result != DID_ABORT << 16) &&
+			(us->srb->result != DID_TIME_OUT << 16)) {
 			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
 				     us->srb->result);
 			us->srb->scsi_done(us->srb);
@@ -390,8 +391,9 @@ SkipForAbort:
 
 		/* If an abort request was received we need to signal that
 		 * the abort has finished.  The proper test for this is
-		 * the TIMED_OUT flag, not srb->result == DID_ABORT, because
-		 * the timeout might have occurred after the command had
+		 * the TIMED_OUT flag, not srb->result == DID_ABORT or
+		 * srb->result == DID_TIMEOUT , because the timeout might
+		 * have occurred after the command had
 		 * already completed with a different result code. */
 		if (test_bit(US_FLIDX_TIMED_OUT, &us->dflags)) {
 			complete(&(us->notify));
--
1.8.4.2

Regards,
Vishal

-----Original Message-----
From: Alan Stern [mailto:stern@rowland.harvard.edu]
Sent: Sunday, October 27, 2013 1:04 AM
To: Vishal Annapurve
Cc: Ming Lei; Linux Kernel Mailing List; linux-usb
Subject: RE: [PATCH] usb-storage: scsiglue: Changing the command result

On Sat, 26 Oct 2013, Vishal Annapurve wrote:

> Hi Alan,
> 
> Here is the new patch:
> 
> From: Vishal Annapurve <vannapurve@nvidia.com>
> Date: Sat, 26 Oct 2013 21:10:11 +0530
> Subject: [PATCH] usb: storage: Proper cmd result assignment
> 
> This change replaces DID_ABORT with DID_TIMEOUT as a command result 
> whenever US_FLIDX_TIMED_OUT bit is set.
> 
> This change is made to bring USB storage inline with a recent change:
> 
> commit    18a4d0a22ed6c54b67af7718c305cd010f09ddf8
> 
> [SCSI] Handle disk devices which can not process medium access 
> commands We have experienced several devices which fail in a fashion 
> we do not currently handle gracefully in SCSI. After a failure these 
> devices will respond to the SCSI primary command set (INQUIRY, TEST 
> UNIT READY, etc.) but any command accessing the storage medium will time out.
> 
> As the USB storage was setting command result as aborted rather than 
> timed out, SCSI layer was not recognizing the above mentioned failure 
> pattern.
> 
> Change-Id: Ic58e2247fed11649f4dbea56382354ba2fe0be1b
> ---
>  drivers/staging/keucr/transport.c   | 6 +++---
>  drivers/staging/keucr/usb.c         | 5 +++--

Those two files aren't part of usb-storage; they belong to a different driver.  It would be better to have a separate patch for them, and you should copy that patch to the driver's maintainer.

>  drivers/usb/storage/cypress_atacb.c | 1 +
>  drivers/usb/storage/isd200.c        | 2 +-
>  drivers/usb/storage/transport.c     | 8 ++++----
>  drivers/usb/storage/usb.c           | 9 +++++----
>  6 files changed, 17 insertions(+), 14 deletions(-)

Otherwise this is okay.  You might also want to submit a third patch for the uas driver.

Alan Stern

