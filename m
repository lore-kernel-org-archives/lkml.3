Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbaDCUkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:40:24 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:56766 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaDCUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
References: <1395179766-31575-1-git-send-email-pantelis.antoniou@konsulko.com>
	<CANk1AXTb=ob52AfK2z--HvFkxJnjnfYWuTCch_Gw99OCoS1ABg@mail.gmail.com>
Date: Thu, 3 Apr 2014 15:40:16 -0500
Message-ID: <CANk1AXRAsktOcfpMO7DzvenmUmZ_hUERkqa3nkKsqrGXn6eM=A@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Introducing (yet again) Device Tree Overlays
From: delicious quinoa <delicious.quinoa@gmail.com>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 1:27 PM, delicious quinoa
<delicious.quinoa@gmail.com> wrote:
> On Tue, Mar 18, 2014 at 4:55 PM, Pantelis Antoniou
> <pantelis.antoniou@konsulko.com> wrote:
>> The following patchset introduces Device Tree overlays, a method
>> of dynamically altering the kernel's live Device Tree, along with
>> a generic interface to use it in a board agnostic manner.
>>
>> It is dependent on Grant Likely's DT kobjectification patches located
>> in his tree as queued for -next.
>>
>> It relies on the following previously submitted patches/patchsets:
>>
>> * OF: Add [__]of_find_node_by_full_name
>> * OF: Utility helper functions for dynamic nodes
>> * of: Make of_find_node_by_path() handle /aliases
>>
>> To compile overlays you need the DTC compiler patch
>>
>> * "dtc: Dynamic symbols & fixup support (v2)"
>>
>> Changes since V2:
>> * Use of a configfs board agnostic overlay method
>> * Use of per bus handlers instead of hardcoded behaviour
>> * Optional target-path overlay target, which allows one to use standard
>> DTBs without resolution options.
>>
>> Changes since V1:
>>
>> * Removal of any bits related to a specific board (beaglebone).
>> * Introduced a platform agnostic interface using /proc/device-tree-overlay
>> * Various bug fixes related to i2c device handling have been squashed in.
>>
>>
>> Pantelis Antoniou (7):
>>   OF: Introduce Device Tree resolve support.
>>   OF: Introduce DT overlay support.
>>   OF: DT-Overlay configfs interface
>>   OF: platform: Add overlay bus handler
>>   OF: i2c: Add overlay bus handler
>>   OF: spi: Add overlay bus handler
>>   of: i2c: Export single device registration method
>>
>>  .../devicetree/dynamic-resolution-notes.txt        |  25 +
>>  Documentation/devicetree/overlay-notes.txt         | 187 +++++
>>  drivers/base/platform.c                            |  99 ++-
>>  drivers/i2c/i2c-core.c                             | 186 +++--
>>  drivers/of/Kconfig                                 |  24 +
>>  drivers/of/Makefile                                |   3 +
>>  drivers/of/configfs.c                              | 272 +++++++
>>  drivers/of/overlay.c                               | 895 +++++++++++++++++++++
>>  drivers/of/resolver.c                              | 376 +++++++++
>>  drivers/spi/spi.c                                  | 345 +++++---
>>  include/linux/i2c.h                                |  10 +
>>  include/linux/of.h                                 | 170 ++++
>>  12 files changed, 2440 insertions(+), 152 deletions(-)
>>  create mode 100644 Documentation/devicetree/dynamic-resolution-notes.txt
>>  create mode 100644 Documentation/devicetree/overlay-notes.txt
>>  create mode 100644 drivers/of/configfs.c
>>  create mode 100644 drivers/of/overlay.c
>>  create mode 100644 drivers/of/resolver.c
>
> I can get a NULL pointer when I apply and remove an overlay and the
> conditions are right.  The overlay applies correctly.  The crash is
> when I do the rmdir.  My overlay is:
>
> /dts-v1/;
> /plugin/;
> / {
>     fragment@0 {
>         target-path="/soc";
>         __overlay__ {
>             #address-cells = <1>;
>                     #size-cells = <1>;
>             agpio0: agpio0 {
>                 compatible = "altr,pio-1.0";
>                 reg = <0xff210040 0x10>;

Added some printks and got a bit further with debug.  If I leave this
as-is, the platform device has 2 resources. We get the NULL pointer in
__release_resource() when releasing the first one (reg). If I remove
this one line ('reg =') the crash goes away.  So in this case, we are
ok when releasing an irq resource but get a NULL pointer when removing
a reg resource.  Don't know why at this point.

>                 interrupts = <0 45 4>;
>                 altr,gpio-bank-width = <32>;
>                 altr,interrupt_type = <1>;
>                 #gpio-cells = <2>;
>                 gpio-controller;
>                 #interrupt-cells = <1>;
>                 interrupt-controller;
>             };
>         };
>     };
> };
>
> The log info I have is:
>
> root@socfpga_cyclone5:~# ./do-overlay-only
> + mkdir /config/device-tree/overlays/foo
> + echo socfpga_overlay.dtbo
> + rmdir /config/device-tree/overlays/foo
> Unable to handle kernel NULL pointer dereference at virtual address 00000018
> pgd = bf164000
> [00000018] *pgd=3fb9c831, *pte=00000000, *ppte=00000000
> Internal error: Oops: 17 [#1] SMP ARM
> Modules linked in:
> CPU: 1 PID: 175 Comm: rmdir Not tainted 3.13.0-00299-g2e61581 #7
> task: bf00f400 ti: bfba4000 task.ti: bfba4000
> PC is at release_resource+0x24/0x98
> LR is at release_resource+0x20/0x98
> pc : [<800286e0>]    lr : [<800286dc>]    psr: 60000013
> sp : bfba5da0  ip : bfba5da0  fp : bfba5db4
> r10: 00100100  r9 : 00000000  r8 : 00200200
> r7 : 80732ff8  r6 : 00000001  r5 : bfbb8400  r4 : bfbd1100
> r3 : 00000000  r2 : 00000000  r1 : 00000002  r0 : 8074e580
> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 10c5387d  Table: 3f16404a  DAC: 00000015
> Process rmdir (pid: 175, stack limit = 0xbfba4248)
> Stack: (0xbfba5da0 to 0xbfba6000)
> 5da0: 00000000 00000001 bfba5dcc bfba5db8 802f2e40 800286c8 bfbb8400 bfb930c0
> 5dc0: bfba5de4 bfba5dd0 802f31e0 802f2dd0 bfbb8434 bfbb8400 bfba5dfc bfba5de8
> 5de0: 802f3224 802f31d0 802f31ec 807410ac bfba5e24 bfba5e00 803b4f20 802f31f8
> 5e00: bfb930c0 bfbe61a8 bfbe61a8 bfbe6180 00200200 00100100 bfba5e4c bfba5e28
> 5e20: 803b4fec 803b4e68 bfbe6140 ffffffff bfbe6188 00000000 80782dd4 80741108
> 5e40: bfba5e6c bfba5e50 803b51ec 803b4f94 00001040 bf82e000 807410b4 00000000
> 5e60: bfba5e84 bfba5e70 803b57f0 803b51b4 803b5778 bf82e018 bfba5ea4 bfba5e88
> 5e80: 80161df8 803b5784 00000000 00000000 bf82e000 bfb26070 bfba5eb4 bfba5ea8
> 5ea0: 80161e64 80161d9c bfba5eec bfba5eb8 8016071c 80161e28 80110da0 8010efbc
> 5ec0: bf59a198 bf59a198 00000000 bf5543f0 7e96ef14 ffffff9c bfba4000 bf59a198
> 5ee0: bfba5f0c bfba5ef0 801086e4 8016054c bf5533b8 bf128000 00000000 00000000
> 5f00: bfba5f94 bfba5f10 80108870 80108650 bf8e3010 bf5533b8 006f6f66 00000003
> 5f20: bf12802d 80107348 00000000 bf576660 bf5543f0 00000000 00000004 00000060
> 5f40: 00000000 00000000 bfba5f64 bfba5f58 800fcb1c 8003f114 bfba5f84 bfba5f68
> 5f60: 8003f114 804d1630 bfba4000 bfba4000 7e96ef14 00000000 7e96ee28 00000028
> 5f80: 8000ece4 00000000 bfba5fa4 bfba5f98 8010a800 8010875c 00000000 bfba5fa8
> 5fa0: 8000eac0 8010a7ec 7e96ef14 00000000 7e96ef14 00000000 00000002 7e96ee28
> 5fc0: 7e96ef14 00000000 7e96ee28 00000028 00000002 7e96ee24 0006a754 00000000
> 5fe0: 76f3d450 7e96ec74 0003c2e5 76f3d45c 80000010 7e96ef14 00000000 00000000
> [<800286e0>] (release_resource+0x24/0x98) from [<802f2e40>]
> (platform_device_del+0x7c/0xac)
> [<802f2e40>] (platform_device_del+0x7c/0xac) from [<802f31e0>]
> (platform_device_unregister+0x1c/0x28)
> [<802f31e0>] (platform_device_unregister+0x1c/0x28) from [<802f3224>]
> (platform_handler_remove+0x38/0x54)
> [<802f3224>] (platform_handler_remove+0x38/0x54) from [<803b4f20>]
> (of_overlay_device_entry_change.isra.0+0xc4/0x12c)
> [<803b4f20>] (of_overlay_device_entry_change.isra.0+0xc4/0x12c) from
> [<803b4fec>] (of_overlay_revert_one+0x64/0x220)
> [<803b4fec>] (of_overlay_revert_one+0x64/0x220) from [<803b51ec>]
> (of_overlay_revert+0x44/0x64)
> [<803b51ec>] (of_overlay_revert+0x44/0x64) from [<803b57f0>]
> (cfs_overlay_release+0x78/0x7c)
> [<803b57f0>] (cfs_overlay_release+0x78/0x7c) from [<80161df8>]
> (config_item_release+0x68/0x8c)
> [<80161df8>] (config_item_release+0x68/0x8c) from [<80161e64>]
> (config_item_put+0x48/0x4c)
> [<80161e64>] (config_item_put+0x48/0x4c) from [<8016071c>]
> (configfs_rmdir+0x1dc/0x264)
> [<8016071c>] (configfs_rmdir+0x1dc/0x264) from [<801086e4>]
> (vfs_rmdir+0xa0/0x10c)
> [<801086e4>] (vfs_rmdir+0xa0/0x10c) from [<80108870>] (do_rmdir+0x120/0x150)
> [<80108870>] (do_rmdir+0x120/0x150) from [<8010a800>] (SyS_rmdir+0x20/0x24)
> [<8010a800>] (SyS_rmdir+0x20/0x24) from [<8000eac0>] (ret_fast_syscall+0x0/0x30)
> Code: e1a04000 e59f0074 eb12b02b e5943010 (e5932018)
> ---[ end trace 1b8539e83d8e0ecc ]---
> ./do-overlay-only: line 7:   175 Segmentation fault      rmdir
> /config/device-tree/overlays/foo
> root@socfpga_cyclone5:~#
>
> I did some debug, haven't figured anything out yet.
>
> I have been able to successfully add/remove an overlay if it was to a
> fpga node that was at /fpga and used 'target = <&fpga>;'   Also
> 'target-path="/fpga";' works fine.
>
> Alan Tull
> aka
> delicious quinoa
