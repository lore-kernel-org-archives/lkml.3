Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab3CVL7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 07:59:08 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:39081 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768Ab3CVL7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 07:59:06 -0400
MIME-Version: 1.0
From: Zhu Yanhai <zhu.yanhai@gmail.com>
Date: Fri, 22 Mar 2013 19:58:45 +0800
Message-ID: <CAC8teKU5H8r+uPqeytWNOsj+g+C0pN8LKdxz3+LzomoWXY6GrA@mail.gmail.com>
Subject: How does spin_unlock() in x86-64 align with the description in Documention/memory-barriers.txt?
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        Jan Beulich <jbeulich@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, muming.wq@taobao.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
In the documention it reads,

(2) UNLOCK operation implication:

     Memory operations issued before the UNLOCK will be completed before the
     UNLOCK operation has completed.

     Memory operations issued after the UNLOCK may be completed before the
     UNLOCK operation has completed.

However, on x86-64 __ticket_spin_unlock() merely does,

static __always_inline void __ticket_spin_unlock(raw_spinlock_t *lock)
{
    asm volatile(
        ALTERNATIVE(UNLOCK_LOCK_PREFIX"incb (%0);"ASM_NOP3,
                UNLOCK_LOCK_ALT_PREFIX"movw $0, (%0)",
                X86_FEATURE_UNFAIR_SPINLOCK)
        :
        : "Q" (&lock->slock)
        : "memory", "cc");
}

While both UNLOCK_LOCK_PREFIX and UNLOCK_LOCK_ALT_PREFIX are empty
strings. So how such a function keeps the memory operations issued
before it completed?

--
Thanks,
Zhu Yanhai
