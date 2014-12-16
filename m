Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLPSAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:00:55 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:36885 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaLPSAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:00:54 -0500
From: bsegall@google.com
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH] sched/fair: Make cfs_rq::decay_counter non-atomic
References: <1418739933.6074.15.camel@tkhai>
Date: Tue, 16 Dec 2014 10:00:46 -0800
In-Reply-To: <1418739933.6074.15.camel@tkhai> (Kirill Tkhai's message of "Tue,
	16 Dec 2014 17:25:33 +0300")
Message-ID: <xm26iohb79v5.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kirill Tkhai <ktkhai@parallels.com> writes:

> We update decay_counter in update_cfs_rq_blocked_load()
> only. This function is always called with rq lock locked,
> so we can kill atomic actions.
>
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/fair.c  |   11 ++++++-----
>  kernel/sched/sched.h |    2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5f3b5a7..af990c4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2570,7 +2570,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>  static inline u64 __synchronize_entity_decay(struct sched_entity *se)
>  {
>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> -	u64 decays = atomic64_read(&cfs_rq->decay_counter);
> +	u64 decays = ACCESS_ONCE(cfs_rq->decay_counter);

This is called without rq lock held from migrate_task_rq_fair. (We could
technically change the atomic_add to atomic64_set(atomic64_read() + x),
but I don't know that that is a win) Now, we could do a
min_vruntime-style two-copy thing if this atomic usage is a hot spot on
32-bit, we just didn't bother initially.
