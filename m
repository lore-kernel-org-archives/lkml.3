Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3H2RN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:13:28 -0400
Received: from forward7.mail.yandex.net ([77.88.61.37]:46303 "EHLO
	forward7.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3H2RN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:13:27 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 13:13:26 EDT
From: Alexander Fyodorov <halcy@yandex.ru>
To: Waiman Long <waiman.long@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <521F67C9.4080805@hp.com>
References: <15321377012704@web8h.yandex.ru> <52142D6C.6000400@hp.com> <336901377100289@web16f.yandex.ru> <5215638E.5020702@hp.com> <169431377178121@web21f.yandex.ru> <521BB71F.6080300@hp.com> <66111377605355@web12m.yandex.ru> <521F67C9.4080805@hp.com>
Subject: Re: [PATCH RFC v2 1/2] qspinlock: Introducing a 4-byte queue spinlock implementation
MIME-Version: 1.0
Message-Id: <53161377795800@web14m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 29 Aug 2013 21:03:20 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.08.2013, 19:25, "Waiman Long" <waiman.long@hp.com>:
> What I have been thinking is to set a flag in an architecture specific
> header file to tell if the architecture need a memory barrier. The
> generic code will then either do a smp_mb() or barrier() depending on
> the presence or absence of the flag. I would prefer to do more in the
> generic code, if possible.

If you use flag then you'll have to check it manually. It is better to add new smp_mb variant, I suggest calling it smp_mb_before_store(), and define it to barrier() on x86.

But the same constraints as to UNLOCK_LOCK_PREFIX should apply here, so it will be something like this:

arch/x86/include/asm/barrier.h:

+#if defined(CONFIG_X86_32) && \
+        (defined(CONFIG_X86_OOSTORE) || defined+(CONFIG_X86_PPRO_FENCE))
+/*      
+ * On PPro SMP or if we are using OOSTORE, we use a full memory barrier
+ * (PPro errata 66, 92)
+ */
+# define smp_mb_before_store() smp_mb()
+#else
+# define smp_mb_before_store() barrier()
+#endif
