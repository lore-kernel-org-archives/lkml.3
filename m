Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3F1UiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 16:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5547 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab3F1UiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:38:05 -0400
Date: Fri, 28 Jun 2013 17:37:39 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Karen Noel <knoel@redhat.com>, Rik van Riel <riel@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: watchdog: print stolen time increment at softlockup detection
Message-ID: <20130628203739.GA25847@amt.cnet>
References: <20130628025723.GA12719@amt.cnet>
 <20130628141215.GF126784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628141215.GF126784@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 10:12:15AM -0400, Don Zickus wrote:
> On Thu, Jun 27, 2013 at 11:57:23PM -0300, Marcelo Tosatti wrote:
> > 
> > One possibility for a softlockup report in a Linux VM, is that the host
> > system is overcommitted to the point where the watchdog task is unable
> > to make progress (unable to touch the watchdog).
> 
> I think I am confused on the VM/host stuff.  How does an overcommitted
> host prevent a high priority task like the watchdog from running?
> 
> Or is it the watchdog task on the VM that is being blocked from running
> because the host is overcommitted and can't run the VM frequent enough?

Yes, thats the case.

> The latter would make sense, though I thought you solved that with the
> other kvm splat in the watchdog code a while ago.  So I would be
> interested in understanding why the previous solution isn't working.

That functionality is for a notification so the guest ignores the time
jump induced by a vm pause. This problem is similar to the kgdb case.

> Second, I am still curious how this problem differs from say kgdb or
> suspend-hibernate/resume.  Doesn't both of those scenarios deal with a
> clock that suddenly jumps forward without the watchdog task running?

The difference is this:

The present functionality in watchdog.c allows the hypervisor to notify
the guest that it should ignore the large delta seen via clock reads
(at the watchdog timer interrupt).
This notification is used for the case where the vm has been paused for
a period of time.

Are you suggesting the host should silence the guest watchdog, also in
the overcommitment case? Issues i see with that:

1) The host is not aware of the variable softlockup threshold in
the guest.

2) Whatever the threshold of overcommitment for sending the ignore
softlockup notification to the guest, genuine softlockup detections in
the guest could be silenced, given proper conditioning.

And why overcommitment is not a valid reason to generate a softlockup in
the first place ?

> For some reason I had the impression that when a VM starts running again,
> one of the first things it does it sync up its clock again (which leads to
> a softlockup shortly thereafter in the case of paused/overcommitted VMs)?

Sort of, the kvmclock counts while the VM is running (whether is
overcommitted or not).

> At that time I would have thought that the code could detect a large jump
> in time and touch_softlockup_watchdog_sync() or something to delay the
> check until the next cycle.

But this would silence any softlockups that are due to delays
in the host causing the watchdog task to make progress (eg:
https://lkml.org/lkml/2013/6/20/633, in that case if 1 operation took
longer than expected your suggestion would silence the report).

> That would make the watchdog code alot less messier than having custom
> kvm/paravirt splat all over it.  Generic solutions are always nice. :-)

Can you give more detail on what the suggestion is and how can you deal
with points 1 and 2 above?

> Or feel free to correct any of my above assumptions as I am kinda ignorant
> on how all this time code works for VMs.

I am afraid that silencing the softlockup watchdog can inhibit genuine 
softlockup cases from being reported.

