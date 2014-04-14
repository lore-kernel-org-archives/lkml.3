Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbaDNJxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbaDNJwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:52:43 -0400
Date: Mon, 14 Apr 2014 11:52:10 +0200
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
Message-ID: <20140414115210.51193098@thinkpad>
In-Reply-To: <20140414091600.GA19771@gmail.com>
References: <1397150061-29735-1-git-send-email-imammedo@redhat.com>
	<1397150061-29735-2-git-send-email-imammedo@redhat.com>
	<20140414091600.GA19771@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 11:16:00 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Igor Mammedov <imammedo@redhat.com> wrote:
> 
> >  	/*
> > +	 * wait for ACK from master CPU before continuing
> > +	 * with AP initialization
> > +	 */
> > +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> > +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> > +		cpu_relax();
> 
> > +	/*
> > +	 * wait for ACK from master CPU before continuing
> > +	 * with AP initialization
> > +	 */
> > +	cpumask_set_cpu(cpu, cpu_initialized_mask);
> > +	while (!cpumask_test_cpu(cpu, cpu_callout_mask))
> > +		cpu_relax();
> 
> That repetitive pattern could be stuck into a properly named helper 
> inline function.
sure

> (Also, before the cpumask_set_cpu() we should probably do a WARN_ON() 
> if the bit is already set.)
The reason why there is no any WARN_ON or likes is that printk is quite
complicated, takes looks and so on. So it's not safe at this point since
CPU could be shot down by any time by INIT/SIPI until it's out of 
cpu_callout_mask loop.
That said it's possible to add WARN_ON in do_boot_cpu() before
cpu_initialized_mask is cleared, to achieve the same effect,
so I'll stick it there.


> 
> Thanks,
> 
> 	Ingo


-- 
Regards,
  Igor
