Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3JKLj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:39:56 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13103 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab3JKLjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:39:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 11 Oct 2013 04:39:54 -0700
Message-ID: <5257E29C.6090608@nvidia.com>
Date: Fri, 11 Oct 2013 14:35:56 +0300
From: Arto Merilainen <amerilainen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] gpu: host1x: Add syncpoint base support
References: <1381319650-9799-1-git-send-email-amerilainen@nvidia.com> <1381319650-9799-2-git-send-email-amerilainen@nvidia.com> <20131011093905.GA8659@ulmo.nvidia.com>
In-Reply-To: <20131011093905.GA8659@ulmo.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 12:39 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Wed, Oct 09, 2013 at 02:54:08PM +0300, Arto Merilainen wrote:
>> This patch adds support for hardware syncpoint bases. This creates
>> a simple mechanism for waiting an operation to complete in the middle
>> of the command buffer.
>
> Perhaps "... simple mechanism to stall the command FIFO until an
> operation is completed." That's what the TRM contains and more
> accurately describes the hardware functionality.
>
>> diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
> [...]
>> @@ -26,6 +26,7 @@
>>   #include "cdma.h"
>>   #include "job.h"
>>
>> +struct host1x_base;
>
> host1x_syncpt_base is more explicit, host1x_base sounds very generic.

I agree.

>
>> diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
>> index ee19962..5f9f735 100644
>> --- a/drivers/gpu/host1x/hw/channel_hw.c
>> +++ b/drivers/gpu/host1x/hw/channel_hw.c
>> @@ -67,6 +67,21 @@ static void submit_gathers(struct host1x_job *job)
>>   	}
>>   }
>>
>> +static inline void synchronize_syncpt_base(struct host1x_job *job)
>> +{
>> +	struct host1x_channel *ch = job->channel;
>> +	struct host1x *host = dev_get_drvdata(ch->dev->parent);
>> +	struct host1x_syncpt *sp = host->syncpt + job->syncpt_id;
>> +	u32 base_id = sp->base->id;
>> +	u32 base_val = host1x_syncpt_read_max(sp);
>> +
>> +	host1x_cdma_push(&ch->cdma,
>> +			 host1x_opcode_setclass(HOST1X_CLASS_HOST1X,
>> +				host1x_uclass_load_syncpt_base_r(), 1),
>> +			 host1x_uclass_load_syncpt_base_base_indx_f(base_id) |
>> +			 host1x_uclass_load_syncpt_base_value_f(base_val));
>
> Please use the all-caps version of the register definitions. The
> lowercase variants were only introduced to allow profiling and coverage
> testing, which I think nobody's been doing and I'm in fact thinking
> about removing them.

Will fix.

>
>> diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
> [...]
>> +static struct host1x_base *host1x_base_alloc(struct host1x *host)
>> +{
>> +	struct host1x_base *base = host->bases;
>> +	int i;
>
> unsigned int

Ops. Will fix.

>
>> +
>> +	for (i = 0; i < host->info->nb_bases && base->reserved; i++, base++)
>> +		;
>
> I'd like to see this rewritten as:
>
> 	for (i = 0; i < host->info->nb_bases; i++) {
> 		if (!host->bases[i].reserved)
> 			break;
> 	}

I agree, that looks less obfuscated.

>
>> +static void host1x_base_free(struct host1x_base *base)
>> +{
>> +	if (!base)
>> +		return;
>> +	base->reserved = false;
>> +}
>
> The following would be somewhat shorter:
>
> 	if (base)
> 		base->reserved = false;
>
>>   static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
>>   						  struct device *dev,
>> -						  bool client_managed)
>> +						  bool client_managed,
>> +						  bool support_base)
>
> I think at this point we probably want to introduce a flags argument
> instead of adding all those boolean parameters. Something like:
>
> 	#define HOST1X_SYNCPT_CLIENT_MANAGED	(1 << 0)
> 	#define HOST1X_SYNCPT_HAS_BASE		(1 << 1)
>
> 	struct host1x_syncpt *host1x_syncpt_alloc(struct host1x *host,
> 						  struct device *dev,
> 						  unsigned long flags);
>

This is not a bad idea... I will write a patch for that.

>>   int host1x_syncpt_init(struct host1x *host)
>>   {
>>   	struct host1x_syncpt *syncpt;
>> +	struct host1x_base *bases;
>>   	int i;
>>
>> +	bases = devm_kzalloc(host->dev, sizeof(*bases) * host->info->nb_bases,
>> +		GFP_KERNEL);
>>   	syncpt = devm_kzalloc(host->dev, sizeof(*syncpt) * host->info->nb_pts,
>>   		GFP_KERNEL);
>
> I'd prefer these to be checked separately. Also the argument alignment
> is wrong here. Align with the first function argument. And for
> consistency, allocate bases after syncpoints...

Oh. Will fix.

>
>> -	if (!syncpt)
>> +	if (!syncpt || !bases)
>>   		return -ENOMEM;
>>
>> -	for (i = 0; i < host->info->nb_pts; ++i) {
>> +	for (i = 0; i < host->info->nb_bases; i++)
>> +		bases[i].id = i;
>> +
>> +	for (i = 0; i < host->info->nb_pts; i++) {
>>   		syncpt[i].id = i;
>>   		syncpt[i].host = host;
>>   	}
>
> ... and initialize them after the syncpoints...
>
>>
>>   	host->syncpt = syncpt;
>> +	host->bases = bases;
>
> ... to match the assignment order.
>

Will fix.

>> @@ -332,7 +368,14 @@ struct host1x_syncpt *host1x_syncpt_request(struct device *dev,
>>   					    bool client_managed)
>>   {
>>   	struct host1x *host = dev_get_drvdata(dev->parent);
>> -	return _host1x_syncpt_alloc(host, dev, client_managed);
>> +	return _host1x_syncpt_alloc(host, dev, client_managed, false);
>> +}
>> +
>> +struct host1x_syncpt *host1x_syncpt_request_based(struct device *dev,
>> +						  bool client_managed)
>> +{
>> +	struct host1x *host = dev_get_drvdata(dev->parent);
>> +	return _host1x_syncpt_alloc(host, dev, client_managed, true);
>>   }
>
> If we add a flags parameter to host1x_syncpt_request() (and
> host1x_syncpt_alloc()) then we don't need the separate function.
>

Will fix. (my original idea was to avoid changes in the interface but it 
is likely just a minor inconvenience..)

>> diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
>> index 267c0b9..852dc76 100644
>> --- a/drivers/gpu/host1x/syncpt.h
>> +++ b/drivers/gpu/host1x/syncpt.h
>> @@ -30,6 +30,11 @@ struct host1x;
>>   /* Reserved for replacing an expired wait with a NOP */
>>   #define HOST1X_SYNCPT_RESERVED			0
>>
>> +struct host1x_base {
>> +	u8 id;
>> +	bool reserved;
>
> Perhaps name this to something like "requested". "reserved" makes it
> sound like it's reserved for some special use.

Sounds good.

- Arto

>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

