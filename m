Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LJLh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:37:56 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11549 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab3LJLhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:37:54 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 10 Dec 2013 03:34:30 -0800
Message-ID: <52A6FD12.1050705@nvidia.com>
Date: Tue, 10 Dec 2013 17:07:54 +0530
From: Vishal Annapurve <vannapurve@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb-storage: scsiglue: Changing the command result
References: <113ACA888B71994BB56E5CF3704953486D664FCD42@BGMAIL02.nvidia.com> <20131209015905.GA5965@kroah.com> <52A590E7.9010603@nvidia.com> <20131209112315.GE6562@kroah.com> <52A6A56F.4040005@nvidia.com> <20131210055505.GA21002@kroah.com>
In-Reply-To: <20131210055505.GA21002@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

There was problem with my email client.
Hope now it is fine.

---
[PATCH 1/3] usb: storage: Proper cmd result assignment

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
 drivers/usb/storage/cypress_atacb.c |  1 +
 drivers/usb/storage/isd200.c        |  2 +-
 drivers/usb/storage/transport.c     |  8 ++++----
 drivers/usb/storage/usb.c           | 10 ++++++----
 4 files changed, 12 insertions(+), 9 deletions(-)
---
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
diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 599d8bf..ffd5d58 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -703,7 +703,7 @@ static void isd200_invoke_transport( struct us_data *us,
 	/* abort processing: the bulk-only transport requires a reset
 	 * following an abort */
 	Handle_Abort:
-	srb->result = DID_ABORT << 16;
+	srb->result = DID_TIME_OUT << 16;

 	/* permit the reset transfer to take place */
 	clear_bit(US_FLIDX_ABORTING, &us->dflags);
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 22c7d43..6a90161 100644
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
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index 5c4fe07..04a68eb 100644
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
---

Regards,
Vishal

On Tuesday 10 December 2013 11:25 AM, Greg KH wrote:
> On Tue, Dec 10, 2013 at 10:53:59AM +0530, Vishal Annapurve wrote:
>> Hi Greg,
>>
>> Does this look fine? I will send over other patches
>> once you confirm.
> 
> I'm not going to confirm a broken format...
> 
> Please go read the file I pointed you at as to how to properly do
> this.
> 
> greg k-h
> 

