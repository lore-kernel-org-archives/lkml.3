Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaGKSgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:36:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:31887 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbaGKSgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:36:07 -0400
Date: Fri, 11 Jul 2014 14:36:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: paulmck <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dipankar <dipankar@in.ibm.com>
Subject: Re: [PATCH] rcu: define tracepoint strings only if CONFIG_TRACING
 is set
Message-ID: <20140711143601.00744c1c@gandalf.local.home>
In-Reply-To: <CAKv+Gu9e+8onYn_t=kHJ0eMNT=CMyMMASbvyVQxjk6XEtzE4OQ@mail.gmail.com>
References: <1405078692-29957-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140711151239.GJ16041@linux.vnet.ibm.com>
	<20140711113010.4ca2c8d9@gandalf.local.home>
	<CAKv+Gu-2Tgf+gvh=LPWFpkgFAVb8qe0Gdp2Va5Br19BwLzK9yw@mail.gmail.com>
	<CAKv+Gu9e+8onYn_t=kHJ0eMNT=CMyMMASbvyVQxjk6XEtzE4OQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014 20:09:26 +0200
Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> On 11 July 2014 17:40, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> > On 11 July 2014 17:30, Steven Rostedt <rostedt@goodmis.org> wrote:
> >> On Fri, 11 Jul 2014 08:12:40 -0700
> >> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>
> >>> On Fri, Jul 11, 2014 at 01:38:12PM +0200, Ard Biesheuvel wrote:
> >>> > Commit f7f7bac9cb1c ("rcu: Have the RCU tracepoints use the tracepoint_string
> >>> > infrastructure") unconditionally populates the __tracepoint_str input section,
> >>> > but this section is not assigned an output section if CONFIG_TRACING is not set.
> >>> > This results in the __tracepoint_str turning up in unexpected places, i.e.,
> >>> > after _edata.
> >>> >
> >>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>> > Cc: rostedt@goodmis.org
> >>> > Cc: dipankar@in.ibm.com
> >>> > Cc: paulmck@linux.vnet.ibm.com
> >>>
> >>> If you get a Reviewed-by from Steven Rostedt, I will be happy to queue
> >>> this one.
> >>
> >> I'm fine with it, but it should add a comment.
> >>
> >>
> >>>
> >>>                                                       Thanx, Paul
> >>>
> >>> > ---
> >>> >  kernel/rcu/tree.c | 9 ++++++++-
> >>> >  1 file changed, 8 insertions(+), 1 deletion(-)
> >>> >
> >>> > diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> >>> > index f1ba77363fbb..ac1984149eb5 100644
> >>> > --- a/kernel/rcu/tree.c
> >>> > +++ b/kernel/rcu/tree.c
> >>> > @@ -79,9 +79,16 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
> >>> >   * the tracing userspace tools to be able to decipher the string
> >>> >   * address to the matching string.
> >>> >   */
> >>> > +#ifdef CONFIG_TRACING
> >>
> >> /*
> >>  * When tracing is enabled, DEFINE_TPS() will export the string to
> >>  * userspace via the tracing debugfs directory. This allows userspace
> >>  * tools to read the binary tracepoints that reference the pointer
> >>  * to the string and not the string itself.
> >>  */
> >>
> >>
> 
> Ehm, actually, a comment to that effect is already right there in the file.
> Would you still like me to add this additional comment?

Heh, I surprised myself with my own documentation :-)

No, I think the existing comment is good enough. Just rename the macro
then.

Thanks!

-- Steve

> 
> >>> > +#define DEFINE_TPS(sname) \
> >>> > +static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname;
> >>> > +#else
> >>> > +#define DEFINE_TPS(sname)
> >>> > +#endif
> >>
> >> Also, perhaps we should call it:
> >>
> >>  DEFINE_RCU_TPS()
> >>
> >> Other than that, I'm fine with the patch.
> >>
> >> I'll review v2 ;-)
> >>
> >
> > Thanks gents, v2 coming up.
> >
> > --
> > Ard.
> >
> >
> >>> > +
> >>> >  #define RCU_STATE_INITIALIZER(sname, sabbr, cr) \
> >>> >  static char sname##_varname[] = #sname; \
> >>> > -static const char *tp_##sname##_varname __used __tracepoint_string = sname##_varname; \
> >>> > +DEFINE_TPS(sname) \
> >>> >  struct rcu_state sname##_state = { \
> >>> >     .level = { &sname##_state.node[0] }, \
> >>> >     .call = cr, \
> >>> > --
> >>> > 1.8.3.2
> >>> >
> >>

