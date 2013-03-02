Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3CBVYP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 16:24:15 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:58441 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab3CBVYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 16:24:14 -0500
MIME-Version: 1.0
In-Reply-To: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
References: <1362183400.3420.24.camel@buesod1.americas.hpqcorp.net>
Date: Sat, 2 Mar 2013 13:24:13 -0800
X-Google-Sender-Auth: -2aEpBgn_HAy8Cu7K2c-nhszU3I
Message-ID: <CA+55aFzxJo3y7r_5BvUVwZX4LyC6dba8qPTbp+iDf_nRgYg4cw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ipc: introduce obtaining a lockless ipc object
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Emmanuel Benisty <benisty.e@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, "Vinod, Chegu" <chegu_vinod@hp.com>,
        "Low, Jason" <jason.low2@hp.com>, linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 4:16 PM, Davidlohr Bueso <davidlohr.bueso@hp.com> wrote:
> @@ -784,7 +806,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
>         int err;
>
>         down_write(&ids->rw_mutex);
> -       ipcp = ipc_lock_check(ids, id);
> +       ipcp = ipc_obtain_object_check(ids, id);
>         if (IS_ERR(ipcp)) {
>                 err = PTR_ERR(ipcp);
>                 goto out_up;
> @@ -801,7 +823,7 @@ struct kern_ipc_perm *ipcctl_pre_down(struct ipc_namespace *ns,
>                 return ipcp;
>
>         err = -EPERM;
> -       ipc_unlock(ipcp);
> +       rcu_read_unlock();
>  out_up:
>         up_write(&ids->rw_mutex);
>         return ERR_PTR(err);

Uhhuh. This is very buggy, and I think it's the reason for the later
bugs that Emmanuel reported.

In particular, the *non-error* case is buggy, where it in the middle
of the function does

    return ipcp;

for a successful lookup.

It used to return a locked ipcp, now it no longer does. And you didn't
change any of the callers, which still do the "ipc_unlock()" at the
end.  So all the locking gets completely confused.

Oops.

                 Linus
