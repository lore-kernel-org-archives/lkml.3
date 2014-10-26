Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaJZU3i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 16:29:38 -0400
Received: from gloria.sntech.de ([95.129.55.99]:43909 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaJZU3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 16:29:36 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Joerg Roedel <joro@8bytes.org>, Simon Xue <xxm@rock-chips.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] iommu/rockchip: rk3288 iommu driver
Date: Sun, 26 Oct 2014 21:32:31 +0100
Message-ID: <9308178.MnIriKUXEi@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1414136029-22695-2-git-send-email-djkurtz@chromium.org>
References: <1414136029-22695-1-git-send-email-djkurtz@chromium.org> <1414136029-22695-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Am Freitag, 24. Oktober 2014, 15:33:47 schrieb Daniel Kurtz:

[...]

> +static int rk_iommu_attach_device(struct iommu_domain *domain,
> +				  struct device *dev)
> +{
> +	struct rk_iommu *iommu = dev_get_drvdata(dev->archdata.iommu);

Here I get a null-ptr dereference [0] when using the iommu driver with the
pending drm changes.

> +	struct rk_iommu_domain *rk_domain = domain->priv;
> +	unsigned long flags;
> +	int ret;
> +	phys_addr_t dte_addr;
> +
> +	/*
> +	 * Allow 'virtual devices' (e.g., drm) to attach to domain.
> +	 * Such a device has a NULL archdata.iommu.
> +	 */
> +	if (!iommu)

When the comment is correct, the code should probably do something like
the following?

if (!dev->archdata.iommu)
	return 0;
 
iommu = dev_get_drvdata(dev->archdata.iommu);


> +		return 0;
> +
> +	ret = rk_iommu_enable_stall(iommu);
> +	if (ret)
> +		return ret;
> +
> +	ret = rk_iommu_force_reset(iommu);
> +	if (ret)
> +		return ret;
> +
> +	iommu->domain = domain;
> +
> +	ret = devm_request_irq(dev, iommu->irq, rk_iommu_irq,
> +			       IRQF_SHARED, dev_name(dev), iommu);
> +	if (ret)
> +		return ret;
> +
> +	dte_addr = virt_to_phys(rk_domain->dt);
> +	rk_iommu_write(iommu, RK_MMU_DTE_ADDR, dte_addr);
> +	rk_iommu_command(iommu, RK_MMU_CMD_ZAP_CACHE);
> +	rk_iommu_write(iommu, RK_MMU_INT_MASK, RK_MMU_IRQ_MASK);
> +
> +	ret = rk_iommu_enable_paging(iommu);
> +	if (ret)
> +		return ret;
> +
> +	spin_lock_irqsave(&rk_domain->iommus_lock, flags);
> +	list_add_tail(&iommu->node, &rk_domain->iommus);
> +	spin_unlock_irqrestore(&rk_domain->iommus_lock, flags);
> +
> +	dev_info(dev, "Attached to iommu domain\n");
> +
> +	rk_iommu_disable_stall(iommu);
> +
> +	return 0;
> +}

[...]

> +
> +static struct platform_driver rk_iommu_driver = {
> +	.probe = rk_iommu_probe,
> +	.remove = rk_iommu_remove,
> +	.driver = {
> +		   .name = "rk_iommu",
> +		   .owner = THIS_MODULE,
> +		   .of_match_table = of_match_ptr(rk_iommu_dt_ids),
> +	},
> +};
> +
> +static int __init rk_iommu_init(void)
> +{
> +	int ret;
> +
> +	ret = bus_set_iommu(&platform_bus_type, &rk_iommu_ops);

on 3.18-rc1 this fails with -ENODEV, as add_iommu_group() is missing the
add_device callback in rk_iommu_ops, so the iommu driver actually never
gets registered.

I've stolen the generic add_device and remove_device callbacks from the
exynos iommu driver which makes the rk one at least probe.

Can't say how far it goes, as I'm still struggling with the floating display
subsystem parts. My current diff against this version can be found in [1].

Maybe the issue I had in attach_device also simply resulted from this one,
not sure right now.


Heiko

> +	if (ret)
> +		return ret;
> +
> +	return platform_driver_register(&rk_iommu_driver);
> +}
> +static void __exit rk_iommu_exit(void)
> +{
> +	platform_driver_unregister(&rk_iommu_driver);
> +}
> +
> +subsys_initcall(rk_iommu_init);
> +module_exit(rk_iommu_exit);
> +
> +MODULE_DESCRIPTION("IOMMU API for Rockchip");
> +MODULE_AUTHOR("Simon Xue <xxm@rock-chips.com> and Daniel Kurtz
> <djkurtz@chromium.org>"); +MODULE_ALIAS("platform:rockchip-iommu");
> +MODULE_LICENSE("GPL v2");



[0]

[drm] Initialized drm 1.1.0 20060810
Unable to handle kernel NULL pointer dereference at virtual address 00000058
pgd = c0004000
[00000058] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.0-rc1+ #1274
task: ee067b40 ti: ee068000 task.ti: ee068000
PC is at rk_iommu_attach_device+0x3c/0x29c
LR is at rk_iommu_attach_device+0x30/0x29c
pc : [<c03686d4>]    lr : [<c03686c8>]    psr: 60000153
sp : ee069db8  ip : 00000000  fp : 00000000
r10: ee276f00  r9 : 00000000  r8 : ee27cc00
r7 : ee27cf80  r6 : ee11b610  r5 : ee11b610  r4 : ee27cf80
r3 : 00000000  r2 : c07bb588  r1 : c045b6d0  r0 : c054a27f
Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
Control: 10c5387d  Table: 0000406a  DAC: 00000015
Process swapper/0 (pid: 1, stack limit = 0xee068240)
Stack: (0xee069db8 to 0xee06a000)
9da0:                                                       c07c75a8 c0367fec
9dc0: c0367fc4 ee276f00 c07c75a8 ee27cf80 ee11b610 00000000 ee27cf80 ee27cc00
9de0: 00000000 c0366c48 ee27c250 c001a470 ee27c250 ee11b610 ee2cf400 00000000
9e00: ee27cf80 c0225388 c0225298 ee2cf400 00000000 00000000 00000000 c0213cb0
9e20: ee11ca40 ee11b610 ee2cf400 00000000 ee2db130 c022522c ee2dbf80 00000004
9e40: ee2db110 c022a9e4 ee27cc00 c07c73f8 ee2dbf80 c07da7c0 c082633c c022abe4
9e60: c0446710 ee127010 ffffffed c07c7354 c07da7c0 c0230174 ee127010 c07c7354
9e80: 00000000 c022ebc0 c07c7354 ee127010 ee069ea8 ee127010 ee127044 c07c7354
9ea0: 00000000 c05be4a0 ee068000 c022ee38 00000000 c07c7354 c022edd0 c022d28c
9ec0: ee04675c ee1226b4 c07c7354 ee2d6a80 c07c75a8 c022e2b4 c0512e6d c0512e6d
9ee0: 00000072 c07c7354 c07b6e18 c07dfac0 c05dd274 c022f4b0 00000000 ee27cd00
9f00: c07b6e18 c00089d0 ee0e9300 c0100018 ee0e9300 ee0e9080 ee0e9000 c0420e38
9f20: c0802444 00000000 c057d980 c01001a4 c05a7594 ef7fcc05 00000000 c0036b68
9f40: 00000000 00000000 c057d980 c057cd90 000000bf 00000006 c07ba5f0 00000006
9f60: c05d1568 c07dfac0 c05dd274 000000bf 00000000 00000000 00000000 c05a7d20
9f80: 00000006 00000006 c05a7594 ee068000 00000000 c04171ac 00000000 00000000
9fa0: 00000000 c04171b4 00000000 c000e878 00000000 00000000 00000000 00000000
9fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
9fe0: 00000000 00000000 00000000 00000000 00000013 00000000 00000000 00000000
[<c03686d4>] (rk_iommu_attach_device) from [<c0366c48>] (iommu_attach_device+0x18/0x24)
[<c0366c48>] (iommu_attach_device) from [<c001a470>] (arm_iommu_attach_device+0x18/0xd0)
[<c001a470>] (arm_iommu_attach_device) from [<c0225388>] (rockchip_drm_load+0xf0/0x198)
[<c0225388>] (rockchip_drm_load) from [<c0213cb0>] (drm_dev_register+0x80/0x100)
[<c0213cb0>] (drm_dev_register) from [<c022522c>] (rockchip_drm_bind+0x48/0x74)
[<c022522c>] (rockchip_drm_bind) from [<c022a9e4>] (try_to_bring_up_master.part.2+0xa4/0xf4)
[<c022a9e4>] (try_to_bring_up_master.part.2) from [<c022abe4>] (component_add+0x9c/0x104)
[<c022abe4>] (component_add) from [<c0230174>] (platform_drv_probe+0x48/0x90)
[<c0230174>] (platform_drv_probe) from [<c022ebc0>] (driver_probe_device+0x130/0x340)
[<c022ebc0>] (driver_probe_device) from [<c022ee38>] (__driver_attach+0x68/0x8c)
[<c022ee38>] (__driver_attach) from [<c022d28c>] (bus_for_each_dev+0x6c/0x80)
[<c022d28c>] (bus_for_each_dev) from [<c022e2b4>] (bus_add_driver+0xfc/0x1f0)
[<c022e2b4>] (bus_add_driver) from [<c022f4b0>] (driver_register+0x9c/0xe0)
[<c022f4b0>] (driver_register) from [<c00089d0>] (do_one_initcall+0x110/0x1bc)
[<c00089d0>] (do_one_initcall) from [<c05a7d20>] (kernel_init_freeable+0xfc/0x1c8)
[<c05a7d20>] (kernel_init_freeable) from [<c04171b4>] (kernel_init+0x8/0xe4)
[<c04171b4>] (kernel_init) from [<c000e878>] (ret_from_fork+0x14/0x3c)
Code: eb02c07d e5963140 e59f1234 e59f0234 (e5934058) 
---[ end trace 41e4f8e55e7119af ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b



[1]

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 56ffb76..959348f 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -708,8 +708,8 @@ static size_t rk_iommu_unmap(struct iommu_domain *domain, unsigned long _iova,
 static int rk_iommu_attach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
-	struct rk_iommu *iommu = dev_get_drvdata(dev->archdata.iommu);
 	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu *iommu;
 	unsigned long flags;
 	int ret;
 	phys_addr_t dte_addr;
@@ -718,9 +718,11 @@ static int rk_iommu_attach_device(struct iommu_domain *domain,
 	 * Allow 'virtual devices' (e.g., drm) to attach to domain.
 	 * Such a device has a NULL archdata.iommu.
 	 */
-	if (!iommu)
+	if (!dev->archdata.iommu)
 		return 0;
 
+	iommu = dev_get_drvdata(dev->archdata.iommu);
+
 	ret = rk_iommu_enable_stall(iommu);
 	if (ret)
 		return ret;
@@ -837,6 +839,32 @@ static void rk_iommu_domain_destroy(struct iommu_domain *domain)
 	domain->priv = NULL;
 }
 
+static int rk_iommu_add_device(struct device *dev)
+{
+	struct iommu_group *group;
+	int ret;
+
+	group = iommu_group_get(dev);
+
+	if (!group) {
+		group = iommu_group_alloc();
+		if (IS_ERR(group)) {
+			dev_err(dev, "Failed to allocate IOMMU group\n");
+			return PTR_ERR(group);
+		}
+	}
+
+	ret = iommu_group_add_device(group, dev);
+	iommu_group_put(group);
+
+	return ret;
+}
+
+static void rk_iommu_remove_device(struct device *dev)
+{
+	iommu_group_remove_device(dev);
+}
+
 static const struct iommu_ops rk_iommu_ops = {
 	.domain_init = rk_iommu_domain_init,
 	.domain_destroy = rk_iommu_domain_destroy,
@@ -845,6 +873,8 @@ static const struct iommu_ops rk_iommu_ops = {
 	.map = rk_iommu_map,
 	.unmap = rk_iommu_unmap,
 	.iova_to_phys = rk_iommu_iova_to_phys,
+	.add_device = rk_iommu_add_device,
+	.remove_device = rk_iommu_remove_device,
 	.pgsize_bitmap = RK_IOMMU_PGSIZE_BITMAP,
 };
 

