Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186AbaAaKDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:03:52 -0500
Received: from science.horizon.com ([71.41.210.146]:25894 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932072AbaAaKDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:03:50 -0500
Date: 31 Jan 2014 05:03:48 -0500
Message-ID: <20140131100348.8867.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org, Waiman.Long@hp.com
Subject: Re: [PATCH v11 0/4] Introducing a queue read/write lock implementation
Cc: akpm@linux-foundation.org, andi@firstfloor.org, arnd@arndb.de,
        aswin@hp.com, hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@horizon.com, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, tim.c.chen@linux.intel.com,
        torvalds@linux-foundation.org, walken@google.com, x86@kernel.org
In-Reply-To: <20140131092616.GC5126@laptop.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How about getting rid of that TICKET_MSB mess and doing something like:

#define TICKET_MASK	0xFFFF

static inline void ticket_spin_unlock(atomic_t *tickets)
{
	u32 t = *tickets;

	smp_mb__before_atomic_inc();

	/* Increment the low 16 bits without affecting the upper. */
	if (unlikely((~t & TICKET_MASK) == 0))
		atomic_add(-(atomic_t)TICKET_MASK, tickets);
	else
		atomic_inc(tickets);
}

That also allows up to 2^16 waiters, up from 2^15.
(Minus one on both cases, if you want to be fussy.)
