Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaDHNQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:16:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47117 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbaDHNQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:16:36 -0400
Message-ID: <5343F6AD.9050300@ti.com>
Date: Tue, 8 Apr 2014 16:16:29 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>, Mark Brown <broonie@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] drivercore: deferral race condition fix
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com> <20140403094059.GR14763@sirena.org.uk> <20140408102731.6C331C40933@trevor.secretlab.ca> <CACxGe6sUSsTuVBOYj3siHOUUnRhzM_jmdmnj0xZg3kLtNMEzCw@mail.gmail.com>
In-Reply-To: <CACxGe6sUSsTuVBOYj3siHOUUnRhzM_jmdmnj0xZg3kLtNMEzCw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 03:47 PM, Grant Likely wrote:
> On Tue, Apr 8, 2014 at 3:27 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Thu, 3 Apr 2014 10:40:59 +0100, Mark Brown <broonie@kernel.org> wrote:
>>> On Thu, Apr 03, 2014 at 10:12:07AM +0300, Peter Ujfalusi wrote:
>>>> When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
>>>> when all modules loaded but some driver still stuck in the deferred list
>>>> and there is a need for external event to kick the deferred queue to probe
>>>> these drivers.
>>>
>>> Acked-by: Mark Brown <broonie@linaro.org>
>>
>> It's a pretty crude solution though. The problem is any "in-flight"
>> probes that are going to defer will not get added to the active list.
>> Rerunning the entire active list is a bit much (but it does have the
>> advantage of still being conceptually simple). I think we can do better.
>>
>> Instead of running the entire list, we could add a check to
>> driver_deferred_probe_add() that adds the device to the active list
>> instead of pending list on the condition that another driver probe
>> completed while the deferred probe was in-flight.
>>
>> I'm playing with a solution now. I'll email a proposal shortly.
> 
> Thinking out loud now...
> 
> The race can occur whenever a probe in another thread completes
> successfully while the current probe is in-flight. If that has
> happened, then the defer condition may be resolved and the driver
> should be scheduled for retry immediately. If the core code can check
> for that condition, then we can add the driver directly to the active
> list and kick the workqueue.
> 
> The problem is that we don't currently have an easy way to test if a
> probe has completed in another thread. This patch handles it with a
> single flag that gets set whenever a probe completes while another
> probe is executing. I was worried that this approach would be racy,
> but after running through the scenarios I can't find a situation where
> it wouldn't get added. I only concern I have remaining on this
> approach is that it will trigger unnecessary retries, but even that
> isn't really a problem because the pending list will have been moved
> to the active list *anyway*. It isn't even a retry of the whole list
> that's happening because most likely the only device on the pending
> list will be the one that completed with -EPROBE_DEFER.

This code will only going to add one retry and it is going to that only under
the condition you have described:
the last driver which finishes it's probe ends up with -EPROBE_DEFER and while
it's probe was in-flight another driver loaded with success.
In all other cases this will not trigger a retry:
If you load only one driver which ends up deferring,
If the driver which differing is not the last driver to load - since we will
have other drivers to be loaded and they will kick the list anyways.

> So, I actually think this is the right approach now. I'll reply to the
> patch itself and make some comments on the code.

Thanks, I'll check the comments.

-- 
Péter
