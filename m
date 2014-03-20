Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbaCTOZE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:25:04 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27299 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984AbaCTOZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:25:00 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-77-532afa3a7821
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@deeprootsystems.com>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com,
        spear-devel@list.st.com
Subject: Re: [PATCH 3/4] ata: add new-style AHCI platform driver for DaVinci
 DA850 AHCI controller
Date: Thu, 20 Mar 2014 15:24:41 +0100
Message-id: <4579887.D6KcuxH2bm@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <532AEBBD.80707@ti.com>
References: <1395081118-15248-1-git-send-email-b.zolnierkie@samsung.com>
 <2662651.GJX9HVKij5@amdc1032> <532AEBBD.80707@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jQV2rX1rBBn82KVicu9XAanFnBbPF
	psfXWC2O7XjEZHF51xw2i/29G5gsGrp72C3mzNjMavFr+VFGi5UX/zI7cHlcf/WfyWPnrLvs
	HptWdbJ5zJnWxOJx8sJJFo/NS+o9nv7Yy+xx/MZ2Jo/Pm+QCOKO4bFJSczLLUov07RK4Mtq/
	JhScEa3oubiRuYFxg2AXIyeHhICJxL/maywQtpjEhXvr2boYuTiEBKYzShz8O5EFwmlhkvh1
	5yArSBWbgJXExPZVjCC2iICCxKore1lBipgFjjFJ/Pw5nQkkISyQIjHjwUywsSwCqhK7etrZ
	QWxeAU2JL5eOg8VFBTwldmxfyQZicwqoSMxe8IMJYlsDo8SfQ8egGgQlfky+B9bALCAvsW//
	VFYIW0dif+s0tgmMArOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx
	8kx6B+OqBotDjAIcjEo8vCv2aAYLsSaWFVfmHmKU4GBWEuG1e64VLMSbklhZlVqUH19UmpNa
	fIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFx47zDM5z4+js33z0ks/+Pl8rKb97Z
	F09n3P4udzdM6WBAsH9YbWkgg5egiqHh4r3yl//9n+z4rvDVNDWem5kHJqy4MGW5qE0h46kw
	91xl5oKZjHs38nKkCCbenrPIJV9j0rcuZv457k85Q5wX7GivZSvS2Ve50eqTcESO6ubX27Kv
	9RRzZU5UYinOSDTUYi4qTgQA/tPVcJECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 20, 2014 06:53:09 PM Sekhar Nori wrote:
> On Thursday 20 March 2014 06:27 PM, Bartlomiej Zolnierkiewicz wrote:
> 
> >>> diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
> 
> >>> +extern void __iomem *da8xx_syscfg1_base;
> >>
> >> This platform specific extern symbol should not be used in drivers and
> >> in fact checkpatch complains about it too. Can you instead get the
> >> addresses you need as part of the device resources?
> > 
> > This is problematic because it is system resource not particular device
> > resource.  I would prefer to wait with fixing it until the conversion to
> > the device tree.
> 
> The way you have it now, module build will fail because the symbol isn't
> exported from platform code (and it should not be). The register is
> "system level" but it is SATA specific and I see no problem in passing
> it to the driver.

OK, I'll try to fix it.

> Conversion to device tree will not change anything until we throw out
> the platform device code. That may or may not ever happen.
> 
> >>> +static int da850_sata_init(struct device *dev, void __iomem *addr)
> >>> +{
> >>> +	int i, ret;
> >>> +	unsigned int val;
> >>> +
> >>> +	da850_sata_clk = clk_get(dev, NULL);
> >>> +	if (IS_ERR(da850_sata_clk))
> >>> +		return PTR_ERR(da850_sata_clk);
> >>> +
> >>> +	ret = clk_prepare_enable(da850_sata_clk);
> >>> +	if (ret)
> >>> +		goto err0;
> >>
> >> Please switch to pm_runtime instead of using the clock APIs directly.
> > 
> > Could you please elaborate a bit more on this?
> 
> I meant using pm_runtime_get_sync() to enable the clocks. There are many
> examples in the kernel. drivers/watchdog/omap_wdt.c is one.
> Documentation is available in Documentation/power/runtime_pm.txt

What would be benefit of adding runtime PM methods (->runtime_suspend
and ->runtime_resume) just for enabling/disabling this clock on driver
->probe and ->remove methods?  Wouldn't it add complexity and additonal
dependency (on runtime PM) just for no gain?

Is the driver specific clock control even needed given the resource
handling in the generic AHCI platform library code (please see
ahci_platform_get_resources(),  ahci_platform_enable_resources() and
ahci_platform_disable_resources())?

[ Please also take a look at commit f1e70c2 ("ata/ahci_platform: Add
  clock framework support") which on Aug 27 2012 added generic clock
  control to ahci_platform driver but forgot to cleanup DA850 AHCI
  platform code.  The DA850 AHCI support was added much earlier by
  commit cbb2c961 ("davinci: da850: add support for SATA interface")
  on Jul 6 2011. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

