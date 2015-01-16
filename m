Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbbAPGfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:35:11 -0500
Received: from smtp1.cypress.com ([157.95.67.100]:49078 "EHLO
	smtp1.cypress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbbAPGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:35:07 -0500
From: Dudley Du <dudl@cypress.com>
To: dmitry.torokhov@gmail.com, jmmahler@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudl@cypress.com>, bleung@google.com, dso@cypress.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v18 00/12] input: cyapa: instruction of cyapa patches
Date: Fri, 16 Jan 2015 14:34:03 +0800
Message-Id: <1421390055-32760-1-git-send-email-dudl@cypress.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V18 patches have below updates, details of other updates see history list:
1) Fix 'cyapa_runtime_suspend' undeclared compiling issue in latest
   kernel-next source code. Verified on next-20150114 with make C=1.
2) Optimize enter bootloader failed for some chipset takes longer time issue.


This patch series is aimed to re-design the cyapa driver to support
old gen3 trackpad devices and new gen5 trackpad devices in one
cyapa driver, it's for easily productions support based on
customers' requirements. And add sysfs functions and interfaces
supported that required by users and customers.

Since the earlier gen3 and the latest gen5 trackpad devices using
two different chipsets, and have different protocols and interfaces,
so if supported these two type trackpad devices in two different drivers,
then it will be difficult to manage productions and later firmware updates.
e.g.: It will cause customer don't know which one trackpad device firmware
image to use and update when it has been used and integrated
in same one productions, so here we support these two trackpad
devices in same on driver.


Dudley Du (12):
  input: cyapa: re-design driver to support multi-trackpad in one driver
  input: cyapa: add gen5 trackpad device basic functions support
  input: cyapa: add power management interfaces support for the device
  input: cyapa: add runtime power management interfaces support for the
    device
  input: cyapa: add sysfs interfaces support in the cyapa driver
  input: cyapa: add gen3 trackpad device firmware update function
    support
  input: cyapa: add gen3 trackpad device read baseline function support
  input: cyapa: add gen3 trackpad device force re-calibrate function
    support
  input: cyapa: add gen5 trackpad device firmware update function
    support
  input: cyapa: add gen5 trackpad device read baseline function support
  input: cyapa: add gen5 trackpad device force re-calibrate function
    support
  input: cyapa: add acpi device id support

 drivers/input/mouse/Kconfig      |   11 +-
 drivers/input/mouse/Makefile     |    3 +-
 drivers/input/mouse/cyapa.c      | 1711 ++++++++++++++---------
 drivers/input/mouse/cyapa.h      |  303 +++++
 drivers/input/mouse/cyapa_gen3.c | 1247 +++++++++++++++++
 drivers/input/mouse/cyapa_gen5.c | 2774 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 5378 insertions(+), 671 deletions(-)
 create mode 100644 drivers/input/mouse/cyapa.h
 create mode 100644 drivers/input/mouse/cyapa_gen3.c
 create mode 100644 drivers/input/mouse/cyapa_gen5.c


History patch series modifications list:
V17 patches have below main updates compared with v16 patches:
1) Fix kernel oops when system booting up with finger on TP.
2) Remove unnecessary error log that may to system.
3) Slipt out pm sleep code into cyapa_prepare_wakeup_controls(),
   remove #indefs in function body of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
4) Supply stubs to cyapa_gen3_ops and cyapa_gen5_ops data structure to avoid
   checking for presence of various methods in ops.
5) Changing CYAPA_BOOTLOADER() and CYAPA_OPERATIONAL() macros to static inline
   functions as cyapa_is_bootloader_mode() and cyapa_is_operational_mode().
6) Remove touching runtime suspend state during system calling cyapa_suspend().
7) Change to enable runtime PM until make sure device is out of bootloader.
8) Change to return -EAGAIN when bootloader is busy.
9) Correct word spell issue and code styles.

V16 patches have below main updates compared with v15 patches:
1) Fix all miss-spelling and space issue.
2) Rename variables and functions with much more clearer names.
3) Initialize and document tries near where it will be used.
4) Modify cmd buffer to struct for more descriptive way.

V15 patches have below main updates compared with v14 patches:
1) Fix all warning errors of sparse tool when running with "make C=1".
2) Change variable name "unique_str" to "product_id" for clearer meanings.
3) Update cyapa_i2c_write function to return error directly when length > 31.

V14 patches have below main updates compared with v13 patches:
1) Correct 9 miss spelling issues of "bufferred" to "buffered".
2) Fix the upgrade issue of removing MOUSE_CYAPA config when make oldconfig
   by replase "depends on I2C && CRC_ITU_T" with
	"depends on I2C"
	"select CRC_ITU_T"
   in patch 9.

V13 patches have below main updates compared with v12 patches:
1) Remove all debugfs interface, including read_fw and raw_data interfaces.
2) This patches are made based linux next-20141208.

V12 patches have below main updates compared with v11 patches:
1) Add check that when TP is detected but not operational, do not exit driver
   immediately, but wait and export the update_fw interface for recovering.
2) Re-arrange the function codes, remove unnesseary protype definitions in
   the header file.

V11 patches have below main updates compared with v10 patches:
1) Add add acpi device id supported for old gen3 and new gen5 trackpad devices.
2) Fix the unable to update firmware issue when cyapa_open is not called
   which means the irq for firwmare update process is not enabled. This fix
   by checking if the irq is enabled, if not then enable irq before start to
   do firmware update.

V10 patches have below main updates compared with v9 patches:
1) Modify code to following kernel code style.
   e.g.: correct to use error as return name when there is only error path,
   and fix the checkpatch.sh wanting in the driver.
2) Remove cyapa_remove method and use input open and close interface to
   following device resouse management infrastructure.
3) Modify cyapa_detect method to return tristate issue to make the return value
   much more consistent and clear.
4) Use platform supplied functions as possible instead of driver
   specific rewritten version.

V9 patches have below updates compared with v8 patches:
1) Removed all async thread stuff from the driver.
2) Split driver into 18 patches for each function change one patch.

V8 patches have below updates compared with v7 patches:
1) [PATCH v8 01/13] - Remove the async thread for device detect in
   probe routine, now the device detect process is completely done within
   the device probe routine.
2) [PATCH v8 01/13] - Split the irq cmd handler function to separated
   function cyapa_default_irq_cmd_handler() and set it to interface
   cyapa_default_ops.irq_cmd_handler.
3) [PATCH v8 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
   to avoid miss-enter when device protocol is still in detecting.

V7 patches have below updates compared with v6 patches:
1) [PATCH v7 01/13] - Split the irq cmd handler function to separated
   function cyapa_default_irq_cmd_handler() and set it to interface
   cyapa_default_ops.irq_cmd_handler.
2) [PATCH v7 06/13] - Add cyapa->gen check in cyapa_gen3_irq_cmd_handler()
   to avoid miss-enter when device protocol is still in detecting.

V6 patches have below updates compared with v5 patches:
1) Remove patch 14 of the lid filtering from the cyapa driver.

V5 patches have below updates compared with v4 patches:
1) Uses get_device()/put_device() instead of kobject_get()/kobject_put();
2) Fix memories freed before debugfs entries issue;
3) Make cyapa_debugs_root valid in driver module level
   in module_init()/moudle_exit() ;
4) Fix i2c_transfer() may return partial transfer issues.
5) Add cyapa->removed flag to avoid detecting thread may still running
   when driver module is removed.
6) Fix the meanings of some comments and return error code not clear issue.
