Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbaGDVxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 17:53:19 -0400
Received: from arrakis.dune.hu ([78.24.191.176]:50997 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939AbaGDVxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 17:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <1404493623-22705-1-git-send-email-emilgoode@gmail.com>
References: <1404493623-22705-1-git-send-email-emilgoode@gmail.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Fri, 4 Jul 2014 23:52:51 +0200
Message-ID: <CAOiHx==mR0eioTk=tc457z4ANbhFR2vS2A2y3wzw119jnCi2Pw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Fix incorrect NULL check in local_flush_tlb_page()
To: Emil Goode <emilgoode@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        John Crispin <blogic@openwrt.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 7:07 PM, Emil Goode <emilgoode@gmail.com> wrote:
> We check that the struct vm_area_struct pointer vma is NULL and
> then dereference it. The intent must have been to check that
> vma is not NULL before we dereference it in the next condition.

Actually if it is NULL, then it will short-cut and won't dereference
it (because !vma is true it can never become false again), so the
condition would be fine previously.

But, looking at the code a few lines into branch:

        if (!vma || cpu_context(cpu, vma->vm_mm) != 0) {
                unsigned long flags;
                int oldpid, newpid, idx;

#ifdef DEBUG_TLB
                printk("[tlbpage<%lu,0x%08lx>]", cpu_context(cpu,
vma->vm_mm), page);
#endif
                newpid = cpu_context(cpu, vma->vm_mm) & ASID_MASK;

it will be then dereferenced here, so the change is actually sensible,
even if the description isn't quite spot-on where it breaks.


Jonas
