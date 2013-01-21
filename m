Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3AUQAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 11:00:39 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50359 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab3AUQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 11:00:38 -0500
MIME-Version: 1.0
In-Reply-To: <20130121055541.GD3666@blaptop>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
 <20130118210859.GH23505@n2100.arm.linux.org.uk> <CAKGA1bmJ6c4LC=NAD4MU_rBZ2hZjf6qH=C+dqMCf0eP+2vSFdA@mail.gmail.com>
 <20130119044602.GC5391@phenom.dumpdata.com> <20130121055541.GD3666@blaptop>
From: Matt Sealey <matt@genesi-usa.com>
Date: Mon, 21 Jan 2013 10:00:17 -0600
Message-ID: <CAKGA1bk3xdD5sTnn8DR9HQ4ae1sUsEnC1ENcwa3jfjDQgGp6QA@mail.gmail.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on ARM
To: Minchan Kim <minchan@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

On Sun, Jan 20, 2013 at 11:55 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Fri, Jan 18, 2013 at 11:46:02PM -0500, Konrad Rzeszutek Wilk wrote:
>> On Fri, Jan 18, 2013 at 07:11:32PM -0600, Matt Sealey wrote:
>> >
>> > diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c
>> > b/drivers/staging/zsmalloc/zsmalloc-main.c
>> > index 09a9d35..ecf75fb 100644
>>       > --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>> > +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>> > @@ -228,7 +228,7 @@ struct zs_pool {
>> >   * mapping rather than copying
>> >   * for object mapping.
>> >  */
>> > -#if defined(CONFIG_ARM)
>> > +#if defined(CONFIG_ARM) && defined(CONFIG_SMP)
>> >  #define USE_PGTABLE_MAPPING
>
> I don't get it. How to prevent the problem Russel described?
> The problem is that other CPU can prefetch _speculatively_ under us.

It prevents no problems, but if that isn't there, kernels build
without SMP support (i.e. specifically uniprocessor kernels) will fail
at the linker stage.

That's not desirable.

We have 3 problems here, this solves the first of them, and creates
the third. The second is constant regardless..

1) zsmalloc will not build on ARM without CONFIG_SMP because on UP
local_tlb_flush_kern_range uses a function which uses an export which
isn't required on SMP

Basically, with CONFIG_SMP (and CONFIG_UP_ON_SMP),
local_tlb_flush_kern_range is calling functions by dereference from
the per-cpu global cpu_tlb structure.

On UP (!CONFIG_SMP), it is calling functions directly (in my case,
v7wbi_local_tlb_flush_kern_range or whatever, but on v6, v5, v4 ARM
processor kernel builds it may be different) which need to be exported
outside of the MM core.

If this difference is going to stick around - Russell is refusing here
to export that/those direct functions - then the optimized vm mapping
code simply should never be allowed to run on non-SMP systems to keep
it building for everyone.

The patch above is simply a build fix for !CONFIG_SMP in this case to
force it to use the slow path for systems where the above missing
export problem will cause the linker failure.

2) the optimized vm mapping isn't per-cpu aware as per Russell's
arguments. I'll let you guys discuss that as I have no idea what the
real implications are for SMP systems (and my current testing is only
on a non-SMP CPU, I will have to go grab a couple boards from the lab
for SMP)

3) it somewhat defeats the purpose of the optimization if UP systems
(which tend to have less memory and might benefit from things like
zsmalloc/zram more) cannot use it, but SMP systems which tend to have
more memory (unless we're talking about a frugal configuration of a
virtual machine, perhaps). Given the myriad use cases of zram that is
not a pervasive or persuasive argument, I know, but it does seem
slightly backwards.

> If I don't miss something, we could have 2 choice.
>
> 1) use flush_tlb_kernel_range instead of local_flush_tlb_kernel_range
> Or
> 2) use only memory copy
>
> I guess everybody want 2 because it makes code very simple and maintainable.
> Even, rencently Joonsoo sent optimize patch.
> Look at https://lkml.org/lkml/2013/1/16/68 so zram/zcache effect caused by 2
> would be minimized.
>
> But please give me the time and I will borrow quad-core embedded target board
> and test 1 on the phone with Seth's benchmark.

In the meantime please take into account building a non-SMP kernel for
this board and testing that; if there is a way to do the flush without
using the particular function which uses the particular export that
Russell will not export, then that would be better. Maybe for
!CONFIG_SMP using flush_tlb_kernel_range is doing the exact same job
and the real patch is not to disable the optimization with
!CONFIG_SMP, but to additionally #if defined(CONFIG_SMP) around
local_flush_tlb_kernel_range and alternatively for UP use
flush_tlb_kernel_range which.. probably.. doesn't use that contentious
export?

This is far beyond the level I want to be digging around in the Linux
kernel so I am not comfortable even trying that to find out.

-- 
Matt Sealey <matt@genesi-usa.com>
Product Development Analyst, Genesi USA, Inc.
