Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbbAUTCZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 14:02:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbbAUTCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 14:02:18 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 0/3] Drivers: hv: vmbus: fix crashes on hv_vmbus load/unload path
Date: Wed, 21 Jan 2015 20:02:06 +0100
Message-Id: <1421866929-20167-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Vitaly Kuznetsov (3):
  Drivers: hv: vmbus: avoid double kfree for device_obj
  Drivers: hv: vmbus: introduce vmbus_acpi_remove
  Drivers: hv: vmbus: teardown hv_vmbus_con workqueue and
    vmbus_connection pages on shutdown

 drivers/hv/channel_mgmt.c |  1 -
 drivers/hv/connection.c   | 17 ++++++++++++-----
 drivers/hv/hyperv_vmbus.h |  1 +
 drivers/hv/vmbus_drv.c    | 16 ++++++++++++++++
 4 files changed, 29 insertions(+), 6 deletions(-)

-- 
1.9.3

