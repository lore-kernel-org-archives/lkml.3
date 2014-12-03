Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaLCTjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:39:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbaLCTjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:39:49 -0500
Date: Wed, 3 Dec 2014 20:39:47 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Juergen Gross <jgross@suse.com>
Cc: David Vrabel <david.vrabel@citrix.com>, Joerg Roedel <jroedel@suse.de>,
        kvm@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, Borislav Petkov <bp@suse.de>,
        Olaf Hering <ohering@suse.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private
	hypercall when non CONFIG_PREEMPT
Message-ID: <20141203193947.GD25677@wotan.suse.de>
References: <20141201150546.GC25677@wotan.suse.de> <547C86BF.2040705@citrix.com> <CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com> <547C8F30.1010306@citrix.com> <20141201161905.GH25677@wotan.suse.de> <547CB07C.1050507@citrix.com> <20141201223611.GM25677@wotan.suse.de> <547D9E56.50708@citrix.com> <20141203022833.GS25677@wotan.suse.de> <547E939F.40106@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547E939F.40106@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 05:37:51AM +0100, Juergen Gross wrote:
> On 12/03/2014 03:28 AM, Luis R. Rodriguez wrote:
>> On Tue, Dec 02, 2014 at 11:11:18AM +0000, David Vrabel wrote:
>>> On 01/12/14 22:36, Luis R. Rodriguez wrote:
>>>>
>>>> Then I do agree its a fair analogy (and find this obviously odd that how
>>>> widespread cond_resched() is), we just don't have an equivalent for IRQ
>>>> context, why not avoid the special check then and use this all the time in the
>>>> middle of a hypercall on the return from an interrupt (e.g., the timer
>>>> interrupt)?
>>>
>>> http://lists.xen.org/archives/html/xen-devel/2014-02/msg01101.html
>>
>> OK thanks! That explains why we need some asm code but in that submission you
>> still also had used is_preemptible_hypercall(regs) and in the new
>> implementation you use a CPU variable xen_in_preemptible_hcall prior to calling
>> preempt_schedule_irq(). I believe you added the CPU variable because
>> preempt_schedule_irq() will preempt first without any checks if it should, I'm
>> asking why not do something like cond_resched_irq() where we check with
>> should_resched() prior to preempting and that way we can avoid having to use
>> the CPU variable?
>
> Because that could preempt at any asynchronous interrupt making the
> no-preempt kernel fully preemptive. 

OK yeah I see. That still doesn't negate the value of using something
like cond_resched_irq() with a should_resched() on only critical hypercalls.
The current implementation (patch by David) forces preemption without
checking for should_resched() so it would preempt unnecessarily at least
once.

> How would you know you are just
> doing a critical hypercall which should be preempted?

You would not, you're right. I was just trying to see if we could generalize
an API for this to avoid having users having to create their own CPU variables
but this all seems very specialized as we want to use this on the timer
so if we do generalize a cond_resched_irq() perhaps the documentation can
warn about this type of case or abuse.

  Luis
