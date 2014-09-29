Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaI2WV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:21:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbaI2WVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:21:54 -0400
Date: Tue, 30 Sep 2014 00:18:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 08/11] module: Fix nested sleep
Message-ID: <20140929221823.GC12112@redhat.com>
References: <20140924081845.572814794@infradead.org> <20140924082242.458562904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924082242.458562904@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24, Peter Zijlstra wrote:
>
> A genuine bug, we cannot use blocking primitives inside a wait loop.
>
> So rewrite the wait_event_interruptible() usage to use the fresh
> wait_woken() stuff.

OK, but ...

> +static int wait_finished_loading(struct module *mod)
> +{
> +	DEFINE_WAIT_FUNC(wait, woken_wake_function);
> +	int ret = 0;
> +
> +	add_wait_queue(&module_wq, &wait);
> +	for (;;) {
> +		if (finished_loading(mod->name))
> +			break;
> +
> +		if (signal_pending_state(TASK_INTERRUPTIBLE, current)) {

I am puzzled by this line, why not

		if (signal_pending(current)) {

?

this should be 100% equivalent.

Oleg.

