Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaATRFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 12:05:19 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:62798 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaATRFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 12:05:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140117100723.GB16003@mudshark.cambridge.arm.com>
References: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
	<20140116115634.GE30257@mudshark.cambridge.arm.com>
	<CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
	<20140116125727.GI30257@mudshark.cambridge.arm.com>
	<CAFrcx1npWFs3=rooqiGKSv-p7ivcG1J7SCvcmsz-hd3waXBfdA@mail.gmail.com>
	<CAFrcx1=QWPFeuNDc0JatiykGnRuvPyOgwwCxnW7pSAiNa9RsxA@mail.gmail.com>
	<20140117100723.GB16003@mudshark.cambridge.arm.com>
Date: Mon, 20 Jan 2014 18:05:14 +0100
Message-ID: <CAFrcx1=53sUDjxa-DjuJUScxanhQJqAVA36RaYNo5-Dfegij7g@mail.gmail.com>
Subject: Re: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Steve Capper <steve.capper@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

Here is an updated version of the change, which uses compat_sp at only
one place.
The drawback is that compat_user_mode is checked when calling
compat_user_stack_pointer, which seems unnecessary. Unfortunately the
check is not optimized out by the complier as I could check with
objdump -S.

What do you think?

diff --git a/arch/arm64/include/asm/compat.h b/arch/arm64/include/asm/compat.h
index fda2704..e71f81f 100644
--- a/arch/arm64/include/asm/compat.h
+++ b/arch/arm64/include/asm/compat.h
@@ -228,7 +228,7 @@ static inline compat_uptr_t ptr_to_compat(void __user *uptr)
        return (u32)(unsigned long)uptr;
 }

-#define compat_user_stack_pointer() (current_pt_regs()->compat_sp)
+#define compat_user_stack_pointer() (user_stack_pointer(current_pt_regs()))

 static inline void __user *arch_compat_alloc_user_space(long len)
 {
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index fbb0020..86d5b54 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -133,7 +133,7 @@ struct pt_regs {
        (!((regs)->pstate & PSR_F_BIT))

 #define user_stack_pointer(regs) \
-       ((regs)->sp)
+       (!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)

 /*
  * Are the current registers suitable for user mode? (used to maintain



Regards,
Jean

On 17 January 2014 11:07, Will Deacon <will.deacon@arm.com> wrote:
> On Fri, Jan 17, 2014 at 09:00:09AM +0000, Jean Pihet wrote:
>> On 16 January 2014 14:47, Jean Pihet <jean.pihet@linaro.org> wrote:
>> >> So the simplest thing would be to make compat_user_stack_pointer expand to
>> >> user_stack_pointer(current_pt_regs()) on arm64 and merge that in with your
>> >> original patch fixing user_stack_pointer.
>>
>> I see 2 issues in your proposal:
>>
>> 1) user_stack_pointer(regs) calls compat_user_stack_pointer if
>> compat_user_mode(regs)) and compat_user_stack_pointer expands to
>> user_stack_pointer. I see a circular dependency in the macros.
>
> Not today it doesn't, so you just need to avoid writing the circular
> dependency and instead make user_stack_pointer access (regs)->compat_sp
> instead.
>
>> 2) current_pt_regs() returns the current task regs although perf
>> passes a regs struct that had been recorded previously.
>
> Yes, but compat_user_stack_pointer doesn't take a regs paramater anyway, so
> there's no change in behaviour here.
>
> Will
