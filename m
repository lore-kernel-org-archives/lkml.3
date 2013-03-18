Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab3CRVA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:00:28 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38690 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539Ab3CRVA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:00:27 -0400
Date: Mon, 18 Mar 2013 21:00:11 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mike Turquette <mturquette@linaro.org>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, linaro-dev@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] clk: allow reentrant calls into the clk framework
Message-ID: <20130318210011.GL4977@n2100.arm.linux.org.uk>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org> <1362026969-11457-2-git-send-email-mturquette@linaro.org> <CAPDyKFqhGjduuSRvgZXJBUnbqS9L9aFw_nYc2VfkY1Ljgxrp+g@mail.gmail.com> <20130318201551.8663.22731@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318201551.8663.22731@quantum>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:15:51PM -0700, Mike Turquette wrote:
> Quoting Ulf Hansson (2013-02-28 01:54:34)
> > On 28 February 2013 05:49, Mike Turquette <mturquette@linaro.org> wrote:
> > > @@ -703,10 +744,29 @@ int clk_enable(struct clk *clk)
> > >         unsigned long flags;
> > >         int ret;
> > >
> > > +       /* this call re-enters if it is from the same context */
> > > +       if (spin_is_locked(&enable_lock) || mutex_is_locked(&prepare_lock)) {
> > > +               if ((void *) atomic_read(&context) == get_current()) {
> > > +                       ret = __clk_enable(clk);
> > > +                       goto out;
> > > +               }
> > > +       }
> > 
> > I beleive the clk_enable|disable code will be racy. What do you think
> > about this scenario:
> > 
> > 1. Thread 1, calls clk_prepare -> clk is not reentrant -> mutex_lock
> > -> set_context to thread1.
> > 2. Thread 2, calls clk_enable -> above "if" will mean that get_current
> > returns thread 1 context and then clk_enable continues ->
> > spin_lock_irqsave -> set_context to thread 2.
> > 3. Thread 1 continues and triggers a reentancy for clk_prepare -> clk
> > is not reentrant (since thread 2 has set a new context) -> mutex_lock
> > and we will hang forever.
> > 
> > Do you think above scenario could happen?
> > 
> > I think the solution would be to invent another "static atomic_t
> > context;" which is used only for fast path functions
> > (clk_enable|disable). That should do the trick I think.
> 
> Ulf,
> 
> You are correct.  In fact I have a branch that has two separate context
> pointers, one for mutex-protected functions and one for
> spinlock-protected functions.  Somehow I managed to discard that change
> before settling on the final version that was published.

Err.

Do not forget one very important point.

Any clock which has clk_enable() called on it must have had clk_prepare()
already called _and_ completed.  A second clk_prepare() call on the same
clock should be a no-op other than to increase the prepare reference count
on it.

If you do anything else, you are going to get into sticky problems.
