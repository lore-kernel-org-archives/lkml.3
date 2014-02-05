Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaBEQSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 11:18:24 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38472 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbaBEQSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 11:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <20140205055137.GB30094@gmail.com>
References: <1391452183-2160-1-git-send-email-bp@alien8.de>
 <alpine.DEB.2.02.1402031358390.9768@chino.kir.corp.google.com>
 <CA+55aFzwB0-fcqa_RaNDE1jjS+awM=j3BGroA5C3wRnK_G7UHg@mail.gmail.com>
 <20140203145718.5bc9ba1619aff8ea0754b0ab@linux-foundation.org>
 <alpine.DEB.2.02.1402031532480.7643@chino.kir.corp.google.com>
 <20140204090809.GA19156@gmail.com> <CA+55aFzXvPseHVZOk82hTpFrQYRnHnq-5TBz5Jw__wuktUgi2w@mail.gmail.com>
 <87fvny238i.fsf@tassilo.jf.intel.com> <CA+55aFzDp70dv=eCwuOr=gAPVBKaDVUyvFbqedrRJXhUDeHnfQ@mail.gmail.com>
 <20140205055137.GB30094@gmail.com>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Wed, 5 Feb 2014 11:17:48 -0500
X-Google-Sender-Auth: S3OLroy6ArHBuj4qqdnacvT6124
Message-ID: <CAP=VYLrqOMw2ZYoeWnNK6r80_FmmCmdne1yA=VTaU1Q8phzaVg@mail.gmail.com>
Subject: Re: [PATCH] x86: Disable CONFIG_X86_DECODER_SELFTEST in allmod/allyesconfigs
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Richard Weinberger <richard@nod.at>,
        Borislav Petkov <bp@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 5, 2014 at 12:51 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>> > BTW you probably also want to do the same for the x86 instruction
>> > decoder test. It seems to be the biggest compile time waster in
>> > allyesconfig and I usually disable it too.
>>
>> Agreed, that should be disabled too by default. Although in that
>> case I think the COMPILE_TEST combination makes more sense, since
>> it's a coverage issue.
>
> I'd say randconfig will cover it often enough, and the failure is also
> borderline build coverage related: you cannot really make the decoder
> test fail via source level changes, only with changes in the build
> environment, so I agree with Andi that we can disable this one too -
> via the patch below.

For the record, even with a (currently) modern CPU such as a
Xeon E5-2630 @ 2.30GHz, the script takes 4m30s on 3.14-rc1
i386 allyesconfig.  And since it runs single threaded at the end
of the build, it really adds that amount to the wall time spent
on the build. So enthusiastically Acked, FWIW.

Paul.
--

>
> Thanks,
>
>         Ingo
>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 0f3621e..f0fca39 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -184,6 +184,11 @@ config HAVE_MMIOTRACE_SUPPORT
>  config X86_DECODER_SELFTEST
>         bool "x86 instruction decoder selftest"
>         depends on DEBUG_KERNEL && KPROBES
> +       #
> +       # It can take some time to validate the image,
> +       # make sure {allyes|allmod}config doesn't enable it:
> +       #
> +       depends on !COMPILE_TEST
>         ---help---
>          Perform x86 instruction decoder selftests at build time.
>          This option is useful for checking the sanity of x86 instruction
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
