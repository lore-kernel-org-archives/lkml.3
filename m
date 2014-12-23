Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaLWROQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 12:14:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45329 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbaLWROO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 12:14:14 -0500
Message-ID: <5499A2B4.2080909@ti.com>
Date: Tue, 23 Dec 2014 11:13:24 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, <lauraa@codeaurora.org>,
        <linus.walleij@linaro.org>, <drake@endlessm.com>, <loeliger@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, <khilman@linaro.org>
Subject: Re: [PATCH v10 2/8] ARM: l2c: Refactor the driver to use commit-like
 interface
References: <1419331716-8972-1-git-send-email-m.szyprowski@samsung.com> <1419331716-8972-3-git-send-email-m.szyprowski@samsung.com> <20141223170613.GM23854@atomide.com>
In-Reply-To: <20141223170613.GM23854@atomide.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 11:06 AM, Tony Lindgren wrote:
> * Marek Szyprowski <m.szyprowski@samsung.com> [141223 02:51]:
>> From: Tomasz Figa <t.figa@samsung.com>
>>
>> Certain implementations of secure hypervisors (namely the one found on
>> Samsung Exynos-based boards) do not provide access to individual L2C
>> registers. This makes the .write_sec()-based interface insufficient and
>> provoking ugly hacks.
>>
>> This patch is first step to make the driver not rely on availability of
>> writes to individual registers. This is achieved by refactoring the
>> driver to use a commit-like operation scheme: all register values are
>> prepared first and stored in an instance of l2x0_regs struct and then a
>> single callback is responsible to flush those values to the hardware.
> 
> The first patch of the series applied things boot with no problem.
> But after applying this one I get the following on am437x:
> 
> Unhandled fault: imprecise external abort (0xc06) at 0xb6f33884
> 
> Probably the same issue Nishanth mentioned.
> 

yep - just finished the bisect... came to the same conclusion..

c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f is the first bad commit
commit c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f
Author: Tomasz Figa <t.figa@samsung.com>
Date:   Tue Dec 23 11:48:30 2014 +0100

    ARM: l2c: Refactor the driver to use commit-like interface

    Certain implementations of secure hypervisors (namely the one found on
    Samsung Exynos-based boards) do not provide access to individual L2C
    registers. This makes the .write_sec()-based interface
insufficient and
    provoking ugly hacks.

    This patch is first step to make the driver not rely on
availability of
    writes to individual registers. This is achieved by refactoring the
    driver to use a commit-like operation scheme: all register values are
    prepared first and stored in an instance of l2x0_regs struct and
then a
    single callback is responsible to flush those values to the hardware.

    Signed-off-by: Tomasz Figa <t.figa@samsung.com>
    Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

:040000 040000 74c6c74a0dc0612d124cd759951adf2a1e4124ee
8082aabb474f8659231de744d87cd8dbd6dd79bb M	arch


$ git bisect log
git bisect start
# good: [97bf6af1f928216fd6c5a66e8a57bfa95a659672] Linux 3.19-rc1
git bisect good 97bf6af1f928216fd6c5a66e8a57bfa95a659672
# bad: [9afe195db6558621bd8bac379ed65ef121930684] ARM: dts: exynos4:
Add nodes for L2 cache controller
git bisect bad 9afe195db6558621bd8bac379ed65ef121930684
# bad: [0a89ef4dd870bbf692e30fef6c8182d7b8b42e17] ARM: l2c: Get outer
cache .write_sec callback from mach_desc only if not NULL
git bisect bad 0a89ef4dd870bbf692e30fef6c8182d7b8b42e17
# bad: [c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f] ARM: l2c: Refactor
the driver to use commit-like interface
git bisect bad c8c3a07fa6a8e9b27a1658e0d305b6f7e0fa068f
# good: [080ab387c653b8655dc1ee790658b618399db2aa] ARM: OMAP2+: use
common l2cache initialization code
git bisect good 080ab387c653b8655dc1ee790658b618399db2aa


-- 
Regards,
Nishanth Menon
