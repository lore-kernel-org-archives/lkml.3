Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932Ab3CTGEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 02:04:16 -0400
Received: from [222.92.8.138] ([222.92.8.138]:60153 "EHLO mail.lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755418Ab3CTGEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 02:04:14 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Mar 2013 02:04:14 EDT
MIME-Version: 1.0
In-Reply-To: <1363524614-3823-1-git-send-email-chenhc@lemote.com>
References: <1363524614-3823-1-git-send-email-chenhc@lemote.com>
From: Chen Jie <chenj@lemote.com>
Date: Wed, 20 Mar 2013 13:49:20 +0800
Message-ID: <CAGXxSxXscpbrFmmxJZZc9tcgdZ5fmrsAZNjLnSRYMApStYxiOg@mail.gmail.com>
Subject: Re: [PATCH V2 02/02] MIPS: Init new mmu_context for each possible CPU
 to avoid memory corruption
To: Huacai Chen <chenhc@lemote.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/17 Huacai Chen <chenhc@lemote.com>:
> Currently, init_new_context() only for each online CPU, this may cause
> memory corruption when CPU hotplug and fork() happens at the same time.
> To avoid this, we make init_new_context() cover each possible CPU.
>
> Scenario:
> 1, CPU#1 is being offline;
> 2, On CPU#0, do_fork() call dup_mm() and copy a mm_struct to the child;
> 3, On CPU#0, dup_mm() call init_new_context(), since CPU#1 is offline
>    and init_new_context() only covers the online CPUs, child has the
>    same asid as its parent on CPU#1 (however, child's asid should be 0);
> 4, CPU#1 is being online;
> 5, Now, if both parent and child run on CPU#1, memory corruption (e.g.
>    segfault, bus error, etc.) will occur.
Adds some further explanations about point 5:
5.1) The parent process runs on CPU#1, the version field of its
asid[CPU#1] and CPU#1's asid cache may match, thus the parent
process's asid[CPU#1] is used in TLB refilling routine.

5.2) Then the child process runs on CPU#1 which probably has the same
asid[CPU#1] as its parent(as pointed by point 3).

5.3) The child process may access address space of its parent.

It can also be solved by increasing version field of asid cache when
plugin a CPU,  may be a better way?



Regards,
-- Chen Jie
