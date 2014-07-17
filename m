Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbaGQPFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:05:23 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46990 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932975AbaGQPFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:05:20 -0400
MIME-Version: 1.0
In-Reply-To: <1405547442-26641-12-git-send-email-keescook@chromium.org>
References: <1405547442-26641-1-git-send-email-keescook@chromium.org> <1405547442-26641-12-git-send-email-keescook@chromium.org>
From: David Drysdale <drysdale@google.com>
Date: Thu, 17 Jul 2014 16:04:56 +0100
Message-ID: <CAHse=S_32tmusk4ceY4U6GbNpX4PkX12iPPDZFVZ7qgv-RAooA@mail.gmail.com>
Subject: Re: [PATCH v11 11/11] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Linux API <linux-api@vger.kernel.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 10:50 PM, Kees Cook <keescook@chromium.org> wrote:
> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
> index 9065d2c79c56..2125b83ccfd4 100644
> +/**
> + * seccomp_can_sync_threads: checks if all threads can be synchronized
> + *
> + * Expects sighand and cred_guard_mutex locks to be held.
> + *
> + * Returns 0 on success, -ve on error, or the pid of a thread which was
> + * either not in the correct seccomp mode or it did not have an ancestral
> + * seccomp filter.
> + */
> +static inline pid_t seccomp_can_sync_threads(void)
> +{
> +       struct task_struct *thread, *caller;
> +
> +       BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
> +       BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +
> +       if (current->seccomp.mode != SECCOMP_MODE_FILTER)
> +               return -EACCES;

Quick question -- is it possible to apply the first filter and also synchronize
it across threads in the same operation?  If so, does this arm also need to
cope with seccomp.mode being SECCOMP_MODE_DISABLED?

[seccomp_set_mode_filter() looks to call this via seccomp_attach_filter()
before it does seccomp_assign_mode()]

> +
> +       /* Validate all threads being eligible for synchronization. */
> +       caller = current;
> +       for_each_thread(caller, thread) {
> +               pid_t failed;
> +
> +               if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
> +                   (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
> +                    is_ancestor(thread->seccomp.filter,
> +                                caller->seccomp.filter)))
> +                       continue;
> +
> +               /* Return the first thread that cannot be synchronized. */
> +               failed = task_pid_vnr(thread);
> +               /* If the pid cannot be resolved, then return -ESRCH */
> +               if (unlikely(WARN_ON(failed == 0)))
> +                       failed = -ESRCH;
> +               return failed;
> +       }
> +
> +       return 0;
> +}
