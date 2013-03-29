Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3C2RGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:06:19 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:49760 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100Ab3C2RGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130329161056.GA9322@shrek.podlesie.net>
References: <CAF1_xX3Ox6=fKomLpvrDxMZ9edB0=2SrVDDPrU0nivD_Yj6KHw@mail.gmail.com>
	<1364570801-6515-1-git-send-email-gwendal@google.com>
	<20130329161056.GA9322@shrek.podlesie.net>
Date: Fri, 29 Mar 2013 10:06:15 -0700
Message-ID: <CAMHSBOXOrxihwBNuA=uN+SKifzZx8UR40=gNnxbkRpk92FQjKg@mail.gmail.com>
Subject: Re: [PATCH] [libata] Fix HDIO_DRIVE_CMD ioctl sense data check
From: Gwendal Grignou <gwendal@google.com>
To: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: ronald645@gmail.com,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yours work.

On Fri, Mar 29, 2013 at 9:10 AM, Krzysztof Mazur <krzysiek@podlesie.net> wrote:
> On Fri, Mar 29, 2013 at 08:26:41AM -0700, Gwendal Grignou wrote:
>> commit 84a9a8cd9d0aa93c17e5815ab8a9cc4c0a765c63 changed the sense key
>> used for returning task registers, but HDIO_DRIVE_CMD ioctl was
>> not changed accordingly.
>>
>> Tested: check that SMART ENABLE sent using HDIO_DRIVE_CMD returns 0
>> instead of EIO.
>>
>> Signed-off-by: Gwendal Grignou <gwendal@google.com>
>> ---
>>  drivers/ata/libata-scsi.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 318b413..e05bf4c 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -532,8 +532,8 @@ int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg)
>>                       struct scsi_sense_hdr sshdr;
>>                       scsi_normalize_sense(sensebuf, SCSI_SENSE_BUFFERSIZE,
>>                                            &sshdr);
>> -                     if (sshdr.sense_key == 0 &&
>> -                         sshdr.asc == 0 && sshdr.ascq == 0)
>> +                     if (sshdr.sense_key == RECOVERED_ERROR &&
>> +                         sshdr.asc == 0 && sshdr.ascq == 0x1D)
>>                               cmd_result &= ~SAM_STAT_CHECK_CONDITION;
>>               }
>>
>> --
>> 1.8.1.3
>
> I did not test your patch, but I think that you missed the second
> test in ata_task_ioctl() and the kernel will still return -EIO
> in case of HDIO_DRIVE_TASK (0x31e) ioctl.
> See http://marc.info/?l=linux-kernel&m=136438868606981&w=2.
> The version I've sent fixes the problem for me.
>
> Krzysiek
