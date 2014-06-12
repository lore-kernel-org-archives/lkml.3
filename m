Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaFLSpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:45:25 -0400
Received: from smtprelay0192.hostedemail.com ([216.40.44.192]:43638 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751034AbaFLSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:45:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:2:41:355:379:541:560:599:800:960:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2199:2393:2559:2562:2689:2693:2736:2828:2892:2895:2912:3138:3139:3140:3141:3142:3865:3866:3867:3868:3870:3871:3872:3873:3874:4050:4119:4250:4321:4385:4605:5007:6119:6691:7514:7576:7652:7875:7903:7974:8603:8660:10004:10848:11026:11232:11473:11596:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12740:13019:13146:13148:13230:13255:13869:13894,0,RBL:none,CacheIP:none,Bayesian
X-HE-Tag: van77_68dd47a00ad41
X-Filterd-Recvd-Size: 8845
Message-ID: <1402598718.12385.16.camel@joe-AO725>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on the
 number of CPUs
From: Joe Perches <joe@perches.com>
To: Davidlohr Bueso <davidlohr@hp.com>, Chris Metcalf <cmetcalf@tilera.com>
Cc: Petr =?ISO-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun KS <arunks.linux@gmail.com>, Kees Cook <keescook@chromium.org>
Date: Thu, 12 Jun 2014 11:45:18 -0700
In-Reply-To: <1402596066.2627.1.camel@buesod1.americas.hpqcorp.net>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
	 <20140611093447.GL7772@pathway.suse.cz>
	 <1402596066.2627.1.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding Chris Metcalf for arch/tile,
 I think this change might impact that arch)

On Thu, 2014-06-12 at 11:01 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-06-11 at 11:34 +0200, Petr Mládek wrote:
> > On Tue 2014-06-10 18:04:45, Luis R. Rodriguez wrote:
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > 
> > > The default size of the ring buffer is too small for machines
> > > with a large amount of CPUs under heavy load. What ends up
> > > happening when debugging is the ring buffer overlaps and chews
> > > up old messages making debugging impossible unless the size is
> > > passed as a kernel parameter. An idle system upon boot up will
> > > on average spew out only about one or two extra lines but where
> > > this really matters is on heavy load and that will vary widely
> > > depending on the system and environment.
> > 
> > Thanks for looking at this. It is a pity to lose stracktrace when a huge
> > machine Oopses just because the default ring buffer is too small.
> 
> Agreed, I would very much welcome something like this.
> 
> > > There are mechanisms to help increase the kernel ring buffer
> > > for tracing through debugfs, and those interfaces even allow growing
> > > the kernel ring buffer per CPU. We also have a static value which
> > > can be passed upon boot. Relying on debugfs however is not ideal
> > > for production, and relying on the value passed upon bootup is
> > > can only used *after* an issue has creeped up. Instead of being
> > > reactive this adds a proactive measure which lets you scale the
> > > amount of contributions you'd expect to the kernel ring buffer
> > > under load by each CPU in the worst case scenerio.
> > > 
> > > We use num_possible_cpus() to avoid complexities which could be
> > > introduced by dynamically changing the ring buffer size at run
> > > time, num_possible_cpus() lets us use the upper limit on possible
> > > number of CPUs therefore avoiding having to deal with hotplugging
> > > CPUs on and off. This option is diabled by default, and if used
> > > the kernel ring buffer size then can be computed as follows:
> > > 
> > > size = __LOG_BUF_LEN + (num_possible_cpus() - 1 ) *  __LOG_CPU_BUF_LEN
> > > 
> > > Cc: Michal Hocko <mhocko@suse.cz>
> > > Cc: Petr Mladek <pmladek@suse.cz>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Joe Perches <joe@perches.com>
> > > Cc: Arun KS <arunks.linux@gmail.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > ---
> > >  init/Kconfig           | 28 ++++++++++++++++++++++++++++
> > >  kernel/printk/printk.c |  6 ++++--
> > >  2 files changed, 32 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index 9d3585b..1814436 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -806,6 +806,34 @@ config LOG_BUF_SHIFT
> > >  		     13 =>  8 KB
> > >  		     12 =>  4 KB
> > >  
> > > +config LOG_CPU_BUF_SHIFT
> > > +	int "CPU kernel log buffer size contribution (13 => 8 KB, 17 => 128KB)"
> > > +	range 0 21
> > > +	default 0
> > > +	help
> > > +	  The kernel ring buffer will get additional data logged onto it
> > > +	  when multiple CPUs are supported. Typically the contributions is a
> > > +	  few lines when idle however under under load this can vary and in the
> > > +	  worst case it can mean loosing logging information. You can use this

trivia: s/loosing/losing/

> > > +	  to set the maximum expected mount of amount of logging contribution
> > > +	  under load by each CPU in the worst case scenerio. Select a size as
> > > +	  a power of 2. For example if LOG_BUF_SHIFT is 18 and if your
> > > +	  LOG_CPU_BUF_SHIFT is 12 your kernel ring buffer size will be as
> > > +	  follows having 16 CPUs as possible.
> > > +
> > > +	     ((1 << 18) + ((16 - 1) * (1 << 12))) / 1024 = 316 KB
> > 
> > It might be better to use the CPU_NUM-specific value as a minimum of
> > the needed space. Linux distributions might want to distribute kernel
> > with non-zero value and still use the static "__log_buf" on reasonable
> > small systems.
> 
> It should also depend on SMP and !BASE_SMALL.
> I was wondering about disabling this by default as it would defeat the
> purpose of being a proactive feature. Similarly, I worry about distros
> choosing a correct default value on their own.
> 
> > > +	  Where as typically you'd only end up with 256 KB. This is disabled
> > > +	  by default with a value of 0.
> > 
> > I would add:
> > 
> > 	This value is ignored when "log_buf_len" commandline parameter
> > 	is used. It forces the exact size of the ring buffer.
> 
> ... and update Documentation/kernel-parameters.txt to be more
> descriptive about this new functionality.
> 
> > > +	  Examples:
> > > +		     17 => 128 KB
> > > +		     16 => 64 KB
> > > +	             15 => 32 KB
> > > +	             14 => 16 KB
> > > +		     13 =>  8 KB
> > > +		     12 =>  4 KB
> > 
> > I think that we should make it more cleat that it is per-CPU here,
> > for example:
> > 
> > 		17 => 128 KB for each CPU
> > 		16 =>  64 KB for each CPU
> > 		15 =>  32 KB for each CPU
> > 		14 =>  16 KB for each CPU
> > 		13 =>   8 KB for each CPU
> > 		12 =>   4 KB for each CPU
> > 
> 
> Agreed.
> 
> > >  #
> > >  # Architectures with an unreliable sched_clock() should select this:
> > >  #
> > > diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> > > index 7228258..2023424 100644
> > > --- a/kernel/printk/printk.c
> > > +++ b/kernel/printk/printk.c
> > > @@ -246,6 +246,7 @@ static u32 clear_idx;
> > >  #define LOG_ALIGN __alignof__(struct printk_log)
> > >  #endif
> > >  #define __LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
> > > +#define __LOG_CPU_BUF_LEN (1 << CONFIG_LOG_CPU_BUF_SHIFT)
> > >  static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
> > >  static char *log_buf = __log_buf;
> > >  static u32 log_buf_len = __LOG_BUF_LEN;
> > > @@ -752,9 +753,10 @@ void __init setup_log_buf(int early)
> > >  	unsigned long flags;
> > >  	char *new_log_buf;
> > >  	int free;
> > > +	int cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_BUF_LEN;
> 
> If depending on SMP, you can remove the - 1 here.
> 
> > > -	if (!new_log_buf_len)
> > > -		return;
> > > +	if (!new_log_buf_len && cpu_extra > 1)
> > > +		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;
> > 
> > We still should return when both new_log_buf_len and cpu_extra are
> > zero and call here:
> > 
> > 	if (!new_log_buf_len)
> > 		return;
> 
> Yep.
> 
> > Also I would feel more comfortable if we somehow limit the maximum
> > size of cpu_extra. I wonder if there might be a crazy setup with a lot
> > of possible CPUs and possible memory but with some minimal amount of
> > CPUs and memory at the boot time.
> 
> Maybe. But considering that systems with a lot of CPUs *do* have a lot
> of memory, I wouldn't worry much about this, just like we don't worry
> about it now. Considering a _large_ 1024 core system and using the max
> value 21 for CONFIG_LOG_BUF_SHIFT, we would only allocate just over 2Gb
> of extra space -- trivial for such a system. And if it does break
> something, then heck, go fix you box and/or just reduce the percpu
> value. I guess that's a good reason to keep the default to 0 and let
> users play with it as they wish without compromising uninterested
> parties. afaict only x86 would be exposed to systems not booting if we
> fail to allocate.
> 
> Thanks,
> Davidlohr



