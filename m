Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3H0MPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 08:15:13 -0400
Received: from forward6.mail.yandex.net ([77.88.60.125]:35149 "EHLO
	forward6.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3H0MPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 08:15:11 -0400
X-Greylist: delayed 350 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Aug 2013 08:15:11 EDT
From: Alexander Fyodorov <halcy@yandex.ru>
To: Waiman Long <waiman.long@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <521BB71F.6080300@hp.com>
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru> <521BB71F.6080300@hp.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
MIME-Version: 1.0
Message-Id: <66111377605355@web12m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 27 Aug 2013 16:09:15 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I also thought that the x86 spinlock unlock path was an atomic add. It
> just comes to my realization recently that this is not the case. The
> UNLOCK_LOCK_PREFIX will be mapped to "" except for some old 32-bit x86
> processors.

Hmm, I didn't know that. Looking through Google found these rules for x86 memory ordering:
  * Loads are not reordered with other loads.
  * Stores are not reordered with other stores.
  * Stores are not reordered with older loads.
So x86 memory model is rather strict and memory barrier is really not needed in the unlock path - xadd is a store and thus behaves like a memory barrier, and since only lock's owner modifies "ticket.head" the "add" instruction need not be atomic.

But this is true only for x86, other architectures have more relaxed memory ordering. Maybe we should allow arch code to redefine queue_spin_unlock()? And define a version without smp_mb() for x86?
