Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3C0MvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 08:51:20 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:51805 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab3C0MvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 08:51:19 -0400
Date: Wed, 27 Mar 2013 13:51:14 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Ronald <ronald645@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        gwendal@google.com, jgarzik@redhat.com
Subject: Re: ata: HDIO_DRIVE_* ioctl() Linux 3.9 regression
Message-ID: <20130327125114.GA22214@shrek.podlesie.net>
References: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 06:26:50PM +0100, Ronald wrote:
> In reply to [1]: I have the same issue. Git bisect took 50+ rebuilds xD
> 
> Smartd does not work anymore since 84a9a8cd9 ([libata] Set proper SK
> when CK_COND is set.).
> 
> I hope I'm not stepping on anyone's toe's by chosing the same title.
> I'm not subscribed to this list.
> 
> Just wanted to add a 'me2'
> 
> [1] http://www.spinics.net/lists/linux-ide/msg45268.html

It seems that the SAM_STAT_CHECK_CONDITION is not cleared
causing -EIO, because that patch modified sensebuf and
the check for clearing SAM_STAT_CHECK_CONDITION is no longer valid.

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 318b413..ff44787 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 					     &sshdr);
-			if (sshdr.sense_key == 0 &&
-			    sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
@@ -618,8 +618,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
 			struct scsi_sense_hdr sshdr;
 			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
 						&sshdr);
-			if (sshdr.sense_key == 0 &&
-				sshdr.asc == 0 && sshdr.ascq == 0)
+			if (sshdr.sense_key == RECOVERED_ERROR &&
+			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
 				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
 		}
 
Krzysiek
