Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaAOAZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 19:25:10 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:44391 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOAZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 19:25:06 -0500
MIME-Version: 1.0
In-Reply-To: <20140114234443.GY10038@linux.vnet.ibm.com>
References: <52D353C8.4000000@numascale.com>
	<52D4172E.6030706@hp.com>
	<52D4A0C7.5070601@numascale.com>
	<20140114110307.GW7572@laptop.programming.kicks-ass.net>
	<CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
	<52D57B60.9020209@twiddle.net>
	<20140114234443.GY10038@linux.vnet.ibm.com>
Date: Wed, 15 Jan 2014 07:25:04 +0700
X-Google-Sender-Auth: TWvxYOGf2PO8-r_gBvdHsT1bffo
Message-ID: <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 6:44 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Which means that Alpha should be able to similarly emulate 1-byte and
> 2-byte atomics, correct?

Not reasonably, no.

The ldl/stc implementation on early alpha was so broken as to be
unusable. It's not actually done in the cache, it WENT OUT ON THE BUS.
We're talking 70's style "external lock signal" kind of things like
the 8086 did for locked cycles before the advent of caches, the kind
that nobody sane has done for a long long time.

So realistically, you absolutely do not want to use those things to
emulate atomic byte/word accesses. The whole point of "load_acquire()"
and "store_release()" is that it's supposed to be cheaper than a
locked access, and can be done with just a barrier instruction or a
special instruction flag.

If you just want to do a store release, on alpha you'd want to
implement that as a full memory barrier followed by a store. It
doesn't get the advantage of a real release consistency model, but at
least it's not doing an external bus access. But you can only do that
store as a 4-byte or 8-byte store.on the older alphas (byte and word
stores work on newer ones).

Of course, it's entirely possible that nobody cares..

             Linus
