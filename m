Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbaGPLzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:55:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59368 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaGPLzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:55:09 -0400
Date: Wed, 16 Jul 2014 04:55:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rcu: define tracepoint strings only if CONFIG_TRACING
 is set
Message-ID: <20140716115504.GK8690@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1405184509-12601-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140714130302.59644d42@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140714130302.59644d42@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071611-0928-0000-0000-0000036F567D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 01:03:02PM -0400, Steven Rostedt wrote:
> On Sat, 12 Jul 2014 19:01:49 +0200
> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
> > Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
> > infrastructure") unconditionally populates the __tracepoint_str input section,
> > but this section is not assigned an output section if CONFIG_TRACING is not set.
> > This results in the __tracepoint_str turning up in unexpected places, i.e.,
> > after _edata.
> > 
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Cc: rostedt@goodmis.org
> > Cc: paulmck@linux.vnet.ibm.com
> > ---
> > v3:
> > - make definition of <var>_varname conditional as well
> > v2:
> > - s/DEFINE_TPS/DEFINE_RCU_TPS/
> > 
> >  kernel/rcu/tree.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> > 
> 
> Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

Queued for 3.18, thank you both!

							Thanx, Paul

> -- Steve
> 
> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> > index f1ba77363fbb..0756a4696007 100644
> > --- a/kernel/rcu/tree.c
> > +++ b/kernel/rcu/tree.c
> > @@ -79,9 +79,18 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
> >   * the tracing userspace tools to be able to decipher the string
> >   * address to the matching string.
> >   */
> > -#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
> > +#ifdef CONFIG_TRACING
> > +# define DEFINE_RCU_TPS(sname) \
> >  static char sname##_varname[] = #sname; \
> > -static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
> > +static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
> > +# define RCU_STATE_NAME(sname) sname##_varname
> > +#else
> > +# define DEFINE_RCU_TPS(sname)
> > +# define RCU_STATE_NAME(sname) __stringify(sname)
> > +#endif
> > +
> > +#define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
> > +DEFINE_RCU_TPS(sname) \
> >  struct rcu_state sname##_state = { \
> >  	.level = { &sname##_state.node[0] }, \
> >  	.call = cr, \
> > @@ -93,7 +102,7 @@ struct rcu_state sname##_state = { \
> >  	.orphan_donetail = &sname##_state.orphan_donelist, \
> >  	.barrier_mutex = __MUTEX_INITIALIZER(sname##_state.barrier_mutex), \
> >  	.onoff_mutex = __MUTEX_INITIALIZER(sname##_state.onoff_mutex), \
> > -	.name = sname##_varname, \
> > +	.name = RCU_STATE_NAME(sname), \
> >  	.abbr = sabbr, \
> >  }; \
> >  DEFINE_PER_CPU(struct rcu_data, sname##_data)
> 

