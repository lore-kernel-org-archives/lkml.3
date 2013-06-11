Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3FKRRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:17:54 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:46644 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3FKRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:17:53 -0400
MIME-Version: 1.0
In-Reply-To: <20130611164807.GJ5146@linux.vnet.ibm.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	<CACvQF51K80e3CbTqqwb=WyTVUqndVKP_-fGNnpoh9Gfoyzv5ig@mail.gmail.com>
	<CACvQF50+b4LS2Zgu2uJBpDc_NGUW942XtB7ymfQdmkQc1MwZ9Q@mail.gmail.com>
	<20130611164807.GJ5146@linux.vnet.ibm.com>
Date: Tue, 11 Jun 2013 10:17:52 -0700
X-Google-Sender-Auth: PLW-cHHawv9MHujjlskWRcB73mc
Message-ID: <CA+55aFyteA526MZHpzYTo1XoMx772FrRoqc_keODx1TfxDx6Fw@mail.gmail.com>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Lai Jiangshan <eag0628@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 9:48 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> Another approach is to permanently associate queues with each lock,
> but that increases the size of the lock -- something that has raised
> concerns in the past.  But if adding 32 bytes to each ticketlock was OK,
> this simplifies things quite a bit.

Yeah, no. The spinlocks need to be small.  We have them in
size-conscious data structures like "struct dentry" and "struct page",
and they really must not be bigger than an "int" in the non-debug
case.

In fact, I've occasionally thought about combining a spinlock with a
refcounter if that could make things fit in 32 bits on smaller
machines, because we also have ops like "atomic_dec_and_lock()" that
could possibly be optimized if they fit in one word. That is probably
not worth it, but spinlocks do need to remain small.

                    Linus
