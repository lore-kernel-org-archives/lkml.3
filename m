Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaERNtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 09:49:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaERNta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 09:49:30 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: [PATCH 0/3] Fix WARN_ON caused by "mfd: Allow mapping regulator supplies to MFD device from children"
Date: Sun, 18 May 2014 15:49:10 +0200
Message-Id: <1400420953-20705-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I hit this WARN_ON:

WARNING: CPU: 0 PID: 1 at drivers/base/dd.c:286 driver_probe_device...
Which points to this line:

	WARN_ON(!list_empty(&dev->devres_head));

While testing Carlo Caione's axp20x regulator patches on top of
3.15-rc5. The problem is that mfd_add_device() from drivers/mfd/mfd-core.c
makes a call to devm_regulator_bulk_register_supply_alias() before doing the
platform_device_add, which results in dev->devres_head not being empty,
triggering the warning.

The code triggering this was introduced by this commit:
"mfd: Allow mapping regulator supplies to MFD device from children" :
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7fcd4274

Which puts the registering of the aliases before the
platform_device_add, so lets try moving it to below the platform_device_add.

This changes the messages about the alias addition from:

[    1.386371] Adding alias for supply acin,(null) -> acin,0-0034
[    1.392205] Adding alias for supply vin2,(null) -> vin2,0-0034
[    1.398112] Adding alias for supply vin3,(null) -> vin3,0-0034
[    1.403995] Adding alias for supply ldo24in,(null) -> ldo24in,0-0034
[    1.410344] Adding alias for supply ldo3in,(null) -> ldo3in,0-0034
[    1.416551] Adding alias for supply ldo5in,(null) -> ldo5in,0-0034

To:

[    1.410545] Adding alias for supply acin,axp20x-regulator -> acin,0-0034
[    1.417288] Adding alias for supply vin2,axp20x-regulator -> vin2,0-0034
[    1.424002] Adding alias for supply vin3,axp20x-regulator -> vin3,0-0034
[    1.430695] Adding alias for supply ldo24in,axp20x-regulator -> ldo24in,0-003
4
[    1.437922] Adding alias for supply ldo3in,axp20x-regulator -> ldo3in,0-0034
[    1.444973] Adding alias for supply ldo5in,axp20x-regulator -> ldo5in,0-0034

Which looks more correct, but this leads to other problems:

[    1.386241] LDO1: 1300 mV
[    1.388989] axp20x-regulator axp20x-regulator: Failed to find supply acin
[    1.395978] axp20x-regulator axp20x-regulator: Failed to register LDO1
[    1.402513] platform axp20x-regulator: Driver axp20x-regulator requests probe
 deferral

Followed by:
[    2.191834] WARNING: CPU: 0 PID: 6 at drivers/base/dd.c:286 driver_probe_devi
ce+0xe0/0x344()
[    2.200323] Modules linked in:
[    2.203422] CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.15.0-rc5+ #143
[    2.210209] Workqueue: deferwq deferred_probe_work_func

So the exact same problem, what happens here is that the driver probe gets deferred,
then we add the aliases, and then when the deferred probe runs we're in the
same situation again that the devres list is not empty at probe time.

Looking more into this, I also noticed that mfd_add_device also has a
call to devm_regulator_bulk_unregister_supply_alias(), which is weird because
the whole idea of devm functions is that they cleanup after themselves.

All this together has led me to the conclusion that the current approach is
simply wrong, and that the regulator alias registering should be done in
the platform drivers probe method. 

So that is what this patch set does. Note I've kept most of the related code
the same. Esp. including the listing of the parent supplies in the cell info,
as I feel that that is the right place for it.

Regards,

Hans
