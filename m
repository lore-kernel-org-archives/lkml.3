Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275AbaFKIOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:14:18 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50955 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932102AbaFKIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:14:14 -0400
Message-ID: <1402474451.3798.44.camel@x220>
Subject: Re: [tip:locking/core] x86, locking/rwlocks: Enable qrwlocks on x86
From: Paul Bolle <pebolle@tiscali.nl>
To: Waiman Long <Waiman.Long@hp.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        davej@redhat.com, jeremy@goop.org, paulmck@linux.vnet.ibm.com,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jun 2014 10:14:11 +0200
In-Reply-To: <tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org>
References: <tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2014 08:14:12.0025 (UTC) FILETIME=[20707290:01CF854D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 05:20 -0700, tip-bot for Waiman Long wrote:
> Make x86 use the fair rwlock_t.
> 
> Implement the custom queue_write_unlock() for best performance.

This landed in linux-next yesterday (ie, next-20140610).

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> [peterz: near complete rewrite]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Cc: "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: x86@kernel.org
> Link: http://lkml.kernel.org/n/tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>[...]
> diff --git a/arch/x86/include/asm/qrwlock.h b/arch/x86/include/asm/qrwlock.h
> new file mode 100644
> index 0000000..70f46f0
> --- /dev/null
> +++ b/arch/x86/include/asm/qrwlock.h
> @@ -0,0 +1,17 @@
> +#ifndef _ASM_X86_QRWLOCK_H
> +#define _ASM_X86_QRWLOCK_H
> +
> +#include <asm-generic/qrwlock_types.h>
> +
> +#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)

X86_OOSTORE was removed in v3.14, see commit 09df7c4c8097 ("x86: Remove
CONFIG_X86_OOSTORE"). So the first test can be removed here, as it will
always be true. Should I submit the trivial, but probably untested,
patch to do that or do you prefer to do that yourself?

> +#define queue_write_unlock queue_write_unlock
> +static inline void queue_write_unlock(struct qrwlock *lock)
> +{
> +        barrier();
> +        ACCESS_ONCE(*(u8 *)&lock->cnts) = 0;
> +}
> +#endif
> +
> +#include <asm-generic/qrwlock.h>
> +
> +#endif /* _ASM_X86_QRWLOCK_H */

Thanks,


Paul Bolle

