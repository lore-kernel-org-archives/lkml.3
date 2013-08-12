Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab3HLGbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:31:13 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:37427 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab3HLGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:31:12 -0400
Message-ID: <52088127.7070109@linux.vnet.ibm.com>
Date: Mon, 12 Aug 2013 14:31:03 +0800
From: yun wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Alessandro Rubini <rubini@gnudd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [fmc] BUG: scheduling while atomic: swapper/0/1/0x00000002
References: <20130811135232.GA16878@localhost>
In-Reply-To: <20130811135232.GA16878@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081206-8878-0000-0000-0000085B1A14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2013 09:52 PM, Fengguang Wu wrote:
> Alessandro,
>
> FYI, the bug still exists in the upstream and linux-next kernels.

And it's caused by:

	fc_probe(...) {
		...
		spin_lock(&fc_lock);
         	ret = misc_register(&fc->misc);
		...
	}

misc_register() will do schedule while spin_lock() disabled the pre-empt 
already.

Alessandro, if fc_lock won't be used in atomic context, may be make it a 
mutex-lock will be better ;-)

Regards,
Michael Wang

>
> commit 4debfe409b6e550032bfef9733e9f6f7c5613617
> Author: Alessandro Rubini <rubini@gnudd.com>
> Date:   Tue Jun 18 23:48:07 2013 +0200
>
>      FMC: add a char-device mezzanine driver
>
>      This driver exports the memory area associated with the mezzanine card
>      as a misc device, so users can access registers.
>
>      Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
>      Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
>      Acked-by: Emilio G. Cota <cota@braap.org>
>      Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
>      Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> [    1.209872] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.210978]  fake-fmc-carrier: mezzanine 0
> [    1.211567]       Manufacturer: fake-vendor
> [    1.212157]       Product name: fake-design-for-testing
> [    1.212857] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    1.213743] fmc_trivial: probe of fake-design-for-testing-f001 failed with error -95
> [    1.214811] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    1.215668] fmc_write_eeprom fake-design-for-testing-f001: fmc_write_eeprom: no busid passed, refusing all cards
> [    1.216982] fmc fake-design-for-testing-f001: Driver has no ID: matches all
> [    1.217870] BUG: scheduling while atomic: swapper/0/1/0x00000002
> [    1.218637] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc4-00592-gd92581f #282
> [    1.219689] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    1.220445]  0000000000000000 ffff88000d8e38b0 ffffffff81896829 ffff88000df11e40
> [    1.221711]  ffff88000d8e38c0 ffffffff81890b39 ffff88000d8e39c8 ffffffff8189c124
> [    1.222972]  ffff88000d8e3fd8 0000000000011e40 ffff88000d8e3fd8 0000000000000000
> [    1.224256] Call Trace:
> [    1.224680]  [<ffffffff81896829>] dump_stack+0x54/0x74
> [    1.225366]  [<ffffffff81890b39>] __schedule_bug+0x43/0x51
> [    1.226075]  [<ffffffff8189c124>] __schedule+0xa5/0x84b
> [    1.226775]  [<ffffffff810fc0d6>] ? __alloc_pages_nodemask+0x15c/0x7ed
> [    1.227616]  [<ffffffff813d6b99>] ? idr_get_empty_slot+0x220/0x337
> [    1.228400]  [<ffffffff813d76af>] ? ida_get_new_above+0xf9/0x189
> [    1.229170]  [<ffffffff8189c92a>] schedule+0x60/0x62
> [    1.229833]  [<ffffffff8189a88a>] schedule_timeout+0x2a/0x1a2
> [    1.230585]  [<ffffffff810b4348>] ? select_task_rq_fair+0x54a/0x6b0
> [    1.231376]  [<ffffffff8104ce99>] ? kvm_clock_read+0x2e/0x3f
> [    1.232102]  [<ffffffff8102b025>] ? sched_clock+0x9/0xd
> [    1.232792]  [<ffffffff8189cead>] wait_for_common+0x105/0x144
> [    1.233546]  [<ffffffff810afaa1>] ? try_to_wake_up+0x27f/0x27f
> [    1.234297]  [<ffffffff8189cf04>] wait_for_completion+0x18/0x1a
> [    1.235052]  [<ffffffff814cf593>] devtmpfs_create_node+0xe8/0x108
> [    1.235825]  [<ffffffff814c8e35>] device_add+0x1bb/0x5f7
> [    1.236526]  [<ffffffff813e1511>] ? kvasprintf+0x64/0x74
> [    1.237234]  [<ffffffff814c9286>] device_register+0x15/0x18
> [    1.237956]  [<ffffffff814c932f>] device_create_groups_vargs+0xa6/0xdb
> [    1.238770]  [<ffffffff814c9b49>] device_create_vargs+0x15/0x17
> [    1.239533]  [<ffffffff814c9b7a>] device_create+0x2f/0x31
> [    1.240248]  [<ffffffff81124bc1>] ? __kmalloc_track_caller+0x72/0x116
> [    1.241052]  [<ffffffff8189b690>] ? mutex_lock+0x1b/0x38
> [    1.241751]  [<ffffffff81495c4f>] misc_register+0xb3/0x103
> [    1.242468]  [<ffffffff816ddb06>] fc_probe+0x97/0x10a
> [    1.243135]  [<ffffffff816dbfaf>] fmc_probe+0x12/0x14
> [    1.243819]  [<ffffffff814cbf0a>] driver_probe_device+0x90/0x199
> [    1.244584]  [<ffffffff814cc0a3>] __driver_attach+0x58/0x7a
> [    1.245305]  [<ffffffff814cc04b>] ? __device_attach+0x38/0x38
> [    1.246039]  [<ffffffff814ca84c>] bus_for_each_dev+0x78/0x82
> [    1.246789]  [<ffffffff814cbe28>] driver_attach+0x19/0x1b
> [    1.247498]  [<ffffffff814cafc2>] bus_add_driver+0xf5/0x1fd
> [    1.248228]  [<ffffffff814cc585>] driver_register+0x8a/0xfb
> [    1.248944]  [<ffffffff816dc0ec>] fmc_driver_register+0x29/0x33
> [    1.249704]  [<ffffffff816ddb79>] ? fc_probe+0x10a/0x10a
> [    1.250411]  [<ffffffff816ddb89>] fc_init+0x10/0x12
> [    1.251063]  [<ffffffff81df3dab>] do_one_initcall+0x7f/0x10e
> [    1.251795]  [<ffffffff810a3100>] ? param_array_set+0xba/0xf4
> [    1.252537]  [<ffffffff810a331d>] ? parse_args+0x18e/0x246
> [    1.253250]  [<ffffffff81df3fcc>] kernel_init_freeable+0x192/0x218
> [    1.254041]  [<ffffffff81df373d>] ? do_early_param+0x88/0x88
> [    1.254776]  [<ffffffff8188815e>] ? rest_init+0x92/0x92
> [    1.255467]  [<ffffffff81888167>] kernel_init+0x9/0xd1
> [    1.256148]  [<ffffffff8189e9fc>] ret_from_fork+0x7c/0xb0
> [    1.256859]  [<ffffffff8188815e>] ? rest_init+0x92/0x92
> [    1.257553] fmc_chardev fake-design-for-testing-f001: Created misc device "fake-design-for-testing-f001"
>
>
> git bisect start c095ba7224d8edc71dcef0d655911399a8bd4a3f v3.10 --
> git bisect  bad 689c3db4d57a73bee6c5ad7797fce7b54d32a87c  # 14:17      0-  CIFS: Fix a deadlock when a file is reopened
> git bisect  bad ee1a8d402e7e204d57fb108aa40003b6d1633036  # 14:21      0-  Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good ce49b6289fa3878b190f15192e54bb23dca552b6  # 17:05     25+  Merge tag 'staging-3.11-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
> git bisect good 1eb92b24e243085d242cf5ffd64829bba70972e1  # 17:12     25+  ARM: integrator: let pciv3 use mem/premem from device tree
> git bisect good 076919a6e0154f06221e02f9e58b14eb1ed9e019  # 17:23     25+  Merge branch 'for_3.11/dts' of git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt into next/dt
> git bisect  bad 22237d5a588cfad92525d2998ff14d3666399dce  # 17:29      0-  Merge tag 'fixes-non-critical-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect  bad 2608fb653103419ac163206ff6d51b7b6528e2d9  # 17:33      0-  drivers: hv: allocate synic structures before hv_synic_init()
> git bisect good c265a0d5152619bddcf1986f17995d2df6781554  # 17:40     25+  pcie-gadget-spear: fix error return code in spear_pcie_gadget_probe()
> git bisect good ea6add0bf1a209a3eab725e4429b1ac4e4cdef73  # 17:54     25+  pcmcia: Remove ARCH_CLPS711X dependency
> git bisect good 022c674728f45ad22ce2bb5eb628ac9d3dbc3aea  # 18:19     25+  FMC: add documentation for the core
> git bisect  bad e3a3c3a205554e564751cd9c0276b2af813d7a92  # 18:24      0-  UIO: fix uio_pdrv_genirq with device tree but no interrupt
> git bisect good 6007b1bd0f752a5c022f7944c65fb96c39d6db3d  # 18:32     25+  FMC: add a driver to write mezzanine EEPROM
> git bisect  bad 05c3e0bb5629b897b0459e4bfb1b93d729033b99  # 18:37      0-  UIO: allow binding uio_pdrv_genirq.c to devices using command line option
> git bisect  bad 4debfe409b6e550032bfef9733e9f6f7c5613617  # 18:46      0-  FMC: add a char-device mezzanine driver
> git bisect good 6007b1bd0f752a5c022f7944c65fb96c39d6db3d  # 21:29     75+  FMC: add a driver to write mezzanine EEPROM
> git bisect  bad dcd86c25b2f19adec9d44033ae4b03861ee5f9c3  # 21:30      0-  Merge remote-tracking branch 'kgene-samsung/for-next' into devel-snb-x86_64-201308061051
> git bisect  bad d92581fcad188d38a5c82c01ace43623bcafea48  # 21:36      0-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
>
> Thanks,
> Fengguang
>

