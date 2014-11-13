Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaKMJiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:38:55 -0500
Received: from smtp3.tech.numericable.fr ([82.216.111.39]:43520 "EHLO
	smtp3.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbaKMJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:38:53 -0500
Message-ID: <54647C10.4070506@laposte.net>
Date: Thu, 13 Nov 2014 10:38:24 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: BUG in scsi_lib.c due to a bad commit
References: <54629CAE.2000207@laposte.net> <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com> <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net> <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrjedtgddtiecutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthekrgdttdefjeenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpegrrhgthhhlihhnuhigrdhorhhg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> Were you running with scsi_mod.use_blk_mq=Y or =N?

I don't find this value in my .config file related to kernel modules
options,

perhaps you talk about a kernel boot option for grub ?
I don't use this kernel option boot in grub ( scsi_mod.use_blk_mq ),

I use archlinux and his default kernel config file for 64 bits CPU, you
can find this file here :

https://projects.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/linux

I don't have SCSI devices, I have only 3 SATA harddisks, and 2 IDE
harddisks,

before kernel 3.17 I don't have this random hang bug on boot, so we need
to know what's going on, it's probably a change made last months ago in
SCSI source code ( or something else ) who has introduced a bug who
prevents a correct behaviour on some parts in scsi_lib.c ( for example
the if statement related to atomic_read(&sdev->device_busy) and
blk_delay_queue(q, SCSI_QUEUE_DELAY)  )

Guenter Roeck was the first to have been hit by this bug ( his qemu test
files hang on boot ), he thought the solution was to revert the polarity
of the if statement, it solves his problem but unfortunately a new bug
is now triggered on some PC configurations,

it would be interesting to find a definitive solution who can solve both
the "qemu bug" and the "random bug on boot" on some PC configurations,

I'm not an expert about the scsi code, perhaps with some unit tests you
can spot the defect element in the scsi source code, check if some parts
in the source code acts really like it should be ?


Le 13/11/2014 06:33, Elliott, Robert (Server Storage) a écrit :
> 
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Barto
>> Sent: Wednesday, November 12, 2014 9:28 PM
>> To: Guenter Roeck; Bjorn Helgaas
>> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Joe
>> Perches
>> Subject: Re: BUG in scsi_lib.c due to a bad commit
>>
>> reverting your commit 045065d8a300a37218c is a solution, but it's just a
>> temporary solution,
>>
>> it's better to search why your commit can create a random hang on boot
>> on some PC configurations,
>>
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue
>> *q)
>> blk_requeue_request(q, req);
>> atomic_dec(&sdev->device_busy);
>> out_delay:
>> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
>> blk_delay_queue(q, SCSI_QUEUE_DELAY);
>> }
>>
>> perhaps the atomic_read() function doesn't make the expected job on some
>> rare circonstances, I have the same doubts about the blk_delay_queue()
>> function
> 
> Were you running with scsi_mod.use_blk_mq=Y or =N?
> 
> device_busy is the active queue depth for the device (e.g.
> 5 means there are 5 commands submitted but not yet completed).
> 
> The function reaches this code if it has run out of tags, the host
> has reached its limit of outstanding commands, or the target has
> reached its limit.  It requeus the request:
> * with delay if device_busy is zero
> * without delay if device_busy is non_zero
> 
> I think this is the reasoning:
> If device_busy is zero, trying to process the request again will
> probably run into the same problem; a delay gives time for the
> situation to change.  If device_busy is non-zero, then the 
> requeued command goes behind others and might get a different
> result.
> 
> With the polarity backwards, the lack of delay hung PA-RISC 
> and SPARC64 systems), not just QEMU.  So, I don't think reverting
> the fix is good.
> 
> Changing it to an unconditional delay might be safe - delay
> regardless of device_busy (until the root cause is understood).
> 
> Also, SCSI_QUEUE_DELAY seems like an arbitrary magic number; 
> maybe that value isn't working correctly anymore?
> 
> 
