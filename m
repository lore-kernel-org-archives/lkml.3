Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbaFLNFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 09:05:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234AbaFLNFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 09:05:44 -0400
Date: Thu, 12 Jun 2014 15:05:32 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Arun KS <arunks.linux@gmail.com>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: [RFC] printk: allow increasing the ring buffer depending on the
 number of CPUs
Message-ID: <20140612130532.GN7772@pathway.suse.cz>
References: <1402448685-30634-1-git-send-email-mcgrof@do-not-panic.com>
 <20140611093447.GL7772@pathway.suse.cz>
 <20140611214741.GH6042@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140611214741.GH6042@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-06-11 23:47:41, Luis R. Rodriguez wrote:
> On Wed, Jun 11, 2014 at 11:34:47AM +0200, Petr Mládek wrote:
> > On Tue 2014-06-10 18:04:45, Luis R. Rodriguez wrote:
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
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
> Not sure if I follow what you mean by CPU_NUM-specific, can you
> elaborate?

I wanted to say that the space requested by LOG_CPU_BUF_SHIFT depends
on the number of CPUs. If LOG_CPU_BUF_SHIFT is not zero, your
patch always allocates new ringbuffer and leave the static "__log_buf"
unused. I think that this is not necessary for machines with small
amount of CPUs and probably also with small amount of memory.

I would rename the variable to LOG_CPU_BUF_MIN_SHIFT or so. It would
represent minimal size that is needed to print CPU-specific
messages. If they take only "small" part of the default ring buffer
size, we could still use the default rind buffer.

For example, if we left 50% of the default buffer for CPU-specific
messages, the code might look like:

	#define __LOG_CPU_MIN_BUF_LEN (1 << CONFIG_LOG_CPU_MIN_BUF_SHIFT)

	int cpu_extra = (num_possible_cpus() - 1) * __LOG_CPU_MIN_BUF_LEN;

	if (!new_log_buf_len && (cpu_extra > __LOG_BUF_LEN / 2))
		new_log_buf_len = __LOG_BUF_LEN + cpu_extra;

	if (!new_log_buf_len)
		return;

	allocate the new ring buffer...


> The default in this patch is to ignore this, do you mean that upstream
> should probably default to a non-zero value here and then let distributions
> select 0 for some kernel builds ?

If the change has effect only for huge systems, the default value
might be non-zero everywhere.

> If so then perhaps adding a sysctl override value might be good to
> allow only small systems to override this to 0?

I think that it won't help to lover the value using sysctl because the
huge buffer would be already allocated during boot. If I did not miss anything.

[...]
> 
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
> > >  
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
> The check for cpu_extra > 1 does that -- the default in the patch was 0
> and 1 << 0 is 1, so if in the case that the default is used we'd bail
> just like before. Or did I perhaps miss what you were saying here?

The problem is that we do not bail out because you removed the "return".
If "new_log_buf_len=0" and "cpu_extra=1" then we keep
"new_log_buf_len" as is. Then we continue, try to allocate zero memory
and print error: "log_buf_len: 0 bytes not available". Do I get it right?


> > Also I would feel more comfortable if we somehow limit the maximum
> > size of cpu_extra.
> 
> Michal had similar concerns and I thought up to limit it to 1024 max
> CPUs, but after my second implementation I did some math on the values
> that would be used if say LOG_CPU_BUF_SHIFT was 12, it turns out to not
> be *that* bad for even huge num_possible_cpus(). For example for 4096
> num_possible_cpus() this comes out to with LOG_BUF_SHIFT of 18:
> 
> 
> ((1 << 18) + ((4096 - 1) * (1 << 12))) / 1024 = 16636 KB
> 
> ~16 MB doesn't seem that bad for such a monster box which I'd presume
> would have an insane amount of memory. If this logic however does
> seems unreasonable and we should cap it -- then by all means lets
> pick a sensible number, its just not clear to me what that number
> should be. Another reason why I stayed away from capping this was
> that we'd then likely end up capping this in the future, and I was
> trying to find a solution that would not require mucking as
> technology evolves. The reasoning above is also why I had opted to
> make the default to 0, only distributions would have a good sense
> of what might be reasonable, which I guess begs more for a sysctl
> value here.

I am not sure but I think that the huge buffer would be allocated
before any sysctl value could be modified. So, I think that sysctl
would not really help here.

I think that the 10% or 20% of the total memory size is a good limit.
Nobody would want to use more than 20% of memory for logging. So, it
needs not be higher. The main purpose of the limit is that the system
does not die immediately after allocating the ring buffer. The 80%
reserve for the rest of the system sounds fine as well. Note that
the limit won't be needed on 99,9% of systems but it would help
with debugging the last 0.1% :-)
 
> > I wonder if there might be a crazy setup with a lot
> > of possible CPUs and possible memory but with some minimal amount of
> > CPUs and memory at the boot time.
> 
> When I tested disabling smp I saw the log was still amended to include
> information about the disabled CPUs, I however hadn't tested on a machine
> with hot pluggable CPUs and with tons of CPUs disabled, so not sure if
> that adds more info as well. This also though points more to this being
> more a system specific thing, which is another reason to perhaps keep this
> disabled and leave this instead as a system config?
> 
> > The question is how to do it. I am still not much familiar with the
> > memory subsystem. I wonder if 10% of memory defined by the
> > "total_rampages" variable would be a reasonable limit.
> 
> Not sure either, curious if Mel might have a suggestion?
> 
> > 
> > >  	if (early) {
> > >  		new_log_buf =
> > > -- 
> > > 2.0.0.rc3.18.g00a5b79
> > > 
> > 
> > >  LocalWords:  buf len cpu boottime
> 
> What's this? :)

Heh, emacs added this when doing spell check. It is strage, it does it
only from time to time :-)

Best Regards,
Petr
