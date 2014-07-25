Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbaGYRBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:01:20 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:39762 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932991AbaGYRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:01:18 -0400
MIME-Version: 1.0
In-Reply-To: <53CF199E.2020108@linux.vnet.ibm.com>
References: <1406040619-1722-1-git-send-email-qiudayu@linux.vnet.ibm.com>
	<20140722154244.GJ13851@htj.dyndns.org>
	<53CF199E.2020108@linux.vnet.ibm.com>
Date: Fri, 25 Jul 2014 10:01:17 -0700
Message-ID: <CAPcyv4gu6h1MOKG8xCrcCn+Bj5JyMqPUBf5wsmKWFaLjR0mq=Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] libata: Fix scsi_host can_queue issue in ata_qc_new()
From: Dan Williams <dan.j.williams@intel.com>
To: Mike Qiu <qiudayu@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "IDE/ATA development list" <linux-ide@vger.kernel.org>,
        Kevin Hao <haokexin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 7:10 PM, Mike Qiu <qiudayu@linux.vnet.ibm.com> wrote:
> On 07/22/2014 11:42 PM, Tejun Heo wrote:
>>
>> Hello,
>>
>> (cc'ing Dan)
>>
>> On Tue, Jul 22, 2014 at 10:50:19AM -0400, Mike Qiu wrote:
>>>
>>> The can_queue in scsi_host can be more than ATA_MAX_QUEUE (32),
>>> for example, in ipr, it can be 100 or more.
>>>
>>> Also, some drivers, like ipr driver, haven't filled the field
>>> scsi_host in ata_port, and will lead a call trace, so add
>>> check for that.
>>>
>>> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
>>> ---
>>>   drivers/ata/libata-core.c | 15 ++++-----------
>>>   1 file changed, 4 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index 259d879..a5b9c70 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -4734,7 +4734,10 @@ static struct ata_queued_cmd *ata_qc_new(struct
>>> ata_port *ap)
>>>         struct ata_queued_cmd *qc = NULL;
>>>         unsigned int i, tag, max_queue;
>>>   -     max_queue = ap->scsi_host->can_queue;
>>> +       if (ap->scsi_host && ap->scsi_host->can_queue <= ATA_MAX_QUEUE)
>>> +               max_queue = ap->scsi_host->can_queue;
>>> +       else
>>> +               max_queue = ATA_MAX_QUEUE;
>>>         /* no command while frozen */
>>>         if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
>>> @@ -6109,16 +6112,6 @@ int ata_host_register(struct ata_host *host,
>>> struct scsi_host_template *sht)
>>>   {
>>>         int i, rc;
>>>   -     /*
>>> -        * The max queue supported by hardware must not be greater than
>>> -        * ATA_MAX_QUEUE.
>>> -        */
>>> -       if (sht->can_queue > ATA_MAX_QUEUE) {
>>> -               dev_err(host->dev, "BUG: the hardware max queue is too
>>> large\n");
>>> -               WARN_ON(1);
>>> -               return -EINVAL;
>>> -       }
>>> -
>>
>> So, ummm, I really don't like that we're adding the conditionals to
>> the hot path (yeah, its implementation is slow but still).  Maybe we
>
>
> Yes, agree ..., not a good idea to do this...
>

...also, seems incomplete given ata_port.qcmd[] is still limited to
ATA_MAX_QUEUE.
