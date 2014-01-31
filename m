Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646AbaAaT2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 14:28:54 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4498 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaAaT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 14:28:52 -0500
Message-ID: <52EBF96D.6010603@hp.com>
Date: Fri, 31 Jan 2014 14:28:45 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: peterz@infradead.org, akpm@linux-foundation.org, andi@firstfloor.org,
        arnd@arndb.de, aswin@hp.com, daniel@numascale.com, halcy@yandex.ru,
        hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulmck@linux.vnet.ibm.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, rostedt@goodmis.org, scott.norton@hp.com,
        tglx@linutronix.de, thavatchai.makpahibulchoke@hp.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org,
        walken@google.com, x86@kernel.org
Subject: Re: [PATCH v3 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <20140131191439.29560.qmail@science.horizon.com>
In-Reply-To: <20140131191439.29560.qmail@science.horizon.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2014 02:14 PM, George Spelvin wrote:
>> Yes, we can do something like that. However I think put_qnode() needs to
>> use atomic dec as well. As a result, we will need 2 additional atomic
>> operations per slowpath invocation. The code may look simpler, but I
>> don't think it will be faster than what I am currently doing as the
>> cases where the used flag is set will be relatively rare.
> The increment does *not* have to be atomic.
>
> First of all, note that the only reader that matters is a local interrupt;
> other processors never access the variable at all, so what they see
> is irrelevant.
>
> "Okay, so I use a non-atomic RMW instruction; what about non-x86
> processors without op-to-memory?"
>
> Well, they're okay, too.  The only requriement is that the write to
> qna->cnt must be visible to the local processor (barrier()) before the
> qna->nodes[] slot is used.
>
> Remember, a local interrupt may use a slot temporarily, but will always
> return qna->cnt to its original value before returning.  So there's
> nothing wrong with
>
> - Load qna->cnt to register
> - Increment register
> - Store register to qna->cnt
>
> Because an interrupt, although it may temporarily modify qna->cnt, will
> restore it before returning so this code will never see any modification.
>
> Just like using the stack below the %rsp, the only requirement is to
> ensure that the qna->cnt increment is visble *to the local processor's
> interrupt handler* before actually using the slot.
>
> The effect of the interrupt handler is that it may corrupt, at any
> time and without warning, any slot not marked in use via qna->cnt.
> But that's not a difficult thing to deal with, and does *not* require
> atomic operations.

George, you are right. I am thinking too much from the general 
perspective of RMW instruction.

-Longman
