Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbbATWqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:46:51 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49447 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbbATWqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:46:49 -0500
MIME-Version: 1.0
In-Reply-To: <20150119185151.GC16427@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com>
 <20150115191918.GA27332@redhat.com> <20150119185109.GA16427@redhat.com> <20150119185151.GC16427@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 14:46:28 -0800
Message-ID: <CALCETrXnm9nHA5SUETp9QtTXgLO4ECFc-YrkOcHXQT=W94m+Zw@mail.gmail.com>
Subject: Re: [PATCH 2/3] x86, fpu: always allow FPU in interrupt if use_eager_fpu()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 10:51 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> The __thread_has_fpu() check in interrupted_kernel_fpu_idle() was needed
> to prevent the nested kernel_fpu_begin(). Now that we have in_kernel_fpu
> and !__thread_has_fpu() case in __kernel_fpu_begin() does not depend on
> use_eager_fpu() (except clts) we can remove it.
>
> __thread_has_fpu() can be false even if use_eager_fpu(), but this case
> does not differ from !use_eager_fpu() case except we should not worry
> about X86_CR0_TS, __kernel_fpu_begin/end will not touch this bit.
>
> Note: I think we can kill all irq_fpu_usable() checks except in_kernel_fpu,
> just we need to record the state of X86_CR0_TS in __kernel_fpu_begin() and
> conditionalize stts() in __kernel_fpu_end(), but this needs another patch.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/i387.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 26f0e80..4734865 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -41,8 +41,8 @@ void kernel_fpu_enable(void)
>   * be set (so that the clts/stts pair does nothing that is
>   * visible in the interrupted kernel thread).
>   *
> - * Except for the eagerfpu case when we return 1 unless we've already
> - * been eager and saved the state in kernel_fpu_begin().
> + * Except for the eagerfpu case when we return true; in the likely case
> + * the thread has FPU but we are not going to set/clear TS.
>   */
>  static inline bool interrupted_kernel_fpu_idle(void)
>  {
> @@ -50,7 +50,7 @@ static inline bool interrupted_kernel_fpu_idle(void)
>                 return false;
>
>         if (use_eager_fpu())
> -               return __thread_has_fpu(current);
> +               return true;
>
>         return !__thread_has_fpu(current) &&
>                 (read_cr0() & X86_CR0_TS);
> --
> 1.5.5.1
>
>

Looks good to me.

--Andy
