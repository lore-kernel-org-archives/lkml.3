Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbaA2C5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:57:44 -0500
Received: from science.horizon.com ([71.41.210.146]:56608 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752281AbaA2C5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:57:42 -0500
Date: 28 Jan 2014 21:57:40 -0500
Message-ID: <20140129025740.17866.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: andi@firstfloor.org, Waiman.Long@hp.com
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
Cc: akpm@linux-foundation.org, arnd@arndb.de, aswin@hp.com,
        daniel@numascale.com, halcy@yandex.ru, hpa@zytor.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, thavatchai.makpahibulchoke@hp.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org,
        walken@google.com, x86@kernel.org
In-Reply-To: <20140129002048.GE11821@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the 1-2 threads case is the standard case on a small
> system, isn't it? This may well cause regressions.

Well, the common case should be uncontended, which is faster.
But yes, testing would be nice.

>> In the extremely unlikely case that all the queue node entries are
>> used up, the current code will fall back to busy spinning without
>> waiting in a queue with warning message.

> Traditionally we had some code which could take thousands
> of locks in rare cases (e.g. all locks in a hash table or all locks of
> a big reader lock) 

Doesn't apply; the question implies a misunderstanding of what's
happening.  The entry is only needed while spinning waiting for
the lock.  Once the lock has been acquired, it may be recycled.

The thread may *hold* thousands of locks; the entries only apply
to locks being *waited for*.

>From process context a thread may only be waiting for one at a time.
Additional entries are only needed in case a processor takes an interrupt
while spinning, and the interrupt handler wants to take a lock, too.

If that lock also has to be waited for, and during the wait you take a
nested interrupt or NMI, a third level might happen.

The chances of this being nested more than 4 deep seem sufficiently
minute.
