Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3CEPk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:40:26 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:43178 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CEPkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:40:23 -0500
MIME-Version: 1.0
In-Reply-To: <51360CFC.7040807@cn.fujitsu.com>
References: <1362449845-7492-1-git-send-email-walken@google.com>
	<1362449845-7492-2-git-send-email-walken@google.com>
	<51360CFC.7040807@cn.fujitsu.com>
Date: Tue, 5 Mar 2013 07:40:22 -0800
Message-ID: <CANN689E_0chWnvTjY6qeYK_r9WWGjincEtpY8HgCbXqn_mujFQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lockdep: introduce lock_acquire_exclusive/shared
 helper macros
From: Michel Lespinasse <walken@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        paulmck@linux.vnet.ibm.com, Rusty Russell <rusty@rustcorp.com.au>,
        rostedt@goodmis.org, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 7:19 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> I don't like the name lock_acquire_shared_recursive().
> (I mean the name is wrong, ......)

Names are hard :/ Do you have a better suggestion ?

> In the lockdep design, lock_acquire(l, s, t, 2, 2, n, i) is used for
> read-preference locks(rwlock) and all types of RCU. not for "recursive"
> read-preference implies "recursive".

I based my names on the following description from lockdep.h:

 * Values for "read":
 *
 *   0: exclusive (write) acquire
 *   1: read-acquire (no recursion allowed)
 *   2: read-acquire with same-instance recursion allowed

> But the name lock_acquire_shared_recursive() don't tell us it is
> read-preference.
>
> Example if we do have a lock which is write-preference but allow read_lock recursive,
> it will be still deadlock in this way, "recursive" does not help:
>
> cpu0: spin_lock(a);                             recursiveable_read_lock(b)
> cpu1: recursiveable_read_lock(b);               spin_lock(a);
> cpu2:                           write_lock(b);

I think this is a very theorical distinction as 1- we don't have such
locks in linux currently, and 2- lockdep does not currently support
this. That is, lockdep will either report both of these scenarios as
valid or invalid, but you can't tell it to allow the first scenario
while disallowing the second:

read_lock(a); read_lock(a);
(the recursive read lock scenario)

read_lock(a); lock(b); vs lock(b); read_lock(a);
(the lock ordering vs other locks scenario)

So, I would think that since lockdep doesn't make this distinction the
helper macros don't need to either ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
