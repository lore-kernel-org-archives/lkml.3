Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab3H2PZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 11:25:12 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:15591 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3H2PZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 11:25:11 -0400
Message-ID: <521F67C9.4080805@hp.com>
Date: Thu, 29 Aug 2013 11:24:57 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Alexander Fyodorov <halcy@yandex.ru>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru> <521BB71F.6080300@hp.com> <66111377605355@web12m.yandex.ru>
In-Reply-To: <66111377605355@web12m.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 08:09 AM, Alexander Fyodorov wrote:
>> I also thought that the x86 spinlock unlock path was an atomic add. It
>> just comes to my realization recently that this is not the case. The
>> UNLOCK_LOCK_PREFIX will be mapped to "" except for some old 32-bit x86
>> processors.
> Hmm, I didn't know that. Looking through Google found these rules for x86 memory ordering:
>    * Loads are not reordered with other loads.
>    * Stores are not reordered with other stores.
>    * Stores are not reordered with older loads.
> So x86 memory model is rather strict and memory barrier is really not needed in the unlock path - xadd is a store and thus behaves like a memory barrier, and since only lock's owner modifies "ticket.head" the "add" instruction need not be atomic.
>
> But this is true only for x86, other architectures have more relaxed memory ordering. Maybe we should allow arch code to redefine queue_spin_unlock()? And define a version without smp_mb() for x86?

What I have been thinking is to set a flag in an architecture specific 
header file to tell if the architecture need a memory barrier. The 
generic code will then either do a smp_mb() or barrier() depending on 
the presence or absence of the flag. I would prefer to do more in the 
generic code, if possible.

Regards,
Longman
