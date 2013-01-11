Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3AKOQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:16:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab3AKOQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:16:44 -0500
Message-ID: <50F01EC2.1000908@redhat.com>
Date: Fri, 11 Jan 2013 09:16:34 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH] module, fix percpu reserved memory exhaustion
References: <1357785669-31848-1-git-send-email-prarit@redhat.com> <87d2xc1itd.fsf@rustcorp.com.au>
In-Reply-To: <87d2xc1itd.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/10/2013 10:48 PM, Rusty Russell wrote:
> Prarit Bhargava <prarit@redhat.com> writes:
>> [   15.478160] kvm: Could not allocate 304 bytes percpu data
>> [   15.478174] PERCPU: allocation failed, size=304 align=32, alloc
>> from reserved chunk failed
> ...
>> What is happening is systemd is loading an instance of the kvm module for
>> each cpu found (see commit e9bda3b).  When the module load occurs the kernel
>> currently allocates the modules percpu data area prior to checking to see
>> if the module is already loaded or is in the process of being loaded.  If
>> the module is already loaded, or finishes load, the module loading code
>> releases the current instance's module's percpu data.
> 
> Wow, what a cool bug!  Classic unforseen side-effect.
> 
> I'd prefer not to do relocations with the module_lock held: it can be
> relatively slow.  Yet we can't do relocations before the per-cpu
> allocation, obviously.  Did you do boot timings before and after?

Heh ... I did! :)  I had a lot of concerns about moving the mutex around so I
put in print at the end of boot to see how long the boot time actually was.

>From stock kernel:

[  22.893015] PRARIT: FINAL BOOT MESSAGE

>From stock kernel + my patch:

[  22.673214] PRARIT: FINAL BOOT MESSAGE

Both kernel boots showed the problem with kvm loading.  A quick grep through my
bootlogs of stock kernel + my patch don't show anything greater than 23.539392
and less than 20.980321.  Those numbers are similar to the numbers from the
stock kernel (23.569450 - 20.898321).

ie) I don't think there's an increase due to calling the relocation under the
module mutex, and if there is it is definitely lost within the noise of boot.

The timing were similar.  I didn't see any huge delays, etc.  Can the
relocations really cause a long delay?  I thought we were pretty much writing
values to memory...

[I should point out that I'm booting a 32 physical/64 logical, with 64GB of memory]

> 
> An alternative would be to put the module into the list even earlier
> (say, just after layout_and_allocate) so we could block on concurrent
> loads at that point.  But then we have to make sure noone looks in the
> module too early before it's completely set up, and that's complicated
> and error-prone too.  A separate list is kind of icky.

Yeah -- that was my first attempt actually, and it got very complex very
quickly.  I abandoned that approach in favor of moving the percpu allocations
under the lock.  I thought that was likely the easiest approach.

> 
> We currently have PERCPU_MODULE_RESERVE set at 8k: in my 32-bit
> allmodconfig build, there are only three modules with per-cpu data,
> totalling 328 bytes.  So it's not reasonable to increase that number to
> paper over this.

I've been thinking about that.  The problem is that at the same time the kvm
problem occurs I'm attempting to load a debug module that I've written to debug
some cpu timer issues that allocates a large amount of percpu data (~.5K/cpu).
While extending PERCPU_MODULE_RESERVE to 10k might work now, it might not work
tomorrow if I have the need to increase the size of my log buffer.

... that is ;), I prefer your and my approach of fixing this problem.

> 
> This is what a new boot state looks like (pains not to break ksplice).
> It's two patches, but I'll just post them back to back:
> 
> module: add new state MODULE_STATE_UNFORMED
> 
> You should never look at such a module, so it's excised from all paths
> which traverse the modules list.
> 
> We add the state at the end, to avoid gratuitous ABI break (ksplice).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
<snip patch>

Sure, but I'm always nervous about expanding any state machine ;).  That's just
me though :).

> 
> module: put modules in list much earlier.
> 
> Prarit's excellent bug report:
>> In recent Fedora releases (F17 & F18) some users have reported seeing
>> messages similar to
>>
>> [   15.478160] kvm: Could not allocate 304 bytes percpu data
>> [   15.478174] PERCPU: allocation failed, size=304 align=32, alloc from
>> reserved chunk failed
>>
>> during system boot.  In some cases, users have also reported seeing this
>> message along with a failed load of other modules.
>>
>> What is happening is systemd is loading an instance of the kvm module for
>> each cpu found (see commit e9bda3b).  When the module load occurs the kernel
>> currently allocates the modules percpu data area prior to checking to see
>> if the module is already loaded or is in the process of being loaded.  If
>> the module is already loaded, or finishes load, the module loading code
>> releases the current instance's module's percpu data.
> 
> Now we have a new state MODULE_STATE_UNFORMED, we can insert the
> module into the list (and thus guarantee its uniqueness) before we
> allocate the per-cpu region.
> 
> Reported-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 

<snip patch>

Tested-by: Prarit Bhargava <prarit@redhat.com>

Rusty, you can change that to an Acked-by if you prefer that.  I know some
engineers prefer one over the other.  I'll also continue doing some reboot
testing and will email back in a few days to let you know what the timing looks
like.

Thanks!,

P.
