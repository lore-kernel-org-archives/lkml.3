Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467AbaFXRax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:30:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbaFXRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:30:51 -0400
Date: Tue, 24 Jun 2014 19:27:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v7 7/9] seccomp: implement SECCOMP_FILTER_FLAG_TSYNC
Message-ID: <20140624172753.GA31435@redhat.com>
References: <1403560693-21809-1-git-send-email-keescook@chromium.org> <1403560693-21809-8-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403560693-21809-8-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Kees Cook wrote:
>
> +static pid_t seccomp_can_sync_threads(void)
> +{
> +	struct task_struct *thread, *caller;
> +
> +	BUG_ON(write_can_lock(&tasklist_lock));
> +	BUG_ON(!spin_is_locked(&current->sighand->siglock));
> +
> +	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
> +		return -EACCES;
> +
> +	/* Validate all threads being eligible for synchronization. */
> +	thread = caller = current;
> +	for_each_thread(caller, thread) {
> +		pid_t failed;
> +
> +		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
> +		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
> +		     is_ancestor(thread->seccomp.filter,
> +				 caller->seccomp.filter)))
> +			continue;
> +
> +		/* Return the first thread that cannot be synchronized. */
> +		failed = task_pid_vnr(thread);
> +		/* If the pid cannot be resolved, then return -ESRCH */
> +		if (failed == 0)
> +			failed = -ESRCH;

forgot to mention, task_pid_vnr() can't fail. sighand->siglock is held,
for_each_thread() can't see a thread which has passed unhash_process().

Oleg.

