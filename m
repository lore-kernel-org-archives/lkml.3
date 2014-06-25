Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbaFYNxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:53:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbaFYNxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:53:06 -0400
Date: Wed, 25 Jun 2014 15:51:22 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        linux-api@vger.kernel.org, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linux-arch@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Message-ID: <20140625135121.GB7892@redhat.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org> <1403642893-23107-6-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403642893-23107-6-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Kees Cook wrote:
>
> +static inline void seccomp_assign_mode(struct task_struct *task,
> +				       unsigned long seccomp_mode)
> +{
> +	BUG_ON(!spin_is_locked(&task->sighand->siglock));
> +
> +	task->seccomp.mode = seccomp_mode;
> +	set_tsk_thread_flag(task, TIF_SECCOMP);
> +}

OK, but unless task == current this can race with secure_computing().
I think this needs smp_mb__before_atomic() and secure_computing() needs
rmb() after test_bit(TIF_SECCOMP).

Otherwise, can't __secure_computing() hit BUG() if it sees the old
mode == SECCOMP_MODE_DISABLED ?

Or seccomp_run_filters() can see ->filters == NULL and WARN(),
smp_load_acquire() only serializes that LOAD with the subsequent memory
operations.

Oleg.

