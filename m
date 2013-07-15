Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3GOWQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 18:16:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3GOWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 18:16:13 -0400
Date: Mon, 15 Jul 2013 15:16:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chen Gang <gang.chen@asianux.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH, re-send] Always trap on BUG()
Message-Id: <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org>
In-Reply-To: <201307051738.35930.arnd@arndb.de>
References: <201307051738.35930.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013 17:38:35 +0200 Arnd Bergmann <arnd@arndb.de> wrote:

> I've run some size analyis using the ARM 'multi_v7_defconfig'
> and gcc-4.8, using various definitions for BUG() and BUG_ON(), to
> see how big the size improvement actually gets
> 
> 1. Baseline: normal bug plus CONFIG_BUG_VERBOSE
>    text    data     bss     dec     hex filename
> 3743196  224396  206812 4174404  3fb244 vmlinux-bugverbose
> 
> 2. disabling CONFIG_BUG_VERBOSE, saving 0.6%
> 3716920  224380  206812 4148112  3f4b90 vmlinux-nobugverbose
> 
> 3. #define BUG() panic(__func__), #define BUG_ON(c) if(c) BUG(), saving 1.0%
> 3701076  224384  206812 4132272  3f0db0 vmlinux-bug-panicfunc
> 
> 3. #define BUG() panic(__func__), #define BUG_ON(c) if(c) BUG(), saving 1.5%
> 3678884  224400  206812 4110096  3eb710 vmlinux-bug-panic
> 
> 4. #define BUG() unreachable(), saving 2.1%
> 3652636  224384  206812 4083832  3e5078 vmlinux-bug-unreachable
> 
> 5. as 4, plus #define BUG_ON(c) if(c) unreachable(), saving 2.2%
> 3651108  224380  206812 4082300  3e4a7c vmlinux-bugon-unreachable
> 
> 6. #define BUG() do{}while(0), saving 2.1%
> 3654264  224380  206812 4085456  3e56d0 vmlinux-nobug
> 
> 7. as 6, plus #define BUG_ON if(0 && (c)) unreachable, saving 2.2%
> 3648392  223996  206748 4079136  3e3e20 vmlinux-no-bugon
> 
> 8. my patch below, saving 1.8%
> 3666532  224380  206812 4097724  3e86bc obj-tmp/vmlinux
> 
> The gain of doing unreachable and letting the code run off whereever
> is minimal compared to the current state of doing nothing, but it
> avoids the warnings.
> 
> Same test using x86_defconfig:
> 
> 1. CONFIG_BUG=y, CONFIG_BUGVERBOSE=n
> 10797859        1395648 1175552 13369059         cbfee3 vmlinux-x86-bug
> 
> 2. CONFIG_BUG=n, saves 1.0%
> 10658553        1395584 1175552 13229689         c9de79 vmlinux-x86-nobug
> 
> 3. with my patch, saves 0.8%
> 10684186        1395584 1175552 13255322         ca429a vmlinux-x86-archbug
> 
> Getting 1-2% savings in kernel size seems absolutely worth keeping the
> option, but 0.2-0.4% left for getting reproducible behavior also seems
> worthwhile. The result in the patch below.
> 
> This basically loses any of the BUG() reporting, but leaves the
> logic to trap and kill the task in place when CONFIG_BUG is disabled.

um, nice changelog, but it didn't tell us what the patch actually does.

AFACIT it arranges for the kernel to execute the trap instruction even
when CONFIG_BUG=n?  Can't be bothered fully working it out, really.

It also makes mystery changes to WARN_ON() and WARN().  What are those?

Also, you say "it avoids the warnings".  To what warnings do you refer?
The ones which are already emitted by CONFIG_BUG=n, or new ones which
would have been added had this patch been implemented differently?

Finally, code-size decreases are nice, but what are the runtime effects
of this patch?

I've been thinking for a while that CONFIG_BUG=n is a pretty dumb thing
to do, and that maintaining it (and trying to fix the warnings it
produces) aren't worth the effort and that we should remove the whole
thing.  Perhaps your patch changes that calculus, dunno.  Please discuss.

