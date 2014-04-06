Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaDFP3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:29:33 -0400
Received: from smtp2.ngi.it ([88.149.128.113]:41845 "EHLO smtp2.ngi.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbaDFP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:29:29 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Apr 2014 11:29:29 EDT
Message-ID: <5341707F.5000406@katamail.com>
Date: Sun, 06 Apr 2014 17:19:27 +0200
From: Michele Ballabio <barra_cuda@katamail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: toralf.foerster@gmx.de, fweisbec@gmail.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Bisected KVM hang on x86-32 between v3.12 and v3.13
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster reported this in
  http://article.gmane.org/gmane.linux.kernel/1662567
  http://article.gmane.org/gmane.linux.kernel/1658422
  http://article.gmane.org/gmane.linux.kernel/1657962

  "The issue happens here at a 32 bit stable Gentoo Linux if
   I try to start a KVM image. Kernels 3.12.X works fine,
   kernel >= v3.13 will hang shortly after I started the image
   with the virtual-manager. The last syslog messages are
   something like:
   Feb 28 16:22:00 n22 kernel: INFO: rcu_sched detected stalls
       on CPUs/tasks: {} (detected by 2, t=60002 jiffies,
       g=14689, c=14688, q=21051)
   Feb 28 16:22:00 n22 kernel: INFO: Stall ended before state
       dump start"

He correctly pointed out that the bisection blamed the merge
commit 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce
"Merge tag 'v3.12-rc4' into sched/core".

This bug is obviously caused by at least two patches, one
on each side of the merge, that only when combined together
(at that merge point) cause the bug in kvm. By rebasing
the "sched/core" branch on "master" before the merge and
going on with the bisection, I found commit
3e8e42c69bb7d9fc12ebc23ff308e8523a2a59a0
"sched: Revert need_resched() to look at TIF_NEED_RESCHED"
as one of the causes. The other patch that contributes to the
bug is commit ded797547548a5b8e7b92383a41e4c0e6b0ecb7f
"irq: Force hardirq exit's softirq processing on its own stack".

Reverting either one of them solves the problem reported with kvm,
but revert is probably not the correct answer.

I wonder if the solution is as simple as this:

--->8---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..f3b985d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -126,6 +126,7 @@ config X86
 	select RTC_LIB
 	select HAVE_DEBUG_STACKOVERFLOW
 	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_64
+	select HAVE_IRQ_EXIT_ON_IRQ_STACK if X86_32
 	select HAVE_CC_STACKPROTECTOR

 config INSTRUCTION_DECODER
---8<---
