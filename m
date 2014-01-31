Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaAaTOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:14:42 -0500
Received: from science.horizon.com ([71.41.210.146]:30947 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932494AbaAaTOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:14:40 -0500
Date: 31 Jan 2014 14:14:39 -0500
Message-ID: <20140131191439.29560.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: peterz@infradead.org, waiman.long@hp.com
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
Cc: akpm@linux-foundation.org, andi@firstfloor.org, arnd@arndb.de,
        aswin@hp.com, daniel@numascale.com, halcy@yandex.ru, hpa@zytor.com,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@horizon.com, mingo@redhat.com, paulmck@linux.vnet.ibm.com,
        raghavendra.kt@linux.vnet.ibm.com, riel@redhat.com,
        rostedt@goodmis.org, scott.norton@hp.com, tglx@linutronix.de,
        thavatchai.makpahibulchoke@hp.com, tim.c.chen@linux.intel.com,
        torvalds@linux-foundation.org, walken@google.com, x86@kernel.org
In-Reply-To: <52EBEAD5.3000502@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, we can do something like that. However I think put_qnode() needs to 
> use atomic dec as well. As a result, we will need 2 additional atomic 
> operations per slowpath invocation. The code may look simpler, but I 
> don't think it will be faster than what I am currently doing as the 
> cases where the used flag is set will be relatively rare.

The increment does *not* have to be atomic.

First of all, note that the only reader that matters is a local interrupt;
other processors never access the variable at all, so what they see
is irrelevant.

"Okay, so I use a non-atomic RMW instruction; what about non-x86
processors without op-to-memory?"

Well, they're okay, too.  The only requriement is that the write to
qna->cnt must be visible to the local processor (barrier()) before the
qna->nodes[] slot is used.

Remember, a local interrupt may use a slot temporarily, but will always
return qna->cnt to its original value before returning.  So there's
nothing wrong with

- Load qna->cnt to register
- Increment register
- Store register to qna->cnt

Because an interrupt, although it may temporarily modify qna->cnt, will
restore it before returning so this code will never see any modification.

Just like using the stack below the %rsp, the only requirement is to
ensure that the qna->cnt increment is visble *to the local processor's
interrupt handler* before actually using the slot.

The effect of the interrupt handler is that it may corrupt, at any
time and without warning, any slot not marked in use via qna->cnt.
But that's not a difficult thing to deal with, and does *not* require
atomic operations.
