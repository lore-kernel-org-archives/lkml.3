Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3JDTMa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 15:12:30 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:48500 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3JDTM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 15:12:29 -0400
MIME-Version: 1.0
In-Reply-To: <20131004184629.GA17550@redhat.com>
References: <20131004184614.GA17536@redhat.com>
	<20131004184629.GA17550@redhat.com>
Date: Fri, 4 Oct 2013 12:12:25 -0700
X-Google-Sender-Auth: U0x77xDxim5HIlOcza4UZAuXmUQ
Message-ID: <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 4, 2013 at 11:46 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Add the new struct rcu_sync_ops which holds sync/call methods, and
> turn the function pointers in rcu_sync_struct into the single pointer
> to struct rcu_sync_ops.
>
> +struct rcu_sync_ops {
> +       void (*sync)(void);
> +       void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +};
> +
>  struct rcu_sync_struct {
>         int                     gp_state;
>         int                     gp_count;
> @@ -12,43 +17,9 @@ struct rcu_sync_struct {
>         int                     cb_state;
>         struct rcu_head         cb_head;
>
> -       void (*sync)(void);
> -       void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
> +       struct rcu_sync_ops     *ops;

Ugh.

This interface pretty much guarantees that a compiler can never do
anything clever, like know that "hey, you used a static initializer on
this thing, and the fields are const, so now know statically what the
functions are, and I can just turn the indirect jumps into direct
jumps".

I'm not sure gcc is actually that clever, but by making it this kind
of ops pointer, I *guarantee* that gcc can never do it.

How about you make the rule be:

 - get rid of the stupid "type" enum index thing

 - get rid of the "init" thing that sets pointers in the dynamic data
structures. Get rid of the pointer too.

 - instead, use a "static const" type descriptor for each type (it
approaches being your "rcu_sync_ops" structure). Pass this in as an
argument to all the functions (use a #define per type or something, so
that users don't need to do this by hand)

 - now every single user passes in that type descriptor.

 - together with using a few inline functions, suddenly the "indirect"
jumps through this type descriptor end up actually being nice direct
compile-time constants: iow, they get turned into direct jumps.

Tadaa. You actually get good code generation, and you use *less*
dynamic memory since you don't have to have this pointer to the
descriptor.

                Linus
