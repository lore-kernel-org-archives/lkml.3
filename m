Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbbASSwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 13:52:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbbASSwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 13:52:33 -0500
Date: Mon, 19 Jan 2015 19:51:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: [PATCH 0/3] x86, fpu: more eagerfpu cleanups
Message-ID: <20150119185109.GA16427@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115191918.GA27332@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15, Oleg Nesterov wrote:
>
> Let me send initial kernel_fpu_begin/end cleanups, I believe they make
> sense anyway and won't conflict with your changes.
>
> This is actually resend, I sent more patches some time ago but they were
> ignored.
>
> Note that (I hope) we can do more changes on top of this series, in
> particular:
>
> 	- remove all checks from irq_fpu_usable() except in_kernel_fpu
>
> 	- do not abuse FPU in kernel threads, this makes sense even if
> 	  use_eager_fpu(), and with or without the changes you proposed.

On top of this series.

Initially I was going to make more changes, but then I decided to delay
the cleanups. IMHO this code needs them in any case. math_state_restore()
and its usage doesn't look nice. init_fpu() too, and unlazy_fpu(current)
is simply wrong afaics. Fortunately the only caller of init_fpu(current)
is coredump, so this task can't return to user-mode, still this doesn't
look good. And it should be unified with save_init_fpu(). Which has the
wrong WARN_ON_ONCE(!__thread_has_fpu(tsk)).

And I am not sure that unlazy_fpu() is correct wrt __kernel_fpu_begin(),
but probably this is because I do not know how fpu works. If the nested
__save_init_fpu() is fine, then why (before the previous changes)
__kernel_fpu_begin() does __thread_clear_has_fpu() first?

Rik, to remind, I think that your changes need 1 + 2 at least, to avoid
the performance regression. Perhaps this needs a single patch.

3/3 is not strictly neccessary, but imo it makes sense anyway, even
without your changes. And if we add TIF_LOAD_FPU, it would be nice to
filter out kthreads automatically.


Could someone review this series?

If this makes any sense, I'll try to make the cleanups later.

Oleg.

