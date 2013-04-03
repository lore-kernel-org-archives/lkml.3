Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604Ab3DCXtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:49:20 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:46390 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DCXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:49:18 -0400
Message-ID: <515CBFFA.3090907@pobox.com>
Date: Wed, 03 Apr 2013 19:49:14 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Krzysztof Mazur <krzysiek@podlesie.net>
CC: Ronald <ronald645@gmail.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwendal@google.com, jgarzik@redhat.com
Subject: Re: ata: HDIO_DRIVE_* ioctl() Linux 3.9 regression
References: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com> <20130327125114.GA22214@shrek.podlesie.net>
In-Reply-To: <20130327125114.GA22214@shrek.podlesie.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:51 AM, Krzysztof Mazur wrote:
> On Mon, Mar 25, 2013 at 06:26:50PM +0100, Ronald wrote:
>> In reply to [1]: I have the same issue. Git bisect took 50+ rebuilds xD
>>
>> Smartd does not work anymore since 84a9a8cd9 ([libata] Set proper SK
>> when CK_COND is set.).
>>
>> I hope I'm not stepping on anyone's toe's by chosing the same title.
>> I'm not subscribed to this list.
>>
>> Just wanted to add a 'me2'
>>
>> [1] http://www.spinics.net/lists/linux-ide/msg45268.html
>
> It seems that the SAM_STAT_CHECK_CONDITION is not cleared
> causing -EIO, because that patch modified sensebuf and
> the check for clearing SAM_STAT_CHECK_CONDITION is no longer valid.
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 318b413..ff44787 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
>   			struct scsi_sense_hdr sshdr;
>   			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
>   					     &sshdr);
> -			if (sshdr.sense_key == 0 &&
> -			    sshdr.asc == 0 && sshdr.ascq == 0)
> +			if (sshdr.sense_key == RECOVERED_ERROR &&
> +			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
>   				cmd_result &= ~SAM_STAT_CHECK_CONDITION;
>   		}
>
> @@ -618,8 +618,8 @@ int ata_task_ioctl(struct scsi_device *scsidev, void __user *arg)
>   			struct scsi_sense_hdr sshdr;
>   			scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
>   						&sshdr);
> -			if (sshdr.sense_key == 0 &&
> -				sshdr.asc == 0 && sshdr.ascq == 0)
> +			if (sshdr.sense_key == RECOVERED_ERROR &&
> +			    sshdr.asc == 0 && sshdr.ascq == 0x1d)
>   				cmd_result &= ~SAM_STAT_CHECK_CONDITION;

applied



