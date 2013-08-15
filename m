Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3HOBzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:55:23 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:38767 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580Ab3HOBzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <1375790802-11857-1-git-send-email-xtfeng@gmail.com>
References: <87d2prqvse.fsf@rustcorp.com.au>
	<1375790802-11857-1-git-send-email-xtfeng@gmail.com>
Date: Thu, 15 Aug 2013 09:55:21 +0800
Message-ID: <CAJn8CcFmVdPLSnfOPROa60SS2iHyj8QAyDb7NJw9Jnv8SuKNtw@mail.gmail.com>
Subject: Re: [PATCH] cpumask: fix cpumask leak in partition_sched_domains
From: Xiaotian Feng <xtfeng@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Xiaotian Feng <xtfeng@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 8:06 PM, Xiaotian Feng <xtfeng@gmail.com> wrote:
> If doms_new is NULL, partition_sched_domains() will reset ndoms_cur
> to 0, and free old sched domains with free_sched_domains(doms_cur, ndoms_cur).
> As ndoms_cur is 0, the cpumask will not be freed.
>
> Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org

Any comments on this patch? Without this patch, I can see following
with kmemleak.

unreferenced object 0xffff880118d26aa8 (size 512):
  comm "swapper/0", pid 1, jiffies 4294892366 (age 287.736s)
  hex dump (first 32 bytes):
    0f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff817350e6>] kmemleak_alloc+0x26/0x50
    [<ffffffff811b92c6>] kmem_cache_alloc_node_trace+0x116/0x2d0
    [<ffffffff8139e66f>] alloc_cpumask_var_node+0x1f/0x90
    [<ffffffff8139e6ee>] alloc_cpumask_var+0xe/0x10
    [<ffffffff810a328c>] alloc_sched_domains+0x5c/0x80
    [<ffffffff81daf8c6>] sched_init_smp+0x365/0x47d
    [<ffffffff81d8f01e>] kernel_init_freeable+0xe3/0x1ef
    [<ffffffff81731b1e>] kernel_init+0xe/0xf0
    [<ffffffff817543ac>] ret_from_fork+0x7c/0xb0
    [<ffffffffffffffff>] 0xffffffffffffffff

> ---
>  kernel/sched/core.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b7c32cb..3d6c57b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6184,8 +6184,9 @@ match1:
>                 ;
>         }
>
> +       n = ndoms_cur;
>         if (doms_new == NULL) {
> -               ndoms_cur = 0;
> +               n = 0;
>                 doms_new = &fallback_doms;
>                 cpumask_andnot(doms_new[0], cpu_active_mask, cpu_isolated_map);
>                 WARN_ON_ONCE(dattr_new);
> @@ -6193,7 +6194,7 @@ match1:
>
>         /* Build new domains */
>         for (i = 0; i < ndoms_new; i++) {
> -               for (j = 0; j < ndoms_cur && !new_topology; j++) {
> +               for (j = 0; j < n && !new_topology; j++) {
>                         if (cpumask_equal(doms_new[i], doms_cur[j])
>                             && dattrs_equal(dattr_new, i, dattr_cur, j))
>                                 goto match2;
> --
> 1.7.9.6 (Apple Git-31.1)
>
