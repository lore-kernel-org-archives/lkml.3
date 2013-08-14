Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3HNJ4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:56:10 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:40638 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3HNJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:56:08 -0400
Date: Wed, 14 Aug 2013 11:56:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Re-tune x86 uaccess code for PREEMPT_VOLUNTARY v2
Message-ID: <20130814095604.GB10849@gmail.com>
References: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376438836-13339-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andi,

You _again_ 'forgot' to Cc: peterz who is an affected maintainer and who 
is keenly interested in such low level changes affecting scheduling - and 
he asked to be Cc:-ed on your previous submission.

I still don't understand, why do you *routinely* do office politics crap 
like that, playing games with Cc:s and private mails, which eminently 
hinders kernel development? (Oh, it's deniable and I'm quite sure you'll 
deny it in a heartbeat and call it an inadvertent omission. Just skip the 
excuses and stop it, ok?)

Thanks,

	Ingo

* Andi Kleen <andi@firstfloor.org> wrote:

> The x86 user access functions (*_user) were originally very well tuned,
> with partial inline code and other optimizations.
> 
> Then over time various new checks -- particularly the sleep checks for
> a voluntary preempt kernel -- destroyed a lot of the tunings
> 
> A typical user access operation is now doing multiple useless
> function calls. Also the without force inline gcc's inlining
> policy makes it even worse, with adding more unnecessary calls.
> 
> Here's a typical example from ftrace:
> 
>      10)               |    might_fault() {
>      10)               |      _cond_resched() {
>      10)               |        should_resched() {
>      10)               |          need_resched() {
>      10)   0.063 us    |            test_ti_thread_flag();
>      10)   0.643 us    |          }
>      10)   1.238 us    |        }
>      10)   1.845 us    |      }
>      10)   2.438 us    |    }
> 
> So we spent 2.5us doing nothing (ok it's a bit less without
> ftrace, but still pretty bad)
> 
> Then in other cases we would have an out of line function,
> but would actually do the might_sleep() checks in the inlined
> caller. This doesn't make any sense at all.
> 
> There were also a few other problems, for example the x86-64 uaccess
> code regularly falls back to string functions, even though a simple
> mov would be enough. For example every futex access to the lock
> variable would actually use string instructions, even though 
> it's just 4 bytes.
> 
> This patch kit is an attempt to get us back to sane code, 
> mostly by doing proper inlining and doing sleep checks in the right
> place. Unfortunately I had to add one tree sweep to avoid an nasty
> include loop.
> 
> v2: Now completely remove reschedule checks for uaccess functions.
