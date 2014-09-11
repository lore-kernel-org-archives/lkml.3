Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaIKQQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:16:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55230 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751552AbaIKQQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:16:41 -0400
Date: Thu, 11 Sep 2014 17:16:36 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 3/8] arm: fixmap: implement __set_fixmap()
Message-ID: <20140911161636.GU6158@arm.com>
References: <CAGXu5jKimGaupwyUwt0Zwa3OtjeoED8-uBeMX0MwXjBYP6ssAg@mail.gmail.com>
 <20140904172748.GO7156@arm.com>
 <20140908191634.GV5598@outflux.net>
 <20140908215506.GA4759@dator>
 <CAGXu5jJFB+pcDVkcMoRZ9DnJu7MQuN=kceDhpkGrO=6ZLFy6Kw@mail.gmail.com>
 <20140909123829.GK1754@arm.com>
 <CAGXu5jJoW-B7WwuFUhbN4e1aL-HVxa9x4da9hB9DcCGEXVLgzw@mail.gmail.com>
 <20140910175126.GJ1710@arm.com>
 <CAGXu5jJaML_S+6LUn1uPLrScXxUJL+1N1B+Fa08ioxKt933nCw@mail.gmail.com>
 <CAGXu5jJ_wLsKOuVgbS7cb+k-nyA=8XpaMYwov0o3hdFdyjaCmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ_wLsKOuVgbS7cb+k-nyA=8XpaMYwov0o3hdFdyjaCmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 05:05:14PM +0100, Kees Cook wrote:
> Actually, this doesn't make sense. If we're using
> local_flush_tlb_kernel_range() in set_fixmap, we must always run under
> stop_machine. The needs-broadcast case is solved by using
> local_flush_tlb_kernel_range(), and the TLB-miss-on-other-CPU case is
> solved by using stop_machine(). This is how the ftrace case work,
> though not via fixmap.
> 
> Since we need to flush the TLB on each fixmap change during
> patch_text(), if we want to make the local_flush_tlb_... optionally
> use flush_tlb_... to avoid calling stop_machine in the
> does't-need-broadcast case, then we'd be checking in multiple places,
> making this code overly complex for this rare operation. Is there a
> good reason to complicate this code to avoid stop_machine()?
> 
> I think we should just do this:
> 
> diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
> index 07314af47733..5038960e3c55 100644
> --- a/arch/arm/kernel/patch.c
> +++ b/arch/arm/kernel/patch.c
> @@ -60,16 +125,5 @@ void __kprobes patch_text(void *addr, unsigned int insn)
>                 .insn = insn,
>         };
> 
> -       if (cache_ops_need_broadcast()) {
> -               stop_machine(patch_text_stop_machine, &patch, cpu_online_mask);
> -       } else {
> -               bool straddles_word = IS_ENABLED(CONFIG_THUMB2_KERNEL)
> -                                     && __opcode_is_thumb32(insn)
> -                                     && ((uintptr_t)addr & 2);
> -
> -               if (straddles_word)
> -                       stop_machine(patch_text_stop_machine, &patch, NULL);
> -               else
> -                       __patch_text(addr, insn);
> -       }
> +       stop_machine(patch_text_stop_machine, &patch, NULL);

The reason not to use stop machine is that it's very expensive and the
architecture does provide some guarantees that mean it's not always
required...

... however, as I pointed out in a kprobes thread the other day, the code
you remove above is actually broken, so I wouldn't be against replacing it
all with stop_machine.

Is there any way to you can WARN_ON(!called_under_stop_machine) in
set_fixmap before doing the local TLBI?

Will

P.S. If you plan on doing an equivalent series for arm64, you should do it
before we have any broken CPUs, then you can use TLBI without worry ;)
