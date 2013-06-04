Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3FDIlg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:41:36 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7307 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab3FDIld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:41:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 04 Jun 2013 01:40:58 -0700
Message-ID: <51ADA837.4020907@nvidia.com>
Date: Tue, 4 Jun 2013 14:11:27 +0530
From: Mayuresh Kulkarni <mkulkarni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Terje Bergstrom <tbergstrom@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "airlied@redhat.com" <airlied@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com> <20130527154539.GD9460@mithrandir> <51A4445F.1000201@nvidia.com> <20130528091022.GB10934@mithrandir>
In-Reply-To: <20130528091022.GB10934@mithrandir>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 02:40 PM, Thierry Reding wrote:
> * PGP Signed by an unknown key
>
> On Tue, May 28, 2013 at 08:45:03AM +0300, Terje Bergström wrote:
>> On 27.05.2013 18:45, Thierry Reding wrote:
>>> On Mon, May 27, 2013 at 07:19:28PM +0530, Mayuresh Kulkarni wrote:
>>>> +#ifdef CONFIG_PM_RUNTIME
>>>> +static int host1x_runtime_suspend(struct device *dev)
>>>> +{
>>>> +	struct host1x *host;
>>>> +
>>>> +	host = dev_get_drvdata(dev);
>>>> +	if (IS_ERR_OR_NULL(host))
>>>
>>> I think a simple
>>>
>>> 	if (!host)
>>> 		return -EINVAL;
>>>
>>> would be enough here. The driver-data of the device should never be an
>>> ERR_PTR()-encoded value, but either a valid pointer to a host1x object
>>> or NULL.
>>
>> True, we should avoid IS_ERR_OR_NULL() like plague. We always know if
>> the called API returns a NULL on error or an error code. In case of
>> error code we should just propagate that.
>
> Yes, that's the case in general. In this specific case the value
> obtained by dev_get_drvdata() should either be a valid pointer or NULL,
> never an error code. We can easily make sure by only setting the data
> (using platform_set_drvdata()) when the pointer is valid.
>
> Thinking about it some more, I don't think we can ever get NULL here. A
> device's .runtime_suspend() cannot be called when the device has been
> removed, right? That's the only case where the value returned might be
> NULL. It would be NULL too if host1x wasn't initialized yet, but that's
> already dealt with by the proper ordering in .probe().
>
>>> Same comments apply here. Also I think it might be a good idea to split
>>> the host1x and gr2d changes into separate patches.
>>
>> That's a bit tricky, but doable. We just need to enable it for 2D first,
>> and then host1x to keep bisectability.
>
> Right, there's a dependency. But I'd still prefer to have them separate.
> Unless it gets really messy.
>
>>>>   static void action_submit_complete(struct host1x_waitlist *waiter)
>>>>   {
>>>> +	int completed = waiter->count;
>>>>   	struct host1x_channel *channel = waiter->data;
>>>>
>>>> +	/* disable clocks for all the submits that got completed in this lot */
>>>> +	while (completed--)
>>>> +		pm_runtime_put(channel->dev);
>>>> +
>>>>   	host1x_cdma_update(&channel->cdma);
>>>>
>>>> -	/*  Add nr_completed to trace */
>>>> +	/* Add nr_completed to trace */
>>>>   	trace_host1x_channel_submit_complete(dev_name(channel->dev),
>>>>   					     waiter->count, waiter->thresh);
>>>> -
>>>>   }
>>>
>>> This feels hackish. But I can't see any better place to do this. Terje,
>>> Arto: any ideas how we can do this in a cleaner way? If there's nothing
>>> better then maybe moving the code into a separate function, say
>>> host1x_waitlist_complete(), might make this less awkward?
>>
>> Yeah, it's a bit awkward. action_submit_complete() actually does handle
>> completion of multiple jobs, and we do one pm_runtime_get() per job.
>>
>> We could do pm_runtime_put() in host1x_cdma_update(). It anyway goes
>> through each job that is completed, so while freeing the job it could as
>> well call runtime PM. That way we could even remove the waiter->count
>> variable altogether as it's not needed anymore.
>
> That sounds a lot better. We could add a helper (host1x_job_finish()
> perhaps) with the following from update_cdma_locked():
>
> 	/* Unpin the memory */
> 	host1x_job_unpin(job);
>
> 	/* Pop push buffer slots */
> 	if (job->num_slots) {
> 		struct push_buffer *pb = &cdma->push_buffer;
> 		host1x_pushbuffer_pop(pb, job->num_slots);
> 		if (cdma->event == CDMA_EVENT_PUSH_BUFFER_SPACE)
> 			signal = true;
> 	}
>
> 	list_del(&job->list);
>
> And add pm_runtime_put() (as well as potentially other stuff) in there.
> That'll prevent update_cdma_unlocked() from growing too much. It isn't
> too bad right now, so maybe a helper isn't warranted yet, but I don't
> think it'll hurt.
>
>> The not-so-beautiful aspect is that we do pm_runtime_get() in
>> host1x_channel.c and pm_runtime_put() in host1x_cdma.c. For code
>> readability it's be great to have them in the same file. I actually get
>> questions every now and then because in downstream because of doing
>> these operations in different files.
>
> With the above helper in place, we could move host1x_job_submit() to
> job.c instead and have all the code in one file.
>
> Thierry
>
> * Unknown Key
> * 0x7F3EB3A1
>

In downstream, we have 2 APIs which are wrapper over runtime PM calls. 
We call those from _submit and job complete.

I wonder if we should follow the same here?

