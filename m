Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaDHMro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:47:44 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:60455 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbaDHMrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140408102731.6C331C40933@trevor.secretlab.ca>
References: <1396509127-23819-1-git-send-email-peter.ujfalusi@ti.com>
 <20140403094059.GR14763@sirena.org.uk> <20140408102731.6C331C40933@trevor.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 8 Apr 2014 05:47:22 -0700
X-Google-Sender-Auth: DJq165Mnou4GbVZcNZf8ZpAVjQE
Message-ID: <CACxGe6sUSsTuVBOYj3siHOUUnRhzM_jmdmnj0xZg3kLtNMEzCw@mail.gmail.com>
Subject: Re: [RESEND] drivercore: deferral race condition fix
To: Mark Brown <broonie@kernel.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 3:27 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, 3 Apr 2014 10:40:59 +0100, Mark Brown <broonie@kernel.org> wrote:
>> On Thu, Apr 03, 2014 at 10:12:07AM +0300, Peter Ujfalusi wrote:
>> > When the kernel is built with CONFIG_PREEMPT it is possible to reach a state
>> > when all modules loaded but some driver still stuck in the deferred list
>> > and there is a need for external event to kick the deferred queue to probe
>> > these drivers.
>>
>> Acked-by: Mark Brown <broonie@linaro.org>
>
> It's a pretty crude solution though. The problem is any "in-flight"
> probes that are going to defer will not get added to the active list.
> Rerunning the entire active list is a bit much (but it does have the
> advantage of still being conceptually simple). I think we can do better.
>
> Instead of running the entire list, we could add a check to
> driver_deferred_probe_add() that adds the device to the active list
> instead of pending list on the condition that another driver probe
> completed while the deferred probe was in-flight.
>
> I'm playing with a solution now. I'll email a proposal shortly.

Thinking out loud now...

The race can occur whenever a probe in another thread completes
successfully while the current probe is in-flight. If that has
happened, then the defer condition may be resolved and the driver
should be scheduled for retry immediately. If the core code can check
for that condition, then we can add the driver directly to the active
list and kick the workqueue.

The problem is that we don't currently have an easy way to test if a
probe has completed in another thread. This patch handles it with a
single flag that gets set whenever a probe completes while another
probe is executing. I was worried that this approach would be racy,
but after running through the scenarios I can't find a situation where
it wouldn't get added. I only concern I have remaining on this
approach is that it will trigger unnecessary retries, but even that
isn't really a problem because the pending list will have been moved
to the active list *anyway*. It isn't even a retry of the whole list
that's happening because most likely the only device on the pending
list will be the one that completed with -EPROBE_DEFER.

So, I actually think this is the right approach now. I'll reply to the
patch itself and make some comments on the code.

g.
