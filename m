Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaLCMLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:11:13 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24325 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLCMLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:11:11 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-75-547efddcdbfa
Message-id: <547EFDCF.2030404@samsung.com>
Date: Wed, 03 Dec 2014 13:10:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 1/5] clk: samsung: Fix double add of syscore ops after
 driver rebind
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
 <1417011857-10419-2-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1417011857-10419-2-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7p3/taFGNzcpWGxccZ6Vou2KwfZ
	LY7+LrB4/cLQov/xa2aLp5sfM1mcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbPJ1w
	kc1i1a4/jA58Hi3NPWwef59fZ/HYOesuu8emVZ1sHneu7WHz2Lyk3qNvyypGj8+b5AI4orhs
	UlJzMstSi/TtErgy1vyXKpgqWTH131LWBsZmsS5GTg4JAROJB28nMELYYhIX7q1n62Lk4hAS
	WMooMfPSObCEkMAnRonVzyxAbF4BLYlru26wgdgsAqoSu3Y8YQWx2QQMJXqP9oHViwpESJy8
	u4cdol5Q4sfkeywgtghQzcHd25lAbGaBJSwSf3aC9QoLxErMv7ifBWJXK6PE6+uqIDangIfE
	l92TgWZyANXrSdy/qAXRKi+xec1b5gmMArOQbJiFUDULSdUCRuZVjKKppckFxUnpuUZ6xYm5
	xaV56XrJ+bmbGCGx83UH49JjVocYBTgYlXh4Hd7VhAixJpYVV+YeYpTgYFYS4X32rS5EiDcl
	sbIqtSg/vqg0J7X4ECMTB6dUA2PBvFPGp05a/dDafMO3xm7/48e5Lu+n7t5i/PT5nYinz2cu
	jlGLseuSVo4UMXhc4LVu13Ij1p0ueRuXs/TufLVJaPL3S/nO0qds+h/xKUp+F3hW8D1/2eKY
	kN9Vh5Q1Pr4o+Cv8/mbhswM3nshLFezyPbPqhEfs7pWRgsfXO8252eD0rLD3gto9JZbijERD
	Leai4kQAodtrNXsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 15:24, Krzysztof Kozlowski wrote:
> During driver unbind the syscore ops were not unregistered which lead to
> double add on syscore list:
> 
> $ echo "3810000.audss-clock-controller" > /sys/bus/platform/drivers/exynos-audss-clk/unbind
> $ echo "3810000.audss-clock-controller" > /sys/bus/platform/drivers/exynos-audss-clk/bind
> [ 1463.044061] ------------[ cut here ]------------
> [ 1463.047255] WARNING: CPU: 0 PID: 1 at lib/list_debug.c:36 __list_add+0x8c/0xc0()
> [ 1463.054613] list_add double add: new=c06e52c0, prev=c06e52c0, next=c06d5f84.
> [ 1463.061625] Modules linked in:
> [ 1463.064623] CPU: 0 PID: 1 Comm: bash Tainted: G        W      3.18.0-rc5-next-20141121-00005-ga8fab06eab42-dirty #1022
> [ 1463.075338] [<c0014e2c>] (unwind_backtrace) from [<c0011d80>] (show_stack+0x10/0x14)
> [ 1463.083046] [<c0011d80>] (show_stack) from [<c048bb70>] (dump_stack+0x70/0xbc)
> [ 1463.090236] [<c048bb70>] (dump_stack) from [<c00233d4>] (warn_slowpath_common+0x74/0xb0)
> [ 1463.098295] [<c00233d4>] (warn_slowpath_common) from [<c00234a4>] (warn_slowpath_fmt+0x30/0x40)
> [ 1463.106962] [<c00234a4>] (warn_slowpath_fmt) from [<c020fe80>] (__list_add+0x8c/0xc0)
> [ 1463.114760] [<c020fe80>] (__list_add) from [<c0282094>] (register_syscore_ops+0x30/0x3c)
> [ 1463.122819] [<c0282094>] (register_syscore_ops) from [<c0392f20>] (exynos_audss_clk_probe+0x36c/0x460)
> [ 1463.132091] [<c0392f20>] (exynos_audss_clk_probe) from [<c0283084>] (platform_drv_probe+0x48/0xa4)
> [ 1463.141013] [<c0283084>] (platform_drv_probe) from [<c0281a14>] (driver_probe_device+0x13c/0x37c)
> [ 1463.149852] [<c0281a14>] (driver_probe_device) from [<c0280560>] (bind_store+0x90/0xe0)
> [ 1463.157822] [<c0280560>] (bind_store) from [<c027fd10>] (drv_attr_store+0x20/0x2c)
> [ 1463.165363] [<c027fd10>] (drv_attr_store) from [<c0143898>] (sysfs_kf_write+0x4c/0x50)
> [ 1463.173252] [<c0143898>] (sysfs_kf_write) from [<c0142c80>] (kernfs_fop_write+0xbc/0x198)
> [ 1463.181395] [<c0142c80>] (kernfs_fop_write) from [<c00e2be0>] (vfs_write+0xa0/0x1a8)
> [ 1463.189104] [<c00e2be0>] (vfs_write) from [<c00e2f00>] (SyS_write+0x40/0x8c)
> [ 1463.196122] [<c00e2f00>] (SyS_write) from [<c000f2a0>] (ret_fast_syscall+0x0/0x48)
> [ 1463.203655] ---[ end trace 08f6710c9bc8d8f3 ]---
> [ 1463.208244] exynos-audss-clk 3810000.audss-clock-controller: setup completed
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: 1241ef94ccc3 ("clk: samsung: register audio subsystem clocks using common clock framework")
> Cc: <stable@vger.kernel.org>

Thanks for the fix, I applied the patch to my tree.

> ---
>  drivers/clk/samsung/clk-exynos-audss.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
> index acce708ace18..7c4368e75ede 100644
> --- a/drivers/clk/samsung/clk-exynos-audss.c
> +++ b/drivers/clk/samsung/clk-exynos-audss.c
> @@ -210,6 +210,10 @@ static int exynos_audss_clk_remove(struct platform_device *pdev)
>  {
>  	int i;
>  
> +#ifdef CONFIG_PM_SLEEP
> +	unregister_syscore_ops(&exynos_audss_clk_syscore_ops);
> +#endif
> +

--
Regards,
Sylwester

