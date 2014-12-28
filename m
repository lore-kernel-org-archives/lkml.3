Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaL1Le2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 06:34:28 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:40658 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaL1LeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 06:34:25 -0500
Message-ID: <549FEABA.10206@gmail.com>
Date: Sun, 28 Dec 2014 20:34:18 +0900
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, lauraa@codeaurora.org,
        linus.walleij@linaro.org, drake@endlessm.com, loeliger@gmail.com,
        Mark Rutland <mark.rutland@arm.com>, khilman@linaro.org
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com> <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com> <20141223170613.GM23854@atomide.com> <5499A2B4.2080909@ti.com>
In-Reply-To: <5499A2B4.2080909@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth, Tony,

On 24.12.2014 02:13, Nishanth Menon wrote:
> On 12/23/2014 11:06 AM, Tony Lindgren wrote:
>> * Marek Szyprowski <m.szyprowski@samsung.com> [141223 02:51]:
>>> From: Tomasz Figa <t.figa@samsung.com>
>>>
>>> Certain implementations of secure hypervisors (namely the one found on
>>> Samsung Exynos-based boards) do not provide access to individual L2C
>>> registers. This makes the .write_sec()-based interface insufficient and
>>> provoking ugly hacks.
>>>
>>> This patch is first step to make the driver not rely on availability of
>>> writes to individual registers. This is achieved by refactoring the
>>> driver to use a commit-like operation scheme: all register values are
>>> prepared first and stored in an instance of l2x0_regs struct and then a
>>> single callback is responsible to flush those values to the hardware.
>>
>> The first patch of the series applied things boot with no problem.
>> But after applying this one I get the following on am437x:
>>
>> Unhandled fault: imprecise external abort (0xc06) at 0xb6f33884
>>
>> Probably the same issue Nishanth mentioned.
>>
>
> yep - just finished the bisect... came to the same conclusion..
>
> c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f is the first bad commit
> commit c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f
> Author: Tomasz Figa <t.figa@samsung.com>
> Date:   Tue Dec 23 11:48:30 2014 +0100
>
>      ARM: l2c: Refactor the driver to use commit-like interface
>
>      Certain implementations of secure hypervisors (namely the one found on
>      Samsung Exynos-based boards) do not provide access to individual L2C
>      registers. This makes the .write_sec()-based interface
> insufficient and
>      provoking ugly hacks.
>
>      This patch is first step to make the driver not rely on
> availability of
>      writes to individual registers. This is achieved by refactoring the
>      driver to use a commit-like operation scheme: all register values are
>      prepared first and stored in an instance of l2x0_regs struct and
> then a
>      single callback is responsible to flush those values to the hardware.
>
>      Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>      Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>
> :040000 040000 74c6c74a0dc0612d124cd759951adf2a1e4124ee
> 8082aabb474f8659231de744d87cd8dbd6dd79bb M	arch
>
>
> $ git bisect log
> git bisect start
> # good: [97bf6af1f928216fd6c5a66e8a57bfa95a659672] Linux 3.19-rc1
> git bisect good 97bf6af1f928216fd6c5a66e8a57bfa95a659672
> # bad: [9afe195db6558621bd8bac379ed65ef121930684] ARM: dts: exynos4:
> Add nodes for L2 cache controller
> git bisect bad 9afe195db6558621bd8bac379ed65ef121930684
> # bad: [0a89ef4dd870bbf692e30fef6c8182d7b8b42e17] ARM: l2c: Get outer
> cache .write_sec callback from mach_desc only if not NULL
> git bisect bad 0a89ef4dd870bbf692e30fef6c8182d7b8b42e17
> # bad: [c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f] ARM: l2c: Refactor
> the driver to use commit-like interface
> git bisect bad c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f
> # good: [080ab387c653b8655dc1ee790658b618399db2aa] ARM: OMAP2+: use
> common l2cache initialization code
> git bisect good 080ab387c653b8655dc1ee790658b618399db2aa
>
>

May I ask you (or anyone else working on OMAP) to try to figure out what 
the issue is? It is stopping L2 cache support for Exynos4 being merged 
and Exynos people don't have access to any of affected boards to do 
anything about it. After all, this is generic code, so I believe 
community should cooperate with pushing it forward. (Of course I 
understand it is a holiday season at the moment, so I don't expect any 
solution right at this moment :))

Apparently patch 1/8 solved problems with some of the boards. Could you 
check how those boards differ and look for potential causes?

Best regards,
Tomasz
