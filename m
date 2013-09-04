Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab3IDQu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 12:50:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56309 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105Ab3IDQuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 12:50:54 -0400
Message-ID: <522763A9.8080708@zytor.com>
Date: Wed, 04 Sep 2013 09:45:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [GIT PULL] x86/asmlinkage changes for v3.12
References: <20130903143921.GA28290@gmail.com> <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
In-Reply-To: <CA+55aFxVv==DC0JdS87V+cPr-twN+TujYg5XmgHOjJOAkZ4xwQ@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 08:58 AM, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 7:39 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> Please pull the latest x86-asmlinkage-for-linus git tree from:
> 
> Grr. This one seems to introduce this annoying warning:
> 
> arch/x86/kernel/paravirt.c:66:0: warning: "DEF_NATIVE" redefined
> [enabled by default]
>  #define DEF_NATIVE(ops, name, code)     \
>  ^
> In file included from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/ptrace.h:65:0,
>                  from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/alternative.h:8,
>                  from
> /home/torvalds/v2.6/linux/arch/x86/include/asm/bitops.h:16,
>                  from include/linux/bitops.h:22,
>                  from include/linux/kernel.h:10,
>                  from include/linux/cache.h:4,
>                  from include/linux/time.h:4,
>                  from include/linux/stat.h:18,
>                  from include/linux/module.h:10,
>                  from arch/x86/kernel/paravirt.c:22:
> /home/torvalds/v2.6/linux/arch/x86/include/asm/paravirt_types.h:389:0:
> note: this is the location of the previous definition
>  #define DEF_NATIVE(ops, name, code)      \
>  ^
> 
> when doing an allmodconfig.
> 
> Maybe it gets fixed later in the series (I am about a third through
> your pull requests), but it's clearly bogus.
> 
> What the heck is wrong with that macro anyway? It is used in one
> single file, and it is _defined_ twice - in two other files. Somebody
> was very very confused when they wrote that code.
> 
> I'm going to let the pull stand, since it doesn't seem to actually
> break anything, but this needs to be fixed.
> 

This is actually a very old bug (the macro is defined in a .c and a .h
file, but this patchset makes them different.)

The definition in the .c file should be removed, I believe.

It is used in two files (paravirt_patch_{32,64}.c) but not in paravirt.c
proper.

This also exposes an interesting problem with Fengguang's build robot.

One build:
[tip:x86/asmlinkage] 28596b6a8779b736829ad837f95fdc2e81bdd1ee BUILD DONE
28596b6a8779b736829ad837f95fdc2e81bdd1ee  x86, asmlinkage, vdso: Mark
vdso variables __visible

... flags the warnings.  The next build for the branch looks clean:
[tip:x86/asmlinkage] eb86b5fd505cb97743d84226140cf247d91a2f03 BUILD SUCCESS
eb86b5fd505cb97743d84226140cf247d91a2f03  x86/asmlinkage: Fix warning in
xen asmlinkage change

("DONE" means warnings or errors.)

A human observer would assume that the problem was fixed, since the
patch says "fix warnings", but the problem is that it didn't actually
fix *all* the warnings.  However, the bot has flagged the warnings as
preexisting from the previous build, and thus no new warnings were
introduced.

It would be better if the bot reported any warnings not present in upstream.

	-hpa

