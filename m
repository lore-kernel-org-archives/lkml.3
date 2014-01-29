Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaA2IZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:25:12 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52233 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA2IZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:25:10 -0500
Date: Wed, 29 Jan 2014 09:25:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Weinberger <richard@nod.at>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140129082505.GB31489@gmail.com>
References: <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
 <20140128201536.GB5178@pd.tnic>
 <CA+55aFwpsAatO7dy_jQM1NdM5VfJy33RaQ0tJzx+KN_oJsHcBQ@mail.gmail.com>
 <52E812F4.50906@nod.at>
 <52E8153A.2000208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E8153A.2000208@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/28/2014 12:28 PM, Richard Weinberger wrote:
> > Am 28.01.2014 21:25, schrieb Linus Torvalds:
> >> On Tue, Jan 28, 2014 at 12:15 PM, Borislav Petkov <bp@alien8.de> wrote:
> >>>
> >>> Shouldn't we hold that down in the Kconfig help text of DEBUG_INFO?
> >>> Something like:
> >>>
> >>> "You don't need to enable this if you want symbolic names for kernel
> >>> objects. Enable CONFIG_KALLSYMS instead."
> >>
> >> Probably. And then we should make sure that allyesconfig/allmodconfig
> >> don't pick it.
> > 
> > Let's make it depend on CONFIG_EXPERT.
> > 
> 
> That doesn't solve all*config.  My scripts for all*config just 
> overrides it, maybe we need to do something like that by default?

For features we want to exclude from allyesconfig we can define them 
as logical negatives. (I've used this technique in the past to hide 
silly options from allyesconfig and it works well.)

So to reign in debuginfo in allyesconfig/allmodconfig builds we could 
do something like:

 config SAVE_TIME_AND_DISK_SPACE
	bool "Faster and leaner kernel build: compile without debug info"
	default y

 choice
        prompt "Choose DEBUGINFO bloat level"
	depends on !SAVE_TIME_AND_DISK_SPACE
        default DEBUG_INFO_REDUCED
        help
           This option allows to select the debuginfo model.

   config DEBUG_INFO_REDUCED
        bool "Reduced amount of debugging information"

   config DEBUG_INFO
        bool "Full DEBUG info, 'planet killer' version"

 endchoice

(or so, perhaps with slightly more PC text.)

That would default to Y and would disable debuginfo by default.

( And yeah, it's a bit ugly, but it beats having to hack the kconfig 
  language! )

Thanks,

	Ingo
