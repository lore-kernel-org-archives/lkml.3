Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbaJGMOC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:14:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753678AbaJGMN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:13:59 -0400
Date: Tue, 7 Oct 2014 14:13:56 +0200
From: Michal Marek <mmarek@suse.cz>
To: Borislav Petkov <bp@alien8.de>, linux-kbuild@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH] Kbuild: Check for CONFIG_READABLE_ASM when building .s
 targets
Message-ID: <20141007121356.GA18003@sepie.suse.cz>
References: <1412523154-25602-1-git-send-email-bp@alien8.de>
 <20141005155816.GB9377@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005155816.GB9377@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-05 17:58, Borislav Petkov wrote:
> On Sun, Oct 05, 2014 at 05:32:34PM +0200, Borislav Petkov wrote:
>> From: Borislav Petkov <bp@suse.de>
>>
>> We do need to look at the asm output of c files for various reasons. In
>> order to do so, we do make <path-to-filename>.s.
>>
>> However, it can happen that the Kconfig option which enables the
>> creation of readable asm CONFIG_READABLE_ASM is disabled. What is more,
>> we want this option enabled because it indirectly enables the issue of
>> line numbers in the asm done by gcc's switch -g.
> 
> Not really: so this is enabled by CONFIG_DEBUG_INFO and there are two
> options: we make CONFIG_READABLE_ASM depend on it which makes people
> answer a couple more questions or we simply add it to the command
> building the .s file.
> 
> I say we do the second thing:
> 
> --
> From: Borislav Petkov <bp@suse.de>
> Subject: [PATCH -v1.1] Kbuild: Check for CONFIG_READABLE_ASM when building .s targets
> 
> We do need to look at the asm output of c files for various reasons. In
> order to do so, we do make <path-to-filename>.s.
> 
> However, it can happen that the Kconfig option which enables the
> creation of readable asm CONFIG_READABLE_ASM is disabled.
> 
> So issue a warning that the asm output might not be optimally readable
> if that option is disabled.
> 
> Additionally, add the -g switch to the .s build command so that gcc
> issues line numbers too.

This violates the principle of least surprise:

make $file.s
as -o $file.o $file.s

should be equivalent to

make $file.o

Why not simply check both READABLE_ASM and DEBUG_INFO?  Also, it's more
straightforward to print the warning in the top-level Makefile rule than
to add a conditional to the generic rule, like this:

diff --git a/Makefile b/Makefile
index 106f300..2b4f62f 100644
--- a/Makefile
+++ b/Makefile
@@ -1505,6 +1505,9 @@ else
 endif
 
 %.s: %.c prepare scripts FORCE
+ifeq ($(CONFIG_READABLE_ASM)$(CONFIG_DEBUG_INFO),)
+       $(warning Enable CONFIG_READABLE_ASM and CONFIG_DEBUG_INFO more helpful asm)
+endif
        $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
 %.i: %.c prepare scripts FORCE
        $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)

I wonder if the whole check shouldn't be wrapped in an ifdef
CONFIG_DEBUG_KERNEL.

Michal
