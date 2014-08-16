Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHPMEz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:04:55 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:47057 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaHPMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140816113718.GA9305@htj.dyndns.org>
References: <1408184238-1733-1-git-send-email-arjun024@gmail.com> <20140816113718.GA9305@htj.dyndns.org>
From: Arjun Sreedharan <arjun024@gmail.com>
Date: Sat, 16 Aug 2014 17:34:31 +0530
Message-ID: <CAJFMrCFKEQXn79Piofwi0Ph0bRVJx-uMasYk_RW36Sp0FTKoEg@mail.gmail.com>
Subject: Re: [PATCH] ata: propagate return value of scc_wait_after_reset
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 August 2014 17:07, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Aug 16, 2014 at 03:47:17PM +0530, Arjun Sreedharan wrote:
>> scc_bus_softreset not necessarily should return zero.
>> Propagate the error code.
>> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
>> ---
>>  drivers/ata/pata_scc.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
>> index 4e006d7..5618c4518 100644
>> --- a/drivers/ata/pata_scc.c
>> +++ b/drivers/ata/pata_scc.c
>> @@ -585,7 +585,7 @@ static int scc_wait_after_reset(struct ata_link *link, unsigned int devmask,
>>   *   Note: Original code is ata_bus_softreset().
>>   */
>>
>> -static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
>> +static int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
>>                                        unsigned long deadline)
>>  {
>>       struct ata_ioports *ioaddr = &ap->ioaddr;
>> @@ -599,9 +599,7 @@ static unsigned int scc_bus_softreset(struct ata_port *ap, unsigned int devmask,
>
> scc_bus_softreset() should return int too, right?

I have changed it from unsigned int to int for better clarity since
scc_wait_after_reset() could
return negative errnos. Any issues ??

>
>>       udelay(20);
>>       out_be32(ioaddr->ctl_addr, ap->ctl);
>>
>> -     scc_wait_after_reset(&ap->link, devmask, deadline);
>> -
>> -     return 0;
>> +     return scc_wait_after_reset(&ap->link, devmask, deadline);
>>  }
>>
>>  /**
>> @@ -618,7 +616,8 @@ static int scc_softreset(struct ata_link *link, unsigned int *classes,
>>  {
>>       struct ata_port *ap = link->ap;
>>       unsigned int slave_possible = ap->flags & ATA_FLAG_SLAVE_POSS;
>> -     unsigned int devmask = 0, err_mask;
>> +     unsigned int devmask = 0;
>> +     int err_mask;
>
> @rc or @ret would be a better name for it.

rc would be better. yes. will do.

>
> Thanks.
>
> --
> tejun
