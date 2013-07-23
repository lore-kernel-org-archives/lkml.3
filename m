Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab3GWHrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:47:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3GWHrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:47:00 -0400
Date: Tue, 23 Jul 2013 00:46:30 -0700
From: tip-bot for Toshi Kani <tipbot@zytor.com>
Message-ID: <tip-a0842b704b0f7c2d925473676f2012ea5dc39976@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com, toshi.kani@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, toshi.kani@hp.com, kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
References: <1374256068-26016-1-git-send-email-toshi.kani@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm/hotplug, x86:
  Disable ARCH_MEMORY_PROBE by default
Git-Commit-ID: a0842b704b0f7c2d925473676f2012ea5dc39976
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 00:46:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0842b704b0f7c2d925473676f2012ea5dc39976
Gitweb:     http://git.kernel.org/tip/a0842b704b0f7c2d925473676f2012ea5dc39976
Author:     Toshi Kani <toshi.kani@hp.com>
AuthorDate: Fri, 19 Jul 2013 11:47:48 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 22 Jul 2013 11:13:34 +0200

mm/hotplug, x86: Disable ARCH_MEMORY_PROBE by default

CONFIG_ARCH_MEMORY_PROBE enables the
/sys/devices/system/memory/probe interface, which allows a given
memory address to be hot-added as follows:

 # echo start_address_of_new_memory > /sys/devices/system/memory/probe

(See Documentation/memory-hotplug.txt for more details.)

This probe interface is required on powerpc. On x86, however,
ACPI notifies a memory hotplug event to the kernel, which
performs its hotplug operation as the result.

Therefore, regular users do not need this interface on x86. This probe
interface is also error-prone and misleading that the kernel blindly
adds a given memory address without checking if the memory is present
on the system; no probing is done despite of its name.

The kernel crashes when a user requests to online a memory block
that is not present on the system. This interface is currently
used for testing as it can fake a hotplug event.

This patch disables CONFIG_ARCH_MEMORY_PROBE by default on x86,
adds its Kconfig menu entry on x86, and clarifies its use in
Documentation/ memory-hotplug.txt.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org
Cc: dave@sr71.net
Cc: isimatu.yasuaki@jp.fujitsu.com
Cc: tangchen@cn.fujitsu.com
Cc: vasilis.liaskovitis@profitbricks.com
Link: http://lkml.kernel.org/r/1374256068-26016-1-git-send-email-toshi.kani@hp.com
[ Edited it slightly. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/memory-hotplug.txt | 16 +++++++++-------
 arch/x86/Kconfig                 |  6 +++++-
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
index 8e5eacb..8fd254c 100644
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -210,13 +210,15 @@ If memory device is found, memory hotplug code will be called.
 
 4.2 Notify memory hot-add event by hand
 ------------
-In some environments, especially virtualized environment, firmware will not
-notify memory hotplug event to the kernel. For such environment, "probe"
-interface is supported. This interface depends on CONFIG_ARCH_MEMORY_PROBE.
-
-Now, CONFIG_ARCH_MEMORY_PROBE is supported only by powerpc but it does not
-contain highly architecture codes. Please add config if you need "probe"
-interface.
+On powerpc, the firmware does not notify a memory hotplug event to the kernel.
+Therefore, "probe" interface is supported to notify the event to the kernel.
+This interface depends on CONFIG_ARCH_MEMORY_PROBE.
+
+CONFIG_ARCH_MEMORY_PROBE is supported on powerpc only. On x86, this config
+option is disabled by default since ACPI notifies a memory hotplug event to
+the kernel, which performs its hotplug operation as the result. Please
+enable this option if you need the "probe" interface for testing purposes
+on x86.
 
 Probe interface is located at
 /sys/devices/system/memory/probe
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b32ebf9..2f9d957 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1344,8 +1344,12 @@ config ARCH_SELECT_MEMORY_MODEL
 	depends on ARCH_SPARSEMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
-	def_bool y
+	bool "Enable sysfs memory/probe interface"
 	depends on X86_64 && MEMORY_HOTPLUG
+	help
+	  This option enables a sysfs memory/probe interface for testing.
+	  See Documentation/memory-hotplug.txt for more information.
+	  If you are unsure how to answer this question, answer N.
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
