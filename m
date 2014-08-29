Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaH2QLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:11:43 -0400
Received: from mail.aswsp.com ([193.34.35.150]:44839 "EHLO mail.aswsp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbaH2QLl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:11:41 -0400
Date: Fri, 29 Aug 2014 18:12:01 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Buffer I/O error after s2ram with usb storage
Message-ID: <20140829181201.277e699d@parrot.com>
In-Reply-To: <Pine.LNX.4.44L0.1408271051160.1460-100000@iolanthe.rowland.org>
References: <20140827104059.3a4bed94@parrot.com>
	<Pine.LNX.4.44L0.1408271051160.1460-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [46.218.109.88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wed, 27 Aug 2014 10:54:53 -0400,
Alan Stern <stern@rowland.harvard.edu> a écrit :

> On Wed, 27 Aug 2014, Matthieu CASTET wrote:
> 
> > Ping
> > 
> > I have got also a problem with a usb sdcard reader (without power cut
> > during suspend)
> 
> > > > The usb storage driver call scsi_report_bus_reset after device reset,
> > > > but because of commit dfcf7775 <4>, we don't ignore unit attention if
> > > > "sshdr.asc == 0x28 && sshdr.ascq == 0x00" ("Not-ready to ready").
> > > > 
> > > > If dfcf7775 is reverted there is no more Buffer I/O error.
> > > > 
> > > > Is that possible to find a way to restore the behavior before dfcf7775
> > > > commit (no Buffer I/O error after device reset) after a suspend to ram ?
> 
> Since that commit was written to fix a problem with certain cdrom
> drives, maybe we would work around the issue by modifying the commit.  
> Have it go back to the original behavior if the device isn't a cdrom 
> drive.
> 
> That's not a complete fix (it won't help when a CD drive is attached 
> via USB), but maybe it's better than nothing.
> 
Ok,

note to handle all case we need also to filter unit_attention in
scsi_test_unit_ready. Otherwise DISK_EVENT_MEDIA_CHANGE event is set and check_disk_change will invalidate vfs cache.


Matthieu

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2bc0362..e994061 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2030,8 +2030,12 @@ scsi_test_unit_ready(struct scsi_device *sdev, int timeout, int retries,
 		result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, sshdr,
 					  timeout, retries, NULL);
 		if (sdev->removable && scsi_sense_valid(sshdr) &&
-		    sshdr->sense_key == UNIT_ATTENTION)
-			sdev->changed = 1;
+		    sshdr->sense_key == UNIT_ATTENTION) {
+			if (sdev->expecting_cc_ua)
+				sdev->expecting_cc_ua = 0;
+			else
+				sdev->changed = 1;
+		}
 	} while (scsi_sense_valid(sshdr) &&
 		 sshdr->sense_key == UNIT_ATTENTION && --retries);
 
