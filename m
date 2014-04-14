Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaDNPEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:04:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaDNPEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:04:21 -0400
Date: Mon, 14 Apr 2014 17:03:46 +0200
From: Igor Mammedov <imammedo@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, bp@suse.de,
        paul.gortmaker@windriver.com, JBeulich@suse.com, prarit@redhat.com,
        drjones@redhat.com, toshi.kani@hp.com, riel@redhat.com,
        gong.chen@linux.intel.com, andi@firstfloor.org, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 1/5] x86: initialize secondary CPU only if master CPU
 will wait for it
Message-ID: <20140414170346.35ad01cb@nial.usersys.redhat.com>
In-Reply-To: <20140414145119.GA27683@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
	<1397150061-29735-2-git-send-email-imammedo@redhat.com>
	<20140414091600.GA19771@gmail.com>
	<20140414115210.51193098@thinkpad>
	<20140414100335.GC731@gmail.com>
	<20140414145048.3d7cf907@nial.usersys.redhat.com>
	<20140414145119.GA27683@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 16:51:19 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> > On Mon, 14 Apr 2014 12:03:35 +0200
> > Ingo Molnar <mingo@kernel.org> wrote:
> > 
> > > 
> > > * Igor Mammedov <imammedo@redhat.com> wrote:
> > > 
> > > > On Mon, 14 Apr 2014 11:16:00 +0200
> > > > Ingo Molnar <mingo@kernel.org> wrote:
> > > > 
> > > > > 
> > > > > * Igor Mammedov <imammedo@redhat.com> wrote:
> > > > > 
> > > > > >  	/*
> > > > > > +	 * wait for ACK from master CPU before continuing
> > > > > > +	 * with AP initialization
> > > > > > +	 */
> > > > > > +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> > > > > > +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> > > > > > +		cpu_relax();
> > > > > 
> > > > > > +	/*
> > > > > > +	 * wait for ACK from master CPU before continuing
> > > > > > +	 * with AP initialization
> > > > > > +	 */
> > > > > > +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> > > > > > +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> > > > > > +		cpu_relax();
> > > > > 
> > > > > That repetitive pattern could be stuck into a properly named helper 
> > > > > inline function.
> > > > sure
> > > > 
> > > > > (Also, before the cpumask_set_cpu() we should probably do a WARN_ON() 
> > > > > if the bit is already set.)
> >
> > WARN_ON will never be triggered here since bit is always cleared by 
> > master CPU before AP gets here. There is no harm keeping WARN_ON 
> > though, do you still want it be here?
> 
> The previous code panic()ed on this condition - so it makes sense to 
> at least keep a WARN_ON(). That it won't ever trigger is good:
> 
> > It could be useful to put WARN_ON in do_boot_cpu() before bit is 
> > cleared, so that user would see that he tries to online AP which has 
> > failed previous time. It's not really necessary since failed to 
> > online attempt reported in logs at ERR level now, see patch 2/5.
> 
> WARN_ON()s are not used to communicate with users, they are used to 
> show developers that there's a _bug_ in the code!
> 
> So a WARN_ON() not triggering, ever, is a good thing.

Thanks for your patience
I'll repost fixed and tested series in a minute

> 
> Thanks,
> 
> 	Ingo

