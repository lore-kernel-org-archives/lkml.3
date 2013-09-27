Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab3I0FpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:45:04 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:61453 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3I0FpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:45:00 -0400
Date: Fri, 27 Sep 2013 07:44:55 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Roger Luethi <rl@hellgate.ch>, Patrick McHardy <kaber@trash.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Jesse Gross <jesse@nicira.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] [RFC] net: Explicitly initialize u64_stats_sync
 structures for lockdep
Message-ID: <20130927054455.GA6597@gmail.com>
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
 <1380220464-28840-2-git-send-email-john.stultz@linaro.org>
 <1380223585.3165.205.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380223585.3165.205.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Thu, 2013-09-26 at 11:34 -0700, John Stultz wrote:
> > In order to enable lockdep on seqcount/seqlock structures, we
> > must explicitly initialize any locks.
> > 
> 
> > diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
> > index 8da8c4e..c450e11 100644
> > --- a/include/linux/u64_stats_sync.h
> > +++ b/include/linux/u64_stats_sync.h
> > @@ -67,6 +67,13 @@ struct u64_stats_sync {
> >  #endif
> >  };
> >  
> > +
> > +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> > +#define u64_stats_init(syncp)	seqcount_init(syncp.seq)
> > +#else
> > +#define u64_stats_init(syncp)
> > +#endif
> > +
> 
> I would prefer a function.

C cannot pass along symbolic names, unfortunately, so we are stuck with 
1970's tech and the C preprocessor.

There's a way to make such macros look a tiny bit more structured and thus 
be more palatable:

#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
# define u64_stats_init(syncp) seqcount_init(syncp.seq)
#else
# define u64_stats_init(syncp)
#endif

Note, the 'else' branch should probably be:

# define u64_stats_init(syncp) do { } while (0)

Thanks,

	Ingo
