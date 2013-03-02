Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab3CBEcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:32:32 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:35766 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3CBEcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:32:31 -0500
MIME-Version: 1.0
In-Reply-To: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 2 Mar 2013 12:32:30 +0800
Message-ID: <CANN689EqgPZVw=Sy_WAkB+=MJJCZeRMq_CmF1gec+cRVCS2xtA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Michel Lespinasse <walken@google.com>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Ingo Molnar <mingo@kernel.org>, Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 2, 2013 at 8:16 AM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> Through ipc_lock() and, therefore, ipc_lock_check() we currently
> return the locked ipc object. This is not necessary for all situations,
> thus introduce, analogous, ipc_obtain_object and ipc_obtain_object_check
> functions that only mark the RCU read critical region without acquiring
> the lock and return the ipc object.
>
> Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> ---
>  ipc/util.c | 42 ++++++++++++++++++++++++++++++++----------
>  ipc/util.h |  2 ++
>  2 files changed, 34 insertions(+), 10 deletions(-)
>
> diff --git a/ipc/util.c b/ipc/util.c
> index 464a8ab..902f282 100644
> --- a/ipc/util.c
> +++ b/ipc/util.c
> @@ -667,6 +667,21 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
>         out->seq        = in->seq;
>  }
>
> +struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)
> +{
> +       struct kern_ipc_perm *out;
> +       int lid = ipcid_to_idx(id);
> +
> +       rcu_read_lock();
> +       out = idr_find(&ids->ipcs_idr, lid);
> +       if (!out) {
> +               rcu_read_unlock();
> +               return ERR_PTR(-EINVAL);
> +       }
> +
> +       return out;
> +}

I think it may be nicer to take the rcu read lock at the call site
rather than in ipc_obtain_object(), to make the rcu read lock/unlock
sites pair up more nicely. Either that or make an inline
ipc_release_object function that pairs up with ipc_obtain_object() and
just does an rcu_read_unlock().

> +
>  /**
>   * ipc_lock - Lock an ipc structure without rw_mutex held
>   * @ids: IPC identifier set
> @@ -679,18 +694,13 @@ void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
>
>  struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
>  {
> -       struct kern_ipc_perm *out;
> -       int lid = ipcid_to_idx(id);
> +       struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
>
> -       rcu_read_lock();
> -       out = idr_find(&ids->ipcs_idr, lid);
> -       if (out == NULL) {
> -               rcu_read_unlock();
> +       if (!out)

I think this should be if (IS_ERR(out)) ?

Looks great otherwise.

Acked-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
