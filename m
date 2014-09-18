Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbaIRDc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 23:32:26 -0400
Received: from mail-bl2on0142.outbound.protection.outlook.com ([65.55.169.142]:58730
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757154AbaIRDcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 23:32:23 -0400
X-Greylist: delayed 65250 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 23:32:23 EDT
Date: Thu, 18 Sep 2014 11:05:55 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kgene.kim@samsung.com>, <linux@arm.linux.org.uk>, <arnd@arndb.de>,
        <naushad@samsung.com>, <tomasz.figa@gmail.com>, <joshi@samsung.com>,
        <thomas.ab@samsung.com>, <vikas.sajjan@samsung.com>,
        <chow.kim@samsung.com>, <lee.jones@linaro.org>,
        "'Boris BREZILLON'" <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH v3] mfd: syscon: Decouple syscon interface from
 platform devices
Message-ID: <20140918030552.GA26661@shlinux1.ap.freescale.net>
References: <1410935510-1567-1-git-send-email-pankaj.dubey@samsung.com>
 <20140917085818.GA10285@shlinux1.ap.freescale.net>
 <000401cfd269$922dfc40$b689f4c0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <000401cfd269$922dfc40$b689f4c0$@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(199003)(51704005)(24454002)(189002)(107046002)(99396002)(64706001)(105606002)(15975445006)(26826002)(110136001)(33656002)(575784001)(50466002)(15202345003)(92566001)(97736003)(21056001)(20776003)(83322001)(95666004)(79102003)(83072002)(104016003)(77982003)(76176999)(46102003)(74662003)(97756001)(68736004)(19580405001)(92726001)(6806004)(47776003)(83506001)(106466001)(90102001)(44976005)(81342003)(54356999)(102836001)(19580395003)(84676001)(85852003)(76482002)(4396001)(46406003)(85306004)(31966008)(80022003)(23726002)(74502003)(81542003)(50986999)(87936001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Aisheng.Dong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 04:50:50PM +0530, Pankaj Dubey wrote:
> Hi,
> 
> On Wednesday, September 17, 2014, Dong Aisheng Wrote,
> > >
> > > +static struct syscon *of_syscon_register(struct device_node *np) {
> > > +	struct syscon *syscon;
> > > +	struct regmap *regmap;
> > > +	void __iomem *base;
> > > +
> > > +	if (!of_device_is_compatible(np, "syscon"))
> > > +		return ERR_PTR(-EINVAL);
> > > +
> > > +	syscon = kzalloc(sizeof(*syscon), GFP_KERNEL);
> > > +	if (!syscon)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	base = of_iomap(np, 0);
> > > +	if (!base)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	regmap = regmap_init_mmio(NULL, base, &syscon_regmap_config);
> > 
> > Does a NULL device pointer work?
> 
> Yes, it is safe, at least we are able to test on Exynos based SoC. 
> I have tested it with kgene/for-next kernel on Exynos3250.
> Also it has been tested on Exynos5250 based Snow board with 3.17-rc5 based
> kernel
> by Vivek Gautam. 
> 
> Patch V2 also has been tested by "Borris Brezillon" on AT91 platform.
> 
> 

The kernel i tested was next-20140915 of linux-next.

please see regmap_get_val_endian called in regmap_init function.
static enum regmap_endian regmap_get_val_endian(struct device *dev,
                                        const struct regmap_bus *bus,
                                        const struct regmap_config *config)
{
        struct device_node *np = dev->of_node;
        enum regmap_endian endian;
...
}
It will crash at the first line of dev->of_node if dev is NULL.

Can you check if you're using the same code as mine?

> > I just tested on MX6SX SDB board and it seemed crashed at here in
> regmap_init
> > function.
> > 
> 
> Can you please provide crash log which can give more information about the
> crash?
> 

My crash log is:

[    0.225148] Unable to handle kernel NULL pointer dereference at virtual address 000001d4
[    0.233383] pgd = 80004000
[    0.236185] [000001d4] *pgd=00000000
[    0.239873] Internal error: Oops: 5 [#1] SMP ARM
[    0.244588] Modules linked in:
[    0.247753] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc4-next-20140915-00006-g8ba2dd0-dirty #421
[    0.257342] task: bd878000 ti: bd880000 task.ti: bd880000
[    0.262848] PC is at regmap_init+0x21c/0xab4
[    0.267221] LR is at vprintk_emit+0x254/0x5e0
[    0.271677] pc : [<80389420>]    lr : [<8006a4f8>]    psr: 60000153
[    0.271677] sp : bd881ae0  ip : bd881a48  fp : bd881b1c
[    0.283354] r10: 00000000  r9 : bd8e1850  r8 : 00000003
[    0.288678] r7 : 00000000  r6 : 8098fccc  r5 : 8098ee0c  r4 : bd8f4e00
[    0.295307] r3 : bd878000  r2 : 000001e5  r1 : 806ee8f0  r0 : 808762c0
[    0.301938] Flags: nZCv  IRQs on  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    0.309438] Control: 10c5387d  Table: 8000404a  DAC: 00000015
[    0.315284] Process swapper/0 (pid: 1, stack limit = 0xbd880240)
[    0.321391] Stack: (0xbd881ae0 to 0xbd882000)
[    0.325851] 1ae0: bd8e1850 00000000 bd881b1c bd881af8 8038f580 8098fccc 00000000 be7d49b8
[    0.334136] 1b00: 8098fca4 bd917000 bd8e1850 00000000 bd881b34 bd881b20 8038f68c 80389210
[    0.342422] 1b20: bd91b480 8098fcc4 bd881b5c bd881b38 80398b24 8038f664 00000000 bd91ac10
[    0.350708] 1b40: be7d4bc0 bd917010 bd917000 bd8e1850 bd881bac bd881b60 803185a4 80398a54
[    0.358993] 1b60: bd881b94 bd881b70 00000000 00000000 00000000 00000000 00000000 00000000
[    0.367277] 1b80: 00000000 00000000 bd917010 80983a64 00000000 bd916c10 80983a64 00000000
[    0.375563] 1ba0: bd881bc4 bd881bb0 8037bb44 80318510 811c65f0 bd917010 bd881bec bd881bc8
[    0.383848] 1bc0: 8037a104 8037bb1c 80983a64 bd917010 8037a23c bd916c10 00000000 00000000
[    0.392134] 1be0: bd881c04 bd881bf0 8037a284 8037a004 00000000 bd917010 bd881c2c bd881c08
[    0.400419] 1c00: 80378614 8037a248 bd8038d8 bd8af7d4 bd916c10 bd917010 bd917044 8098e308
[    0.408704] 1c20: bd881c4c bd881c30 80379fb8 803785c0 bd803800 bd917018 bd917010 8098e308
[    0.416990] 1c40: bd881c6c bd881c50 8037961c 80379f48 00000000 bd917018 00000000 bd917010
[    0.425275] 1c60: bd881ca4 bd881c70 80377904 80379598 bd881cc8 bd881cc0 bd881cb8 bd881c88
[    0.433560] 1c80: be7d4bc0 bd916c10 00000000 00000001 bd917000 be7d4c10 bd881cb4 bd881ca8
[    0.441845] 1ca0: 804f1708 803774e8 bd881cfc bd881cb8 804f1f2c 804f16dc bd881cdc bd881cc8
[    0.450130] 1cc0: 806b6d7c 80060478 809b0220 60000153 bd881cfc 00000000 be7d4bc0 00000000
[    0.458415] 1ce0: 00000001 8070bb80 bd916c10 00000000 bd881d5c bd881d00 804f2068 804f1e5c
[    0.466700] 1d00: bd878000 a0000153 809b0220 00000000 bd881d2c bd881d20 80060480 80060284
[    0.474985] 1d20: bd881d44 bd881d30 806b6d7c 80060478 00000000 be7d4bc0 be7d49b8 00000000
[    0.483270] 1d40: 00000001 8070bb80 bd916c10 00000000 bd881dbc bd881d60 804f20c4 804f1f8c
[    0.491556] 1d60: 00000001 60000153 809b0220 00000000 bd881d8c bd881d80 80060480 80060284
[    0.499841] 1d80: bd881da4 bd881d90 806b6d7c 80060478 be7d46f8 be7d49b8 be7cf764 00000000
[    0.508126] 1da0: 00000001 8070bb80 bd910810 00000000 bd881e1c bd881dc0 804f20c4 804f1f8c
[    0.516411] 1dc0: 00000001 60000153 809b0220 00000000 bd881dec bd881de0 80060480 80060284
[    0.524696] 1de0: bd881e04 bd881df0 806b6d7c 80060478 be7cf3a8 be7cf764 be7ce930 00000000
[    0.532981] 1e00: 00000001 8070bb80 bd90b010 00000000 bd881e7c bd881e20 804f20c4 804f1f8c
[    0.541266] 1e20: 00000001 60000153 809b0220 00000000 bd881e4c bd881e40 80060480 80060284
[    0.549552] 1e40: bd881e64 bd881e50 806b6d7c 80060478 be7cde48 be7ce930 be7cca4c 8070bb80
[    0.557837] 1e60: 00000000 bd90a800 00000001 80947f80 bd881eac bd881e80 804f2250 804f1f8c
[    0.566122] 1e80: 00000001 80903738 809660a0 809660a0 bd8e7f00 809c05c0 80903738 00000000
[    0.574408] 1ea0: bd881ec4 bd881eb0 8091c654 804f21f8 809660a0 bd8e7f00 bd881ed4 bd881ec8
[    0.582693] 1ec0: 8090375c 8091c620 bd881f54 bd881ed8 80008b7c 80903744 bd881ef4 bd881ee8
[    0.590978] 1ee0: bd881f0c bd881ef0 bd881f00 bd881ef8 809005e8 befffa86 806d20c0 000000cc
[    0.599263] 1f00: bd881f54 bd881f10 80044908 809005f4 00000000 00000003 00000003 befffa91
[    0.607548] 1f20: 808fd3c0 00000000 bd878000 80954be4 00000003 809c05c0 809c05c0 80947f68
[    0.615833] 1f40: 000000cc 80947f80 bd881f94 bd881f58 80900e0c 80008b00 00000003 00000003
[    0.624118] 1f60: 809005e8 00000000 80049408 00000000 806aac88 00000000 00000000 00000000
[    0.632403] 1f80: 00000000 00000000 bd881fac bd881f98 806aac98 80900d00 00000000 00000000
[    0.640688] 1fa0: 00000000 bd881fb0 8000ece8 806aac94 00000000 00000000 00000000 00000000
[    0.648972] 1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    0.657257] 1fe0: 00000000 00000000 00000000 00000000 00000013 00000000 44488040 80000600
[    0.665537] Backtrace:
[    0.668100] [<80389204>] (regmap_init) from [<8038f68c>] (regmap_init_mmio_clk+0x34/0x40)
[    0.676381]  r10:00000000 r9:bd8e1850 r8:bd917000 r7:8098fca4 r6:be7d49b8 r5:00000000
[    0.684374]  r4:8098fccc
[    0.687021] [<8038f658>] (regmap_init_mmio_clk) from [<80398b24>] (syscon_node_to_regmap+0xdc/0x168)
[    0.696260]  r5:8098fcc4 r4:bd91b480
[    0.699963] [<80398a48>] (syscon_node_to_regmap) from [<803185a4>] (anatop_regulator_probe+0xa0/0x3a8)
[    0.709376]  r9:bd8e1850 r8:bd917000 r7:bd917010 r6:be7d4bc0 r5:bd91ac10 r4:00000000
[    0.717292] [<80318504>] (anatop_regulator_probe) from [<8037bb44>] (platform_drv_probe+0x34/0x64)
[    0.726356]  r9:00000000 r8:80983a64 r7:bd916c10 r6:00000000 r5:80983a64 r4:bd917010
[    0.734267] [<8037bb10>] (platform_drv_probe) from [<8037a104>] (driver_probe_device+0x10c/0x244)
[    0.743244]  r5:bd917010 r4:811c65f0
[    0.746942] [<80379ff8>] (driver_probe_device) from [<8037a284>] (__device_attach+0x48/0x4c)
[    0.755483]  r9:00000000 r8:00000000 r7:bd916c10 r6:8037a23c r5:bd917010 r4:80983a64
[    0.763392] [<8037a23c>] (__device_attach) from [<80378614>] (bus_for_each_drv+0x60/0x94)
[    0.771673]  r5:bd917010 r4:00000000
[    0.775370] [<803785b4>] (bus_for_each_drv) from [<80379fb8>] (device_attach+0x7c/0x94)
[    0.783477]  r6:8098e308 r5:bd917044 r4:bd917010
[    0.788230] [<80379f3c>] (device_attach) from [<8037961c>] (bus_probe_device+0x90/0xb8)
[    0.796336]  r6:8098e308 r5:bd917010 r4:bd917018 r3:bd803800
[    0.802144] [<8037958c>] (bus_probe_device) from [<80377904>] (device_add+0x428/0x528)
[    0.810164]  r6:bd917010 r5:00000000 r4:bd917018 r3:00000000
[    0.815978] [<803774dc>] (device_add) from [<804f1708>] (of_device_add+0x38/0x40)
[    0.823563]  r9:be7d4c10 r8:bd917000 r7:00000001 r6:00000000 r5:bd916c10 r4:be7d4bc0
[    0.831475] [<804f16d0>] (of_device_add) from [<804f1f2c>] (of_platform_device_create_pdata+0xdc/0x114)
[    0.840983] [<804f1e50>] (of_platform_device_create_pdata) from [<804f2068>] (of_platform_bus_create+0xe8/0x198)
[    0.851264]  r10:00000000 r9:bd916c10 r8:8070bb80 r7:00000001 r6:00000000 r5:be7d4bc0
[    0.859255]  r4:00000000
[    0.861899] [<804f1f80>] (of_platform_bus_create) from [<804f20c4>] (of_platform_bus_create+0x144/0x198)
[    0.871485]  r10:00000000 r9:bd916c10 r8:8070bb80 r7:00000001 r6:00000000 r5:be7d49b8
[    0.879476]  r4:be7d4bc0
[    0.882119] [<804f1f80>] (of_platform_bus_create) from [<804f20c4>] (of_platform_bus_create+0x144/0x198)
[    0.891704]  r10:00000000 r9:bd910810 r8:8070bb80 r7:00000001 r6:00000000 r5:be7cf764
[    0.899695]  r4:be7d49b8
[    0.902339] [<804f1f80>] (of_platform_bus_create) from [<804f20c4>] (of_platform_bus_create+0x144/0x198)
[    0.911925]  r10:00000000 r9:bd90b010 r8:8070bb80 r7:00000001 r6:00000000 r5:be7ce930
[    0.919916]  r4:be7cf764
[    0.922559] [<804f1f80>] (of_platform_bus_create) from [<804f2250>] (of_platform_populate+0x64/0xa8)
[    0.931797]  r10:80947f80 r9:00000001 r8:bd90a800 r7:00000000 r6:8070bb80 r5:be7cca4c
[    0.939788]  r4:be7ce930
[    0.942435] [<804f21ec>] (of_platform_populate) from [<8091c654>] (imx6sx_init_machine+0x40/0x58)
[    0.951412]  r9:00000000 r8:80903738 r7:809c05c0 r6:bd8e7f00 r5:809660a0 r4:809660a0
[    0.959326] [<8091c614>] (imx6sx_init_machine) from [<8090375c>] (customize_machine+0x24/0x48)
[    0.968051] [<80903738>] (customize_machine) from [<80008b7c>] (do_one_initcall+0x88/0x1e0)
[    0.976513] [<80008af4>] (do_one_initcall) from [<80900e0c>] (kernel_init_freeable+0x118/0x1dc)
[    0.985315]  r10:80947f80 r9:000000cc r8:80947f68 r7:809c05c0 r6:809c05c0 r5:00000003
[    0.993306]  r4:80954be4
[    0.995949] [<80900cf4>] (kernel_init_freeable) from [<806aac98>] (kernel_init+0x10/0xf4)
[    1.004230]  r10:00000000 r9:00000000 r8:00000000 r7:00000000 r6:00000000 r5:806aac88
[    1.012221]  r4:00000000
[    1.014865] [<806aac88>] (kernel_init) from [<8000ece8>] (ret_from_fork+0x14/0x2c)
[    1.022537]  r4:00000000 r3:00000000
[    1.026234] Code: eb0c9207 e59f27e0 e59f07d8 e59f17cc (e59791d4)
[    1.032484] ---[ end trace 560f6f42d35d980a ]---
[    1.037231] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    1.037231]
[    1.046566] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    1.046566]
[   83.483571] random: nonblocking pool is initialized

Regards
Dong Aisheng

> 
> Thanks,
> Pankaj Dubey
> 
> > Regards
> > Dong Aisheng
> > 
> > > +	if (IS_ERR(regmap)) {
> > > +		pr_err("regmap init failed\n");
> > > +		return ERR_CAST(regmap);
> > > +	}
> > > +
> > > +	syscon->regmap = regmap;
> > > +	syscon->np = np;
> > > +
> > > +	spin_lock(&syscon_list_slock);
> > > +	list_add_tail(&syscon->list, &syscon_list);
> > > +	spin_unlock(&syscon_list_slock);
> > > +
> > > +	return syscon;
> > > +}
> > > +
> > >  static int syscon_probe(struct platform_device *pdev)  {
> > >  	struct device *dev = &pdev->dev;
> > > @@ -167,7 +204,6 @@ static struct platform_driver syscon_driver = {
> > >  	.driver = {
> > >  		.name = "syscon",
> > >  		.owner = THIS_MODULE,
> > > -		.of_match_table = of_syscon_match,
> > >  	},
> > >  	.probe		= syscon_probe,
> > >  	.id_table	= syscon_ids,
> > > --
> > > 1.7.9.5
> > >
> > >
> > > _______________________________________________
> > > linux-arm-kernel mailing list
> > > linux-arm-kernel@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
