Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758672AbbA0Qof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:44:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925AbbA0Qod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:44:33 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v2 0/5] Drivers: hv: vmbus: fix crashes on hv_vmbus load/unload path
Date: Tue, 27 Jan 2015 17:44:14 +0100
Message-Id: <1422377059-7858-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
- '[PATCH 2/3] Drivers: hv: vmbus: introduce vmbus_acpi_remove' was dropped in
  favor of Jake's '[PATCH v2 1/1] drivers:hv:vmbus drivers:hv:vmbus Allow for
  more than one MMIO range for children'. It is required to make unload/load
  work on Gen2 instances.

- Added '[PATCH v2 3/5] drivers: hv: Teardown synthetic interrupt controllers
  on module unload' to deal with synic.

- Added '[PATCH v2 4/5] clockevents: export clockevents_unbind_device instead
 of clockevents_unbind'. It is not for Hyper-V subsystem, however, it is a
 pre-requisite for 'PATCH 5/5' and a natural part of this series. CC: Thomas
 Gleixner as the subsystem maintainer.

- Added '[PATCH v2 5/5] Drivers: hv: vmbus: Teardown clockevent devices on
 module unload' to deal with clockevent devices.

Patches are supposed to be applied on top of current char-misc-next tree.

Original description:

It is possible (since 93e5bd06a953: "Drivers: hv: Make the vmbus driver
unloadable") to unload hv_vmbus driver if no other devices are connected.
1aec169673d7: "x86: Hyperv: Cleanup the irq mess" fixed doulble interrupt
gate setup. However, if we try to unload hv_vmbus and then load it back
crashes in different places of vmbus driver occur on both unload and second
load paths. Address those I saw in my testing.

Not everything is fixed though. MCE was hit once on Generation2 instance and
I neither understand what caused it nor do I know the way to reproduce it.
Anyway, here is the log:

[  204.846255] mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 0: b2000000c0020001
[  204.846675] mce: [Hardware Error]: TSC 6b5cd64bc8
[  204.846675] mce: [Hardware Error]: PROCESSOR 0:306e4 TIME 1421944123 SOCKET 0 APIC 0 microcode ffffffff
[  204.846675] mce: [Hardware Error]: Run the above through 'mcelog --ascii'
[  204.846675] mce: [Hardware Error]: Machine check: Processor context corrupt
[  204.846675] Kernel panic - not syncing: Fatal Machine check
[  204.846675] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[  204.846675] Rebooting in 30 seconds..
[  204.846675] ACPI MEMORY or I/O RESET_REG.

Vitaly Kuznetsov (5):
  Drivers: hv: vmbus: avoid double kfree for device_obj
  Drivers: hv: vmbus: teardown hv_vmbus_con workqueue and
    vmbus_connection pages on shutdown
  drivers: hv: Teardown synthetic interrupt controllers on module unload
  clockevents: export clockevents_unbind_device instead of
    clockevents_unbind
  Drivers: hv: vmbus: Teardown clockevent devices on module unload

 drivers/hv/channel_mgmt.c |  1 -
 drivers/hv/connection.c   | 17 ++++++++++++-----
 drivers/hv/hv.c           | 34 +++++++++++++++++++++++++++++++---
 drivers/hv/hyperv_vmbus.h |  3 +++
 drivers/hv/vmbus_drv.c    | 11 +++++++++++
 kernel/time/clockevents.c |  2 +-
 6 files changed, 58 insertions(+), 10 deletions(-)

-- 
1.9.3

