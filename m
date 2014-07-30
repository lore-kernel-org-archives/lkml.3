Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbaG3ItD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 04:49:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51703 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbaG3Is7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 04:48:59 -0400
Date: Wed, 30 Jul 2014 10:48:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Chen, Gong" <gong.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de,
        paulus@samba.org, benh@kernel.crashing.org, tony.luck@intel.com,
        hpa@zytor.com, jkosina@suse.cz, rafael.j.wysocki@intel.com,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com
Subject: Re: [RFC PATCH v1 13/70] x86, x2apic_cluster: _FROZEN Cleanup
Message-ID: <20140730084852.GA10213@pd.tnic>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
 <1406080786-3938-14-git-send-email-gong.chen@linux.intel.com>
 <20140723203628.GJ21707@pd.tnic>
 <20140730062415.GA5100@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140730062415.GA5100@gchen.bj.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 02:24:15AM -0400, Chen, Gong wrote:
> On Wed, Jul 23, 2014 at 10:36:28PM +0200, Borislav Petkov wrote:
> >   /*
> >    * At CPU state changes, update the x2apic cluster sibling info.
> >    */
> > @@ -151,9 +166,14 @@ static int
> >  update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  {
> >  	unsigned int this_cpu = (unsigned long)hcpu;
> > -	unsigned int cpu;
> >  	int err = 0;
> >  
> > +	if (action & CPU_TASKS_FROZEN) {
> > +		if ((action & ~CPU_TASKS_FROZEN) == CPU_UP_CANCELED)
> > +			__update_clusterinfo(this_cpu);
> > +		return NOTIFY_OK;
> > +	}
> > +
> Hi, Boris
> 
> Here you assume once the action contains FROZEN flag, it will return
> NOTIFY_OK.

Well, look at the original code. What do you think happens if another
_FROZEN action comes in which we don't handle in the switch-case?

Take a piece of paper and play it through slowly if you don't see it.
Hint: err = 0.

> It looks like not quite comply with original logic. Once
> new FROZEN logic is added, we have to update this code again. How
> about using following code snippet:
> 
> +       if ((action & CPU_TASKS_FROZEN) &&
> +           ((action & ~CPU_TASKS_FROZEN) == CPU_UP_CANCELED)) {
> +               __update_clusterinfo(this_cpu);
> +               return NOTIFY_OK;

No, this is different now from the original logic.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
