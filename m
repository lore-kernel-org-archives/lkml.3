Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916Ab3E1Fsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 01:48:55 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15440 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853Ab3E1Fsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 01:48:53 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 01:48:53 EDT
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 27 May 2013 22:43:45 -0700
Message-ID: <51A4445F.1000201@nvidia.com>
Date: Tue, 28 May 2013 08:45:03 +0300
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Mayuresh Kulkarni <mkulkarni@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com> <20130527154539.GD9460@mithrandir>
In-Reply-To: <20130527154539.GD9460@mithrandir>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.05.2013 18:45, Thierry Reding wrote:
> On Mon, May 27, 2013 at 07:19:28PM +0530, Mayuresh Kulkarni wrote:
>> +#ifdef CONFIG_PM_RUNTIME
>> +static int host1x_runtime_suspend(struct device *dev)
>> +{
>> +	struct host1x *host;
>> +
>> +	host = dev_get_drvdata(dev);
>> +	if (IS_ERR_OR_NULL(host))
> 
> I think a simple
> 
> 	if (!host)
> 		return -EINVAL;
> 
> would be enough here. The driver-data of the device should never be an
> ERR_PTR()-encoded value, but either a valid pointer to a host1x object
> or NULL.

True, we should avoid IS_ERR_OR_NULL() like plague. We always know if
the called API returns a NULL on error or an error code. In case of
error code we should just propagate that.

> Same comments apply here. Also I think it might be a good idea to split
> the host1x and gr2d changes into separate patches.

That's a bit tricky, but doable. We just need to enable it for 2D first,
and then host1x to keep bisectability.

>>  static void action_submit_complete(struct host1x_waitlist *waiter)
>>  {
>> +	int completed = waiter->count;
>>  	struct host1x_channel *channel = waiter->data;
>>  
>> +	/* disable clocks for all the submits that got completed in this lot */
>> +	while (completed--)
>> +		pm_runtime_put(channel->dev);
>> +
>>  	host1x_cdma_update(&channel->cdma);
>>  
>> -	/*  Add nr_completed to trace */
>> +	/* Add nr_completed to trace */
>>  	trace_host1x_channel_submit_complete(dev_name(channel->dev),
>>  					     waiter->count, waiter->thresh);
>> -
>>  }
> 
> This feels hackish. But I can't see any better place to do this. Terje,
> Arto: any ideas how we can do this in a cleaner way? If there's nothing
> better then maybe moving the code into a separate function, say
> host1x_waitlist_complete(), might make this less awkward?

Yeah, it's a bit awkward. action_submit_complete() actually does handle
completion of multiple jobs, and we do one pm_runtime_get() per job.

We could do pm_runtime_put() in host1x_cdma_update(). It anyway goes
through each job that is completed, so while freeing the job it could as
well call runtime PM. That way we could even remove the waiter->count
variable altogether as it's not needed anymore.

The not-so-beautiful aspect is that we do pm_runtime_get() in
host1x_channel.c and pm_runtime_put() in host1x_cdma.c. For code
readability it's be great to have them in the same file. I actually get
questions every now and then because in downstream because of doing
these operations in different files.

Terje
