Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaKZPW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 10:22:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaKZPW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 10:22:56 -0500
Date: Wed, 26 Nov 2014 17:22:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141126152229.GC9612@redhat.com>
References: <1416915806-24757-1-git-send-email-dahi@linux.vnet.ibm.com>
 <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126110504.511b733a@thinkpad-w530>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm you sent same mail to me off-list, and I replied there.
Now there's a copy on list - I'm just going to assume
it's exactly identical, pasting my response here as well.
If there are more questions I missed, let me know.

On Wed, Nov 26, 2014 at 09:23:31AM +0100, David Hildenbrand wrote:
> Sorry I haven't put you on cc, must have lost you while packing my list :)
> Thanks for your answer!
> 
> This change was introduced in 2013, and I haven't seen an instance making use
> of your described scenario, right?

My work is still out of tree. RHEL6 shipped some patches that use
this. I don't know whether any instances in-tree use this capability.

But it just doesn't make sense for might_fault to call might_sleep
because a fault does not imply sleep.

> > On Tue, Nov 25, 2014 at 12:43:24PM +0100, David Hildenbrand wrote:
> > > I recently discovered that commit 662bbcb2747c2422cf98d3d97619509379eee466
> > > removed/skipped all might_sleep checks for might_fault() calls when in atomic.
> > 
> > Yes.  You can add e.g. might_sleep in your code if, for some reason, it is
> > illegal to call it in an atomic context.
> > But faults are legal in atomic if you handle the possible
> > errors, and faults do not necessary cause caller to sleep, so might_fault
> > should not call might_sleep.
> 
> I think we should use in_atomic variants for this purpose (as done in the code
> for now) - especially as pagefault_disable has been relying on the preempt
> count for a long time. But see my comment below about existing documentation.

IIUC they are not interchangeable.
*in_atomic seems to require that page is pinned.
*user does not: it installs a fixup so you get an error code if you try
to access an invalid address.

Besides, this would just lead to a ton of
 if (atomic) return inatomic else return user
in code, for no good purpose.

> > 
> > > Reason was to allow calling copy_(to|from)_user while in pagefault_disabled(),
> > > because otherwise, CONFIG_DEBUG_ATOMIC_SLEEP would find false positives.
> > 
> > That wasn't the only reason BTW.
> > Andi Kleen also showed that compiler did a terrible job optimizing
> > get/put user when might_sleep was called.
> 
> might_fault() should never call might_sleep() when lock debugging is off, so
> there should be no performance problem or am I missing something?

CONFIG_DEBUG_ATOMIC_SLEEP too, no?

> > See e.g. this thread:
> > https://lkml.org/lkml/2013/8/14/652
> > There was even an lwn.net article about it, that I don't seem to be
> > able to locate.
> 
> Thanks, will see if I can find it.
> 
> > So might_sleep is not appropriate for lightweight operations like __get_user,
> > which people literally expect to be a single instruction.
> 
> Yes, as discussed below, __.* variants should never call it.

So that would be even more inconsistent. They fault exactly the same as
the non __ variants.


> > 
> > 
> > I also have a project going which handles very short packets by copying
> > them into guest memory directly without waking up a thread.
> > I do it by calling recvmsg on a socket, then switching to
> > a thread if I get back EFAULT.
> > Not yet clean enough to upstream but it does seem to cut
> > the latency down quite a bit, so I'd like to have the option.
> > 
> > 
> > Generally, a caller that does something like this under a spinlock:
> >         preempt_disable
> >         pagefault_disable
> >         error = copy_to_user
> >         pagefault_enable
> >         preempt_enable_no_resched
> > 
> > is not doing anything wrong and should not get a warning,
> > as long as error is handled correctly later.
> 
> I think this would be a perfect fit for an inatomic variant, no?

No because inatomic does not handle faults.

> I mean even the copy_to_user documentation of e.g. s390, x86, mips
> clearly says:
> 	"Context: User context only.>-This function may sleep."

So the comment is incomplete - I didn't get around fixing that.
It may sleep but not in atomic context.

> So calling it from your described scenario is wrong. And as the interface says,
> it might_sleep() and therefore also call the check in might_fault().

Exactly the reverse.
There's no way for it to sleep except on fault and that only if
preempttion is on.

> > 
> > You can also find the discussion around the patches
> > educational:
> > http://article.gmane.org/gmane.comp.emulators.kvm.devel/109928
> > 
> > > However
> > > we have the inatomic variants of these function for this purpose.
> > 
> > Does inatomic install fixups now?
> 
> I think this varies between architectures but I am no expert. But as 99,9% of
> all pagefault_disable code uses inatomic, I would have guessed that this is
> rather the way to got than simply using the non atomic variant that clearly
> states on the interface that it might sleep?

Let's go ahead and make the comment more exact then.

> > 
> > Last I checked, it didn't so it did not satisfy this purpose.
> > See this comment from x86:
> > 
> >  * Copy data from kernel space to user space.  Caller must check
> >  * the specified block with access_ok() before calling this function.
> >  * The caller should also make sure he pins the user space address
> >  * so that we don't result in page fault and sleep.
> > 
> > 
> > Also - switching to inatomic would scatter if (atomic) all
> > over code. It's much better to simply call the same
> > function (e.g. recvmsg) and have it fail gracefully:
> > after all, we have code to handle get/put user errors
> > anyway.
> > 
> > > The result of this change was that all guest access (that correctly uses
> > > might_fault()) doesn't perform atomic checks when CONFIG_DEBUG_ATOMIC_SLEEP is
> > > enabled. We lost a mighty debugging feature for user access.
> > 
> > What's the path you are trying to debug?
> > 
> 
> Well, if you are holding a spin_lock and call copy_to_guest() you would love to
> see why you get deadlocks, such bugs are really hard to find (... and might
> take people almost a week to identify ...)

Is copy_to_guest same as copy_to_user?
I was unable to find it in tree.
If yes, you will not get deadlocks - it will simply fail.




> > If your code can faults, then it's safe to call
> > from atomic context.
> > If it can't, it must pin the page.  You can not do access_ok checks and
> > then assume access won't fault.
> > 
> > > As I wasn't able to come up with any other reason why this should be
> > > necessary, I suggest turning the might_sleep() checks on again in the
> > > might_fault() code.
> > 
> > Faults triggered with pagefault_disabled do not cause
> > caller to sleep, merely to fail and get an error,
> > so might_sleep is simply wrong.
> 
> And my point is, that we need a separate function for this scenario

To me it looks like you want to add a bunch of code for the sole purpose
of then making it easier to debug it.

> (in my
> opinion inatomic) - I mean the caller knows what he is doing, so he can handle
> it properly with inatomic, or am I missing something?

No, the caller gets pointer from userspace so it still must be
validated, inatomic does not do this.


> > 
> > > 
> > > pagefault_disable/pagefault_enable seems to be used mainly for futex, perf event
> > > and kmap.
> > > 
> > > Going over all changes since that commit, it seems like most code already uses the
> > > inatomic variants of copy_(to|from)_user. Code relying on (get|put)_user during
> > > pagefault_disable() don't make use of any might_fault() in their (get|put)_user
> > > implementation. Examples:
> > > - arch/m68k/include/asm/futex.h
> > > - arch/parisc/include/asm/futex.h
> > > - arch/sh/include/asm/futex-irq.h
> > > - arch/tile/include/asm/futex.h
> > > So changing might_fault() back to trigger might_sleep() won't change a thing for
> > > them. Hope I haven't missed anything.
> > 
> > Did you check the generated code?
> > On x86 it seems to me this patchset is definitely going to
> > slow things down, in fact putting back in a performance regression
> > that Andi found.
> 
> Should be optimized out without lock debugging, right?

You can compile it out, but CONFIG_DEBUG_ATOMIC_SLEEP
is pretty common.

> > 
> > 
> > > I only identified one might_fault() that would get triggered by get_user() on
> > > powerpc and fixed it by using the inatomic variant (not tested). I am not sure
> > > if we need some non-sleeping access_ok() prior to __get_user_inatomic().
> > > 
> > > By looking at the code I was wondering where the correct place for might_fault()
> > > calls is? Doesn't seem to be very consistent. Examples:
> > > 
> > >                    | asm-generic | arm | arm64 | frv | m32r | x86 and s390
> > > ---------------------------------------------------------------------------
> > > get_user()         |   Yes       | Yes | Yes   | No  | Yes  |     Yes
> > > __get_user()       |   No        | Yes | No    | No  | Yes  |     No
> > > put_user()         |   Yes       | Yes | Yes   | No  | Yes  |     Yes
> > > __put_user()       |   No        | Yes | No    | No  | Yes  |     No
> > > copy_to_user()     |   Yes       | No  | No    | Yes | Yes  |     Yes
> > > __copy_to_user()   |   No        | No  | No    | Yes | No   |     No
> > > copy_from_user()   |   Yes       | No  | No    | Yes | Yes  |     Yes
> > > __copy_from_user() |   No        | No  | No    | Yes | No   |     No
> > > 
> > 
> > I think it would be a mistake to make this change.
> > 
> > Most call-sites handle faults in atomic just fine by
> > returning error to caller.
> > 
> > > So I would have assume that the way asm-generic, x86 and s390 (+ propably
> > > others) do this is the right way?
> > > So we can speed up multiple calls to e.g. copy_to_user() by doing the access
> > > check manually (and also the might_fault() if relevant), then calling
> > > __copy_to_user().
> > > 
> > > So in general, I conclude that the concept is:
> > > 1. __.* variants perform no checking and don't call might_fault()
> > > 2. [a-z].* variants perform access checking (access_ok() if implemented)
> > > 3. [a-z].* variants call might_fault()
> > > 4. .*_inatomic variants usually don't perform access checks
> > > 5. .*_inatomic variants don't call might_fault()
> > > 6. If common code uses the __.* variants, it has to trigger access_ok() and
> > >    call might_fault()
> > > 7. For pagefault_disable(), the inatomic variants are to be used
> > 
> > inatomic variants don't seem to handle faults, so you
> > must pin any memory you pass to them.
> 
> And we don't have a single code part in the system that relies on this, right?

Hmm relies on what?
Do you want to change *inatomic to actually handle faults?
That's fine by me, but if you do, won't you need might_fault there.
And then your patch will be wrong, won't it?


> > 
> > 
> > > Comments? Opinions?
> > > 
> > 
> > If the same address is accessed multiple times, access_ok + __
> > variant can be used to speed access up a bit.
> > This is rarely the case, but this is the case for e.g. vhost.
> > But access_ok does not guarantee that no fault will trigger:
> > there's really no way to do that ATM except pinning the page.
> > 
> > 

