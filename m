Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbbAIOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 09:19:55 -0500
Received: from mail-yh0-f46.google.com ([209.85.213.46]:57849 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbbAIOTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 09:19:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150109121348.GD12942@leverpostej>
References: <CA+55aFwsxoyLb9OWMSCL3doe_cz_EQtKsEFCyPUYn_T87pbz0A@mail.gmail.com>
	<54AE7D53.2020305@redhat.com>
	<20150109121348.GD12942@leverpostej>
Date: Fri, 9 Jan 2015 14:19:54 +0000
Message-ID: <CAPvkgC23LHhs7Tw4rdAPFooimonji8R7kEAbWYRKPJwouwUzBA@mail.gmail.com>
Subject: Re: Linux 3.19-rc3
From: Steve Capper <steve.capper@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mark Langsdorf <mlangsdo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        vishnu.ps@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 January 2015 at 12:13, Mark Rutland <mark.rutland@arm.com> wrote:
> On Thu, Jan 08, 2015 at 12:51:31PM +0000, Mark Langsdorf wrote:
>> On 01/05/2015 07:46 PM, Linus Torvalds wrote:
>> > It's a day delayed - not because of any particular development issues,
>> > but simply because I was tiling a bathroom yesterday. But rc3 is out
>> > there now, and things have stayed reasonably calm. I really hope that
>> > implies that 3.19 is looking good, but it's equally likely that it's
>> > just that people are still recovering from the holiday season.
>>
>> I'm consistently getting an out of memory killer triggered when
>> compiling the kernel (make -j 16 -s) on a 16 core ARM64 system
>> with 16 GB of memory. This doesn't happen when running a 3.18
>> kernel.
>>
>> I'm going to start bisecting the failure now, but here's the crash
>> log in case someone can see something obvious in it.
>
> FWIW I've just reproduced this with v3.19-rc3 defconfig +
> CONFIG_ARM64_64K_PAGES=y by attempting a git clone of mainline. My
> system has 16GB of RAM and 6 CPUs.
>
> I have a similarly dodgy looking number of pages reserved
> (18446744073709544451 A.K.A. -7165). Log below.
>

I think the negative page reserved count is a consequence of another bug.

We have the following reporting code in lib/show_mem.c:
#ifdef CONFIG_CMA
        printk("%lu pages reserved\n", (reserved - totalcma_pages));
        printk("%lu pages cma reserved\n", totalcma_pages);
#else

With totalcma_pages being reported as 8192, that would account for the
-7000ish values reported.

That change appears to have come from:
49abd8c lib/show_mem.c: add cma reserved information

Is the quickest way to exacerbate this OOM a kernel compile?

Cheers,
--
Steve
