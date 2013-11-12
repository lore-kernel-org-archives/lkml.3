Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279Ab3KLRQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:16:38 -0500
Received: from science.horizon.com ([71.41.210.146]:55018 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753961Ab3KLRQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:16:35 -0500
Date: 12 Nov 2013 12:16:33 -0500
Message-ID: <20131112171633.7498.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: tim.c.chen@linux.intel.com, will.deacon@arm.com
Subject: Re: [PATCH v5 4/4] MCS Lock: Barrier corrections
Cc: a.p.zijlstra@chello.nl, aarcange@redhat.com, akpm@linux-foundation.org,
        alex.shi@linaro.org, andi@firstfloor.org, arnd@arndb.de, aswin@hp.com,
        dave.hansen@intel.com, davidlohr.bueso@hp.com, figo1802@gmail.com,
        hpa@zytor.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux@horizon.com,
        matthew.r.wilcox@intel.com, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
        peter@hurleysoftware.com, raghavendra.kt@linux.vnet.ibm.com,
        riel@redhat.com, scott.norton@hp.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, waiman.long@hp.com, walken@google.com
In-Reply-To: <20131112160827.GB25953@mudshark.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 11, 2013 at 09:17:52PM +0000, Tim Chen wrote:
>> An alternate implementation is
>> 	while (!ACCESS_ONCE(node->locked))
>> 		arch_mutex_cpu_relax();
>> 	smp_load_acquire(&node->locked);
>> 
>> Leaving the smp_load_acquire at the end to provide appropriate barrier.
>> Will that be acceptable?

Will Deacon <will.deacon@arm.com> wrote:
> It still doesn't solve my problem though: I want a way to avoid that busy
> loop by some architecture-specific manner. The arch_mutex_cpu_relax() hook
> is a start, but there is no corresponding hook on the unlock side to issue a
> wakeup. Given a sensible relax implementation, I don't have an issue with
> putting a load-acquire in a loop, since it shouldn't be aggresively spinning
> anymore.

So you want something like this?

/*
 * This is a spin-wait with acquire semantics.  That is, accesses after
 * this are not allowed to be reordered before the load that meets
 * the specified condition.  This requires that it end with either a
 * load-acquire or a full smp_mb().  The optimal way to do this is likely
 * to be architecture-dependent.  E.g. x86 MONITOR/MWAIT instructions.
 */
#ifndef smp_load_acquire_until
#define smp_load_acquire_until(addr, cond) \
	while (!(smp_load_acquire(addr) cond)) { \
		do { \
			arch_mutex_cpu_relax(); \
		} while (!(ACCESS_ONCE(*(addr)) cond)); \
	}
#endif

	smp_load_acquire_until(&node->locked, != 0);

Alternative implementations:

#define smp_load_acquire_until(addr, cond) { \
	while (!(ACCESS_ONCE(*(addr)) cond)) \
		arch_mutex_cpu_relax(); \
	smp_mb(); }

#define smp_load_acquire_until(addr, cond) \
	if (!(smp_load_acquire(addr) cond)) { \
		do { \
			arch_mutex_cpu_relax(); \
		} while (!(ACCESS_ONCE(*(addr)) cond)); \
		smp_mb(); \
	}
