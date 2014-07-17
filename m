Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934643AbaGQP7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:59:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63185 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaGQP7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:59:12 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-bf-53c7f2cf8b54
Message-id: <53C7F2A9.1080508@samsung.com>
Date: Thu, 17 Jul 2014 17:58:33 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: Re: [PATCH] irqchip: gic: Fix core ID calculation when topology is
 read from DT
References: <1405610624-18722-1-git-send-email-t.figa@samsung.com>
 <20140717153236.GS13108@titan.lakedaemon.net> <53C7EE82.6040803@samsung.com>
 <20140717155105.GT13108@titan.lakedaemon.net>
In-reply-to: <20140717155105.GT13108@titan.lakedaemon.net>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsVy+t/xq7rnPx0PNlg1ld1i44z1rBaNSy6z
	WPQuuMpmsenxNVaLy7vmsFnMOL+PyeLN7xfsFmuP3GW32LxpKrPFql1/GB24PNbMW8PosXPW
	XXaPhgPnWTzenTvH7rF5Sb1H35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZdzoa2UteCJScfZd
	E2sD42OBLkZODgkBE4lbk+cxQdhiEhfurWcDsYUEljJKTGxP7WLkArI/M0p03H/MDJLgFdCS
	uP3vPEsXIwcHi4CqxL1FfiBhNgE1ic8Nj8B6+YFK1jRdBysRFYiQeHxBCKJTUOLH5HssILaI
	gLrEuc2tbCDjmQW+MElcnvwBLCEsECVx+nUTG8Teg4wSG15sBBvKKWAlMXfqF0YQm1lAR2J/
	6zQ2CFteYvOat8wTGAVnIVkyC0nZLCRlCxiZVzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKE
	RMvXHYxLj1kdYhTgYFTi4f3BdTxYiDWxrLgy9xCjBAezkghv9n2gEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsadNdKb/Y/ZrbbkfZ51TV79bMgthgnXxdinva7wYvzseTRt1tmz1pe+T0zUcz7R
	eHSuu1vuJb3iAnEPVv6qiavnmmxrb/m5UYCv0MTSXMX4XdCasnzWTMa2+YnZJ/cf2LWVyThB
	oT57n9//u99ETTknHSxri0jjUGdbs9f7aOJH8R7HF9qHu5RYijMSDbWYi4oTAXojW9R0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.07.2014 17:51, Jason Cooper wrote:
> On Thu, Jul 17, 2014 at 05:40:50PM +0200, Tomasz Figa wrote:
>> Hi Jason,
>>
>> On 17.07.2014 17:32, Jason Cooper wrote:
>>> On Thu, Jul 17, 2014 at 05:23:44PM +0200, Tomasz Figa wrote:
>>>> Certain GIC implementation, namely those found on earlier, single
>>>> cluster, Exynos SoCs, have registers mapped without per-CPU banking,
>>>> which means that the driver needs to use different offset for each CPU.
>>>>
>>>> Currently the driver calculates the offset by multiplying value returned
>>>> by cpu_logical_map() by CPU offset parsed from DT. This is correct when
>>>> CPU topology is not specified in DT and aforementioned function returns
>>>> core ID alone. However when DT contains CPU topology, the function
>>>> changes to return cluster ID as well, which is non-zero on mentioned
>>>> SoCs and so breaks the calculation in GIC driver.
>>>>
>>>> This patch fixes this by masking out cluster ID in CPU offset
>>>> calculation so that only core ID is considered. Multi-cluster Exynos
>>>> SoCs already have banked GIC implementations, so this simple fix should
>>>> be enough.
>>>>
>>>> Reported-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>>>> Reported-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
>>>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>>>> ---
>>>>  drivers/irqchip/irq-gic.c | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>
>>> iiuc, this was introduced by:
>>>
>>>   db0d4db22a78d ARM: gic: allow GIC to support non-banked setups
>>>
>>> and so should be for v3.3 and up, correct?
>>
>> Could be, although there was and still is no topology data specified in
>> DT for affected Exynos SoCs. The need for it showed up just recently, so
>> I'm not sure this is a regression to fix in older kernels.
> 
> In my "the kernel and the dtb aren't tied together" quest, these are the
> kinds of things I like to see fixed in stable kernels.
> 
> If a user needs to update a dtb, say to fix a bug, it's reasonable to
> use the newest one for a given board.  After all, any new nodes won't
> change anything, since the driver in the kernel won't match the node.
> 
> However, in this case, without this fix, a user upgrading to the newest
> dtb would get a broken system.  So, this fix should be backported to
> prevent the breakage.  Or, have I missed something in my analysis?

This is correct when looking only at this issue. However I suspect such
move would cause a breakage anyway, because DT stuff isn't that stable
on Exynos side. I don't mind if this patch hits stable, though.

Best regards,
Tomasz
