Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab3IKSBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:01:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40059 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3IKSBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:01:44 -0400
Date: Wed, 11 Sep 2013 14:01:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Jason Baron <jbaron@akamai.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: Re: Regression :-) Re: [GIT PULL RESEND] x86/jumpmplabel changes for
 v3.12-rc1
Message-ID: <20130911180113.GB29406@phenom.dumpdata.com>
References: <20130911134717.GA10925@phenom.dumpdata.com>
 <20130911135745.GB11043@phenom.dumpdata.com>
 <20130911142545.GA11364@phenom.dumpdata.com>
 <20130911105633.1c029147@gandalf.local.home>
 <20130911152149.GA22076@phenom.dumpdata.com>
 <20130911114708.1b42aec0@gandalf.local.home>
 <20130911161745.GA5884@phenom.dumpdata.com>
 <20130911130507.44a2b115@gandalf.local.home>
 <20130911172552.GB6870@phenom.dumpdata.com>
 <20130911135237.245386fb@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911135237.245386fb@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 01:52:37PM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 13:25:52 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> 
> > commit 97ce2c88f9ad42e3c60a9beb9fca87abf3639faa
> > Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Date:   Wed Oct 12 16:17:54 2011 -0700
> > 
> >     jump-label: initialize jump-label subsystem much earlier
> >     
> >     Initialize jump_labels much, much earlier, so they're available for use
> >     during system setup.
> >     
> >     Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >     Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > 
> > implies that yes.
> 
> Unfortunately it does not. All that patch did was move
> jump_label_init() up more. If anything, it implies "no".
> 
> The question is, can we enable jump_labels before jump_label_init()?
> 
> Note, we may still be able to (as it seems to work), the thing is, the
> only thing that static_key_slow_inc() does is to tell jump_label_init()
> to enable it. Before jump_label_init() is called, nothing has changed.
> No code modification, all users of paravirt_ticketlocks_enabled are
> still off.

<confused>

I am thins would still work:


47 static __always_inline void arch_spin_unlock(arch_spinlock_t *lock)             
148 {                                                                               
149         if (TICKET_SLOWPATH_FLAG &&                                             
150             static_key_false(&paravirt_ticketlocks_enabled)) {                  

(from arch/x86/include/asm/spinlock.h) as the static_key_false
would check the key->enabled. Which had been incremented?

Granted there are no patching done yet, but that should still allow
this code path to be taken?
