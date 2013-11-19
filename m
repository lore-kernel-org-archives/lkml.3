Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3KSI3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:29:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3KSI3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:29:20 -0500
Date: Tue, 19 Nov 2013 09:29:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH/RFC] wait_for_completion_timeout() considered harmful.
Message-ID: <20131119082913.GE10022@twins.programming.kicks-ass.net>
References: <20131117080603.2a0d3b6d@notabene.brown>
 <20131118152746.937b2b7971d7a4bba4ef996d@linux-foundation.org>
 <20131118234209.GO16796@laptop.programming.kicks-ass.net>
 <20131118174902.312d8fa6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118174902.312d8fa6@lwn.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 05:49:02PM -0700, Jonathan Corbet wrote:
> On Tue, 19 Nov 2013 00:42:09 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > I briefly talked to Thomas about this earlier today and we need to fix
> > this at a lower level -- the quick 'n dirty solution is to add 1 jiffy
> > down in the timer-wheel when we enqueue these things.
> 
> That can lead to situations like the one I encountered years ago where
> msleep(1) would snooze for 20ms. 

No, for up to 20ms, since you get part of the first jiffy, which was the
whole problem (assuming we're talking HZ=100 here).

> I didn't get much love for my idea of
> switching msleep() to hrtimers back then, but I still think it might be be
> better to provide the resolution that the interface appears to promise.

It would actually make more sense to use hrtimers here than it does to
use the old timers since hrtimers has much better gurantees but also
because the timer is guaranteed to fire.

The use case where the old timers really beat hrtimers hands down is
for timeout timers that never actually fire.
