Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaKFUia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 15:38:30 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:58973 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaKFUi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 15:38:28 -0500
MIME-Version: 1.0
Date: Thu, 6 Nov 2014 21:38:26 +0100
X-Google-Sender-Auth: iWB9ilabhLJoCfQbY1xI4EsGfnw
Message-ID: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
Subject: (bisected) Lock up on sh73a0/kzm9g on cpuidle initialization
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_CPU_IDLE=y, the kernel locks up during cpuidle initialization
on Renesas sh73a0/kzm9g-reference, which has a dual-core Cortex-A9.

Last message is:

    DMA: preallocated 256 KiB pool for atomic coherent allocations

After this it's supposed to print:

    cpuidle: using governor ladder
    cpuidle: using governor menu

I've bisected this to commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
("sched: Let the scheduler see CPU idle states").

Reverting that commit, and commit 83a0a96a5f26d974580fd7251043ff70c8f1823d
("sched/fair: Leverage the idle state info when choosing the "idlest"
cpu") which
depends on it, fixes the problem.

I saw the discussion "lockdep splat in CPU hotplug", so I enabled lockdep
debugging, but didn't see a lockdep splat.

I'm using CONFIG_TREE_RCU=y, as this is SMP without PREEMPT.

Anyone with a clue?

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
