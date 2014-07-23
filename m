Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaGWCKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:10:50 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:32780 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaGWCKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:10:48 -0400
Message-ID: <53CF199E.2020108@linux.vnet.ibm.com>
Date: Wed, 23 Jul 2014 10:10:38 +0800
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        haokexin@gmail.com, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] libata: Fix scsi_host can_queue issue in ata_qc_new()
References: <1406040619-1722-1-git-send-email-qiudayu@linux.vnet.ibm.com> <20140722154244.GJ13851@htj.dyndns.org>
In-Reply-To: <20140722154244.GJ13851@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072302-1618-0000-0000-0000009FFAAD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 11:42 PM, Tejun Heo wrote:
> Hello,
>
> (cc'ing Dan)
>
> On Tue, Jul 22, 2014 at 10:50:19AM -0400, Mike Qiu wrote:
>> The can_queue in scsi_host can be more than ATA_MAX_QUEUE (32),
>> for example, in ipr, it can be 100 or more.
>>
>> Also, some drivers, like ipr driver, haven't filled the field
>> scsi_host in ata_port, and will lead a call trace, so add
>> check for that.
>>
>> Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
>> ---
>>   drivers/ata/libata-core.c | 15 ++++-----------
>>   1 file changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 259d879..a5b9c70 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -4734,7 +4734,10 @@ static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
>>   	struct ata_queued_cmd *qc = NULL;
>>   	unsigned int i, tag, max_queue;
>>   
>> -	max_queue = ap->scsi_host->can_queue;
>> +	if (ap->scsi_host && ap->scsi_host->can_queue <= ATA_MAX_QUEUE)
>> +		max_queue = ap->scsi_host->can_queue;
>> +	else
>> +		max_queue = ATA_MAX_QUEUE;
>>   
>>   	/* no command while frozen */
>>   	if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
>> @@ -6109,16 +6112,6 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
>>   {
>>   	int i, rc;
>>   
>> -	/*
>> -	 * The max queue supported by hardware must not be greater than
>> -	 * ATA_MAX_QUEUE.
>> -	 */
>> -	if (sht->can_queue > ATA_MAX_QUEUE) {
>> -		dev_err(host->dev, "BUG: the hardware max queue is too large\n");
>> -		WARN_ON(1);
>> -		return -EINVAL;
>> -	}
>> -
> So, ummm, I really don't like that we're adding the conditionals to
> the hot path (yeah, its implementation is slow but still).  Maybe we

Yes, agree ..., not a good idea to do this...

Thanks
Mike
> need to store the chosen queue depth after all?  Dan?
>
> Thanks.
>

