Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaCVGke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 02:40:34 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49242 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbaCVGkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 02:40:31 -0400
From: behanw@converseincode.com
To: dh.herrmann@gmail.com, sameo@linux.intel.com, jani.nikula@intel.com,
        alexandre.bounine@idt.com
Cc: akpm@linux-foundation.org, dmitry.torokhov@gmail.com,
        tomas.winkler@intel.com, gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        pageexec@freemail.hu, Behan Webster <behanw@converseincode.com>,
        =?UTF-8?q?Jan-Simon=20M=C3=B6ller?= <dl9pf@gmx.de>
Subject: [PATCH] x86: LLVMLinux: Fix "incomplete type const struct x86cpu_device_id"
Date: Fri, 21 Mar 2014 23:40:18 -0700
Message-Id: <1395470418-16015-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

Similar to the fix in 40413dcb7b273bda681dca38e6ff0bbb3728ef11

MODULE_DEVICE_TABLE(x86cpu, ...) expects the struct to be called struct
x86cpu_device_id, and not struct x86_cpu_id which is what is used in the rest
of the kernel code.  Although gcc seems to ignore this error, clang fails
without this define to fix the name.

Code from drivers/thermal/x86_pkg_temp_thermal.c
static const struct x86_cpu_id __initconst pkg_temp_thermal_ids[] = { ... };
MODULE_DEVICE_TABLE(x86cpu, pkg_temp_thermal_ids);

Error from clang:
drivers/thermal/x86_pkg_temp_thermal.c:577:1: error: variable has
      incomplete type 'const struct x86cpu_device_id'
MODULE_DEVICE_TABLE(x86cpu, pkg_temp_thermal_ids);
^
include/linux/module.h:145:3: note: expanded from macro
      'MODULE_DEVICE_TABLE'
  MODULE_GENERIC_TABLE(type##_device, name)
  ^
include/linux/module.h:87:32: note: expanded from macro
      'MODULE_GENERIC_TABLE'
extern const struct gtype##_id __mod_##gtype##_table            \
                               ^
<scratch space>:143:1: note: expanded from here
__mod_x86cpu_device_table
^
drivers/thermal/x86_pkg_temp_thermal.c:577:1: note: forward declaration of
      'struct x86cpu_device_id'
include/linux/module.h:145:3: note: expanded from macro
      'MODULE_DEVICE_TABLE'
  MODULE_GENERIC_TABLE(type##_device, name)
  ^
include/linux/module.h:87:21: note: expanded from macro
      'MODULE_GENERIC_TABLE'
extern const struct gtype##_id __mod_##gtype##_table            \
                    ^
<scratch space>:141:1: note: expanded from here
x86cpu_device_id
^
1 error generated.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 include/linux/mod_devicetable.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 45e9214..dbb5cf0 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -548,6 +548,11 @@ struct amba_id {
  * See documentation of "x86_match_cpu" for details.
  */
 
+/*
+ * MODULE_DEVICE_TABLE expects this struct to be called x86cpu_device_id.
+ * Although gcc seems to ignore this error, clang fails without this define.
+ */
+#define x86cpu_device_id x86_cpu_id
 struct x86_cpu_id {
 	__u16 vendor;
 	__u16 family;
-- 
1.8.3.2

