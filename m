Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaFRTVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:21:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50539 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbaFRTVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:21:37 -0400
Date: Wed, 18 Jun 2014 21:21:34 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Stephen Warren <swarren@wwwdotorg.org>,
        Michal Hocko <mhocko@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [RFT 2/2] printk: allow increasing the ring buffer depending
	on the number of CPUs
Message-ID: <20140618192134.GN4841@wotan.suse.de>
References: <1403090065-13879-1-git-send-email-mcgrof@do-not-panic.com> <1403090065-13879-2-git-send-email-mcgrof@do-not-panic.com> <1403115072.3787.3.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403115072.3787.3.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:11:12AM -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-18 at 04:14 -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> 
> Looks good Luis, thanks a lot for doing this -- it will definitely help
> my everyday debugging issues on huge machines.
> 
> I ran this on my 160-core Westmere. Some nits below, otherwise:
> 
> Reviewed-and-tested-by: Davidlohr Bueso <davidlohr@hp.com>

Great thanks for testing and your review!

> > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > index af164a7..7c7b599 100644
> > --- a/kernel/printk/printk.c
> > +++ b/kernel/printk/printk.c
> > @@ -848,12 +849,43 @@ static int __init log_buf_len_setup(char *str)
> >  }
> >  early_param("log_buf_len", log_buf_len_setup);
> >  
> > +static void __init log_buf_add_cpu(void)
> > +{
> > +	int cpu_extra;
> 
> unsigned int

Amended.

> > +
> > +	/*
> > +	 * archs should set up cpu_possible_bits properly with
> > +	 * set_cpu_possible() after setup_arch() but just in
> > +	 * case lets ensure this is valid. During an early
> > +	 * call before setup_arch()() this will be 1.
> > +	 */
> > +	if (num_possible_cpus() <= 1)
> 
> This can never return 0, so how about making it == 1?

I was originally concerned over the early boot code which had
not yet called setup_arch() but since we now have a check for
early on setup_log_buf() before calling log_buf_add_cpu() I
think its safe to check for 1 then, will change! I'll also
remove the note about this always returning 1 on early init
before setup_arch() as I only confirmed that for x86 -- unless
of course there is code that ensures this for early boot for
all archs, I just can't find it.

> > +		return;
> > +
> > +	cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;
> > +
> > +	/* by default this will only continue through for large > 64 CPUs */
> > +	if (cpu_extra <= __LOG_BUF_LEN / 2)
> > +		return;
> > +
> > +	pr_info("log_buf_len cpu_extra contribution: %d\n", cpu_extra);
> 
> We should add 'bytes' for units. 

That should mean also amending the orignal setup_log_buf() for the final size,
will do that too.

> Also, while at it, how about making it easier for users and also print
> the individual contribution of each CPU

Sure, done. While at it I renamed LOG_CPU_MIN_BUF_SHIFT to MAX to annotate folks
want to to consider the worst case scenario to help with debugging on production.

  Luis
