Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbaENQSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:18:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:39679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbaENQSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:18:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1053,1389772800"; 
   d="scan'208";a="511613824"
User-Agent: Microsoft-MacOutlook/14.4.1.140326
Date: Wed, 14 May 2014 09:18:54 -0700
Subject: Re: futex(2) man page update help request
From: Darren Hart <dvhart@linux.intel.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>
CC: "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Message-ID: <CF98E3EF.90564%dvhart@linux.intel.com>
Thread-Topic: futex(2) man page update help request
References: <537346E5.4050407@gmail.com>
In-Reply-To: <537346E5.4050407@gmail.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/14, 3:35, "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
wrote:

>[So, some futex recent discussions remind me I should make this request]
>
>Hello all (especially those in the To:, namely Thomas, Darren, Ingo,
>Jakub),
>
>The futex man pages:
>http://man7.org/linux/man-pages/man2/futex.2.html
>http://man7.org/linux/man-pages/man7/futex.7.html
>are currently in a sorry state. I'm by no means convinced that all of the
>futex operations described there are explained fully and correctly. And
>probably not all error cases for each operation are properly documented.
>I'd be very happy if some folk could review those pages and send me
>corrections (Git: 
>http://git.kernel.org/pub/scm/docs/man-pages/man-pages).
>
>But worse, a number of futex operations remain undocumented in futex(2)
>(see the list below).
>
>I am aware of Documentation/pi-futex.txt and
>Documentation/futex-requeue-pi.txt. However, both of those documents
>are rather thin on details / explain what certain FUTEX_* operations are
>used for rather than what they do / focus on the implementation, rather
>than the semantics.
>
>What I would like is that the futex(2) page documenta each one of
>these operations with a focus on the semantics in a way that might be
>useful to writers of library functions or those who simply wish to
>better understand (from a user-space perspective) what futexes are
>and how they are used. However, I don't have the knowledge to do
>this well in any reasonable time.
>
>Would the folk in the To: list (or anyone else who is knowledgeable)
>be willing to write patches
>(Git: http://git.kernel.org/pub/scm/docs/man-pages/man-pages )
>or just supply me with some raw text that documents these currently
>undocumented futex operations, in the manner suggested?

Yes, I'll be glad to help.

However, unless I'm sorely mistaken, the larger problem is that glibc
removed the futex() call entirely, so these man pages don't describe
something users even have access to anymore. I had to revert to calling
the syscalls directly in the futextest test suite because of this:

http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
de/futextest.h#n67


Which basically defines:

#define futex(uaddr, op, val, timeout, uaddr2, val3, opflags) \
        syscall(SYS_futex, uaddr, op | opflags, val, timeout, uaddr2, val3)


Adding Carlos for his perspective.

If I'm wrong, or we can restore the futex() call, great. If not... Should
we keep the man-pages and document it as syscall(SYS_futex, ..., op, ...) ?

Thanks,

Darren

>
>The operations for which documentation is currently missing are:
>
>2.6.14 adds FUTEX_WAKE_OP
>    commit 4732efbeb997189d9f9b04708dc26bf8613ed721
>    Author: Jakub Jelinek <jakub@redhat.com>
>    Date:   Tue Sep 6 15:16:25 2005 -0700
>    See also https://bugzilla.kernel.org/show_bug.cgi?id=14303
>
>2.6.18 adds priority inheritance support:
>FUTEX_LOCK_PI, FUTEX_UNLOCK_PI, and FUTEX_TRYLOCK_PI.
>    commit c87e2837be82df479a6bae9f155c43516d2feebc
>    Author: Ingo Molnar <mingo@elte.hu>
>    Date:   Tue Jun 27 02:54:58 2006 -0700
>
>    commit e2970f2fb6950183a34e8545faa093eb49d186e1
>    Author: Ingo Molnar <mingo@elte.hu>
>    Date:   Tue Jun 27 02:54:47 2006 -0700
>
>    See Documentation/pi-futex.txt
>
>2.6.25 adds FUTEX_WAKE_BITSET, FUTEX_WAIT_BITSET
>    commit cd689985cf49f6ff5c8eddc48d98b9d581d9475d
>    Author: Thomas Gleixner <tglx@linutronix.de>
>    Date:   Fri Feb 1 17:45:14 2008 +0100
>
>2.6.31 adds FUTEX_WAIT_REQUEUE_PI, FUTEX_CMP_REQUEUE_PI
>    commit 52400ba946759af28442dee6265c5c0180ac7122
>    Author: Darren Hart <dvhltc@us.ibm.com>
>    Date:   Fri Apr 3 13:40:49 2009 -0700
>
>    commit ba9c22f2c01cf5c88beed5a6b9e07d42e10bd358
>    Author: Darren Hart <dvhltc@us.ibm.com>
>    Date:   Mon Apr 20 22:22:22 2009 -0700
>
>    See Documentation/futex-requeue-pi.txt
>
>Thanks,
>
>Michael
>
>
>-- 
>Michael Kerrisk
>Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
>Linux/UNIX System Programming Training: http://man7.org/training/
>


-- 
Darren Hart					Open Source Technology Center
darren.hart@intel.com				            Intel Corporation



