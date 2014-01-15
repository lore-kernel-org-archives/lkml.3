Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaAOII3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:08:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57408 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOII1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:08:27 -0500
Date: Wed, 15 Jan 2014 09:07:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Henderson <rth@twiddle.net>, Matt Turner <mattst88@gmail.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Waiman Long <waiman.long@hp.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH v8 4/4] qrwlock: Use smp_store_release() in write_unlock()
Message-ID: <20140115080753.GW31570@twins.programming.kicks-ass.net>
References: <52D353C8.4000000@numascale.com>
 <52D4172E.6030706@hp.com>
 <52D4A0C7.5070601@numascale.com>
 <20140114110307.GW7572@laptop.programming.kicks-ass.net>
 <CAEdQ38GOSr+yk2=HApW3c0GM0MMysCvW6Fkd5UNMjS1ynrcZDg@mail.gmail.com>
 <52D57B60.9020209@twiddle.net>
 <20140114234443.GY10038@linux.vnet.ibm.com>
 <CA+55aFyF2Vg785qO52fJLV7rsi6bMtGFhxsAvJ7354EBrcESCA@mail.gmail.com>
 <20140115023958.GA10038@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115023958.GA10038@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 06:39:58PM -0800, Paul E. McKenney wrote:
> > If you just want to do a store release, on alpha you'd want to
> > implement that as a full memory barrier followed by a store. It
> > doesn't get the advantage of a real release consistency model, but at
> > least it's not doing an external bus access. But you can only do that
> > store as a 4-byte or 8-byte store.on the older alphas (byte and word
> > stores work on newer ones).
> > 
> > Of course, it's entirely possible that nobody cares..
> 
> That would be my hope.  ;-)
> 
> If nobody cares about Alpha period, it is easy.  However, the last time
> that I tried that approach, they sent me a URL of a wiki showing Alpha
> systems still running mainline.  But a slow-but-working approach for
> Alpha does seem reasonable, even for those still running Linux on Alpha.

Well, if they're all EV56 or later we're still good as they can actually
do what we need.

But I don't think a ll/sc implementation of the store_release can even
work, because in that case all users of the other bytes also need a
ll/sc around them but how are we to know about them?

So the only real way to allow store_release on 8/16 bit values is by
removing all Alpha support _pre_ EV56 :/
