Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbaA1UtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:49:19 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39872 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaA1UtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:49:17 -0500
Date: Tue, 28 Jan 2014 21:49:06 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128204906.GK815@pd.tnic>
References: <52E7D2E5.8090208@linux.intel.com>
 <52E7D9FF.1080506@nod.at>
 <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
 <20140128201536.GB5178@pd.tnic>
 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 12:25:15PM -0800, Linus Torvalds wrote:
> Probably. And then we should make sure that allyesconfig/allmodconfig
> don't pick it.

I'd need to think about that a bit longer as scripts/kconfig/conf.c goes
and sets those. Unless someone has a better idea...

> There *are* reasonable uses for DEBUG_INFO:
> 
>  - if you very actively and extensively use kgdb, DEBUG_INFO is very useful.

Right, and at least KGDB depends on it. I was going to suggest to hide
it and make only tools select it but...

>  - distros might want to build distro kernels with DEBUG_INFO for the
> kernel debug package

Yes. SUSE uses crash to analyze dumps and for that it needs -g symbols
and other distros I'm sure too in some fashion.

> but for most kernel developers, DEBUG_INFO really just bloats things
> and makes the build much *much* slower, for very little gain.

Right, your discussion kinda made me aware of this - I hadn't realized
that KALLSYMS is enough.

> Sure, you get line numbers, but let's face it, it's not that hard
> to just do "x/20i <address>" and trying to match it up with the
> generated code instead. And since "just match it up" model works with
> user-reported oopses of random kernels, you had better be able and
> willing to do that *anyway*.

Hohumm.

> If most of the oopses you decode are on your own machine with your own
> kernel, you might want to try to learn to be more careful when writing
> code. And I'm not even kidding.

Haha.

Ok, here's the help text hunk:

---
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index dbf94a7d25a8..73b36a1624ec 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -126,7 +126,11 @@ config DEBUG_INFO
 	  This adds debug symbols to the kernel and modules (gcc -g), and
 	  is needed if you intend to use kernel crashdump or binary object
 	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
-	  Say Y here only if you plan to debug the kernel.
+
+	  If you only want to have symbols in kernel traces and are not
+	  going to need support for those tools above, you don't need
+	  to enable this as it is a huge bloat and build slowdown.
+	  Enable CONFIG_KALLSYMS instead.
 
 	  If unsure, say N.
 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
