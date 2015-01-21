Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbbAULXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:23:39 -0500
Received: from down.free-electrons.com ([37.187.137.238]:35930 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751502AbbAULXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:23:31 -0500
Message-ID: <54BF8C2A.6070800@free-electrons.com>
Date: Wed, 21 Jan 2015 12:23:22 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thierry Reding <treding@nvidia.com>
CC: Paul Walmsley <paul@pwsan.com>, Tejun Heo <tj@kernel.org>,
        hdegoede@redhat.com, pwalmsley@nvidia.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: next-20150120 broken on Tegra by "ata: libahci: Allow using multiple
 regulators"
References: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com> <20150121105001.GA9921@ulmo.nvidia.com>
In-Reply-To: <20150121105001.GA9921@ulmo.nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On 21/01/2015 11:50, Thierry Reding wrote:
> On Wed, Jan 21, 2015 at 12:03:41AM +0000, Paul Walmsley wrote:
>> (linux-ide@ added)
>>
>> Commit c7d7ddee7e24eedde6149eefbcfbfbc7125b9ff0 ("ata: libahci: Allow
>> using multiple regulators") in Linux-next 20150120 causes a panic
>> during boot on multiple Tegra boards:
>>
>> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra30-beaver/tegra30-beaver/tegra_defconfig_log.txt
>> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra114-dalmore-a04/tegra114-dalmore/tegra_defconfig_log.txt
>> http://nvt.pwsan.com/experimental/linux-next/testlogs/test_next-20150120/20150120001539/boot/tegra124-jetson-tk1/tegra124-jetson-tk1/tegra_defconfig_log.txt
>>
>> Taking the latter boot log as an example, the 6b6b6b9f value that the 
>> kernel is trying to dereference is being passed into _regulator_put() as a 
>> struct regulator *.
>>
>>
>> - Paul
>>
> 
> Here's the devres log of what's happening:
> 
> 	[    4.949689] tegra-ahci 70027000.sata: DEVRES ADD ee1e2a00 devm_kzalloc_release (16 bytes)
> 	[    4.957886] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 devm_pinctrl_release (4 bytes)
> 	[    4.965984] tegra-ahci 70027000.sata: DEVRES REM ee1e29c0 devm_pinctrl_release (4 bytes)
> 	[    4.974079] tegra-ahci 70027000.sata: DEVRES REM ee1e2a00 devm_kzalloc_release (16 bytes)
> 	[    4.982298] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 grp< (0 bytes)
> 	[    4.989006] tegra-ahci 70027000.sata: DEVRES ADD ee1dae00 ahci_platform_put_resources (96 bytes)
> 	[    4.997784] tegra-ahci 70027000.sata: DEVRES ADD ee1e2980 devm_region_release (12 bytes)
> 	[    5.005879] tegra-ahci 70027000.sata: DEVRES ADD ee1e2900 devm_ioremap_release (4 bytes)
> 	[    5.014005] tegra-ahci 70027000.sata: DEVRES ADD ee1e28c0 devm_kzalloc_release (4 bytes)
> 	[    5.022096] tegra-ahci 70027000.sata: DEVRES ADD ee1e2880 devm_kzalloc_release (4 bytes)
> 	[    5.030209] tegra-ahci 70027000.sata: DEVRES ADD ee1e2840 devm_phy_release (4 bytes)
> 	[    5.037952] tegra-ahci 70027000.sata: DEVRES REM ee1e29c0 grp< (0 bytes)
> 	[    5.044660] tegra-ahci 70027000.sata: DEVRES ADD ee1dad80 devm_kzalloc_release (84 bytes)
> 	[    5.052845] tegra-ahci 70027000.sata: DEVRES ADD ee1e29c0 devm_region_release (12 bytes)
> 	[    5.060938] tegra-ahci 70027000.sata: DEVRES ADD ee1e2f80 devm_ioremap_release (4 bytes)
> 	[    5.069039] tegra-ahci 70027000.sata: DEVRES ADD ee1e2f40 devm_reset_control_release (4 bytes)
> 	[    5.077647] tegra-ahci 70027000.sata: DEVRES ADD ee1e2ec0 devm_reset_control_release (4 bytes)
> 	[    5.086271] tegra-ahci 70027000.sata: DEVRES ADD ee1e2e40 devm_reset_control_release (4 bytes)
> 	[    5.094890] tegra-ahci 70027000.sata: DEVRES ADD ee1e2dc0 devm_clk_release (4 bytes)
> 	[    5.102659] tegra-ahci 70027000.sata: Failed to get supply 'avdd': -517
> 	[    5.109276] tegra-ahci 70027000.sata: Failed to get regulators
> 	[    5.115103] tegra-ahci 70027000.sata: DEVRES REL ee1e2dc0 devm_clk_release (4 bytes)
> 	[    5.122850] tegra-ahci 70027000.sata: DEVRES REL ee1e2e40 devm_reset_control_release (4 bytes)
> 	[    5.131462] tegra-ahci 70027000.sata: DEVRES REL ee1e2ec0 devm_reset_control_release (4 bytes)
> 	[    5.140073] tegra-ahci 70027000.sata: DEVRES REL ee1e2f40 devm_reset_control_release (4 bytes)
> 	[    5.148672] tegra-ahci 70027000.sata: DEVRES REL ee1e2f80 devm_ioremap_release (4 bytes)
> 	[    5.156764] tegra-ahci 70027000.sata: DEVRES REL ee1e29c0 devm_region_release (12 bytes)
> 	[    5.164856] tegra-ahci 70027000.sata: DEVRES REL ee1dad80 devm_kzalloc_release (84 bytes)
> 	[    5.173034] tegra-ahci 70027000.sata: DEVRES REL ee1e2840 devm_phy_release (4 bytes)
> 	[    5.180778] tegra-ahci 70027000.sata: DEVRES REL ee1e2880 devm_kzalloc_release (4 bytes)
> 	[    5.188868] tegra-ahci 70027000.sata: DEVRES REL ee1e28c0 devm_kzalloc_release (4 bytes)
> 	[    5.196948] tegra-ahci 70027000.sata: DEVRES REL ee1e2900 devm_ioremap_release (4 bytes)
> 	[    5.205037] tegra-ahci 70027000.sata: DEVRES REL ee1e2980 devm_region_release (12 bytes)
> 	[    5.213129] tegra-ahci 70027000.sata: DEVRES REL ee1dae00 ahci_platform_put_resources (96 bytes)
> 
> What's happening here is that ahci_platform_put_resources() is added to
> the devres list before the devm_kzalloc() that allocates the target_pwrs
> array, which causes the target_pwrs array to be freed before devres gets
> to call ahci_platform_put_resources().
> 
> Mixing managed and non-managed resources this way doesn't work, so I had
> to apply the attached patch to fix this.
> 
> Tejun, preferably the attached patch should be squashed into commit
> c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators") to avoid
> breaking bisectability. If you don't want to rewrite history, let me
> know and I can turn it into a proper patch.

Thanks having took care of it. I tested your patch and it didn't introduce
any regression on the board I tested.

Gregory


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
