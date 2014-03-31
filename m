Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbaCaVyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:54:21 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:35724 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaCaVyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:54:20 -0400
MIME-Version: 1.0
In-Reply-To: <201403312105.s2VL5AqX010173@terminus.zytor.com>
References: <201403312105.s2VL5AqX010173@terminus.zytor.com>
Date: Mon, 31 Mar 2014 14:54:19 -0700
X-Google-Sender-Auth: E8mvJXzDkt-D3GJJZbXUguz4sZQ
Message-ID: <CA+55aFwccMZNgHA_xS_+cLNPqEjAt4qm2LYK_WLU0XbeDOoa=g@mail.gmail.com>
Subject: Re: [GIT PULL] x86 LTO changes for v3.15
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Anvin <hpa@zytor.com>, hubicka@ucw.cz,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 2:05 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> diff --git a/include/linux/linkage.h b/include/linux/linkage.h
> index a6a42dd..34a513a 100644
> --- a/include/linux/linkage.h
> +++ b/include/linux/linkage.h
> @@ -12,9 +12,9 @@
>  #endif
>
>  #ifdef __cplusplus
> -#define CPP_ASMLINKAGE extern "C"
> +#define CPP_ASMLINKAGE extern "C" __visible
>  #else
> -#define CPP_ASMLINKAGE
> +#define CPP_ASMLINKAGE __visible
>  #endif

This seems to result in new warnings, and they appear to be valid.

We have things like

  arch/x86/crypto/sha1_ssse3_glue.c:43:1: warning:
‘externally_visible’ attribute have effect only on public objects
[-Wattributes]
   static asmlinkage void (*sha1_transform_asm)(u32 *, const char *,
unsigned int);
   ^

and it seems to be because "asmlinkage" now means "visible", which is
utter BS. "asmlinkage" is about the calling convention, and visibility
is about something completely different.

So the compiler is actually correct in warning about insane code.
You're basically saying "static" + "visible", which makes no sense.
But "static" + "asmlinkage void (*)" makes sense, because it's about
the "void (*)" being a function with asmlinkage calling convention.

So I think that adding "visible" to asmlinkage is actively wrong and
misguided. And the compiler even told you so, but somebody then chose
to ignore the compiler telling them that they did stupid things.

Don't do crap like this.

                   Linus
