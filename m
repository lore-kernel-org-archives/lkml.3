Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbaIVSez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:34:55 -0400
Received: from forward16.mail.yandex.net ([95.108.253.141]:40080 "EHLO
	forward16.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaIVSex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:34:53 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Kirill Tkhai <ktkhai@parallels.com>
In-Reply-To: <20140922183228.10761.72219.stgit@localhost>
References: <20140922183202.10761.6682.stgit@localhost> <20140922183228.10761.72219.stgit@localhost>
Subject: Re: [PATCH v2 5/6] sched: Use rq->rd in sched_setaffinity() under RCU read lock
MIME-Version: 1.0
Message-Id: <1125761411410889@web23g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 22 Sep 2014 22:34:49 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.09.2014, 22:32, "Kirill Tkhai" <tkhai@yandex.ru>:
> From: Kirill Tkhai <ktkhai@parallels.com>
>
> task_rq(p)->rd and task_rq(p)->rd->span may be used-after-free here.
> Probability of NULL pointer derefference isn't zero in this place.

Wrong comment, sorry. I'll resend

>
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> Cc: <stable@vger.kernel.org> # v3.14+
> ---
> škernel/sched/core.c | ššš9 +++++----
> š1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3b07710..643ee99 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4023,13 +4023,14 @@ long sched_setaffinity(pid_t pid, const struct cpumask *in_mask)
> šššššššššš* root_domain.
> šššššššššš*/
> š#ifdef CONFIG_SMP
> - if (task_has_dl_policy(p)) {
> - const struct cpumask *span = task_rq(p)->rd->span;
> -
> - if (dl_bandwidth_enabled() && !cpumask_subset(span, new_mask)) {
> + if (task_has_dl_policy(p) && dl_bandwidth_enabled()) {
> + rcu_read_lock();
> + if (!cpumask_subset(task_rq(p)->rd->span, new_mask)) {
> šššššššššššššššššššššššššretval = -EBUSY;
> + rcu_read_unlock();
> šššššššššššššššššššššššššgoto out_free_new_mask;
> ššššššššššššššššš}
> + rcu_read_unlock();
> ššššššššš}
> š#endif
> šagain:
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/
