Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3C2QLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:11:06 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:41148 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3C2QLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:11:05 -0400
Date: Fri, 29 Mar 2013 17:10:56 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Gwendal Grignou <gwendal@google.com>
Cc: ronald645@gmail.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
Message-ID: <20130329161056.GA9322@shrek.podlesie.net>
References: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
 <1364570801-6515-1-git-send-email-gwendal@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364570801-6515-1-git-send-email-gwendal@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 08:26:41AM -0700, Gwendal Grignou wrote:
> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63 changed the sense key
> used for returning task registers, but HDIO_DRIVE_CMD ioctl was
> not changed accordingly.
> 
> Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
> instead of EIO.
> 
> Signed-off-by: Gwendal Grignou <gwendal@google.com>
> ---
>  drivers/ata/libata-scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 318b413..e05bf4c 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
>  			struct scsi_sense_hdr sshdr;
>  			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
>  					     &sshdr);
> -			if (sshdr.sense_key == 0 &&
> -			    sshdr.asc == 0 && sshdr.ascq == 0)
> +			if (sshdr.sense_key == RECOVERED_ERROR &&
> +			    sshdr.asc == 0 && sshdr.ascq == 0x1D)
>  				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
>  		}
>  
> -- 
> 1.8.1.3

I did not test your patch, but I think that you missed the second
test in ata_task_ioctl() and the kernel will still return -EIO
in case of HDIO_DRIVE_TASK (0x31e) ioctl.
See http://marc.info/?l=linux-kernel&m=136438868606981&w=2.
The version I've sent fixes the problem for me.

Krzysiek
