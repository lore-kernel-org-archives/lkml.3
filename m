Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbaK0HJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 02:09:26 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:42473 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaK0HJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 02:09:24 -0500
Date: Thu, 27 Nov 2014 08:09:19 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        mingo@kernel.org
Subject: Re: [RFC 0/2] Reenable might_sleep() checks for might_fault() when
 atomic
Message-ID: <20141127070919.GA4390@osiris>
References: <20141126070258.GA25523@redhat.com>
 <20141126110504.511b733a@thinkpad-w530>
 <20141126151729.GB9612@redhat.com>
 <20141126152334.GA9648@redhat.com>
 <20141126163207.63810fcb@thinkpad-w530>
 <20141126154717.GB10568@redhat.com>
 <5475FAB1.1000802@de.ibm.com>
 <20141126163216.GB10850@redhat.com>
 <547604FC.4030300@de.ibm.com>
 <20141126170447.GC11202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141126170447.GC11202@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112707-0009-0000-0000-00000228BB37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 07:04:47PM +0200, Michael S. Tsirkin wrote:
> On Wed, Nov 26, 2014 at 05:51:08PM +0100, Christian Borntraeger wrote:
> > > But this one was > giving users in field false positives.
> > 
> > So lets try to fix those, ok? If we cant, then tough luck.
> 
> Sure.
> I think the simplest way might be to make spinlock disable
> premption when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
> 
> As a result, userspace access will fail and caller will
> get a nice error.

Yes, _userspace_ now sees unpredictable behaviour, instead of that the
kernel emits a big loud warning to the console.

Please consider this simple example:

int bar(char __user *ptr)
{
	...
	if (copy_to_user(ptr, ...)
		return -EFAULT;
	...
}

SYSCALL_DEFINE1(foo, char __user *, ptr)
{
	int rc;

	...
	rc = bar(ptr);
	if (rc)
		goto out;
	...
out:
	return rc;	
}

The above simple system call just works fine, with and without your change,
however if somebody (incorrectly) changes sys_foo() to the code below:

	spin_lock(&lock);
	rc = bar(ptr);
	if (rc)
		goto out;
out:
	spin_unlock(&lock);
	return rc;	

Broken code like above used to generate warnings. With your change we won't
see any warnings anymore. Instead we get random and bad behaviour:

For !CONFIG_PREEMPT if the page at ptr is not mapped, the kernel will see
a fault, potentially schedule and potentially deadlock on &lock.
Without _any_ warning anymore.

For CONFIG_PREEMPT if the page at ptr is mapped, everthing works. However if
the page is not mapped, userspace now all of the sudden will see an invalid(!)
-EFAULT return code, instead of that the kernel resolved the page fault.
Yes, the kernel can't resolve the fault since we hold a spinlock. But the
above bogus code did give warnings to give you an idea that something probably
is not correct.

Who on earth is supposed to debug crap like this???

What we really want is:

Code like
	spin_lock(&lock);
	if (copy_to_user(...))
		rc = ...
	spin_unlock(&lock);
really *should* generate warnings like it did before.

And *only* code like
	spin_lock(&lock);
	page_fault_disable();
	if (copy_to_user(...))
		rc = ...
	page_fault_enable();
	spin_unlock(&lock);
should not generate warnings, since the author hopefully knew what he did.

We could achieve that by e.g. adding a couple of pagefault disabled bits
within current_thread_info()->preempt_count, which would allow
pagefault_disable() and pagefault_enable() to modify a different part of
preempt_count than it does now, so there is a way to tell if pagefaults have
been explicitly disabled or are just a side effect of preemption being
disabled.
This would allow might_fault() to restore its old sane behaviour for the
!page_fault_disabled() case.

