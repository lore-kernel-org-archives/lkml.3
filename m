Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965737AbaKNSXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 13:23:24 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:38393 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964931AbaKNSXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 13:23:22 -0500
Message-ID: <5466489F.8020807@gmail.com>
Date: Fri, 14 Nov 2014 13:23:27 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alex Elder <elder@linaro.org>, Steven Rostedt <rostedt@goodmis.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>,
        Jan Kara <jack@suse.cz>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Joe Perches <joe@perches.com>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile type
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>	<546589A1.9040100@linaro.org>	<20141113235722.7457f9c7@gandalf.local.home> <20141114002436.535a16a9@gandalf.local.home> <54663046.7050800@linaro.org>
In-Reply-To: <54663046.7050800@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/14/2014 11:39 AM, Alex Elder wrote:
> On 11/13/2014 11:24 PM, Steven Rostedt wrote:
>> On Thu, 13 Nov 2014 23:57:22 -0500
>> Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>>> That assignment is what it is initialized to at boot up. I can't see
>>> any optimization that would cause gcc to modify that. Especially since
>>> we are hiding its accesses within the ACCESS_ONCE(). That alone should
>>> confuse gcc enough to leave it a hell alone J.
>>
>> I'm actually wondering if the ACCESS_ONCE or volatile is even needed.
>>
>> static variables are used to maintain state, and that goes for
>> recursive functions. gcc should not touch it.
> I think you're right.
>
> Here's some extra analysis.  I may be wrong on a detail or
> two but see if it makes sense.
>
> The logbuf_cpu variable has static storage duration, so will
> be initialized before program startup.
>
> This function (vprintk_emit()) can be called on multiple
> CPUs concurrently.  So we can assume that there is more than
> one thread executing in window from the start of the function
> until the raw_spin_lock(&logbuf_lock) call is made.
>
> The only writes to logbuf_lock are made under protection
> of the spinlock.  It is initially UINT_MAX; it is changed
> to the current processor id right after taking the lock;
> and it is reverted to UINT_MAX right before releasing the
> lock.  So logbuf_cpu will either contain UINT_MAX, or will
> hold the processor id of the CPU that is holding logbuf_lock.
> The spinlock barrier ensures that the only value a CPU will
> see is UINT_MAX, unless it is the CPU that holds the spinlock.
>
> There is only one read of logbuf_cpu:
>         if (unlikely(logbuf_cpu == this_cpu)) {
> This is called only while local interrupts are disabled, so
> if this condition holds it cannot be due to an interrupt--it
> must be due to simple recursion into printk() while inside
> the spinlock-protected critical section.
>
> We *can* recurse into printk() via a function call within
> the protected section--through vscnprintf(), which can
> descend into printk() via WARN() calls in format_decode().
> (There may be others after that point, but up to there it
> looks like no other function call in that section can fail.)
> So it *is* possible to hit this recursion (I wanted to
> verify that...).
>
> OK.  So back to the original issue...  How do we ensure
> the value of logbuf_cpu is in fact the last set value,
> and is not affected by any compiler reordering?
>
> If its value is anything other than UINT_MAX, it will
> be the current CPU's processor id, which will have been
> set by the current CPU.  There are no issues related to
> caches or barriers.
>
> Since vprintk_emit() is a public entry point there's no
> magic inter-function optimization or inlining that could
> allow the value of the static logbuf_cpu to be preserved
> between calls.  So the first read of logbuf_cpu in a given
> function call will have to fetch its current value from memory
> (regardless of whether there's a "volatile" qualifier).
>
> And therefore the one read of that value will involve
> fetching the "real" value from memory, and it will
> either be UINT_MAX or the CPU's own processor id.
>
> So there should be no need to declare the variable
> volatile, nor to access it with ACCESS_ONCE().
>
> QED.  (Well, please correct me where I'm wrong...)
>

Thanks Alex, for the in-depth analysis. Please drop my patch in favour of removing volatile and without ACCESS_ONCE(). Will you send in such a patch?
