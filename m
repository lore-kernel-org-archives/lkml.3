Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbaCEDg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 22:36:57 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:36080 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbaCEDg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 22:36:56 -0500
MIME-Version: 1.0
In-Reply-To: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
References: <1393983784.2512.40.camel@buesod1.americas.hpqcorp.net>
Date: Tue, 4 Mar 2014 19:36:55 -0800
X-Google-Sender-Auth: L3miiI9r3jprZqjKO_deYqk51-0
Message-ID: <CA+55aFzRi+r4=8D+d5odaRMRNOWSY01ydsbreko7HNsD_Dg68Q@mail.gmail.com>
Subject: Re: futex funkiness -- massive lockups
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2014 at 5:43 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
>
> From the paths related to futex wait we are stuck when taking the hb
> spinlock in futex_wait_setup >> queue_lock.

Just judging from your trace, I would have suspected a (possibly soft)
lockup in load_balance() rather than the futexes.

The futex being stuck seems expected, since one cpu is definitely
holding the lock - it was interrupted by a timer interrupt at the
successful return case of raw_spin_lock if I read the offset right.

So if that softirq is stuck - perhaps because it's in some endless
loop in load_balance(), or perhaps because it's spending so much time
load-balancing that the next balancing time happens immediately, or
whatever - then you'd see that trace.

              Linus
