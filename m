Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbaI3Nne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:43:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34405 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaI3Nnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:43:33 -0400
Date: Tue, 30 Sep 2014 15:43:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 08/11] module: Fix nested sleep
Message-ID: <20140930134324.GE4241@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <20140924082242.458562904@infradead.org>
 <20140929221823.GC12112@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140929221823.GC12112@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 12:18:23AM +0200, Oleg Nesterov wrote:
> On 09/24, Peter Zijlstra wrote:
> >
> > A genuine bug, we cannot use blocking primitives inside a wait loop.
> >
> > So rewrite the wait_event_interruptible() usage to use the fresh
> > wait_woken() stuff.
> 
> OK, but ...
> 
> > +static int wait_finished_loading(struct module *mod)
> > +{
> > +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> > +	int ret = 0;
> > +
> > +	add_wait_queue(&module_wq, &wait);
> > +	for (;;) {
> > +		if (finished_loading(mod->name))
> > +			break;
> > +
> > +		if (signal_pending_state(TASK_INTERRUPTIBLE, current)) {
> 
> I am puzzled by this line, why not
> 
> 		if (signal_pending(current)) {
> 
> ?
> 
> this should be 100% equivalent.

Ah, because I looked at ___wait_event() and that ends up using
signal_pending_state() through preprare_to_wait_event().

I did not actually 'think' much. Lemme change that for you.
