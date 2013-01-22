Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab3AVJSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:18:04 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52632 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3AVJR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:17:59 -0500
X-Nat-Received: from [202.181.97.72]:63924 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1358846259.4293
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [3.8-rc4 arm] SCSI_SYM53C8XX_2 module cannot register IRQ
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201301202124.BFJ81722.SFOHtJFOLQFVOM@I-love.SAKURA.ne.jp>
	<CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
In-Reply-To: <CACRpkdY1sJPkPJx8zFbYOsvHFUM4S_6_eLWjifBpNyqH7cCrDA@mail.gmail.com>
Message-Id: <201301221817.IDD95831.HVOOFMFJOLFSQt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 22 Jan 2013 18:17:33 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 22012013 #9160241, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> > While (1) was fixed by now, I can't bisect (2) since (1) is preventing (2) from
> > printing messages.
> 
> I usually bisect like this:
> 
> 1.  Get hold of the patch fixing the boot regression:
>     git format-patch
> f5565295892eb93c3191aa241405fe8b685542d6^..f5565295892eb93c3191aa241405fe8b685542d6

Thanks, but sorry, I couldn't understand how this command line works.

Which one ("blank console bug" or "IRQ registration failure bug") does
"the boot regression" refer?

Your command line generated only one patch but you say "iterate".

  $ git format-patch f5565295^..f5565295
  0001-ARM-7610-1-versatile-bump-IRQ-numbers.patch

If I use 5c49985c^..5c49985c (the patch which the blank console bug was fixed),
it generated 8 patches.

  $ git format-patch 5c49985c^..5c49985c
  0001-ARM-7608-1-l2x0-Only-set-.set_debug-on-PL310-r3p0-an.patch
  0002-ARM-7609-1-disable-errata-work-arounds-which-access-.patch
  0003-ARM-7610-1-versatile-bump-IRQ-numbers.patch
  0004-ARM-7611-1-VIC-fix-bug-in-VIC-irqdomain-code.patch
  0005-ARM-7612-1-imx-Do-not-select-some-errata-that-depend.patch
  0006-ARM-7614-1-mm-fix-wrong-branch-from-Cortex-A9-to-PJ4.patch
  0007-ARM-7615-1-cache-l2x0-aurora-Invalidate-during-clean.patch
  0008-ARM-7616-1-cache-l2x0-aurora-Use-writel_relaxed-inst.patch
  $ grep -il irq 000*
  0003-ARM-7610-1-versatile-bump-IRQ-numbers.patch
  0004-ARM-7611-1-VIC-fix-bug-in-VIC-irqdomain-code.patch
  0008-ARM-7616-1-cache-l2x0-aurora-Use-writel_relaxed-inst.patch

Since the IRQ registration failure bug message contains IRQ number "27",
I suspect f5565295 "ARM: 7610/1: versatile: bump IRQ numbers"

  The Versatile starts to register Linux IRQ numbers from offset 0
  which is illegal, since this is NO_IRQ. Bump all hard-coded IRQs
  by 32 to get rid of the problem.

and 5ced33bc06 "ARM: 7611/1: VIC: fix bug in VIC irqdomain code"

  The VIC irqdomain code added in commit
  07c9249f1fa90cc8189bed44c0bcece664596a72
  "ARM: 7554/1: VIC: use irq_domain_add_simple()"

  Had two bugs:

  1) It didn't call irq_create_mapping() once on each
     valid irq source in the slowpath when registering
     the controller.

  2) It passed a -1 as IRQ offset for the DT case, whereas
     0 should be passed as invalid IRQ instead.

but how can I test them?

> 
> 2. At each iterative step using git bisect:
>    patch -p1 < 0001-ARM-7610-1-versatile-bump-IRQ-numbers.patch
> 
> 3. Boot/trial-and-horror
> 
> 4. git reset --hard HEAD
>    To nullify the effects of the patch.
> 
> 5. git bisect [good|bad]
> 
Excuse me, what range do I need to pass to "git bisect start" command line?

> 6. Iterate from (2) until you find the bug.
