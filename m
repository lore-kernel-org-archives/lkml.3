Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaAGOdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:33:46 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:49035 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaAGOd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:33:27 -0500
MIME-Version: 1.0
In-Reply-To: <201401071512.34016.arnd@arndb.de>
References: <1382975339-25831-1-git-send-email-tom.leiming@gmail.com>
	<201401071512.34016.arnd@arndb.de>
Date: Tue, 7 Jan 2014 22:33:24 +0800
Message-ID: <CACVXFVNPcC+7Th-xfD24GiEat=FHMGKXh9Abc_othvR5pdLOYQ@mail.gmail.com>
Subject: Re: [PATCH] scripts/kallsyms: filter symbols not in kernel address space
From: Ming Lei <tom.leiming@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Jan 7, 2014 at 10:12 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 28 October 2013, Ming Lei wrote:
>> This patch uses CONFIG_PAGE_OFFSET to filter symbols which
>> are not in kernel address space because these symbols are
>> generally for generating code purpose and can't be run at
>> kernel mode, so we needn't keep them in /proc/kallsyms.
>>
>> For example, on ARM there are some symbols which are
>> linked in relocatable code section, then perf can't parse
>> symbols any more from /proc/kallsyms, and this patch fixes
>> the problem.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: Michal Marek <mmarek@suse.cz>
>> Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>
> Sorry for the late report, but I seem to have encountered a problem with this
> patch, now that it has made it into all stable kernels.
>
> When linking an ARM nommu kernel, I get the output "No valid symbol." twice,
> from scripts/kallsyms. The problem evidently is that PAGE_OFFSET is still
> set to 0xC0000000 on ARM NOMMU builds but the kernel is linked to start at
> PLAT_PHYS_OFFSET instead, which may be elsehwere. For most platforms,
> this is defined in Kconfig these days, so we could get away with
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index d1e4098..c477a7c 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1592,6 +1592,7 @@ endchoice
>
>  config PAGE_OFFSET
>         hex
> +       default PHYS_OFFSET if !MMU
>         default 0x40000000 if VMSPLIT_1G
>         default 0x80000000 if VMSPLIT_2G
>         default 0xC0000000
>
> but there are still a few ARM platforms that define their own PLAT_PHYS_OFFSET
> in memory.h, and it wouldn't help on non-ARM systems that might have the same
> problem.

We had posted two patches to address the problem, see below link:

   http://lists.scusting.com/index.php?t=msg&goto=1726509&S=Google


Thanks,
-- 
Ming Lei
