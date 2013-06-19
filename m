Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab3FSQwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:52:12 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50105 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab3FSQwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:52:09 -0400
Message-ID: <51C1E1B6.8090203@linaro.org>
Date: Wed, 19 Jun 2013 09:52:06 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com> <1371655523-15609-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1371655523-15609-3-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:25 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> The high resolution timer code gets notified of step changes to the
> system time with clock_was_set() or clock_was_set_delayed() calls.  If
> other parts of the kernel require similar notification there is no
> clear place to hook into.
>
> Add a clock_was_set atomic notifier chain
> (clock_was_set_notifier_list) and call this in place of
> clock_was_set().  If the timekeeping locks are held, the calls are
> deferred to a new tasklet.
>
> The hrtimer code adds a notifier block to this chain and uses it to
> call (the now internal) clock_was_set().  Since the timekeeping code
> does not call the chain from the timer irq clock_was_set_delayed() and
> associated code can be removed.

So on my initial quick review, this *looks* pretty reasonable. I get a 
little worried about interface abuse (ie: random drivers trying to hook 
into clock_was_set_notifier_list), but we can move that into 
timekeeper_internal.h or something similar to limit that.

The other issue here is we've been burned pretty badly in the past with 
changes to clock_was_set(), as its key to keeping timers in line with 
timekeeping.  So this will need a fair amount of testing and run time 
before this gets merged, so 3.12 is what we'd be targeting at the 
earliest (its getting a bit late for taking changes for 3.11 anyway).

If you want to try to push patch 1/4 in for 3.11 via the Xen tree, I'll 
see about queuing the other three for hopefully 3.12.

thanks
-john

