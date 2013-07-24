Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab3GXO3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:29:15 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:58859 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3GXO2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:28:14 -0400
From: Balint Czobor <czoborbalint@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, Balint Czobor <czoborbalint@gmail.com>
Subject: [PATCH 2/2] drivers: power: Add support for BATTERY_ARIESVE
Date: Wed, 24 Jul 2013 16:27:10 +0200
Message-Id: <1374676030-4534-1-git-send-email-czoborbalint@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial support for the battery in Samsung ARIESVE.

Signed-off-by: Balint Czobor <czoborbalint@gmail.com>
---
 arch/arm/mach-msm/include/mach/msm_battery.h   |   31 +
 arch/arm/mach-msm/include/mach/msm_rpcrouter.h |  376 ++++
 drivers/power/Kconfig                          |   14 +
 drivers/power/Makefile                         |    1 +
 drivers/power/ariesve_battery.c                | 2710 ++++++++++++++++++++++++
 drivers/power/fuelgauge_max17043.c             |  434 ++++
 drivers/power/power_supply_sysfs.c             |   19 +-
 include/linux/earlysuspend.h                   |   56 +
 include/linux/leds-pmic8058.h                  |   40 +
 include/linux/mfd/pm8xxx/batt-alarm.h          |  201 ++
 include/linux/mfd/pm8xxx/gpio.h                |  162 ++
 include/linux/mfd/pm8xxx/misc.h                |  284 +++
 include/linux/mfd/pm8xxx/mpp.h                 |  263 +++
 include/linux/mfd/pm8xxx/nfc.h                 |   79 +
 include/linux/mfd/pm8xxx/tm.h                  |   42 +
 include/linux/mfd/pm8xxx/upl.h                 |   65 +
 include/linux/mfd/pm8xxx/vibrator.h            |   39 +
 include/linux/mfd/pmic8058.h                   |  137 ++
 include/linux/pmic8058-othc.h                  |  146 ++
 include/linux/pmic8058-pwm.h                   |  148 ++
 include/linux/pmic8058-xoadc.h                 |  121 ++
 include/linux/power_supply.h                   |   13 +-
 include/linux/regulator/pm8058-xo.h            |   31 +
 include/linux/regulator/pmic8058-regulator.h   |   89 +
 include/linux/wakelock.h                       |   90 +
 25 files changed, 5588 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_battery.h
 create mode 100644 arch/arm/mach-msm/include/mach/msm_rpcrouter.h
 create mode 100644 drivers/power/ariesve_battery.c
 create mode 100644 drivers/power/fuelgauge_max17043.c
 create mode 100644 include/linux/earlysuspend.h
 create mode 100644 include/linux/leds-pmic8058.h
 create mode 100644 include/linux/mfd/pm8xxx/batt-alarm.h
 create mode 100644 include/linux/mfd/pm8xxx/gpio.h
 create mode 100644 include/linux/mfd/pm8xxx/misc.h
 create mode 100644 include/linux/mfd/pm8xxx/mpp.h
 create mode 100644 include/linux/mfd/pm8xxx/nfc.h
 create mode 100644 include/linux/mfd/pm8xxx/tm.h
 create mode 100644 include/linux/mfd/pm8xxx/upl.h
 create mode 100644 include/linux/mfd/pm8xxx/vibrator.h
 create mode 100644 include/linux/mfd/pmic8058.h
 create mode 100644 include/linux/pmic8058-othc.h
 create mode 100644 include/linux/pmic8058-pwm.h
 create mode 100644 include/linux/pmic8058-xoadc.h
 create mode 100644 include/linux/regulator/pm8058-xo.h
 create mode 100644 include/linux/regulator/pmic8058-regulator.h
 create mode 100644 include/linux/wakelock.h

diff --git a/arch/arm/mach-msm/include/mach/msm_battery.h b/arch/arm/mach-msm/include/mach/msm_battery.h
new file mode 100644
index 0000000..dfa8097
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_battery.h
@@ -0,0 +1,31 @@
+/* Copyright (c) 2009, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+
+#ifndef __MSM_BATTERY_H__
+#define __MSM_BATTERY_H__
+
+#define NO_CHG     0x00000000
+#define AC_CHG     0x00000001
+#define USB_CHG    0x00000002
+
+struct msm_psy_batt_pdata {
+	u32 voltage_max_design;
+	u32 voltage_min_design;
+	u32 voltage_fail_safe;
+	u32 avail_chg_sources;
+	u32 batt_technology;
+	u32 (*calculate_capacity)(u32 voltage);
+};
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_rpcrouter.h b/arch/arm/mach-msm/include/mach/msm_rpcrouter.h
new file mode 100644
index 0000000..28841a9
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_rpcrouter.h
@@ -0,0 +1,376 @@
+/** include/asm-arm/arch-msm/msm_rpcrouter.h
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2007-2011, Code Aurora Forum. All rights reserved.
+ * Author: San Mehat <san@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM__ARCH_MSM_RPCROUTER_H
+#define __ASM__ARCH_MSM_RPCROUTER_H
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/platform_device.h>
+
+/* RPC API version structure
+ * Version bit 31 : 1->hashkey versioning,
+ *                  0->major-minor (backward compatible) versioning
+ * hashkey versioning:
+ *   Version bits 31-0 hashkey
+ * major-minor (backward compatible) versioning
+ *   Version bits 30-28 reserved (no match)
+ *   Version bits 27-16 major (must match)
+ *   Version bits 15-0  minor (greater or equal)
+ */
+#define RPC_VERSION_MODE_MASK  0x80000000
+#define RPC_VERSION_MAJOR_MASK 0x0fff0000
+#define RPC_VERSION_MINOR_MASK 0x0000ffff
+
+/* callback ID for NULL callback function is -1 */
+#define MSM_RPC_CLIENT_NULL_CB_ID 0xffffffff
+
+struct msm_rpc_endpoint;
+
+struct rpcsvr_platform_device
+{
+	struct platform_device base;
+	uint32_t prog;
+	uint32_t vers;
+};
+
+#define RPC_DATA_IN	0
+/*
+ * Structures for sending / receiving direct RPC requests
+ * XXX: Any cred/verif lengths > 0 not supported
+ */
+
+struct rpc_request_hdr
+{
+	uint32_t xid;
+	uint32_t type;	/* 0 */
+	uint32_t rpc_vers; /* 2 */
+	uint32_t prog;
+	uint32_t vers;
+	uint32_t procedure;
+	uint32_t cred_flavor;
+	uint32_t cred_length;
+	uint32_t verf_flavor;
+	uint32_t verf_length;
+};
+
+typedef struct
+{
+	uint32_t low;
+	uint32_t high;
+} rpc_reply_progmismatch_data;
+
+typedef struct
+{
+} rpc_denied_reply_hdr;
+
+typedef struct
+{
+	uint32_t verf_flavor;
+	uint32_t verf_length;
+	uint32_t accept_stat;
+#define RPC_ACCEPTSTAT_SUCCESS 0
+#define RPC_ACCEPTSTAT_PROG_UNAVAIL 1
+#define RPC_ACCEPTSTAT_PROG_MISMATCH 2
+#define RPC_ACCEPTSTAT_PROC_UNAVAIL 3
+#define RPC_ACCEPTSTAT_GARBAGE_ARGS 4
+#define RPC_ACCEPTSTAT_SYSTEM_ERR 5
+#define RPC_ACCEPTSTAT_PROG_LOCKED 6
+	/*
+	 * Following data is dependant on accept_stat
+	 * If ACCEPTSTAT == PROG_MISMATCH then there is a
+	 * 'rpc_reply_progmismatch_data' structure following the header.
+	 * Otherwise the data is procedure specific
+	 */
+} rpc_accepted_reply_hdr;
+
+struct rpc_reply_hdr
+{
+	uint32_t xid;
+	uint32_t type;
+	uint32_t reply_stat;
+#define RPCMSG_REPLYSTAT_ACCEPTED 0
+#define RPCMSG_REPLYSTAT_DENIED 1
+	union {
+		rpc_accepted_reply_hdr acc_hdr;
+		rpc_denied_reply_hdr dny_hdr;
+	} data;
+};
+
+struct rpc_board_dev {
+	uint32_t prog;
+	struct platform_device pdev;
+};
+
+/* flags for msm_rpc_connect() */
+#define MSM_RPC_UNINTERRUPTIBLE 0x0001
+
+/* use IS_ERR() to check for failure */
+struct msm_rpc_endpoint *msm_rpc_open(void);
+/* Connect with the specified server version */
+struct msm_rpc_endpoint *msm_rpc_connect(uint32_t prog, uint32_t vers, unsigned flags);
+/* Connect with a compatible server version */
+struct msm_rpc_endpoint *msm_rpc_connect_compatible(uint32_t prog,
+	uint32_t vers, unsigned flags);
+/* check if server version can handle client requested version */
+int msm_rpc_is_compatible_version(uint32_t server_version,
+				  uint32_t client_version);
+
+int msm_rpc_close(struct msm_rpc_endpoint *ept);
+int msm_rpc_write(struct msm_rpc_endpoint *ept,
+		  void *data, int len);
+int msm_rpc_read(struct msm_rpc_endpoint *ept,
+		 void **data, unsigned len, long timeout);
+void msm_rpc_read_wakeup(struct msm_rpc_endpoint *ept);
+void msm_rpc_setup_req(struct rpc_request_hdr *hdr,
+		       uint32_t prog, uint32_t vers, uint32_t proc);
+int msm_rpc_register_server(struct msm_rpc_endpoint *ept,
+			    uint32_t prog, uint32_t vers);
+int msm_rpc_unregister_server(struct msm_rpc_endpoint *ept,
+			      uint32_t prog, uint32_t vers);
+
+int msm_rpc_add_board_dev(struct rpc_board_dev *board_dev, int num);
+
+int msm_rpc_clear_netreset(struct msm_rpc_endpoint *ept);
+
+int msm_rpc_get_curr_pkt_size(struct msm_rpc_endpoint *ept);
+/* simple blocking rpc call
+ *
+ * request is mandatory and must have a rpc_request_hdr
+ * at the start.  The header will be filled out for you.
+ *
+ * reply provides a buffer for replies of reply_max_size
+ */
+int msm_rpc_call_reply(struct msm_rpc_endpoint *ept, uint32_t proc,
+		       void *request, int request_size,
+		       void *reply, int reply_max_size,
+		       long timeout);
+int msm_rpc_call(struct msm_rpc_endpoint *ept, uint32_t proc,
+		 void *request, int request_size,
+		 long timeout);
+
+struct msm_rpc_xdr {
+	void *in_buf;
+	uint32_t in_size;
+	uint32_t in_index;
+	wait_queue_head_t in_buf_wait_q;
+
+	void *out_buf;
+	uint32_t out_size;
+	uint32_t out_index;
+	struct mutex out_lock;
+
+	struct msm_rpc_endpoint *ept;
+};
+
+int xdr_send_int8(struct msm_rpc_xdr *xdr, const int8_t *value);
+int xdr_send_uint8(struct msm_rpc_xdr *xdr, const uint8_t *value);
+int xdr_send_int16(struct msm_rpc_xdr *xdr, const int16_t *value);
+int xdr_send_uint16(struct msm_rpc_xdr *xdr, const uint16_t *value);
+int xdr_send_int32(struct msm_rpc_xdr *xdr, const int32_t *value);
+int xdr_send_uint32(struct msm_rpc_xdr *xdr, const uint32_t *value);
+int xdr_send_bytes(struct msm_rpc_xdr *xdr, const void **data, uint32_t *size);
+
+int xdr_recv_int8(struct msm_rpc_xdr *xdr, int8_t *value);
+int xdr_recv_uint8(struct msm_rpc_xdr *xdr, uint8_t *value);
+int xdr_recv_int16(struct msm_rpc_xdr *xdr, int16_t *value);
+int xdr_recv_uint16(struct msm_rpc_xdr *xdr, uint16_t *value);
+int xdr_recv_int32(struct msm_rpc_xdr *xdr, int32_t *value);
+int xdr_recv_uint32(struct msm_rpc_xdr *xdr, uint32_t *value);
+int xdr_recv_bytes(struct msm_rpc_xdr *xdr, void **data, uint32_t *size);
+
+struct msm_rpc_server
+{
+	struct list_head list;
+	uint32_t flags;
+
+	uint32_t prog;
+	uint32_t vers;
+
+	struct mutex cb_req_lock;
+
+	struct msm_rpc_endpoint *cb_ept;
+
+	struct msm_rpc_xdr cb_xdr;
+
+	uint32_t version;
+
+	int (*rpc_call)(struct msm_rpc_server *server,
+			struct rpc_request_hdr *req, unsigned len);
+
+	int (*rpc_call2)(struct msm_rpc_server *server,
+			 struct rpc_request_hdr *req,
+			 struct msm_rpc_xdr *xdr);
+};
+
+int msm_rpc_create_server(struct msm_rpc_server *server);
+int msm_rpc_create_server2(struct msm_rpc_server *server);
+
+#define MSM_RPC_MSGSIZE_MAX 8192
+
+struct msm_rpc_client;
+
+struct msm_rpc_client {
+	struct task_struct *read_thread;
+	struct task_struct *cb_thread;
+
+	struct msm_rpc_endpoint *ept;
+	wait_queue_head_t reply_wait;
+
+	uint32_t prog, ver;
+
+	void *buf;
+
+	struct msm_rpc_xdr xdr;
+	struct msm_rpc_xdr cb_xdr;
+
+	uint32_t version;
+
+	int (*cb_func)(struct msm_rpc_client *, void *, int);
+	int (*cb_func2)(struct msm_rpc_client *, struct rpc_request_hdr *req,
+			struct msm_rpc_xdr *);
+	void *cb_buf;
+	int cb_size;
+
+	struct list_head cb_item_list;
+	struct mutex cb_item_list_lock;
+
+	wait_queue_head_t cb_wait;
+	int cb_avail;
+
+	atomic_t next_cb_id;
+	spinlock_t cb_list_lock;
+	struct list_head cb_list;
+
+	uint32_t exit_flag;
+	struct completion complete;
+	struct completion cb_complete;
+
+	struct mutex req_lock;
+
+	void (*cb_restart_teardown)(struct msm_rpc_client *client);
+	void (*cb_restart_setup)(struct msm_rpc_client *client);
+	int in_reset;
+};
+
+struct msm_rpc_client_info {
+	uint32_t pid;
+	uint32_t cid;
+	uint32_t prog;
+	uint32_t vers;
+};
+
+
+int msm_rpc_client_in_reset(struct msm_rpc_client *client);
+
+struct msm_rpc_client *msm_rpc_register_client(
+	const char *name,
+	uint32_t prog, uint32_t ver,
+	uint32_t create_cb_thread,
+	int (*cb_func)(struct msm_rpc_client *, void *, int));
+
+struct msm_rpc_client *msm_rpc_register_client2(
+	const char *name,
+	uint32_t prog, uint32_t ver,
+	uint32_t create_cb_thread,
+	int (*cb_func)(struct msm_rpc_client *, struct rpc_request_hdr *req,
+		       struct msm_rpc_xdr *xdr));
+
+int msm_rpc_unregister_client(struct msm_rpc_client *client);
+
+int msm_rpc_client_req(struct msm_rpc_client *client, uint32_t proc,
+		       int (*arg_func)(struct msm_rpc_client *,
+				       void *, void *), void *arg_data,
+		       int (*result_func)(struct msm_rpc_client *,
+					  void *, void *), void *result_data,
+		       long timeout);
+
+int msm_rpc_client_req2(struct msm_rpc_client *client, uint32_t proc,
+			int (*arg_func)(struct msm_rpc_client *,
+					struct msm_rpc_xdr *, void *),
+			void *arg_data,
+			int (*result_func)(struct msm_rpc_client *,
+					   struct msm_rpc_xdr *, void *),
+			void *result_data,
+			long timeout);
+
+int msm_rpc_register_reset_callbacks(
+	struct msm_rpc_client *client,
+	void (*teardown)(struct msm_rpc_client *client),
+	void (*setup)(struct msm_rpc_client *client)
+	);
+
+void *msm_rpc_start_accepted_reply(struct msm_rpc_client *client,
+				   uint32_t xid, uint32_t accept_status);
+
+int msm_rpc_send_accepted_reply(struct msm_rpc_client *client, uint32_t size);
+
+void *msm_rpc_server_start_accepted_reply(struct msm_rpc_server *server,
+					  uint32_t xid, uint32_t accept_status);
+
+int msm_rpc_server_send_accepted_reply(struct msm_rpc_server *server,
+				       uint32_t size);
+
+int msm_rpc_add_cb_func(struct msm_rpc_client *client, void *cb_func);
+
+void *msm_rpc_get_cb_func(struct msm_rpc_client *client, uint32_t cb_id);
+
+void msm_rpc_remove_cb_func(struct msm_rpc_client *client, void *cb_func);
+
+int msm_rpc_server_cb_req(struct msm_rpc_server *server,
+			  struct msm_rpc_client_info *clnt_info,
+			  uint32_t cb_proc,
+			  int (*arg_func)(struct msm_rpc_server *server,
+					  void *buf, void *data),
+			  void *arg_data,
+			  int (*ret_func)(struct msm_rpc_server *server,
+					  void *buf, void *data),
+			  void *ret_data, long timeout);
+
+int msm_rpc_server_cb_req2(struct msm_rpc_server *server,
+			   struct msm_rpc_client_info *clnt_info,
+			   uint32_t cb_proc,
+			   int (*arg_func)(struct msm_rpc_server *server,
+					   struct msm_rpc_xdr *xdr, void *data),
+			   void *arg_data,
+			   int (*ret_func)(struct msm_rpc_server *server,
+					   struct msm_rpc_xdr *xdr, void *data),
+			   void *ret_data, long timeout);
+
+void msm_rpc_server_get_requesting_client(
+	struct msm_rpc_client_info *clnt_info);
+
+int xdr_send_pointer(struct msm_rpc_xdr *xdr, void **obj,
+		     uint32_t obj_size, void *xdr_op);
+
+int xdr_recv_pointer(struct msm_rpc_xdr *xdr, void **obj,
+		     uint32_t obj_size, void *xdr_op);
+
+int xdr_send_array(struct msm_rpc_xdr *xdr, void **addr, uint32_t *size,
+		   uint32_t maxsize, uint32_t elm_size, void *xdr_op);
+
+int xdr_recv_array(struct msm_rpc_xdr *xdr, void **addr, uint32_t *size,
+		   uint32_t maxsize, uint32_t elm_size, void *xdr_op);
+
+int xdr_recv_req(struct msm_rpc_xdr *xdr, struct rpc_request_hdr *req);
+int xdr_recv_reply(struct msm_rpc_xdr *xdr, struct rpc_reply_hdr *reply);
+int xdr_start_request(struct msm_rpc_xdr *xdr, uint32_t prog,
+		      uint32_t ver, uint32_t proc);
+int xdr_start_accepted_reply(struct msm_rpc_xdr *xdr, uint32_t accept_status);
+int xdr_send_msg(struct msm_rpc_xdr *xdr);
+
+#endif
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7b8979c..847a77e 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -75,6 +75,12 @@ config BATTERY_88PM860X
 	help
 	  Say Y here to enable battery monitor for Marvell 88PM860x chip.
 
+config BATTERY_ARIESVE
+	tristate "Ariesve battery driver"
+	depends on MACH_ARIESVE
+	help
+	  Say Y to enable support for the battery in Samsung ARIESVE.
+
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
 	depends on W1 && W1_SLAVE_DS2760
@@ -362,6 +368,14 @@ config BATTERY_GOLDFISH
 	  Say Y to enable support for the battery and AC power in the
 	  Goldfish emulator.
 
+config MAX17043_FUEL_GAUGE
+	tristate "Maxim MAX17043 Fuel Gauge"
+	depends on I2C
+	help
+	  MAX17043 is fuel-gauge systems for lithium-ion (Li+) batteries
+	  in handheld and portable equipment. The MAX17043 is configured
+	  to operate with a single lithium cell.
+
 source "drivers/power/reset/Kconfig"
 
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 653bf6c..9ced370 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
 obj-$(CONFIG_TEST_POWER)	+= test_power.o
 
 obj-$(CONFIG_BATTERY_88PM860X)	+= 88pm860x_battery.o
+obj-$(CONFIG_BATTERY_ARIESVE)	+= ariesve_battery.o
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_DS2780)	+= ds2780_battery.o
 obj-$(CONFIG_BATTERY_DS2781)	+= ds2781_battery.o
diff --git a/drivers/power/ariesve_battery.c b/drivers/power/ariesve_battery.c
new file mode 100644
index 0000000..3dc03fd
--- /dev/null
+++ b/drivers/power/ariesve_battery.c
@@ -0,0 +1,2710 @@
+/* Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ */
+
+/*
+ * this needs to be before <linux/kernel.h> is loaded,
+ * and <linux/sched.h> loads <linux/kernel.h>
+ */
+
+//#define DEBUG 1
+#include <linux/device.h>
+
+#define MAX17043_FUEL_GAUGE		// Support low battery alert
+
+// For LPM mode
+extern int charging_boot;
+
+/* ***** Test Features ***** */
+
+//#define __BATT_TEST_DEVICE__
+//#define __AUTO_TEMP_TEST__
+//#define __FULL_CHARGE_TEST__
+
+
+#include <linux/earlysuspend.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/sched.h>
+#include <linux/signal.h>
+#include <linux/uaccess.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include <asm/atomic.h>
+
+#include <mach/msm_rpcrouter.h>
+#include <mach/msm_battery.h>
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/gpio.h>
+#include <linux/mfd/pmic8058.h>
+#include <linux/wakelock.h>
+
+#ifdef CONFIG_WIRELESS_CHARGING
+#define IRQ_WC_DETECT PM8058_GPIO_IRQ(PMIC8058_IRQ_BASE, (PM8058_GPIO(35)))
+#define GPIO_WC_DETECT PM8058_GPIO_PM_TO_SYS(PM8058_GPIO(35))
+#endif
+
+static struct wake_lock vbus_wake_lock;
+
+
+#ifdef DEBUG
+#undef pr_debug
+#define pr_debug pr_info
+#endif
+
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/timer.h>
+#include <linux/time.h>
+#include "fuelgauge_max17043.c"
+#endif
+
+#define BATTERY_RPC_PROG	0x30000089
+#define BATTERY_RPC_VER_1_1	0x00010001
+#define BATTERY_RPC_VER_2_1	0x00020001
+#define BATTERY_RPC_VER_4_1     0x00040001
+#define BATTERY_RPC_VER_5_1     0x00050001
+
+#define BATTERY_RPC_CB_PROG	(BATTERY_RPC_PROG | 0x01000000)
+
+#define CHG_RPC_PROG		0x3000001a
+#define CHG_RPC_VER_1_1		0x00010001
+#define CHG_RPC_VER_1_3		0x00010003
+#define CHG_RPC_VER_2_2		0x00020002
+#define CHG_RPC_VER_3_1         0x00030001
+#define CHG_RPC_VER_4_1         0x00040001
+
+#define BATTERY_REGISTER_PROC                          	2
+#define BATTERY_MODIFY_CLIENT_PROC                     	4
+#define BATTERY_DEREGISTER_CLIENT_PROC			5
+#define BATTERY_READ_MV_PROC 				12
+#define BATTERY_ENABLE_DISABLE_FILTER_PROC 		14
+
+#define VBATT_FILTER			2
+
+#define BATTERY_CB_TYPE_PROC 		1
+#define BATTERY_CB_ID_ALL_ACTIV       	1
+#define BATTERY_CB_ID_LOW_VOL		2
+
+#define BATTERY_LOW            	3400	//2800
+#define BATTERY_HIGH           	4200	//4300
+
+#define ONCRPC_CHG_GET_GENERAL_STATUS_PROC 	12
+#define ONCRPC_CHARGER_API_VERSIONS_PROC 	0xffffffff
+
+#define BATT_RPC_TIMEOUT    5000	/* 5 sec */
+
+#define INVALID_BATT_HANDLE    -1
+
+#define RPC_TYPE_REQ     0
+#define RPC_TYPE_REPLY   1
+#define RPC_REQ_REPLY_COMMON_HEADER_SIZE   (3 * sizeof(uint32_t))
+
+
+/*******************************/
+/* Charging control settings */
+
+typedef enum {
+	STOP_CHARGING,
+	START_CHARGING
+} chg_enable_type;
+
+
+const int temp_table[][2] =  {
+	/* ADC, Temperature (C) */
+	{ 1980,		-200},
+	{ 1914,		-150},
+	{ 1845,		-100},
+	{ 1760,		-50	},
+	{ 1738,		-40	},
+	{ 1718, 	-30	},
+	{ 1696, 	-20	},
+	{ 1682, 	-10	},
+	{ 1658,		0	},
+	{ 1637,		10	},
+	{ 1590, 	30 },
+	{ 1542, 	50	},
+	{ 1483, 	70	},
+	{ 1424, 	100	},
+	{ 1364, 	130 },
+	{ 1303, 	150 },
+	{ 1235, 	170 },
+	{ 1167, 	200 },
+	{ 1100, 	230 },
+	{ 1034, 	250 },
+	{  973, 	270 },
+	{  911, 	300 },
+	{  855, 	330 },
+	{  800, 	350 },
+	{  741, 	370 },
+	{  689, 	400 },
+	{  654, 	420 },
+	{  632, 	430 },
+	{  615, 	440 },
+	{  601, 	450 },
+	{  517, 	500 },
+	{  468, 	550 },
+	{  390, 	600 },
+	{  352, 	640 },
+	{  345, 	650 },
+	{  333, 	660 },
+};
+
+
+
+#define AVERAGE_COUNT		10
+
+#define TIME_UNIT_SECOND	(HZ)
+#define TIME_UNIT_MINUTE	(60*HZ)
+#define TIME_UNIT_HOUR		(60*60*HZ)
+
+#ifdef __FULL_CHARGE_TEST__
+#define TOTAL_CHARGING_TIME			(1 * TIME_UNIT_MINUTE)
+#define TOTAL_RECHARGING_TIME		(1 * TIME_UNIT_MINUTE)
+#else
+#define TOTAL_CHARGING_TIME			(6 * TIME_UNIT_HOUR)
+#define TOTAL_RECHARGING_TIME		(90 * TIME_UNIT_MINUTE)
+#endif
+#define TOTAL_WATING_TIME				(20 * TIME_UNIT_SECOND)	// wait for full-charging and recharging
+
+#define TEMP_TABLE_OFFSET		30
+#define BATT_TEMP_HIGH_BLOCK		348		//	65`C   +- 2
+#define BATT_TEMP_HIGH_RECOVER		623		//	43` C  +- 2
+#define BATT_TEMP_LOW_BLOCK			1708	// 	-3`C   +- 2
+#define BATT_TEMP_LOW_RECOVER		1670	//	0`C    +- 2
+
+#define BATT_FULL_CHARGING_VOLTAGE	4160
+#define BATT_FULL_CHARGING_CURRENT	180
+
+#define BATT_RECHARGING_VOLTAGE_1	4140
+#define BATT_RECHARGING_VOLTAGE_2	4000
+
+#ifdef __BATT_TEST_DEVICE__
+static int temp_test_adc = 0;
+#endif
+
+
+
+enum {
+	BATTERY_REGISTRATION_SUCCESSFUL = 0,
+	BATTERY_DEREGISTRATION_SUCCESSFUL = BATTERY_REGISTRATION_SUCCESSFUL,
+	BATTERY_MODIFICATION_SUCCESSFUL = BATTERY_REGISTRATION_SUCCESSFUL,
+	BATTERY_INTERROGATION_SUCCESSFUL = BATTERY_REGISTRATION_SUCCESSFUL,
+	BATTERY_CLIENT_TABLE_FULL = 1,
+	BATTERY_REG_PARAMS_WRONG = 2,
+	BATTERY_DEREGISTRATION_FAILED = 4,
+	BATTERY_MODIFICATION_FAILED = 8,
+	BATTERY_INTERROGATION_FAILED = 16,
+	/* Client's filter could not be set because perhaps it does not exist */
+	BATTERY_SET_FILTER_FAILED         = 32,
+	/* Client's could not be found for enabling or disabling the individual
+	 * client */
+	BATTERY_ENABLE_DISABLE_INDIVIDUAL_CLIENT_FAILED  = 64,
+	BATTERY_LAST_ERROR = 128,
+};
+
+enum {
+	BATTERY_VOLTAGE_UP = 0,
+	BATTERY_VOLTAGE_DOWN,
+	BATTERY_VOLTAGE_ABOVE_THIS_LEVEL,
+	BATTERY_VOLTAGE_BELOW_THIS_LEVEL,
+	BATTERY_VOLTAGE_LEVEL,
+	BATTERY_ALL_ACTIVITY,
+	VBATT_CHG_EVENTS,
+	BATTERY_VOLTAGE_UNKNOWN,
+};
+
+/*
+ * This enum contains defintions of the charger hardware status
+ */
+enum chg_charger_status_type {
+    /* The charger is good      */
+    CHARGER_STATUS_GOOD,
+    /* The charger is bad       */
+    CHARGER_STATUS_BAD,
+    /* The charger is weak      */
+    CHARGER_STATUS_WEAK,
+    /* Invalid charger status.  */
+    CHARGER_STATUS_INVALID
+};
+
+/*
+ *This enum contains defintions of the charger hardware type
+ */
+enum chg_charger_hardware_type {
+    /* The charger is removed                 */
+    CHARGER_TYPE_NONE,
+    /* The charger is a regular wall charger   */
+    CHARGER_TYPE_WALL,
+    /* The charger is a PC USB                 */
+    CHARGER_TYPE_USB_PC,
+    /* The charger is a wall USB charger       */
+    CHARGER_TYPE_USB_WALL,
+    /* The charger is a USB carkit             */
+    CHARGER_TYPE_USB_CARKIT,
+    /* Invalid charger hardware status.        */
+    CHARGER_TYPE_INVALID
+};
+
+/*
+ *  This enum contains defintions of the battery status
+ */
+enum chg_battery_status_type {
+    /* The battery is good        */
+    BATTERY_STATUS_GOOD,
+    /* The battery is cold/hot    */
+    BATTERY_STATUS_BAD_TEMP,
+    /* The battery is bad         */
+    BATTERY_STATUS_BAD,
+	/* The battery is removed     */
+	BATTERY_STATUS_REMOVED,		/* on v2.2 only */
+	BATTERY_STATUS_INVALID_v1 = BATTERY_STATUS_REMOVED,
+    /* Invalid battery status.    */
+    BATTERY_STATUS_INVALID
+};
+
+/*
+ *This enum contains defintions of the battery voltage level
+ */
+enum chg_battery_level_type {
+    /* The battery voltage is dead/very low (less than 3.2V)        */
+    BATTERY_LEVEL_DEAD,
+    /* The battery voltage is weak/low (between 3.2V and 3.4V)      */
+    BATTERY_LEVEL_WEAK,
+    /* The battery voltage is good/normal(between 3.4V and 4.2V)  */
+    BATTERY_LEVEL_GOOD,
+    /* The battery voltage is up to full (close to 4.2V)            */
+    BATTERY_LEVEL_FULL,
+    /* Invalid battery voltage level.                               */
+    BATTERY_LEVEL_INVALID
+};
+
+//fatory jig check 2010.08.06 Huh Won
+int batt_jig_on_status=0;
+EXPORT_SYMBOL(batt_jig_on_status);
+
+/* sys fs */
+struct class *jig_class;
+EXPORT_SYMBOL(jig_class);
+struct device *jig_dev;
+EXPORT_SYMBOL(jig_dev);
+
+static ssize_t jig_show(struct device *dev, struct device_attribute *attr, char *buf);
+static DEVICE_ATTR(jig , S_IRUGO | S_IWUSR | S_IWOTH | S_IXOTH, jig_show, NULL);
+
+static ssize_t jig_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", batt_jig_on_status );
+}
+/* sys fs */
+
+
+
+struct rpc_reply_batt_chg_v1 {
+	struct rpc_reply_hdr hdr;
+	u32 	more_data;
+
+	u32	charger_status;
+	u32	charger_type;
+	u32	battery_status;
+	u32	battery_level;
+	u32	battery_voltage;
+	u32	battery_temp;
+	u32	chg_current;
+#ifdef CONFIG_WIRELESS_CHARGING
+	u32	wc_adc;
+#endif
+};
+
+struct rpc_reply_batt_chg_v2 {
+	struct rpc_reply_batt_chg_v1	v1;
+
+	u32	is_charger_valid;
+	u32	is_charging;
+	u32	is_battery_valid;
+	u32	ui_event;
+};
+
+union rpc_reply_batt_chg {
+	struct rpc_reply_batt_chg_v1	v1;
+	struct rpc_reply_batt_chg_v2	v2;
+};
+
+static union rpc_reply_batt_chg rep_batt_chg;
+
+struct msm_battery_info {
+	u32 voltage_max_design;
+	u32 voltage_min_design;
+	u32 chg_api_version;
+	u32 batt_technology;
+	u32 batt_api_version;
+
+	u32 avail_chg_sources;
+	u32 current_chg_source;	// NC (charging_source)
+
+	u32 batt_status;
+	u32 batt_health;
+	u32 charger_valid;		// NC
+	u32 batt_valid;
+	u32 batt_capacity; 		/* in percentage */
+
+	u32 charger_status;		// NC
+	u32 charger_type;
+	u32 battery_status;		// NC
+	u32 battery_level;		// NC (batt_capacity)
+	u32 battery_voltage;
+	u32 battery_voltage_adc; // Volatage ADC
+
+	u32 fg_soc;				// NC
+	u32 batt_vol;			// NC (battery_voltage)
+	u32 batt_temp_check;
+	u32 batt_full_check;
+	u32 charging_source;
+
+	u32 battery_temp;		/* in celsius */
+	u32 battery_temp_adc;	/* ADC code from CP */
+	u32 chg_current_adc;	// ICHG ADC code (charging current)
+	u32 batt_recharging;
+
+	u32 batt_wireless;		// CONFIG_WIRELESS_CHARGING
+	u32 wc_adc;				// CONFIG_WIRELESS_CHARGING
+
+	u32 chargingblock_clear;
+	u32 batt_voltage_now;	// for low batt
+
+	u32(*calculate_capacity) (u32 voltage);	// NC
+
+	s32 batt_handle;
+
+	struct power_supply *msm_psy_ac;
+	struct power_supply *msm_psy_usb;
+	struct power_supply *msm_psy_batt;
+	struct power_supply *current_ps;		// NC
+
+	struct msm_rpc_client *batt_client;
+	struct msm_rpc_endpoint *chg_ep;
+
+	struct workqueue_struct *msm_batt_wq;
+	struct timer_list timer;
+
+	wait_queue_head_t wait_q;
+
+	u32 vbatt_modify_reply_avail;			// NC
+
+	struct early_suspend early_suspend;
+};
+
+static struct msm_battery_info msm_batt_info = {
+	.batt_handle = INVALID_BATT_HANDLE,
+	.charger_type = CHARGER_TYPE_NONE,
+	.battery_voltage = BATTERY_HIGH,
+	.batt_capacity = 100,
+	.batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING,
+	.batt_health = POWER_SUPPLY_HEALTH_GOOD,
+	.batt_valid  = 1,
+	.battery_temp = 230,	// 23.0`C
+#ifdef CONFIG_WIRELESS_CHARGING
+	.batt_wireless = 0,
+	.wc_adc = 0,
+#endif
+};
+
+static enum power_supply_property msm_power_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static char *msm_power_supplied_to[] = {
+	"battery",
+};
+
+#define BATT_CHECK_INTERVAL	(5 * TIME_UNIT_SECOND) // every 5 sec
+
+static unsigned int charging_start_time = 0;
+
+static int msm_batt_driver_init = 0;
+static int msm_batt_unhandled_interrupt = 0;
+
+//Temp for USB OTG charging problem
+enum chg_type {
+	USB_CHG_TYPE__SDP,
+	USB_CHG_TYPE__CARKIT,
+	USB_CHG_TYPE__WALLCHARGER,
+	USB_CHG_TYPE__INVALID
+};
+
+extern void hsusb_chg_connected_ext(enum chg_type chgtype);
+extern void hsusb_chg_vbus_draw_ext(unsigned mA);
+extern int fsa9480_get_charger_status(void);
+extern int fsa9480_get_jig_status(void);
+
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+static u32 get_voltage_from_fuelgauge(void);
+static u32 get_level_from_fuelgauge(void);
+#endif
+
+//------------------------------
+
+int batt_restart(void);
+
+//------------------------------
+
+static ssize_t msm_batt_show_property(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf);
+static ssize_t msm_batt_store_property(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count);
+
+static int msm_batt_average_chg_current(int chg_current_adc);
+
+static void msm_batt_check_event(struct work_struct *work);
+static void msm_batt_cable_status_update(void);
+
+/* charging absolute time control */
+static void msm_batt_set_charging_start_time(chg_enable_type enable);
+static int msm_batt_is_over_abs_time(void);
+
+static void msm_batt_update_psy_status(void);
+static DECLARE_WORK(msm_batt_work, msm_batt_check_event);
+
+static void batt_timeover(unsigned long arg )
+{
+	queue_work(msm_batt_info.msm_batt_wq, &msm_batt_work);
+	mod_timer(&msm_batt_info.timer, (jiffies + BATT_CHECK_INTERVAL));
+}
+
+static void msm_batt_check_event(struct work_struct *work)
+{
+	msm_batt_update_psy_status();
+}
+
+#define MSM_BATTERY_ATTR(_name)		\
+{			\
+	.attr = { .name = #_name, .mode = 0664 },	\
+	.show = msm_batt_show_property,			\
+	.store = msm_batt_store_property,		\
+}
+
+static struct device_attribute ariesve_battery_attrs[] = {
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+	MSM_BATTERY_ATTR(fg_soc),
+	MSM_BATTERY_ATTR(reset_soc),
+#endif
+	MSM_BATTERY_ATTR(batt_temp_check),
+	MSM_BATTERY_ATTR(charging_source),
+	MSM_BATTERY_ATTR(batt_chg_current),	// ICHG ADC code (charging current)
+#ifdef __BATT_TEST_DEVICE__
+	MSM_BATTERY_ATTR(batt_temp_test_adc),
+#endif
+#ifdef CONFIG_WIRELESS_CHARGING
+	MSM_BATTERY_ATTR(wc_status),
+	MSM_BATTERY_ATTR(wc_adc),
+#endif
+	MSM_BATTERY_ATTR(chargingblock_clear),
+};
+
+enum {
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+	FG_SOC,
+	RESET_SOC,
+#endif
+	BATT_TEMP_CHECK,
+	CHARGING_SOURCE,
+	BATT_CHG_CURRENT,
+#ifdef __BATT_TEST_DEVICE__
+	BATT_TEMP_TEST_ADC,
+#endif
+#ifdef CONFIG_WIRELESS_CHARGING
+	WC_STATUS,
+	WC_ADC,
+#endif
+	CHARGINGBLOCK_CLEAR,
+};
+
+static int msm_batt_create_attrs(struct device * dev)
+{
+	int i, rc;
+
+
+	for (i = 0; i < ARRAY_SIZE(ariesve_battery_attrs); i++)
+	{
+		rc = device_create_file(dev, &ariesve_battery_attrs[i]);
+		if (rc)
+			goto failed;
+	}
+	goto succeed;
+
+failed:
+	while (i--)
+		device_remove_file(dev, &ariesve_battery_attrs[i]);
+
+succeed:
+	return rc;
+}
+
+static void msm_batt_remove_attrs(struct device * dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ariesve_battery_attrs); i++)
+	{
+		device_remove_file(dev, &ariesve_battery_attrs[i]);
+	}
+}
+
+#if 1
+static ssize_t msm_batt_show_property(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	int i = 0;
+	const ptrdiff_t offset = attr - ariesve_battery_attrs;
+
+	switch (offset) {
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+		case FG_SOC:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				get_level_from_fuelgauge());
+			break;
+		case RESET_SOC :
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				fg_reset_soc());
+			break;
+#endif
+		case BATT_TEMP_CHECK:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				msm_batt_info.batt_temp_check);
+			break;
+		case CHARGING_SOURCE:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				msm_batt_info.charging_source);
+			break;
+		case BATT_CHG_CURRENT: // ICHG ADC code (charging current)
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				msm_batt_info.chg_current_adc);
+			break;
+#ifdef __BATT_TEST_DEVICE__
+		case BATT_TEMP_TEST_ADC:
+				i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n", temp_test_adc);
+			break;
+#endif
+#ifdef CONFIG_WIRELESS_CHARGING
+		case WC_STATUS:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				msm_batt_info.batt_wireless);
+			break;
+		case WC_ADC:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n",
+				msm_batt_info.wc_adc);
+			break;
+#endif
+		case CHARGINGBLOCK_CLEAR:
+			i += scnprintf(buf + i, PAGE_SIZE - i, "%d\n", msm_batt_info.chargingblock_clear);
+			break;
+		default:
+			i = -EINVAL;
+	}
+
+	return i;
+}
+
+static ssize_t msm_batt_store_property(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	int x = 0;
+	int ret = 0;
+	const ptrdiff_t offset = attr - ariesve_battery_attrs;
+
+
+	switch (offset) {
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+	case RESET_SOC:
+ 		if (sscanf(buf, "%d\n", &x) == 1) {
+			fg_reset_soc();	// rilactionservice.java...
+			ret = count;
+		}
+		break;
+#endif
+#ifdef __BATT_TEST_DEVICE__
+	case BATT_TEMP_TEST_ADC:
+ 		if (sscanf(buf, "%d\n", &x) == 1) {
+			if (x == 0)
+				temp_test_adc = 0;
+			else
+			{
+				temp_test_adc = x;
+			}
+			ret = count;
+		}
+		break;
+#endif
+	case CHARGINGBLOCK_CLEAR:
+ 		if (sscanf(buf, "%d\n", &x) == 1) {
+			pr_debug("\n[BATT] %s: chargingblock_clear -> write 0x%x\n\n", __func__, x);
+			msm_batt_info.chargingblock_clear = x;
+			ret = count;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}	/* end of switch */
+
+ 	return ret;
+}
+#endif
+
+static int msm_power_get_property(struct power_supply *psy,
+				  enum power_supply_property psp,
+				  union power_supply_propval *val)
+{
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		if (psy->type == POWER_SUPPLY_TYPE_MAINS) {
+			val->intval = msm_batt_info.charging_source & AC_CHG
+			    ? 1 : 0;
+		}
+		if (psy->type == POWER_SUPPLY_TYPE_USB) {
+			val->intval = msm_batt_info.charging_source & USB_CHG
+			    ? 1 : 0;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct power_supply msm_psy_ac = {
+	.name = "ac",
+	.type = POWER_SUPPLY_TYPE_MAINS,
+	.supplied_to = msm_power_supplied_to,
+	.num_supplicants = ARRAY_SIZE(msm_power_supplied_to),
+	.properties = msm_power_props,
+	.num_properties = ARRAY_SIZE(msm_power_props),
+	.get_property = msm_power_get_property,
+};
+
+static struct power_supply msm_psy_usb = {
+	.name = "usb",
+	.type = POWER_SUPPLY_TYPE_USB,
+	.supplied_to = msm_power_supplied_to,
+	.num_supplicants = ARRAY_SIZE(msm_power_supplied_to),
+	.properties = msm_power_props,
+	.num_properties = ARRAY_SIZE(msm_power_props),
+	.get_property = msm_power_get_property,
+};
+
+static enum power_supply_property msm_batt_power_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_BATT_TEMP,
+	POWER_SUPPLY_PROP_BATT_TEMP_ADC,
+	POWER_SUPPLY_PROP_BATT_VOL,
+	POWER_SUPPLY_PROP_BATT_VOL_ADC,
+	POWER_SUPPLY_PROP_BATT_VF_ADC,
+	POWER_SUPPLY_PROP_BATT_VOL_ADC_AVER,
+	POWER_SUPPLY_PROP_BATT_TEMP_ADC_AVER,
+	POWER_SUPPLY_PROP_BATT_VOL_AVER,
+	POWER_SUPPLY_PROP_BATT_TEMP_AVER,
+	POWER_SUPPLY_PROP_BATT_TYPE,
+	POWER_SUPPLY_PROP_BATT_FULL,
+};
+
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+static u32 get_voltage_from_fuelgauge(void)
+{
+	if (is_attached)
+		return (fg_read_vcell());	// +0 (voltage drop compensation)
+	return 3700;	// default
+}
+
+static u32 get_level_from_fuelgauge(void)
+{
+	if (is_attached)
+		return fg_read_soc();
+	return 100;	// default
+}
+#endif
+
+static int msm_batt_power_get_property(struct power_supply *psy,
+				       enum power_supply_property psp,
+				       union power_supply_propval *val)
+{
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = msm_batt_info.batt_status;
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = msm_batt_info.batt_health;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = msm_batt_info.batt_valid;
+		break;
+	case POWER_SUPPLY_PROP_TECHNOLOGY:
+		val->intval = msm_batt_info.batt_technology;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN:
+		val->intval = msm_batt_info.voltage_max_design;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN:
+		val->intval = msm_batt_info.voltage_min_design;
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = msm_batt_info.batt_voltage_now;
+		break;
+	case POWER_SUPPLY_PROP_CAPACITY:
+		val->intval = msm_batt_info.batt_capacity;
+		break;
+	case POWER_SUPPLY_PROP_BATT_TEMP:
+		val->intval = msm_batt_info.battery_temp;
+		break;
+	case POWER_SUPPLY_PROP_BATT_TEMP_ADC:
+		val->intval = msm_batt_info.battery_temp_adc;
+		break;
+	case POWER_SUPPLY_PROP_BATT_VOL:
+		val->intval = msm_batt_info.battery_voltage;
+		break;
+	case POWER_SUPPLY_PROP_BATT_VOL_ADC:
+		val->intval = msm_batt_info.battery_voltage_adc;
+		break;
+	case POWER_SUPPLY_PROP_BATT_VF_ADC:
+//		val->intval = msm_batt_info.battery_vf;
+		break;
+	case POWER_SUPPLY_PROP_BATT_VOL_ADC_AVER:
+		val->intval = msm_batt_info.battery_level;
+		break;
+	case POWER_SUPPLY_PROP_BATT_TEMP_ADC_AVER:
+		val->intval = msm_batt_info.battery_temp;
+		break;
+	case POWER_SUPPLY_PROP_BATT_VOL_AVER:
+		val->intval = msm_batt_info.battery_voltage;
+		break;
+	case POWER_SUPPLY_PROP_BATT_TEMP_AVER:
+		val->intval = msm_batt_info.battery_temp_adc;
+		break;
+	case POWER_SUPPLY_PROP_BATT_TYPE:
+		break;
+	case POWER_SUPPLY_PROP_BATT_FULL:
+		val->intval = msm_batt_info.batt_full_check;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct power_supply msm_psy_batt = {
+	.name = "battery",
+	.type = POWER_SUPPLY_TYPE_BATTERY,
+	.properties = msm_batt_power_props,
+	.num_properties = ARRAY_SIZE(msm_batt_power_props),
+	.get_property = msm_batt_power_get_property,
+};
+
+#ifdef MAX17043_FUEL_GAUGE
+struct timer_list fg_alert_timer;
+extern int (*fg_alert_handler)(int);
+static void fg_set_alert_ext(unsigned long arg)
+{
+
+	if (msm_batt_info.charging_source == NO_CHG)
+	{
+		pr_info("[BATT] %s: low battery, power off...\n", __func__);
+		is_alert = 1;
+		wake_lock_timeout(&vbus_wake_lock, 30 * TIME_UNIT_SECOND);
+	}
+	else
+		is_alert = 0;
+}
+
+static int fg_set_alert(int value)
+{
+
+	if (value)
+	{
+		is_alert =
+		mod_timer(&fg_alert_timer, (jiffies + (1 * TIME_UNIT_MINUTE)));
+//		is_alert = 1;
+//		wake_lock_timeout(&vbus_wake_lock, 30 * TIME_UNIT_SECOND);
+	}
+	else
+	{
+		// clear alert flag
+		is_alert = 0;
+	}
+
+	return is_alert;
+}
+
+
+#endif	/* MAX17043_FUEL_GAUGE */
+
+static void msm_batt_chg_en(chg_enable_type enable)
+{
+
+	if (enable == START_CHARGING)
+	{
+		if (msm_batt_info.charging_source == NO_CHG)	// *Note: DO NOT USE "&" operation for NO_CHG (0x0), it returns FALSE always.
+		{
+			pr_err("[BATT] %s: charging_source not defined!\n", __func__);
+			return ;
+		}
+
+		// Set charging current (ICHG; mA)
+		if (msm_batt_info.charging_source & AC_CHG)
+		{
+			pr_info("[BATT] %s: Start charging! (charging_source = AC, wireless = %d)\n", __func__, msm_batt_info.batt_wireless);
+			hsusb_chg_connected_ext(USB_CHG_TYPE__WALLCHARGER);
+#ifdef CONFIG_WIRELESS_CHARGING
+			if (msm_batt_info.batt_wireless)
+				hsusb_chg_vbus_draw_ext(500);	// wireless charging	(450mA)
+			else
+#endif
+				hsusb_chg_vbus_draw_ext(650);	// TA charging	(600mA)
+		}
+		else // USB_CHG
+		{
+			pr_info("[BATT] %s: Start charging! (charging_source = USB)\n", __func__);
+			hsusb_chg_connected_ext(USB_CHG_TYPE__SDP);
+			//hsusb_chg_vbus_draw_ext(450); // USB charging	(400mA)
+			hsusb_chg_vbus_draw_ext(500); // USB charging	(450mA)
+		}
+
+		msm_batt_set_charging_start_time(START_CHARGING);
+#ifdef MAX17043_FUEL_GAUGE
+		fg_set_alert(0);
+#endif
+	}
+	else	// STOP_CHARGING
+	{
+		msm_batt_set_charging_start_time(STOP_CHARGING);
+
+		if (msm_batt_info.charging_source == NO_CHG)
+			hsusb_chg_connected_ext(USB_CHG_TYPE__INVALID);	// not charging
+		else
+			hsusb_chg_vbus_draw_ext(0);	// discharging
+
+		msm_batt_average_chg_current(-1);	// Initialize all current data sampling
+
+		pr_info("[BATT] %s: Stop charging! (charging_source = 0x%x, full_check = %d)\n",
+			__func__, msm_batt_info.charging_source, msm_batt_info.batt_full_check);
+	}
+}
+
+static int msm_batt_average_chg_current(int chg_current_adc)
+{
+	static int history[AVERAGE_COUNT] = {0};
+	static int count = 0;
+	static int index = 0;
+	int i, sum, max, min, ret;
+
+
+
+	if (chg_current_adc == 0)
+		return 0;
+
+	if (chg_current_adc < 0)	// initialize all data
+	{
+		count = 0;
+		index = 0;
+		for (i=0; i<AVERAGE_COUNT; i++)	history[i] = 0;
+
+		return 0;
+	}
+
+	if (count == 0)	// no data
+	{
+		for (i=0; i<AVERAGE_COUNT; i++)	history[i] = chg_current_adc;
+	}
+
+	if (index >= count)	count++;
+
+	max = min = history[0];
+	sum = 0;
+
+	for (i=0; i<AVERAGE_COUNT; i++)
+	{
+		if (i == index)
+		{
+			history[i] = chg_current_adc;
+		}
+
+		if (max < history[i])	max = history[i];
+		if (min > history[i])	min = history[i];
+
+		sum += history[i];
+	}
+
+	ret = ((sum-max-min) / (AVERAGE_COUNT-2));
+
+	index++;
+	if (index == AVERAGE_COUNT)
+	{
+		history[0] = ret;
+		index = 1;
+	}
+
+	pr_debug("[BATT] %s: adc=%d, sum=%d, max=%d, min=%d, ret=%d\n", __func__, chg_current_adc, sum, max, min, ret);
+
+	if (count < AVERAGE_COUNT)
+		return (BATT_FULL_CHARGING_CURRENT+50);	// do not check full charging before current sampling is stable...
+
+	return ret;
+}
+
+static int msm_batt_check_full_charging(int chg_current_adc)
+{
+	static unsigned int time_after_under_tsh = 0;
+
+	if (chg_current_adc == 0)
+		return 0;	// not charging
+
+	// check charging absolute time
+	if (msm_batt_is_over_abs_time())
+	{
+		pr_info("[BATT] %s: Fully charged, over abs time! (recharging=%d)\n", __func__, msm_batt_info.batt_recharging);
+		msm_batt_info.batt_full_check = 0;
+		msm_batt_info.batt_recharging = 1;
+		msm_batt_info.batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		msm_batt_chg_en(STOP_CHARGING);
+		return 1;
+	}
+
+	if (msm_batt_info.battery_voltage >= BATT_FULL_CHARGING_VOLTAGE)
+	{
+		// check charging current threshold
+		if (chg_current_adc < BATT_FULL_CHARGING_CURRENT)
+		{
+			if (time_after_under_tsh == 0)
+				time_after_under_tsh = jiffies;
+			else
+			{
+				if (time_after((unsigned long)jiffies, (unsigned long)(time_after_under_tsh + TOTAL_WATING_TIME)))
+				{
+					// fully charged !
+					pr_info("[BATT] %s: Fully charged, cut off charging current! (voltage=%d, ICHG=%d)\n",
+						__func__, msm_batt_info.battery_voltage, chg_current_adc);
+					msm_batt_info.batt_full_check = 1;
+					msm_batt_info.batt_recharging = 0;
+					msm_batt_info.batt_status = POWER_SUPPLY_STATUS_FULL;
+					time_after_under_tsh = 0;
+					msm_batt_chg_en(STOP_CHARGING);
+					return 1;
+				}
+			}
+		}
+		else
+		{
+			time_after_under_tsh = 0;
+		}
+	}
+
+	return 0;
+}
+
+static int msm_batt_check_recharging(void)
+{
+	static unsigned int time_after_vol1 = 0, time_after_vol2 = 0;
+
+
+	if ( (msm_batt_info.batt_full_check == 0) ||
+		(msm_batt_info.batt_recharging == 1) ||
+		(msm_batt_info.batt_health != POWER_SUPPLY_HEALTH_GOOD) )
+	{
+		time_after_vol1 = 0;
+		time_after_vol2 = 0;
+		return 0;
+	}
+
+	/* check 1st voltage */
+	if (msm_batt_info.battery_voltage <= BATT_RECHARGING_VOLTAGE_1)
+	{
+		if (time_after_vol1 == 0)
+			time_after_vol1 = jiffies;
+
+		if (time_after((unsigned long)jiffies, (unsigned long)(time_after_vol1 + TOTAL_WATING_TIME)))
+		{
+			pr_info("[BATT] %s: Recharging ! (voltage1 = %d)\n", __func__, msm_batt_info.battery_voltage);
+			msm_batt_info.batt_recharging = 1;
+			msm_batt_chg_en(START_CHARGING);
+			return 1;
+		}
+	}
+	else
+		time_after_vol1 = 0;
+
+	/* check 2nd voltage */
+	if (msm_batt_info.battery_voltage <= BATT_RECHARGING_VOLTAGE_2)
+	{
+		if (time_after_vol2 == 0)
+			time_after_vol2 = jiffies;
+
+		if (time_after((unsigned long)jiffies, (unsigned long)(time_after_vol2 + TOTAL_WATING_TIME)))
+		{
+			pr_info("[BATT] %s: Recharging ! (voltage2 = %d)\n", __func__, msm_batt_info.battery_voltage);
+			msm_batt_info.batt_recharging = 1;
+			msm_batt_chg_en(START_CHARGING);
+			return 1;
+		}
+	}
+	else
+		time_after_vol2 = 0;
+
+	return 0;
+}
+
+static int msm_batt_check_level(int battery_level)
+{
+	if (msm_batt_info.batt_full_check == 0 && battery_level == 100)
+		battery_level = 99;	// not yet fully charged
+
+	if (msm_batt_info.batt_capacity != battery_level)
+	{
+		pr_info("[BATT] %s: Battery level changed ! (%d -> %d)\n", __func__, msm_batt_info.batt_capacity, battery_level);
+		msm_batt_info.batt_capacity = battery_level;
+		return 1;
+	}
+
+#ifdef MAX17043_FUEL_GAUGE
+	if (is_alert)
+		return 1;	// force update to power off !
+#endif
+
+	return 0;
+}
+
+static int msm_batt_average_temperature(int temp_adc)
+{
+	static int history[AVERAGE_COUNT] = {0};
+	static int count = 0;
+	static int index = 0;
+	int i, sum, max, min, ret;
+
+	if (temp_adc == 0)
+		return 0;
+
+	if (count == 0 && temp_adc == 150)
+		return 0;
+
+#ifdef __BATT_TEST_DEVICE__
+		if (temp_test_adc)
+			return temp_test_adc;
+#endif
+
+	if (count == 0)	// no data
+	{
+		for (i=0; i<AVERAGE_COUNT; i++)	history[i] = temp_adc;
+	}
+
+	if (index >= count)	count++;
+
+	max = min = history[0];
+	sum = 0;
+
+	for (i=0; i<AVERAGE_COUNT; i++)
+	{
+		if (i == index)
+		{
+			history[i] = temp_adc;
+		}
+
+		if (max < history[i])	max = history[i];
+		if (min > history[i])	min = history[i];
+
+		sum += history[i];
+	}
+
+	ret = ((sum-max-min) / (AVERAGE_COUNT-2));
+
+	index++;
+	if (index == AVERAGE_COUNT)
+	{
+		history[0] = ret;
+		index = 1;
+	}
+
+	pr_debug("[BATT] %s: adc=%d, sum=%d, max=%d, min=%d, ret=%d\n", __func__, temp_adc, sum, max, min, ret);
+	return ret;
+}
+
+static int msm_batt_control_temperature(int temp_adc)
+{
+	int prev_health = msm_batt_info.batt_health;
+	int new_health = prev_health;
+	int array_size = 0;
+	int i;
+	int degree;
+
+
+	static char *health_text[] = {
+		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
+		"Unspecified failure", "Cold",
+	};
+
+	if (temp_adc == 0)
+		return 0;
+
+#ifdef __AUTO_TEMP_TEST__
+	static unsigned int auto_test_start_time = 0;
+	static unsigned int auto_test_interval = (2 * TIME_UNIT_MINUTE);
+	static int auto_test_mode = 0;	// 0: normal (recover cold), 1: force overheat, 2: normal (recover overheat), 3: force cold
+
+	if (msm_batt_info.charging_source != NO_CHG)	// charging
+	{
+		if (auto_test_start_time == 0)
+			auto_test_start_time = jiffies;
+
+		if (time_after((unsigned long)jiffies, (unsigned long)(auto_test_start_time + auto_test_interval)))
+		{
+			auto_test_mode++;
+			if (auto_test_mode > 3) auto_test_mode = 0;
+			auto_test_start_time = jiffies;
+		}
+		pr_debug("[BATT] auto test mode = %d (0:normal,1:overheat,2:normal,3:cold)\n", auto_test_mode);
+
+		if (auto_test_mode == 1)
+		{
+			temp_adc = BATT_TEMP_HIGH_BLOCK + 10;
+			msm_batt_info.battery_temp_adc = temp_adc;
+		}
+		else if (auto_test_mode == 3)
+		{
+			temp_adc = BATT_TEMP_LOW_BLOCK - 10;
+			msm_batt_info.battery_temp_adc = temp_adc;
+		}
+	}
+	else	// not charging
+	{
+		auto_test_start_time = 0;
+		auto_test_mode = 0;
+	}
+#endif
+
+	// map in celcius degree
+	array_size = ARRAY_SIZE(temp_table);
+	for (i = 0; i <= (array_size - 1); i++)
+	{
+		if (i == 0)
+		{
+			if (temp_adc >= temp_table[0][0])
+			{
+				degree = temp_table[0][1];
+				break;
+			}
+			else if (temp_adc <= temp_table[array_size-1][0])
+			{
+				degree = temp_table[array_size-1][1];
+				break;
+			}
+		}
+
+		if (temp_table[i][0] < temp_adc && temp_table[i-1][0] >= temp_adc)
+		{
+			degree = temp_table[i-1][1];
+		}
+	}
+
+	msm_batt_info.battery_temp = degree;	// celcius degree
+
+	// TODO:  check application
+
+	if (prev_health == POWER_SUPPLY_HEALTH_UNSPEC_FAILURE)
+	{
+		return 0;	// do not check temperature... (charging is already blocked!)
+	}
+
+	if (temp_adc <= BATT_TEMP_HIGH_BLOCK)
+	{
+		// over high block
+		if (prev_health != POWER_SUPPLY_HEALTH_OVERHEAT)
+			new_health = POWER_SUPPLY_HEALTH_OVERHEAT;
+	}
+	else if ((temp_adc >= BATT_TEMP_HIGH_RECOVER) && (temp_adc <= BATT_TEMP_LOW_RECOVER))
+	{
+		// low recover ~ high recover (normal)
+		if ( (prev_health == POWER_SUPPLY_HEALTH_OVERHEAT) ||
+			(prev_health == POWER_SUPPLY_HEALTH_COLD) )
+			new_health = POWER_SUPPLY_HEALTH_GOOD;
+	}
+	else if (temp_adc >= BATT_TEMP_LOW_BLOCK)
+	{
+		// under low block
+		if (prev_health != POWER_SUPPLY_HEALTH_COLD)
+			new_health = POWER_SUPPLY_HEALTH_COLD;
+	}
+
+	if (msm_batt_info.charging_source == NO_CHG)
+	{
+		if ((BATT_TEMP_LOW_BLOCK > temp_adc) && (temp_adc > BATT_TEMP_HIGH_BLOCK))
+		{
+			if ( (prev_health == POWER_SUPPLY_HEALTH_OVERHEAT) ||
+				(prev_health == POWER_SUPPLY_HEALTH_COLD) )
+				new_health = POWER_SUPPLY_HEALTH_GOOD;
+		}
+	}
+
+	if (msm_batt_info.chargingblock_clear != 0x0)
+		new_health = POWER_SUPPLY_HEALTH_GOOD;
+
+	if (prev_health != new_health)
+	{
+		if (msm_batt_info.charging_source == NO_CHG)	// not charging
+		{
+			pr_info("[BATT] %s: Health changed by temperature! (ADC = %d, %s-> %s)\n",
+				__func__, temp_adc, health_text[prev_health], health_text[new_health]);
+				msm_batt_info.batt_status = POWER_SUPPLY_STATUS_DISCHARGING;
+		}
+		else	// in charging
+		{
+			if (new_health != POWER_SUPPLY_HEALTH_GOOD)	// block!
+			{
+				pr_info("[BATT] %s: Block charging! (ADC = %d, %s-> %s)\n",
+					__func__, temp_adc, health_text[prev_health], health_text[new_health]);
+				msm_batt_info.batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+				msm_batt_chg_en(STOP_CHARGING);
+			}
+			else if (msm_batt_info.batt_full_check == 0)	// recover!
+			{
+				pr_info("[BATT] %s: Recover charging! (ADC = %d, %s-> %s)\n",
+					__func__, temp_adc, health_text[prev_health], health_text[new_health]);
+				msm_batt_info.batt_status = POWER_SUPPLY_STATUS_CHARGING;
+				msm_batt_chg_en(START_CHARGING);
+			}
+		}
+
+		msm_batt_info.batt_health = new_health;
+	}
+
+	return 1;
+//	return 0;	// nothing is changed
+}
+
+#define	be32_to_cpu_self(v)	(v = be32_to_cpu(v))
+#define	be16_to_cpu_self(v)	(v = be16_to_cpu(v))
+
+static int msm_batt_get_batt_chg_status(void)
+{
+	int rc ;
+	struct rpc_req_batt_chg {
+		struct rpc_request_hdr hdr;
+		u32 more_data;
+	} req_batt_chg;
+	struct rpc_reply_batt_chg_v1 *v1p;
+
+
+	req_batt_chg.more_data = cpu_to_be32(1);
+
+	memset(&rep_batt_chg, 0, sizeof(rep_batt_chg));
+
+	v1p = &rep_batt_chg.v1;
+	rc = msm_rpc_call_reply(msm_batt_info.chg_ep,
+				ONCRPC_CHG_GET_GENERAL_STATUS_PROC,
+				&req_batt_chg, sizeof(req_batt_chg),
+				&rep_batt_chg, sizeof(rep_batt_chg),
+				msecs_to_jiffies(BATT_RPC_TIMEOUT));
+	if (rc < 0) {
+		pr_err("%s: ERROR. msm_rpc_call_reply failed! proc=%d rc=%d\n",
+		       __func__, ONCRPC_CHG_GET_GENERAL_STATUS_PROC, rc);
+		return rc;
+	} else if (be32_to_cpu(v1p->more_data)) {
+		be32_to_cpu_self(v1p->charger_status);
+		be32_to_cpu_self(v1p->charger_type);
+		be32_to_cpu_self(v1p->battery_status);
+		be32_to_cpu_self(v1p->battery_level);
+		be32_to_cpu_self(v1p->battery_voltage);
+		be32_to_cpu_self(v1p->battery_temp);
+		be32_to_cpu_self(v1p->chg_current);
+#ifdef CONFIG_WIRELESS_CHARGING
+		be32_to_cpu_self(v1p->wc_adc);
+#endif
+	} else {
+		pr_err("%s: No battery/charger data in RPC reply\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static void msm_batt_update_psy_status(void)
+{
+	u32	charger_status;
+	u32	charger_type;
+	u32	battery_status;
+	u32	battery_level;
+	u32	fuel_battery_voltage;
+	u32 battery_voltage_adc;
+	u32	battery_temp_adc;
+	u32 chg_current_adc;
+#ifdef CONFIG_WIRELESS_CHARGING
+	u32 wc_adc;
+#endif
+
+	u32 status_changed = 0;
+
+	/*
+	// Check LPM mode
+	if(charging_boot)
+	{
+		msm_batt_info.batt_voltage_now = charging_boot;
+		msm_batt_info.batt_status = 0;
+	}
+	*/
+
+	/* Get general status from CP by RPC */
+	if (msm_batt_get_batt_chg_status())
+		return;
+
+	charger_status = rep_batt_chg.v1.charger_status;
+	charger_type = rep_batt_chg.v1.charger_type;
+	battery_status = rep_batt_chg.v1.battery_status;
+	battery_temp_adc = rep_batt_chg.v1.battery_temp;
+//	chg_current_adc = rep_batt_chg.v1.chg_current;
+	chg_current_adc = battery_voltage_adc = rep_batt_chg.v1.battery_voltage;  // Use voltage for current adc
+
+	msm_batt_info.battery_voltage_adc = battery_voltage_adc;
+	msm_batt_info.battery_temp_adc = battery_temp_adc;
+
+#ifdef CONFIG_WIRELESS_CHARGING
+	wc_adc = rep_batt_chg.v1.wc_adc;
+	wc_adc = wc_adc * 46 / 160;	// HW req.
+#endif
+
+	if ( (msm_batt_info.batt_status == POWER_SUPPLY_STATUS_CHARGING) ||
+		(msm_batt_info.batt_recharging == 1) )
+	{
+		pr_debug("[BATT] %s: chg_current_adc from CP = %d\n", __func__, chg_current_adc);
+		if (chg_current_adc < 30)
+			chg_current_adc = 0;
+	}
+	else
+		chg_current_adc = 0;	// not charging
+
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+	battery_level = get_level_from_fuelgauge();
+	fuel_battery_voltage = get_voltage_from_fuelgauge();
+#endif
+
+	msm_batt_info.battery_voltage = fuel_battery_voltage;
+	msm_batt_info.batt_voltage_now = fuel_battery_voltage;
+
+#ifdef CONFIG_WIRELESS_CHARGING
+	msm_batt_info.wc_adc = wc_adc;
+#endif
+
+	/**************************/
+	/* Check what is changed */
+
+	/* check temperature */
+//	msm_batt_info.battery_temp_adc = msm_batt_average_temperature(battery_temp_adc);
+	status_changed += msm_batt_control_temperature(msm_batt_info.battery_temp_adc);
+
+	/* check full charging */
+	msm_batt_info.chg_current_adc = msm_batt_average_chg_current(chg_current_adc);
+	status_changed += msm_batt_check_full_charging(msm_batt_info.chg_current_adc);
+
+	/* check recharging */
+	status_changed += msm_batt_check_recharging();
+
+	/* battery level, capacity (%) */
+	status_changed += msm_batt_check_level(battery_level);
+
+	/* temperature health for power off charging */
+	if (msm_batt_info.batt_health == POWER_SUPPLY_HEALTH_GOOD)
+		msm_batt_info.batt_temp_check = 1;
+	else
+		msm_batt_info.batt_temp_check = 0;
+
+#ifndef DEBUG
+	if (msm_batt_info.charging_source != NO_CHG)
+#endif
+	{
+		pr_info("[BATT] %s: charger_status=%d, charger_type=%d, battery_status=%d, battery_temp_adc=%d, chg_current=%d, wc_adc=%d\n",
+			__func__, charger_status, charger_type, battery_status, msm_batt_info.battery_temp_adc, msm_batt_info.chg_current_adc, msm_batt_info.wc_adc);
+	}
+
+	if (status_changed)
+	{
+		pr_info("[BATT] %s: power_supply_changed !\n", __func__);
+		power_supply_changed(&msm_psy_batt);
+	}
+
+	if (msm_batt_unhandled_interrupt)
+	{
+		msm_batt_cable_status_update();
+		msm_batt_unhandled_interrupt = 0;
+	}
+}
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+struct batt_modify_client_req {
+
+	u32 client_handle;
+
+	/* The voltage at which callback (CB) should be called. */
+	u32 desired_batt_voltage;
+
+	/* The direction when the CB should be called. */
+	u32 voltage_direction;
+
+	/* The registered callback to be called when voltage and
+	 * direction specs are met. */
+	u32 batt_cb_id;
+
+	/* The call back data */
+	u32 cb_data;
+};
+
+struct batt_modify_client_rep {
+	u32 result;
+};
+
+static int msm_batt_modify_client_arg_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct batt_modify_client_req *batt_modify_client_req =
+		(struct batt_modify_client_req *)data;
+	u32 *req = (u32 *)buf;
+	int size = 0;
+
+
+
+	*req = cpu_to_be32(batt_modify_client_req->client_handle);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_modify_client_req->desired_batt_voltage);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_modify_client_req->voltage_direction);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_modify_client_req->batt_cb_id);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_modify_client_req->cb_data);
+	size += sizeof(u32);
+
+	return size;
+}
+
+static int msm_batt_modify_client_ret_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct  batt_modify_client_rep *data_ptr, *buf_ptr;
+
+
+
+	data_ptr = (struct batt_modify_client_rep *)data;
+	buf_ptr = (struct batt_modify_client_rep *)buf;
+
+	data_ptr->result = be32_to_cpu(buf_ptr->result);
+
+	return 0;
+}
+
+static int msm_batt_modify_client(u32 client_handle, u32 desired_batt_voltage,
+	     u32 voltage_direction, u32 batt_cb_id, u32 cb_data)
+{
+	int rc;
+
+	struct batt_modify_client_req  req;
+	struct batt_modify_client_rep rep;
+
+	req.client_handle = client_handle;
+	req.desired_batt_voltage = desired_batt_voltage;
+	req.voltage_direction = voltage_direction;
+	req.batt_cb_id = batt_cb_id;
+	req.cb_data = cb_data;
+
+
+	rc = msm_rpc_client_req(msm_batt_info.batt_client,
+			BATTERY_MODIFY_CLIENT_PROC,
+			msm_batt_modify_client_arg_func, &req,
+			msm_batt_modify_client_ret_func, &rep,
+			msecs_to_jiffies(BATT_RPC_TIMEOUT));
+
+	if (rc < 0) {
+		pr_err("%s: ERROR. failed to modify  Vbatt client\n",
+				__func__);
+		return rc;
+	}
+
+	if (rep.result != BATTERY_MODIFICATION_SUCCESSFUL) {
+		pr_err("%s: ERROR. modify client failed. result = %u\n",
+				__func__, rep.result);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+void msm_batt_early_suspend(struct early_suspend *h)
+{
+	int rc;
+
+
+	pr_debug("%s: enter\n", __func__);
+
+	if (msm_batt_info.batt_handle != INVALID_BATT_HANDLE) {
+		rc = msm_batt_modify_client(msm_batt_info.batt_handle,
+				BATTERY_LOW, BATTERY_VOLTAGE_BELOW_THIS_LEVEL,
+				BATTERY_CB_ID_LOW_VOL, BATTERY_LOW);
+
+		if (rc < 0) {
+			pr_err("%s: msm_batt_modify_client. rc=%d\n",
+			       __func__, rc);
+			return;
+		}
+	} else {
+		pr_err("%s: ERROR. invalid batt_handle\n", __func__);
+		return;
+	}
+
+	pr_debug("%s: exit\n", __func__);
+}
+
+void msm_batt_late_resume(struct early_suspend *h)
+{
+	int rc;
+
+
+	pr_debug("%s: enter\n", __func__);
+
+	if (msm_batt_info.batt_handle != INVALID_BATT_HANDLE) {
+		rc = msm_batt_modify_client(msm_batt_info.batt_handle,
+				BATTERY_LOW, BATTERY_ALL_ACTIVITY,
+			       BATTERY_CB_ID_ALL_ACTIV, BATTERY_ALL_ACTIVITY);
+		if (rc < 0) {
+			pr_err("%s: msm_batt_modify_client FAIL rc=%d\n",
+			       __func__, rc);
+			return;
+		}
+	} else {
+		pr_err("%s: ERROR. invalid batt_handle\n", __func__);
+		return;
+	}
+
+	msm_batt_update_psy_status();
+	pr_debug("%s: exit\n", __func__);
+}
+#endif
+
+struct msm_batt_vbatt_filter_req {
+	u32 batt_handle;
+	u32 enable_filter;
+	u32 vbatt_filter;
+};
+
+struct msm_batt_vbatt_filter_rep {
+	u32 result;
+};
+
+static int msm_batt_filter_arg_func(struct msm_rpc_client *batt_client,
+
+		void *buf, void *data)
+{
+	struct msm_batt_vbatt_filter_req *vbatt_filter_req =
+		(struct msm_batt_vbatt_filter_req *)data;
+	u32 *req = (u32 *)buf;
+	int size = 0;
+
+
+	*req = cpu_to_be32(vbatt_filter_req->batt_handle);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(vbatt_filter_req->enable_filter);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(vbatt_filter_req->vbatt_filter);
+	size += sizeof(u32);
+	return size;
+}
+
+static int msm_batt_filter_ret_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+
+	struct msm_batt_vbatt_filter_rep *data_ptr, *buf_ptr;
+
+
+	data_ptr = (struct msm_batt_vbatt_filter_rep *)data;
+	buf_ptr = (struct msm_batt_vbatt_filter_rep *)buf;
+
+	data_ptr->result = be32_to_cpu(buf_ptr->result);
+	return 0;
+}
+
+static int msm_batt_enable_filter(u32 vbatt_filter)
+{
+	int rc;
+	struct  msm_batt_vbatt_filter_req  vbatt_filter_req;
+	struct  msm_batt_vbatt_filter_rep  vbatt_filter_rep;
+
+
+	vbatt_filter_req.batt_handle = msm_batt_info.batt_handle;
+	vbatt_filter_req.enable_filter = 1;
+	vbatt_filter_req.vbatt_filter = vbatt_filter;
+
+	rc = msm_rpc_client_req(msm_batt_info.batt_client,
+			BATTERY_ENABLE_DISABLE_FILTER_PROC,
+			msm_batt_filter_arg_func, &vbatt_filter_req,
+			msm_batt_filter_ret_func, &vbatt_filter_rep,
+			msecs_to_jiffies(BATT_RPC_TIMEOUT));
+
+	if (rc < 0) {
+		pr_err("%s: FAIL: enable vbatt filter. rc=%d\n",
+		       __func__, rc);
+		return rc;
+	}
+
+	if (vbatt_filter_rep.result != BATTERY_DEREGISTRATION_SUCCESSFUL) {
+		pr_err("%s: FAIL: enable vbatt filter: result=%d\n",
+		       __func__, vbatt_filter_rep.result);
+		return -EIO;
+	}
+
+	pr_debug("%s: enable vbatt filter: OK\n", __func__);
+	return rc;
+}
+
+struct batt_client_registration_req {
+	/* The voltage at which callback (CB) should be called. */
+	u32 desired_batt_voltage;
+
+	/* The direction when the CB should be called. */
+	u32 voltage_direction;
+
+	/* The registered callback to be called when voltage and
+	 * direction specs are met. */
+	u32 batt_cb_id;
+
+	/* The call back data */
+	u32 cb_data;
+	u32 more_data;
+	u32 batt_error;
+};
+
+struct batt_client_registration_rep {
+	u32 batt_handle;
+};
+
+static int msm_batt_register_arg_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct batt_client_registration_req *batt_reg_req =
+		(struct batt_client_registration_req *)data;
+	u32 *req = (u32 *)buf;
+	int size = 0;
+
+
+
+	*req = cpu_to_be32(batt_reg_req->desired_batt_voltage);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_reg_req->voltage_direction);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_reg_req->batt_cb_id);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_reg_req->cb_data);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_reg_req->more_data);
+	size += sizeof(u32);
+	req++;
+
+	*req = cpu_to_be32(batt_reg_req->batt_error);
+	size += sizeof(u32);
+
+	return size;
+}
+
+static int msm_batt_register_ret_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct batt_client_registration_rep *data_ptr, *buf_ptr;
+
+
+	data_ptr = (struct batt_client_registration_rep *)data;
+	buf_ptr = (struct batt_client_registration_rep *)buf;
+
+	data_ptr->batt_handle = be32_to_cpu(buf_ptr->batt_handle);
+
+	return 0;
+}
+
+static int msm_batt_register(u32 desired_batt_voltage,
+			     u32 voltage_direction, u32 batt_cb_id, u32 cb_data)
+{
+	struct batt_client_registration_req batt_reg_req;
+	struct batt_client_registration_rep batt_reg_rep;
+	int rc;
+
+
+	batt_reg_req.desired_batt_voltage = desired_batt_voltage;
+	batt_reg_req.voltage_direction = voltage_direction;
+	batt_reg_req.batt_cb_id = batt_cb_id;
+	batt_reg_req.cb_data = cb_data;
+	batt_reg_req.more_data = 1;
+	batt_reg_req.batt_error = 0;
+
+	rc = msm_rpc_client_req(msm_batt_info.batt_client,
+			BATTERY_REGISTER_PROC,
+			msm_batt_register_arg_func, &batt_reg_req,
+			msm_batt_register_ret_func, &batt_reg_rep,
+			msecs_to_jiffies(BATT_RPC_TIMEOUT));
+
+	if (rc < 0) {
+		pr_err("%s: FAIL: vbatt register. rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	msm_batt_info.batt_handle = batt_reg_rep.batt_handle;
+
+	pr_debug("%s: got handle = %d\n", __func__, msm_batt_info.batt_handle);
+
+	return 0;
+}
+
+struct batt_client_deregister_req {
+	u32 batt_handle;
+};
+
+struct batt_client_deregister_rep {
+	u32 batt_error;
+};
+
+static int msm_batt_deregister_arg_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct batt_client_deregister_req *deregister_req =
+		(struct  batt_client_deregister_req *)data;
+	u32 *req = (u32 *)buf;
+	int size = 0;
+
+
+	*req = cpu_to_be32(deregister_req->batt_handle);
+	size += sizeof(u32);
+
+	return size;
+}
+
+static int msm_batt_deregister_ret_func(struct msm_rpc_client *batt_client,
+				       void *buf, void *data)
+{
+	struct batt_client_deregister_rep *data_ptr, *buf_ptr;
+
+
+
+	data_ptr = (struct batt_client_deregister_rep *)data;
+	buf_ptr = (struct batt_client_deregister_rep *)buf;
+
+	data_ptr->batt_error = be32_to_cpu(buf_ptr->batt_error);
+
+	return 0;
+}
+
+static int msm_batt_deregister(u32 batt_handle)
+{
+	int rc;
+	struct batt_client_deregister_req req;
+	struct batt_client_deregister_rep rep;
+
+
+	req.batt_handle = batt_handle;
+
+	rc = msm_rpc_client_req(msm_batt_info.batt_client,
+			BATTERY_DEREGISTER_CLIENT_PROC,
+			msm_batt_deregister_arg_func, &req,
+			msm_batt_deregister_ret_func, &rep,
+			msecs_to_jiffies(BATT_RPC_TIMEOUT));
+
+	if (rc < 0) {
+		pr_err("%s: FAIL: vbatt deregister. rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	if (rep.batt_error != BATTERY_DEREGISTRATION_SUCCESSFUL) {
+		pr_err("%s: vbatt deregistration FAIL. error=%d, handle=%d\n",
+		       __func__, rep.batt_error, batt_handle);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int msm_batt_get_charger_type(void)
+{
+	int charger_type = CHARGER_TYPE_NONE;
+
+	charger_type = fsa9480_get_charger_status();
+
+	return charger_type;
+}
+
+#ifdef CONFIG_WIRELESS_CHARGING
+static int msm_batt_get_wireless_status(void)
+{
+	int wc_detect = 0;
+	int charger_type = msm_batt_get_charger_type();
+
+
+	if (charger_type == CHARGER_TYPE_NONE)	// no cable inserted
+	{
+		wc_detect = gpio_get_value_cansleep(GPIO_WC_DETECT);
+		return wc_detect;
+	}
+
+	return 0;	// plugged
+}
+#endif
+
+static void msm_batt_cable_status_update(void)
+{
+	/* Check charger type and update if changed */
+
+	int charger_type = CHARGER_TYPE_NONE;
+
+	static char *health_text[] = {
+		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
+		"Unspecified failure", "Cold",
+	};
+
+	charger_type = msm_batt_get_charger_type();
+
+#ifdef CONFIG_WIRELESS_CHARGING
+	msm_batt_info.batt_wireless = msm_batt_get_wireless_status();
+
+	if (msm_batt_info.batt_wireless)
+	{
+		charger_type = CHARGER_TYPE_WALL;
+	}
+#endif
+
+	msm_batt_info.charger_type = charger_type;
+	pr_info("[BATT] %s: charger_type = %d (0:none, 1:TA, 2:USB) \n", __func__, charger_type);
+
+	msm_batt_info.batt_full_check = 0;
+	msm_batt_info.batt_recharging = 0;
+
+	if (charger_type != CHARGER_TYPE_NONE)	// USB, TA, Wireless
+	{
+		if (charger_type == CHARGER_TYPE_USB_PC)
+		{
+			msm_batt_info.charging_source = USB_CHG;
+			hsusb_chg_connected_ext(USB_CHG_TYPE__SDP);
+			power_supply_changed(&msm_psy_usb);
+		}
+		else	// TA and Wireless
+		{
+			msm_batt_info.charging_source = AC_CHG;
+			hsusb_chg_connected_ext(USB_CHG_TYPE__WALLCHARGER);
+			power_supply_changed(&msm_psy_ac);
+		}
+
+		if (msm_batt_info.batt_health != POWER_SUPPLY_HEALTH_GOOD)
+		{
+			pr_info("[BATT] %s: Battery health is %s, stop charging! \n", __func__, health_text[msm_batt_info.batt_health]);
+			msm_batt_info.batt_status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+			msm_batt_chg_en(STOP_CHARGING);
+		}
+		else
+		{
+			msm_batt_info.batt_status = POWER_SUPPLY_STATUS_CHARGING;
+			msm_batt_chg_en(START_CHARGING);
+		}
+
+		wake_lock(&vbus_wake_lock);
+	}
+	else	// No charger
+	{
+		msm_batt_info.charging_source = NO_CHG;
+		msm_batt_info.batt_status = POWER_SUPPLY_STATUS_DISCHARGING;
+		msm_batt_chg_en(STOP_CHARGING);
+		wake_lock_timeout(&vbus_wake_lock, 5 * TIME_UNIT_SECOND);
+	}
+
+	pr_info("[BATT] %s: power_supply_changed !\n", __func__);
+	power_supply_changed(&msm_psy_batt);
+
+	if (msm_batt_unhandled_interrupt)
+		msm_batt_unhandled_interrupt = 0;
+}
+
+static int msm_batt_suspend(struct platform_device *pdev,
+		pm_message_t state)
+{
+	pr_debug("[BATT] %s\n",__func__);
+	del_timer_sync(&msm_batt_info.timer);
+
+	return 0;
+}
+
+static int msm_batt_resume(struct platform_device *pdev)
+{
+	pr_debug("[BATT] %s\n",__func__);
+	queue_work(msm_batt_info.msm_batt_wq, &msm_batt_work);
+	mod_timer(&msm_batt_info.timer, (jiffies + BATT_CHECK_INTERVAL));
+
+	return 0;
+}
+
+int batt_restart(void)
+{
+
+	if (msm_batt_driver_init)
+	{
+		msm_batt_cable_status_update();
+
+		del_timer_sync(&msm_batt_info.timer);
+		queue_work(msm_batt_info.msm_batt_wq, &msm_batt_work);
+		mod_timer(&msm_batt_info.timer, (jiffies + BATT_CHECK_INTERVAL));
+	}
+	else
+	{
+		pr_err("[BATT] %s: Battery driver is not ready !!\n", __func__);
+		msm_batt_unhandled_interrupt = 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(batt_restart);
+
+static int msm_batt_cleanup(void)
+{
+	int rc = 0;
+
+
+	pr_info("[BATT] %s\n", __func__);
+
+	del_timer_sync(&msm_batt_info.timer);
+	msm_batt_remove_attrs(msm_psy_batt.dev);
+	i2c_del_driver(&fg_i2c_driver);
+
+	if (msm_batt_info.batt_handle != INVALID_BATT_HANDLE) {
+
+		rc = msm_batt_deregister(msm_batt_info.batt_handle);
+		if (rc < 0)
+			pr_err("%s: FAIL: msm_batt_deregister. rc=%d\n",
+			       __func__, rc);
+	}
+
+	msm_batt_info.batt_handle = INVALID_BATT_HANDLE;
+
+	if (msm_batt_info.batt_client)
+		msm_rpc_unregister_client(msm_batt_info.batt_client);
+
+	if (msm_batt_info.msm_psy_ac)
+		power_supply_unregister(msm_batt_info.msm_psy_ac);
+
+	if (msm_batt_info.msm_psy_usb)
+		power_supply_unregister(msm_batt_info.msm_psy_usb);
+	if (msm_batt_info.msm_psy_batt)
+		power_supply_unregister(msm_batt_info.msm_psy_batt);
+
+	if (msm_batt_info.chg_ep) {
+		rc = msm_rpc_close(msm_batt_info.chg_ep);
+		if (rc < 0) {
+			pr_err("%s: FAIL. msm_rpc_close(chg_ep). rc=%d\n",
+			       __func__, rc);
+		}
+	}
+
+#ifdef CONFIG_WIRELESS_CHARGING
+	free_irq(IRQ_WC_DETECT, NULL);
+#endif
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	if (msm_batt_info.early_suspend.suspend == msm_batt_early_suspend)
+		unregister_early_suspend(&msm_batt_info.early_suspend);
+#endif
+	return rc;
+}
+
+int msm_batt_get_charger_api_version(void)
+{
+	int rc ;
+	struct rpc_reply_hdr *reply;
+
+
+	struct rpc_req_chg_api_ver {
+		struct rpc_request_hdr hdr;
+		u32 more_data;
+	} req_chg_api_ver;
+
+	struct rpc_rep_chg_api_ver {
+		struct rpc_reply_hdr hdr;
+		u32 num_of_chg_api_versions;
+		u32 *chg_api_versions;
+	};
+
+	u32 num_of_versions;
+
+	struct rpc_rep_chg_api_ver *rep_chg_api_ver;
+
+
+	req_chg_api_ver.more_data = cpu_to_be32(1);
+
+	msm_rpc_setup_req(&req_chg_api_ver.hdr, CHG_RPC_PROG, CHG_RPC_VER_1_1,
+			 ONCRPC_CHARGER_API_VERSIONS_PROC);
+
+	rc = msm_rpc_write(msm_batt_info.chg_ep, &req_chg_api_ver,
+			sizeof(req_chg_api_ver));
+	if (rc < 0) {
+		pr_err("%s: FAIL: msm_rpc_write. proc=0x%08x, rc=%d\n",
+		       __func__, ONCRPC_CHARGER_API_VERSIONS_PROC, rc);
+		return rc;
+	}
+
+	for (;;) {
+		rc = msm_rpc_read(msm_batt_info.chg_ep, (void *) &reply, -1,
+				BATT_RPC_TIMEOUT);
+		if (rc < 0)
+			return rc;
+		if (rc < RPC_REQ_REPLY_COMMON_HEADER_SIZE) {
+			pr_err("%s: LENGTH ERR: msm_rpc_read. rc=%d (<%d)\n",
+			       __func__, rc, RPC_REQ_REPLY_COMMON_HEADER_SIZE);
+
+			rc = -EIO;
+			break;
+		}
+		/* we should not get RPC REQ or call packets -- ignore them */
+		if (reply->type == RPC_TYPE_REQ) {
+			pr_err("%s: TYPE ERR: type=%d (!=%d)\n",
+			       __func__, reply->type, RPC_TYPE_REQ);
+			kfree(reply);
+			continue;
+		}
+
+		/* If an earlier call timed out, we could get the (no
+		 * longer wanted) reply for it.	 Ignore replies that
+		 * we don't expect
+		 */
+		if (reply->xid != req_chg_api_ver.hdr.xid) {
+			pr_err("%s: XID ERR: xid=%d (!=%d)\n", __func__,
+			       reply->xid, req_chg_api_ver.hdr.xid);
+			kfree(reply);
+			continue;
+		}
+		if (reply->reply_stat != RPCMSG_REPLYSTAT_ACCEPTED) {
+			rc = -EPERM;
+			break;
+		}
+		if (reply->data.acc_hdr.accept_stat !=
+				RPC_ACCEPTSTAT_SUCCESS) {
+			rc = -EINVAL;
+			break;
+		}
+
+		rep_chg_api_ver = (struct rpc_rep_chg_api_ver *)reply;
+
+		num_of_versions =
+			be32_to_cpu(rep_chg_api_ver->num_of_chg_api_versions);
+
+		rep_chg_api_ver->chg_api_versions =  (u32 *)
+			((u8 *) reply + sizeof(struct rpc_reply_hdr) +
+			sizeof(rep_chg_api_ver->num_of_chg_api_versions));
+
+		rc = be32_to_cpu(
+			rep_chg_api_ver->chg_api_versions[num_of_versions - 1]);
+
+		pr_debug("%s: num_of_chg_api_versions = %u. "
+			"  The chg api version = 0x%08x\n", __func__,
+			num_of_versions, rc);
+		break;
+	}
+	kfree(reply);
+	return rc;
+}
+
+static int msm_batt_cb_func(struct msm_rpc_client *client,
+			    void *buffer, int in_size)
+{
+	int rc = 0;
+	struct rpc_request_hdr *req;
+	u32 procedure;
+	u32 accept_status;
+
+
+	req = (struct rpc_request_hdr *)buffer;
+	procedure = be32_to_cpu(req->procedure);
+
+	switch (procedure) {
+	case BATTERY_CB_TYPE_PROC:
+		accept_status = RPC_ACCEPTSTAT_SUCCESS;
+		break;
+
+	default:
+		accept_status = RPC_ACCEPTSTAT_PROC_UNAVAIL;
+		pr_err("%s: ERROR. procedure (%d) not supported\n",
+		       __func__, procedure);
+		break;
+	}
+
+	msm_rpc_start_accepted_reply(msm_batt_info.batt_client,
+			be32_to_cpu(req->xid), accept_status);
+
+	rc = msm_rpc_send_accepted_reply(msm_batt_info.batt_client, 0);
+	if (rc)
+		pr_err("%s: FAIL: sending reply. rc=%d\n", __func__, rc);
+
+	if (accept_status == RPC_ACCEPTSTAT_SUCCESS)
+	{
+		del_timer_sync(&msm_batt_info.timer);
+		queue_work(msm_batt_info.msm_batt_wq, &msm_batt_work);
+		mod_timer(&msm_batt_info.timer, (jiffies + BATT_CHECK_INTERVAL));
+	}
+
+	return rc;
+}
+
+#ifdef CONFIG_WIRELESS_CHARGING
+static irqreturn_t wc_detect_irq_handler(int irq, void *data)
+{
+	int wc_detect = msm_batt_get_wireless_status();
+
+
+	pr_info("[BATT] %s: WC_DETECT = (%d)\n", __func__, wc_detect);
+
+	if (wc_detect == msm_batt_info.batt_wireless)	// wireless status is not changed...
+	{
+		return IRQ_HANDLED;
+	}
+
+	batt_restart();	// charger status changed...
+	return IRQ_HANDLED;
+}
+#endif
+
+static void msm_batt_set_charging_start_time(chg_enable_type enable)
+{
+
+	if (enable == START_CHARGING)
+	{
+		charging_start_time = jiffies;
+	}
+	else	// STOP_CHARGING
+	{
+		charging_start_time = 0;
+	}
+}
+
+static int msm_batt_is_over_abs_time(void)
+{
+	unsigned int total_time;
+
+
+	if (charging_start_time == 0)
+	{
+		return 0;	// not charging
+	}
+
+	if (msm_batt_info.batt_full_check == 1)
+	{
+		total_time = TOTAL_RECHARGING_TIME;	// already fully charged... (recharging)
+	}
+	else
+	{
+		total_time = TOTAL_CHARGING_TIME;
+	}
+
+	if (time_after((unsigned long)jiffies, (unsigned long)(charging_start_time + total_time)))
+	{
+		pr_debug("[BATT] %s: abs time is over !! \n", __func__);
+		return 1;
+	}
+	else
+	{
+		return 0;
+	}
+}
+
+#ifdef MAX17043_FUEL_GAUGE
+/* Quick start condition check. */
+static struct fuelgauge_linear_data {
+	u32 min_vcell;
+	u32 slope;
+	u32 y_interception;
+} qstrt_table[2][12] = {
+	{	// w/o charger
+		{ 450000000,       0,         0 },
+		{ 407900000, 2171993,	193731125 },
+		{ 389790000,  847027,	324374902 },
+		{ 378060000,  602617,	343245771 },
+		{ 372020000,  293109,	361124348 },
+		{ 368220000,  209554,	364231282 },
+		{ 362530000,  596997,	356856383 },
+		{ 359070000,  604297,	356792124 },
+		{ 354500000, 2679480,	348980813 },
+		{ 344820000, 6365513, 341425848 },
+		{ 339970000, 9109696, 339974670 },
+		{ 100000000,       0,         0 }
+	},
+
+	{	// w/charger
+		{ 450000000,       0,         0 },
+		{ 419270000,   12835,	406438276 },
+		{ 418480000,   73645,	349402654 },
+		{ 404650000,   45824,	370277069 },
+		{ 392800000,   20460,	382744637 },
+		{ 387510000,   51008,	375639409 },
+		{ 377390000,  298446,	367071455 },
+		{ 373320000,  630069,	360004053 },
+		{ 363720000, 1231165,	356301531 },
+		{ 100000000,       0,         0 },
+		{ 100000000,       0,         0 },
+		{ 100000000,       0,         0 }
+	},
+};
+
+#define FG_SOC_TOLERANCE	20	// 15
+
+static int check_quick_start(void)
+{
+	unsigned int vcell_raw = 0;
+	int soc_raw = 0, soc_cal = 0;
+	int i, curr_idx = 0;
+	int status = 0;
+	int array_size = 0;
+
+
+	if (msm_batt_get_charger_type() == CHARGER_TYPE_NONE)
+	{
+		status = 0;
+		array_size = 12;
+		pr_debug("[BATT] %s: No charger !\n", __func__);
+	}
+	else
+	{
+		status = 1;
+		array_size = 10;
+		pr_debug("[BATT] %s: charger detected !\n", __func__);
+	}
+
+	/* get vcell. */
+// hyekoseon.yu
+	vcell_raw = fg_read_raw_vcell();
+
+
+
+	/* get soc. */
+	soc_raw = fg_read_raw_soc();
+
+
+
+	/* find range */
+	for (i = 0; i < array_size-1; i++) {
+		if (vcell_raw < qstrt_table[status][i].min_vcell &&
+				vcell_raw >= qstrt_table[status][i+1].min_vcell) {
+			curr_idx = i+1;
+			break;
+		}
+	}
+
+	pr_debug("[BATT] %s: curr_idx = %d (vol=%d)\n", __func__, curr_idx, qstrt_table[status][curr_idx].min_vcell);
+
+	/* calculate assumed soc and compare */
+	if ( (status == 0 && curr_idx > 0 && curr_idx < 11) ||
+		(status == 1 && curr_idx > 0 && curr_idx < 9) ) {
+		int limit_min, limit_max;
+		soc_cal = (int) ((vcell_raw - qstrt_table[status][curr_idx].y_interception) / qstrt_table[status][curr_idx].slope);
+
+		pr_debug("[BATT] %s: soc_cal = %d\n", __func__, soc_cal);
+
+		limit_min = soc_cal - FG_SOC_TOLERANCE;
+		limit_max = soc_cal + FG_SOC_TOLERANCE;
+		if (limit_min < 0)
+			limit_min = 0;
+
+		if (soc_raw > limit_max || soc_raw < limit_min) {
+//			hsusb_chg_vbus_draw_ext(0);
+			fg_reset_soc();
+			pr_info("\n[BATT] %s: QUICK START (reset_soc)!!! \n\n", __func__);
+		}
+	}
+
+	return 0;
+}
+#endif
+
+static int msm_batt_probe(struct platform_device *pdev)
+{
+	int rc;
+	struct msm_psy_batt_pdata *pdata = pdev->dev.platform_data;
+
+
+	if (pdev->id != -1) {
+		dev_err(&pdev->dev,
+			"%s: MSM chipsets Can only support one"
+			" battery ", __func__);
+		return -EINVAL;
+	}
+
+	if (pdata->avail_chg_sources & AC_CHG) {
+		rc = power_supply_register(&pdev->dev, &msm_psy_ac);
+		if (rc < 0) {
+			dev_err(&pdev->dev,
+				"%s: power_supply_register failed"
+				" rc = %d\n", __func__, rc);
+			msm_batt_cleanup();
+			return rc;
+		}
+		msm_batt_info.msm_psy_ac = &msm_psy_ac;
+		msm_batt_info.avail_chg_sources |= AC_CHG;
+	}
+
+	if (pdata->avail_chg_sources & USB_CHG) {
+		rc = power_supply_register(&pdev->dev, &msm_psy_usb);
+		if (rc < 0) {
+			dev_err(&pdev->dev,
+				"%s: power_supply_register failed"
+				" rc = %d\n", __func__, rc);
+			msm_batt_cleanup();
+			return rc;
+		}
+		msm_batt_info.msm_psy_usb = &msm_psy_usb;
+		msm_batt_info.avail_chg_sources |= USB_CHG;
+	}
+
+	if (!msm_batt_info.msm_psy_ac && !msm_batt_info.msm_psy_usb) {
+
+		dev_err(&pdev->dev,
+			"%s: No external Power supply(AC or USB)"
+			"is avilable\n", __func__);
+		msm_batt_cleanup();
+		return -ENODEV;
+	}
+
+	msm_batt_info.voltage_max_design = pdata->voltage_max_design;
+	msm_batt_info.voltage_min_design = pdata->voltage_min_design;
+	msm_batt_info.batt_technology = pdata->batt_technology;
+
+	if (!msm_batt_info.voltage_min_design)
+		msm_batt_info.voltage_min_design = BATTERY_LOW;
+	if (!msm_batt_info.voltage_max_design)
+		msm_batt_info.voltage_max_design = BATTERY_HIGH;
+	if (msm_batt_info.batt_technology == POWER_SUPPLY_TECHNOLOGY_UNKNOWN)
+		msm_batt_info.batt_technology = POWER_SUPPLY_TECHNOLOGY_LION;
+
+	rc = power_supply_register(&pdev->dev, &msm_psy_batt);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "%s: power_supply_register failed"
+			" rc=%d\n", __func__, rc);
+		msm_batt_cleanup();
+		return rc;
+	}
+	msm_batt_info.msm_psy_batt = &msm_psy_batt;
+
+	rc = msm_batt_register(BATTERY_LOW, BATTERY_ALL_ACTIVITY,
+			       BATTERY_CB_ID_ALL_ACTIV, BATTERY_ALL_ACTIVITY);
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"%s: msm_batt_register failed rc = %d\n", __func__, rc);
+		msm_batt_cleanup();
+		return rc;
+	}
+
+	rc =  msm_batt_enable_filter(VBATT_FILTER);
+
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"%s: msm_batt_enable_filter failed rc = %d\n",
+			__func__, rc);
+		msm_batt_cleanup();
+		return rc;
+	}
+
+	msm_batt_create_attrs(msm_psy_batt.dev);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	msm_batt_info.early_suspend.level = EARLY_SUSPEND_LEVEL_DISABLE_FB + 1;
+	msm_batt_info.early_suspend.suspend = msm_batt_early_suspend;
+	msm_batt_info.early_suspend.resume = msm_batt_late_resume;
+	register_early_suspend(&msm_batt_info.early_suspend);
+#endif
+
+	setup_timer(&msm_batt_info.timer, batt_timeover, 0);
+	mod_timer(&msm_batt_info.timer, (jiffies + BATT_CHECK_INTERVAL));
+
+	wake_lock_init(&vbus_wake_lock, WAKE_LOCK_SUSPEND, "vbus_wake_lock");
+
+#ifdef CONFIG_WIRELESS_CHARGING
+	set_irq_type(IRQ_WC_DETECT, IRQ_TYPE_EDGE_BOTH);
+
+	if (request_threaded_irq(IRQ_WC_DETECT, NULL,
+		wc_detect_irq_handler,
+		IRQF_ONESHOT|(IRQF_TRIGGER_RISING|IRQF_TRIGGER_FALLING),
+		"WC_DETECT", NULL)) {
+		free_irq(IRQ_WC_DETECT, NULL);
+		pr_err("BATT: irq handler registration failed....\n");
+	}
+#endif
+
+#ifdef CONFIG_MAX17043_FUEL_GAUGE
+
+	if (i2c_add_driver(&fg_i2c_driver))
+	{
+		printk("%s: Can't add max17043 fuel gauge i2c drv\n", __func__);
+		pr_err("%s: Can't add max17043 fuel gauge i2c drv\n", __func__);
+	}
+
+	//check_quick_start();
+
+	if (is_attached)
+	{
+		msm_batt_info.batt_capacity = get_level_from_fuelgauge();
+		msm_batt_info.battery_voltage = get_voltage_from_fuelgauge();
+	}
+
+#ifdef MAX17043_FUEL_GAUGE
+	setup_timer(&fg_alert_timer, fg_set_alert_ext, 0);
+	fg_alert_handler = fg_set_alert;
+#endif
+
+#endif
+
+	/* sys fs */
+	jig_class = class_create(THIS_MODULE, "jig");
+	if (IS_ERR(jig_class))
+		pr_err("Failed to create class(jig)!\n");
+
+	jig_dev = device_create(jig_class, NULL, 0, NULL, "jig");
+	if (IS_ERR(jig_dev))
+		pr_err("Failed to create device(jig)!\n");
+
+	if (device_create_file(jig_dev, &dev_attr_jig) < 0)
+		pr_err("Failed to create device file(%s)!\n", dev_attr_jig.attr.name);
+	/* sys fs */
+
+	msm_batt_driver_init = 1;
+
+	//Need to check init connect check!
+	msm_batt_cable_status_update();
+
+	pr_debug("[BATT] %s : success!\n", __func__);
+
+	return 0;
+}
+
+static int msm_batt_remove(struct platform_device *pdev)
+{
+	int rc;
+	rc = msm_batt_cleanup();
+
+	wake_lock_destroy(&vbus_wake_lock);
+
+	if (rc < 0) {
+		dev_err(&pdev->dev,
+			"%s: msm_batt_cleanup  failed rc=%d\n", __func__, rc);
+		return rc;
+	}
+
+	return 0;
+}
+
+static void msm_batt_shutdown(struct platform_device *pdev)
+{
+	del_timer_sync(&msm_batt_info.timer);
+}
+
+static const struct dev_pm_ops msm_bat_pm_ops = {
+	.suspend = msm_batt_suspend,
+	.resume = msm_batt_resume,
+};
+
+static struct platform_driver msm_batt_driver = {
+	.probe = msm_batt_probe,
+	.remove = msm_batt_remove,
+	.driver = {
+		   .name = "ariesve-battery",
+		   .shutdown = msm_batt_shutdown,
+		   .pm = &msm_bat_pm_ops,
+		   },
+};
+
+static int msm_batt_init_rpc(void)
+{
+	int rc;
+
+
+	msm_batt_info.msm_batt_wq =
+	    create_singlethread_workqueue("msm_battery");
+	if (!msm_batt_info.msm_batt_wq) {
+		printk(KERN_ERR "%s: create workque failed \n", __func__);
+		return -ENOMEM;
+	}
+
+	msm_batt_info.chg_ep =
+		msm_rpc_connect_compatible(CHG_RPC_PROG, CHG_RPC_VER_4_1, 0);
+	msm_batt_info.chg_api_version =  CHG_RPC_VER_4_1;
+	if (msm_batt_info.chg_ep == NULL) {
+		pr_err("%s: rpc connect CHG_RPC_PROG = NULL\n", __func__);
+		return -ENODEV;
+	}
+
+	if (IS_ERR(msm_batt_info.chg_ep)) {
+		msm_batt_info.chg_ep = msm_rpc_connect_compatible(
+				CHG_RPC_PROG, CHG_RPC_VER_3_1, 0);
+		msm_batt_info.chg_api_version =  CHG_RPC_VER_3_1;
+	}
+	if (IS_ERR(msm_batt_info.chg_ep)) {
+		msm_batt_info.chg_ep = msm_rpc_connect_compatible(
+				CHG_RPC_PROG, CHG_RPC_VER_1_1, 0);
+		msm_batt_info.chg_api_version =  CHG_RPC_VER_1_1;
+	}
+	if (IS_ERR(msm_batt_info.chg_ep)) {
+		msm_batt_info.chg_ep = msm_rpc_connect_compatible(
+				CHG_RPC_PROG, CHG_RPC_VER_1_3, 0);
+		msm_batt_info.chg_api_version =  CHG_RPC_VER_1_3;
+	}
+	if (IS_ERR(msm_batt_info.chg_ep)) {
+		msm_batt_info.chg_ep = msm_rpc_connect_compatible(
+				CHG_RPC_PROG, CHG_RPC_VER_2_2, 0);
+		msm_batt_info.chg_api_version =  CHG_RPC_VER_2_2;
+	}
+	if (IS_ERR(msm_batt_info.chg_ep)) {
+		rc = PTR_ERR(msm_batt_info.chg_ep);
+		pr_err("%s: FAIL: rpc connect for CHG_RPC_PROG. rc=%d\n",
+		       __func__, rc);
+		msm_batt_info.chg_ep = NULL;
+		return rc;
+	}
+
+	/* Get the real 1.x version */
+	if (msm_batt_info.chg_api_version == CHG_RPC_VER_1_1)
+		msm_batt_info.chg_api_version =
+			msm_batt_get_charger_api_version();
+
+	/* Fall back to 1.1 for default */
+	if (msm_batt_info.chg_api_version < 0)
+		msm_batt_info.chg_api_version = CHG_RPC_VER_1_1;
+	msm_batt_info.batt_api_version =  BATTERY_RPC_VER_4_1;
+
+	msm_batt_info.batt_client =
+		msm_rpc_register_client("battery", BATTERY_RPC_PROG,
+					BATTERY_RPC_VER_4_1,
+					1, msm_batt_cb_func);
+
+	if (msm_batt_info.batt_client == NULL) {
+		pr_err("%s: FAIL: rpc_register_client. batt_client=NULL\n",
+		       __func__);
+		return -ENODEV;
+	}
+	if (IS_ERR(msm_batt_info.batt_client)) {
+		msm_batt_info.batt_client =
+			msm_rpc_register_client("battery", BATTERY_RPC_PROG,
+						BATTERY_RPC_VER_1_1,
+						1, msm_batt_cb_func);
+		msm_batt_info.batt_api_version =  BATTERY_RPC_VER_1_1;
+	}
+	if (IS_ERR(msm_batt_info.batt_client)) {
+		msm_batt_info.batt_client =
+			msm_rpc_register_client("battery", BATTERY_RPC_PROG,
+						BATTERY_RPC_VER_2_1,
+						1, msm_batt_cb_func);
+		msm_batt_info.batt_api_version =  BATTERY_RPC_VER_2_1;
+	}
+
+	if (IS_ERR(msm_batt_info.batt_client)) {
+		msm_batt_info.batt_client =
+			msm_rpc_register_client("battery", BATTERY_RPC_PROG,
+						BATTERY_RPC_VER_5_1,
+						1, msm_batt_cb_func);
+		msm_batt_info.batt_api_version =  BATTERY_RPC_VER_5_1;
+	}
+	if (IS_ERR(msm_batt_info.batt_client)) {
+		rc = PTR_ERR(msm_batt_info.batt_client);
+		pr_err("%s: ERROR: rpc_register_client: rc = %d\n ",
+		       __func__, rc);
+		msm_batt_info.batt_client = NULL;
+		return rc;
+	}
+
+	rc = platform_driver_register(&msm_batt_driver);
+
+	if (rc < 0)
+		pr_err("%s: FAIL: platform_driver_register. rc = %d\n",
+		       __func__, rc);
+
+		return rc;
+}
+
+static int __init msm_batt_init(void)
+{
+	int rc;
+
+
+	rc = msm_batt_init_rpc();
+
+	if (rc < 0) {
+		pr_err("%s: FAIL: msm_batt_init_rpc.  rc=%d\n", __func__, rc);
+		msm_batt_cleanup();
+		return rc;
+	}
+
+	pr_info("%s: Charger/Battery = 0x%08x/0x%08x (RPC version)\n",
+		__func__, msm_batt_info.chg_api_version,
+		msm_batt_info.batt_api_version);
+
+	//Check jig status
+	if(fsa9480_get_jig_status())
+		batt_jig_on_status = 1;
+	else
+		batt_jig_on_status = 0;
+
+	return 0;
+}
+
+static void __exit msm_batt_exit(void)
+{
+
+	platform_driver_unregister(&msm_batt_driver);
+}
+
+module_init(msm_batt_init);
+module_exit(msm_batt_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Kiran Kandi, Qualcomm Innovation Center, Inc.");
+MODULE_DESCRIPTION("Battery driver for Qualcomm MSM chipsets.");
+MODULE_VERSION("1.0");
+MODULE_ALIAS("platform:ariesve_battery");
diff --git a/drivers/power/fuelgauge_max17043.c b/drivers/power/fuelgauge_max17043.c
new file mode 100644
index 0000000..97d4fc1
--- /dev/null
+++ b/drivers/power/fuelgauge_max17043.c
@@ -0,0 +1,434 @@
+/*
+ *
+ * Copyright (C) 2009 SAMSUNG ELECTRONICS.
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ */
+
+/* Slave address */
+#define MAX17040_SLAVE_ADDR	0x6D
+
+/* Register address */
+#define VCELL0_REG			0x02
+#define VCELL1_REG			0x03
+#define SOC0_REG			0x04
+#define SOC1_REG			0x05
+#define MODE0_REG			0x06
+#define MODE1_REG			0x07
+#define RCOMP0_REG			0x0C
+#define RCOMP1_REG			0x0D
+#define CMD0_REG			0xFE
+#define CMD1_REG			0xFF
+
+#include <linux/slab.h>
+
+extern bool power_down;
+
+static struct i2c_driver fg_i2c_driver;
+struct fg_i2c_chip {
+	struct i2c_client		*client;
+};
+static struct fg_i2c_chip *fg_max17043 = NULL;
+
+static int is_reset_soc = 0;
+static int is_attached = 0;
+
+#ifdef MAX17043_FUEL_GAUGE
+static int is_alert = 0;	// ALARM_INT
+#endif
+
+static int fg_i2c_read(struct i2c_client *client, u8 reg, u8 *data)
+{
+	int ret;
+	u8 buf[1];
+	struct i2c_msg msg[2];
+
+
+	buf[0] = reg;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = buf;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = 1;
+	msg[1].buf = buf;
+
+	ret = i2c_transfer(client->adapter, msg, 2);
+	if (ret != 2)
+		return -EIO;
+
+	*data = buf[0];
+
+	return 0;
+}
+
+static int fg_i2c_write(struct i2c_client *client, u8 reg, u8 *data)
+{
+	int ret;
+	u8 buf[3];
+	struct i2c_msg msg[1];
+
+
+	buf[0] = reg;
+	buf[1] = *data;
+	buf[2] = *(data + 1);
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 3;
+	msg[0].buf = buf;
+
+	ret = i2c_transfer(client->adapter, msg, 1);
+	if (ret != 1)
+		return -EIO;
+
+	return 0;
+}
+
+// hyeokseon.yu
+unsigned int fg_read_vcell(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 data[2];
+	u32 vcell = 0;
+
+
+	if (!client)
+		return -1;
+
+	if (fg_i2c_read(client, VCELL0_REG, &data[0]) < 0) {
+		pr_err("%s: Failed to read VCELL0\n", __func__);
+		return -1;
+	}
+	if (fg_i2c_read(client, VCELL1_REG, &data[1]) < 0) {
+		pr_err("%s: Failed to read VCELL1\n", __func__);
+		return -1;
+	}
+
+#if defined(CONFIG_BATT_MICROVOLT_UNIT)
+	vcell = (((data[0] << 4) & 0xFF0) | ((data[1] >> 4) & 0xF)) * 1250;
+#else
+	vcell = ((((data[0] << 4) & 0xFF0) | ((data[1] >> 4) & 0xF)) * 125)/100;
+#endif
+
+	if(!power_down)
+		pr_debug("%s: VCELL=%d\n", __func__, vcell);
+
+	return vcell;
+}
+
+// hyeokseon.yu
+unsigned int fg_read_soc(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 data[2];
+	int FGPureSOC = 0;
+	int FGAdjustSOC = 0;
+	int FGSOC = 0;
+
+	if (!client)
+		return -1;
+
+	if (fg_i2c_read(client, SOC0_REG, &data[0]) < 0) {
+		pr_err("%s: Failed to read SOC0\n", __func__);
+		return -1;
+	}
+	if (fg_i2c_read(client, SOC1_REG, &data[1]) < 0) {
+		pr_err("%s: Failed to read SOC1\n", __func__);
+		return -1;
+	}
+
+	if (is_reset_soc) {
+		pr_info("%s: Reseting SOC\n", __func__);
+		return -1;
+	}
+
+	/*Adjusted SOC(Ancora)
+	**RCOMP : B0h, FULL : 96.7, EMPTY : 0.0
+	**Adjusted SOC(Aries VE)
+	**RCOMP : D0h, FULL : 97.7, EMPTY : 0.4
+	**Adj_soc = (SOC%-EMPTY)/(FULL-EMPTY)*100
+	*/
+
+	// calculating soc
+	FGPureSOC = data[0]*100+((data[1]*100)/256);
+
+	// hsil for get Adjusted SOC%
+	if(FGPureSOC >= 0)
+#ifdef CONFIG_MACH_ARIESVE
+		FGAdjustSOC = ((FGPureSOC*10000)-40)/9730;
+#else
+		FGAdjustSOC = ((FGPureSOC*10000)-0)/9670;
+#endif
+	else
+		FGAdjustSOC = 0;
+
+	// rounding off and Changing to percentage.
+	FGSOC=FGAdjustSOC/100;
+
+#ifdef CONFIG_MACH_ARIESVE
+	if(FGAdjustSOC%100 >= 50)
+#else
+	if(FGAdjustSOC%100 >= 50 && FGSOC > 1)
+#endif
+		FGSOC+=1;
+
+	if(FGSOC>=100)
+		FGSOC=100;
+
+	if (FGSOC < 0)
+		FGSOC = 0;
+
+	if(!power_down)
+		printk("[MAX17043] FGPureSOC = %d (%d.%d)\tFGAdjustSOC = %d\tFGSOC = %d\n", FGPureSOC, data[0], (data[1]*100)/256, FGAdjustSOC, FGSOC);
+
+
+	return FGSOC;
+}
+
+// hyeokseon.yu
+unsigned int fg_read_raw_vcell(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 data[2];
+	u32 vcell = 0;
+
+	if (!client)
+		return -1;
+
+	if (fg_i2c_read(client, VCELL0_REG, &data[0]) < 0) {
+		pr_err("%s: Failed to read VCELL0\n", __func__);
+		return -1;
+	}
+	if (fg_i2c_read(client, VCELL1_REG, &data[1]) < 0) {
+		pr_err("%s: Failed to read VCELL1\n", __func__);
+		return -1;
+	}
+
+	vcell = data[0] << 8 | data[1];
+	vcell = (vcell >> 4) * 125 * 1000;
+
+	printk("SEXYKYU %s: VCELL=%d\n", __func__, vcell);
+
+	return vcell;
+}
+
+unsigned int fg_read_raw_soc(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 data[2];
+
+	if (!client)
+		return -1;
+
+	if (fg_i2c_read(client, SOC0_REG, &data[0]) < 0) {
+		pr_err("%s: Failed to read SOC0\n", __func__);
+		return -1;
+	}
+	if (fg_i2c_read(client, SOC1_REG, &data[1]) < 0) {
+		pr_err("%s: Failed to read SOC1\n", __func__);
+		return -1;
+	}
+
+	if (data[0] < 0)	data[0] = 0;
+	if (data[0] > 100)	data[0] = 100;
+
+	pr_debug("%s: SOC [0]=%d [1]=%d\n", __func__, data[0], data[1]);
+
+	if (is_reset_soc) {
+		pr_info("%s: Reseting SOC\n", __func__);
+		return -1;
+	} else {
+		return data[0];
+	}
+}
+
+// hyeokseon.yu
+unsigned int fg_reset_soc(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 rst_cmd[2];
+	s32 ret = 0;
+
+
+	if (!client)
+		return -1;
+
+	is_reset_soc = 1;
+	/* Quick-start */
+	rst_cmd[0] = 0x40;
+	rst_cmd[1] = 0x00;
+
+	ret = fg_i2c_write(client, MODE0_REG, rst_cmd);
+	if (ret)
+		pr_err("[BATT] %s: failed reset SOC(%d)\n", __func__, ret);
+
+	msleep(500);
+	is_reset_soc = 0;
+	return ret;
+}
+
+// hyeokseon.yu
+void fuel_gauge_rcomp(void)
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 rst_cmd[2];
+	s32 ret = 0;
+
+
+	if (!client)
+		return ;
+#if defined(CONFIG_MACH_ARIESVE) || defined(CONFIG_MACH_APACHE)
+	rst_cmd[0] = 0xC0; /* MAXIM recommend */
+#else
+	rst_cmd[0] = 0xB0;
+#endif
+
+#ifdef MAX17043_FUEL_GAUGE
+	rst_cmd[1] = 0x1F;
+#else
+	rst_cmd[1] = 0x00;
+#endif
+
+	ret = fg_i2c_write(client, RCOMP0_REG, rst_cmd);
+	if (ret)
+		pr_err("[BATT] %s: failed fuel_gauge_rcomp(%d)\n", __func__, ret);
+
+	//msleep(500);
+}
+
+#ifdef MAX17043_FUEL_GAUGE
+int (*fg_alert_handler)(int) = NULL;
+static irqreturn_t fg_interrupt_handler(int irq, void *data)	// ALARM_INT
+{
+	struct i2c_client *client = fg_max17043->client;
+	u8 rst_cmd[2];
+	int ret = 0;
+
+	if (!client)
+		return IRQ_HANDLED;
+
+	rst_cmd[0] = 0x00;
+	rst_cmd[1] = 0x00;
+
+	if (fg_i2c_read(client, RCOMP0_REG, &rst_cmd[0]) < 0)
+	{
+		pr_err("[BATT] %s failed!\n", __func__);
+		return IRQ_HANDLED;
+	}
+	if (fg_i2c_read(client, RCOMP1_REG, &rst_cmd[1]) < 0)
+	{
+		pr_err("[BATT] %s failed!\n", __func__);
+		return IRQ_HANDLED;
+	}
+
+#ifdef DEBUG
+	pr_info("\n-----------------------------------------------------\n");
+	pr_info(" << %s (vcell:%d, soc:%d, rcomp:0x%x,0x%x) >> \n", __func__, fg_read_vcell(), fg_read_soc(), rst_cmd[0], rst_cmd[1]);
+	pr_info("-----------------------------------------------------\n\n");
+#endif
+
+	if(fg_alert_handler) {
+		ret = (*fg_alert_handler)(1);
+
+		if (ret)
+			pr_info("[BATT]: %s: low battery alert, ready to power down (0x%x, 0x%x)\n", __func__, rst_cmd[0], rst_cmd[1]);
+		else
+			// ignore alert
+			pr_info("[BATT] %s: Ignore low battery alert during charging... \n", __func__);
+	}
+
+	// Clear ALRT bit to prevent another low battery interrupt...
+	rst_cmd[1] = rst_cmd[1] & 0xDF;
+
+#ifdef DEBUG
+	pr_info("[FG] %s: clear the bit = 0x%x, 0x%x \n", __func__, rst_cmd[0], rst_cmd[1]);
+#endif
+
+	if (fg_i2c_write(client, RCOMP0_REG, rst_cmd))
+		pr_err("[BATT] %s: failed write rcomp\n", __func__);
+
+	return IRQ_HANDLED;
+}
+#endif
+
+static int fg_i2c_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
+
+
+	if (fg_max17043 == NULL ) {
+		fg_max17043 = kzalloc(sizeof(struct fg_i2c_chip), GFP_KERNEL);
+		if (fg_max17043 == NULL ) {
+			return -ENOMEM;
+		}
+	}
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
+
+	fg_max17043->client = client;
+
+	i2c_set_clientdata(client, fg_max17043);
+
+	fuel_gauge_rcomp();
+
+#ifdef MAX17043_FUEL_GAUGE
+	if (request_threaded_irq(client->irq, NULL,
+		fg_interrupt_handler,
+		IRQF_ONESHOT|IRQF_TRIGGER_FALLING, "ALARM_INT", client))
+	{
+		free_irq(client->irq, NULL);
+		pr_err("[BATT] fg_interrupt_handler can't register the handler! and passing....\n");
+	}
+#endif
+
+	is_attached = 1;
+
+	pr_debug("[BATT] %s : success!\n", __func__);
+	return 0;
+}
+
+static int fg_i2c_remove(struct i2c_client *client)
+{
+	struct max17040_chip *chip = i2c_get_clientdata(client);
+
+
+	pr_info("[BATT] %s\n", __func__);
+
+	i2c_set_clientdata(client, NULL);
+	kfree(chip);
+	fg_max17043->client = NULL;
+	return 0;
+}
+
+#define fg_i2c_suspend NULL
+#define fg_i2c_resume NULL
+
+
+static const struct i2c_device_id fg_i2c_id[] = {
+	{ "fuelgauge_max17043", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, max17040_id);
+
+static struct i2c_driver fg_i2c_driver = {
+	.driver	= {
+		.name	= "fuelgauge_max17043",
+	},
+	.probe		= fg_i2c_probe,
+	.remove		= fg_i2c_remove,
+	.suspend	= fg_i2c_suspend,
+	.resume		= fg_i2c_resume,
+	.id_table	= fg_i2c_id,
+};
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 29178f7..3d81e0d 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -33,7 +33,7 @@
 
 #define POWER_SUPPLY_ATTR(_name)					\
 {									\
-	.attr = { .name = #_name },					\
+	.attr = { .name = #_name, .mode = 0444 },					\
 	.show = power_supply_show_property,				\
 	.store = power_supply_store_property,				\
 }
@@ -104,6 +104,10 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", scope_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
+	else if (off >= POWER_SUPPLY_PROP_BATT_FULL)
+		return sprintf(buf, "%d\n", value.intval);
+	else if (off >= POWER_SUPPLY_PROP_BATT_TYPE)
+		return sprintf(buf, "SDI_SDI\n");
 
 	return sprintf(buf, "%d\n", value.intval);
 }
@@ -141,7 +145,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(online),
 	POWER_SUPPLY_ATTR(authentic),
 	POWER_SUPPLY_ATTR(technology),
-	POWER_SUPPLY_ATTR(cycle_count),
+	/* POWER_SUPPLY_ATTR(cycle_count), */
 	POWER_SUPPLY_ATTR(voltage_max),
 	POWER_SUPPLY_ATTR(voltage_min),
 	POWER_SUPPLY_ATTR(voltage_max_design),
@@ -183,6 +187,17 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(temp_ambient),
 	POWER_SUPPLY_ATTR(temp_ambient_alert_min),
 	POWER_SUPPLY_ATTR(temp_ambient_alert_max),
+	POWER_SUPPLY_ATTR(batt_temp),
+	POWER_SUPPLY_ATTR(batt_temp_adc),
+	POWER_SUPPLY_ATTR(batt_vol),
+	POWER_SUPPLY_ATTR(batt_vol_adc),
+	POWER_SUPPLY_ATTR(batt_vf_adc),
+	POWER_SUPPLY_ATTR(batt_vol_adc_aver),
+	POWER_SUPPLY_ATTR(batt_temp_adc_aver),
+	POWER_SUPPLY_ATTR(batt_vol_aver),
+	POWER_SUPPLY_ATTR(batt_temp_aver),
+	POWER_SUPPLY_ATTR(batt_type),
+	POWER_SUPPLY_ATTR(batt_full_check),
 	POWER_SUPPLY_ATTR(time_to_empty_now),
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
diff --git a/include/linux/earlysuspend.h b/include/linux/earlysuspend.h
new file mode 100644
index 0000000..8343b81
--- /dev/null
+++ b/include/linux/earlysuspend.h
@@ -0,0 +1,56 @@
+/* include/linux/earlysuspend.h
+ *
+ * Copyright (C) 2007-2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_EARLYSUSPEND_H
+#define _LINUX_EARLYSUSPEND_H
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/list.h>
+#endif
+
+/* The early_suspend structure defines suspend and resume hooks to be called
+ * when the user visible sleep state of the system changes, and a level to
+ * control the order. They can be used to turn off the screen and input
+ * devices that are not used for wakeup.
+ * Suspend handlers are called in low to high level order, resume handlers are
+ * called in the opposite order. If, when calling register_early_suspend,
+ * the suspend handlers have already been called without a matching call to the
+ * resume handlers, the suspend handler will be called directly from
+ * register_early_suspend. This direct call can violate the normal level order.
+ */
+enum {
+	EARLY_SUSPEND_LEVEL_BLANK_SCREEN = 50,
+	EARLY_SUSPEND_LEVEL_STOP_DRAWING = 100,
+	EARLY_SUSPEND_LEVEL_DISABLE_FB = 150,
+};
+struct early_suspend {
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	struct list_head link;
+	int level;
+	void (*suspend)(struct early_suspend *h);
+	void (*resume)(struct early_suspend *h);
+#endif
+};
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+void register_early_suspend(struct early_suspend *handler);
+void unregister_early_suspend(struct early_suspend *handler);
+#else
+#define register_early_suspend(handler) do { } while (0)
+#define unregister_early_suspend(handler) do { } while (0)
+#endif
+
+#endif
+
diff --git a/include/linux/leds-pmic8058.h b/include/linux/leds-pmic8058.h
new file mode 100644
index 0000000..cbfde9f
--- /dev/null
+++ b/include/linux/leds-pmic8058.h
@@ -0,0 +1,40 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __LEDS_PMIC8058_H__
+#define __LEDS_PMIC8058_H__
+
+enum pmic8058_leds {
+	PMIC8058_ID_LED_KB_LIGHT = 1,
+	PMIC8058_ID_LED_0,
+	PMIC8058_ID_LED_1,
+	PMIC8058_ID_LED_2,
+	PMIC8058_ID_FLASH_LED_0,
+	PMIC8058_ID_FLASH_LED_1,
+};
+
+struct pmic8058_led {
+	const char	*name;
+	const char	*default_trigger;
+	unsigned	max_brightness;
+	int		id;
+};
+
+struct pmic8058_leds_platform_data {
+	int	num_leds;
+	struct pmic8058_led *leds;
+};
+
+int pm8058_set_flash_led_current(enum pmic8058_leds id, unsigned mA);
+int pm8058_set_led_current(enum pmic8058_leds id, unsigned mA);
+
+#endif /* __LEDS_PMIC8058_H__ */
diff --git a/include/linux/mfd/pm8xxx/batt-alarm.h b/include/linux/mfd/pm8xxx/batt-alarm.h
new file mode 100644
index 0000000..f10715d
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/batt-alarm.h
@@ -0,0 +1,201 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+/*
+ * Qualcomm PMIC PM8xxx Battery Alarm driver
+ *
+ */
+#ifndef __MFD_PM8XXX_BATT_ALARM_H__
+#define __MFD_PM8XXX_BATT_ALARM_H__
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/notifier.h>
+
+#define PM8XXX_BATT_ALARM_DEV_NAME	"pm8xxx-batt-alarm"
+
+/**
+ * enum pm8xxx_batt_alarm_core_data - PMIC core specific core passed into the
+ *	batter alarm driver as platform data
+ * @irq_name:
+ * @reg_addr_batt_alarm_threshold:	PMIC threshold register address
+ * @reg_addr_batt_alarm_ctrl1:		PMIC control 1 register address
+ * @reg_addr_batt_alarm_ctrl2:		PMIC control 2 register address
+ * @reg_addr_batt_alarm_pwm_ctrl:	PMIC PWM control register address
+ */
+struct pm8xxx_batt_alarm_core_data {
+	char	*irq_name;
+	u16	reg_addr_threshold;
+	u16	reg_addr_ctrl1;
+	u16	reg_addr_ctrl2;
+	u16	reg_addr_pwm_ctrl;
+};
+
+/**
+ * enum pm8xxx_batt_alarm_comparator - battery alarm comparator ID values
+ */
+enum pm8xxx_batt_alarm_comparator {
+	PM8XXX_BATT_ALARM_LOWER_COMPARATOR,
+	PM8XXX_BATT_ALARM_UPPER_COMPARATOR,
+};
+
+/**
+ * enum pm8xxx_batt_alarm_hold_time - hold time required for out of range
+ *	battery voltage needed to trigger a status change.  Enum names denote
+ *	hold time in milliseconds.
+ */
+enum pm8xxx_batt_alarm_hold_time {
+	PM8XXX_BATT_ALARM_HOLD_TIME_0p125_MS = 0,
+	PM8XXX_BATT_ALARM_HOLD_TIME_0p25_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_0p5_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_1_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_2_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_4_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_8_MS,
+	PM8XXX_BATT_ALARM_HOLD_TIME_16_MS,
+};
+
+/*
+ * Bits that are set in the return value of pm8xxx_batt_alarm_status_read
+ * to indicate crossing of the upper or lower threshold.
+ */
+#define PM8XXX_BATT_ALARM_STATUS_BELOW_LOWER	BIT(0)
+#define PM8XXX_BATT_ALARM_STATUS_ABOVE_UPPER	BIT(1)
+
+#if defined(CONFIG_MFD_PM8XXX_BATT_ALARM) \
+	|| defined(CONFIG_MFD_PM8XXX_BATT_ALARM_MODULE)
+
+/**
+ * pm8xxx_batt_alarm_enable - enable one of the battery voltage threshold
+ *			      comparators
+ * @comparator:	selects which comparator to enable
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_enable(enum pm8xxx_batt_alarm_comparator comparator);
+
+/**
+ * pm8xxx_batt_alarm_disable - disable one of the battery voltage threshold
+ *			       comparators
+ * @comparator:	selects which comparator to disable
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_disable(enum pm8xxx_batt_alarm_comparator comparator);
+
+
+/**
+ * pm8xxx_batt_alarm_threshold_set - set the lower and upper alarm thresholds
+ * @comparator:		selects which comparator to set the threshold of
+ * @threshold_mV:	battery voltage threshold in millivolts
+ *			set points = 2500-5675 mV in 25 mV steps
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_threshold_set(
+	enum pm8xxx_batt_alarm_comparator comparator, int threshold_mV);
+
+/**
+ * pm8xxx_batt_alarm_status_read - get status of both threshold comparators
+ *
+ * RETURNS:	< 0	   = error
+ *		  0	   = battery voltage ok
+ *		BIT(0) set = battery voltage below lower threshold
+ *		BIT(1) set = battery voltage above upper threshold
+ */
+int pm8xxx_batt_alarm_status_read(void);
+
+/**
+ * pm8xxx_batt_alarm_register_notifier - register a notifier to run when a
+ *	battery voltage change interrupt fires
+ * @nb:	notifier block containing callback function to register
+ *
+ * nb->notifier_call must point to a function of this form -
+ * int (*notifier_call)(struct notifier_block *nb, unsigned long status,
+ *			void *unused);
+ * "status" will receive the battery alarm status; "unused" will be NULL.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_register_notifier(struct notifier_block *nb);
+
+/**
+ * pm8xxx_batt_alarm_unregister_notifier - unregister a notifier that is run
+ *	when a battery voltage change interrupt fires
+ * @nb:	notifier block containing callback function to unregister
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_unregister_notifier(struct notifier_block *nb);
+
+/**
+ * pm8xxx_batt_alarm_hold_time_set - set hold time of interrupt output *
+ * @hold_time:	amount of time that battery voltage must remain outside of the
+ *		threshold range before the battery alarm interrupt triggers
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_hold_time_set(enum pm8xxx_batt_alarm_hold_time hold_time);
+
+/**
+ * pm8xxx_batt_alarm_pwm_rate_set - set battery alarm update rate *
+ * @use_pwm:		1 = use PWM update rate, 0 = comparators always active
+ * @clock_scaler:	PWM clock scaler = 2 to 9
+ * @clock_divider:	PWM clock divider = 2 to 8
+ *
+ * This function sets the rate at which the battery alarm module enables
+ * the threshold comparators.  The rate is determined by the following equation:
+ *
+ * f_update = (1024 Hz) / (clock_divider * (2 ^ clock_scaler))
+ *
+ * Thus, the update rate can range from 0.25 Hz to 128 Hz.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_batt_alarm_pwm_rate_set(int use_pwm, int clock_scaler,
+				   int clock_divider);
+#else
+
+static inline int
+pm8xxx_batt_alarm_enable(enum pm8xxx_batt_alarm_comparator comparator)
+{ return -ENODEV; }
+
+static inline int
+pm8xxx_batt_alarm_disable(enum pm8xxx_batt_alarm_comparator comparator)
+{ return -ENODEV; }
+
+static inline int
+pm8xxx_batt_alarm_threshold_set(enum pm8xxx_batt_alarm_comparator comparator,
+				int threshold_mV)
+{ return -ENODEV; }
+
+static inline int pm8xxx_batt_alarm_status_read(void)
+{ return -ENODEV; }
+
+static inline int pm8xxx_batt_alarm_register_notifier(struct notifier_block *nb)
+{ return -ENODEV; }
+
+static inline int
+pm8xxx_batt_alarm_unregister_notifier(struct notifier_block *nb)
+{ return -ENODEV; }
+
+static inline int
+pm8xxx_batt_alarm_hold_time_set(enum pm8xxx_batt_alarm_hold_time hold_time)
+{ return -ENODEV; }
+
+static inline int
+pm8xxx_batt_alarm_pwm_rate_set(int use_pwm, int clock_scaler, int clock_divider)
+{ return -ENODEV; }
+
+#endif
+
+
+#endif /* __MFD_PM8XXX_BATT_ALARM_H__ */
diff --git a/include/linux/mfd/pm8xxx/gpio.h b/include/linux/mfd/pm8xxx/gpio.h
new file mode 100644
index 0000000..ccd9c10
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/gpio.h
@@ -0,0 +1,162 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Qualcomm PMIC8XXX gpio driver header file
+ *
+ */
+
+#ifndef __PM8XXX_GPIO_H
+#define __PM8XXX_GPIO_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_GPIO_DEV_NAME	"pm8xxx-gpio"
+
+struct pm8xxx_gpio_core_data {
+	int	ngpios;
+};
+
+struct pm8xxx_gpio_platform_data {
+	struct pm8xxx_gpio_core_data	gpio_cdata;
+	int				gpio_base;
+};
+
+/* GPIO parameters */
+/* direction */
+#define	PM_GPIO_DIR_OUT			0x01
+#define	PM_GPIO_DIR_IN			0x02
+#define	PM_GPIO_DIR_BOTH		(PM_GPIO_DIR_OUT | PM_GPIO_DIR_IN)
+
+/* output_buffer */
+#define	PM_GPIO_OUT_BUF_OPEN_DRAIN	1
+#define	PM_GPIO_OUT_BUF_CMOS		0
+
+/* pull */
+#define	PM_GPIO_PULL_UP_30		0
+#define	PM_GPIO_PULL_UP_1P5		1
+#define	PM_GPIO_PULL_UP_31P5		2
+#define	PM_GPIO_PULL_UP_1P5_30		3
+#define	PM_GPIO_PULL_DN			4
+#define	PM_GPIO_PULL_NO			5
+
+/* vin_sel: Voltage Input Select */
+#define	PM_GPIO_VIN_VPH			0 /* 3v ~ 4.4v */
+#define	PM_GPIO_VIN_BB			1 /* ~3.3v */
+#define	PM_GPIO_VIN_S4			2 /* 1.8v */
+#define	PM_GPIO_VIN_L15			3
+#define	PM_GPIO_VIN_L4			4
+#define	PM_GPIO_VIN_L3			5
+#define	PM_GPIO_VIN_L17			6
+
+/* vin_sel: Voltage Input select on PM8058 */
+#define PM8058_GPIO_VIN_VPH		0
+#define PM8058_GPIO_VIN_BB		1
+#define PM8058_GPIO_VIN_S3		2
+#define PM8058_GPIO_VIN_L3		3
+#define PM8058_GPIO_VIN_L7		4
+#define PM8058_GPIO_VIN_L6		5
+#define PM8058_GPIO_VIN_L5		6
+#define PM8058_GPIO_VIN_L2		7
+
+/* vin_sel: Voltage Input Select on PM8038*/
+#define PM8038_GPIO_VIN_VPH		0
+#define PM8038_GPIO_VIN_BB		1
+#define PM8038_GPIO_VIN_L11		2
+#define PM8038_GPIO_VIN_L15		3
+#define PM8038_GPIO_VIN_L4		4
+#define PM8038_GPIO_VIN_L3		5
+#define PM8038_GPIO_VIN_L17		6
+
+/* vin_sel: Voltage Input Select on PM8018*/
+#define PM8018_GPIO_VIN_L4		0
+#define PM8018_GPIO_VIN_L14		1
+#define PM8018_GPIO_VIN_S3		2
+#define PM8018_GPIO_VIN_L6		3
+#define PM8018_GPIO_VIN_L2		4
+#define PM8018_GPIO_VIN_L5		5
+#define PM8018_GPIO_VIN_L8		6
+#define PM8018_GPIO_VIN_VPH		7
+
+/* out_strength */
+#define	PM_GPIO_STRENGTH_NO		0
+#define	PM_GPIO_STRENGTH_HIGH		1
+#define	PM_GPIO_STRENGTH_MED		2
+#define	PM_GPIO_STRENGTH_LOW		3
+
+/* function */
+#define	PM_GPIO_FUNC_NORMAL		0
+#define	PM_GPIO_FUNC_PAIRED		1
+#define	PM_GPIO_FUNC_1			2
+#define	PM_GPIO_FUNC_2			3
+#define	PM_GPIO_DTEST1			4
+#define	PM_GPIO_DTEST2			5
+#define	PM_GPIO_DTEST3			6
+#define	PM_GPIO_DTEST4			7
+
+/**
+ * struct pm_gpio - structure to specify gpio configurtion values
+ * @direction:		indicates whether the gpio should be input, output, or
+ *			both. Should be of the type PM_GPIO_DIR_*
+ * @output_buffer:	indicates gpio should be configured as CMOS or open
+ *			drain. Should be of the type PM_GPIO_OUT_BUF_*
+ * @output_value:	The gpio output value of the gpio line - 0 or 1
+ * @pull:		Indicates whether a pull up or pull down should be
+ *			applied. If a pullup is required the current strength
+ *			needs to be specified. Current values of 30uA, 1.5uA,
+ *			31.5uA, 1.5uA with 30uA boost are supported. This value
+ *			should be one of the PM_GPIO_PULL_*
+ * @vin_sel:		specifies the voltage level when the output is set to 1.
+ *			For an input gpio specifies the voltage level at which
+ *			the input is interpreted as a logical 1.
+ * @out_strength:	the amount of current supplied for an output gpio,
+ *			should be of the type PM_GPIO_STRENGTH_*
+ * @function:		choose alternate function for the gpio. Certain gpios
+ *			can be paired (shorted) with each other. Some gpio pin
+ *			can act as alternate functions. This parameter should
+ *			be of type PM_GPIO_FUNC_*
+ * @inv_int_pol:	Invert polarity before feeding the line to the interrupt
+ *			module in pmic. This feature will almost be never used
+ *			since the pm8xxx interrupt block can detect both edges
+ *			and both levels.
+ * @disable_pin:	Disable the gpio by configuring it as high impedance.
+ */
+struct pm_gpio {
+	int		direction;
+	int		output_buffer;
+	int		output_value;
+	int		pull;
+	int		vin_sel;
+	int		out_strength;
+	int		function;
+	int		inv_int_pol;
+	int		disable_pin;
+};
+
+#if defined(CONFIG_GPIO_PM8XXX) || defined(CONFIG_GPIO_PM8XXX_MODULE)
+/**
+ * pm8xxx_gpio_config - configure a gpio controlled by a pm8xxx chip
+ * @gpio: gpio number to configure
+ * @param: configuration values
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_gpio_config(int gpio, struct pm_gpio *param);
+#else
+static inline int pm8xxx_gpio_config(int gpio, struct pm_gpio *param)
+{
+	return -ENXIO;
+}
+#endif
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/misc.h b/include/linux/mfd/pm8xxx/misc.h
new file mode 100644
index 0000000..c4b0ea4
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/misc.h
@@ -0,0 +1,284 @@
+/*
+ * Copyright (c) 2011-2012, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MFD_PM8XXX_MISC_H__
+#define __MFD_PM8XXX_MISC_H__
+
+#include <linux/err.h>
+
+#define PM8XXX_MISC_DEV_NAME	"pm8xxx-misc"
+
+/**
+ * struct pm8xxx_misc_platform_data - PM8xxx misc driver platform data
+ * @priority:	PMIC prority level in a multi-PMIC system. Lower value means
+ *		greater priority. Actions are performed from highest to lowest
+ *		priority PMIC.
+ */
+struct pm8xxx_misc_platform_data {
+	int	priority;
+};
+
+enum pm8xxx_uart_path_sel {
+	UART_NONE,
+	UART_TX1_RX1,
+	UART_TX2_RX2,
+	UART_TX3_RX3,
+};
+
+enum pm8xxx_coincell_chg_voltage {
+	PM8XXX_COINCELL_VOLTAGE_3p2V = 1,
+	PM8XXX_COINCELL_VOLTAGE_3p1V,
+	PM8XXX_COINCELL_VOLTAGE_3p0V,
+	PM8XXX_COINCELL_VOLTAGE_2p5V = 16
+};
+
+enum pm8xxx_coincell_chg_resistor {
+	PM8XXX_COINCELL_RESISTOR_2100_OHMS,
+	PM8XXX_COINCELL_RESISTOR_1700_OHMS,
+	PM8XXX_COINCELL_RESISTOR_1200_OHMS,
+	PM8XXX_COINCELL_RESISTOR_800_OHMS
+};
+
+enum pm8xxx_coincell_chg_state {
+	PM8XXX_COINCELL_CHG_DISABLE,
+	PM8XXX_COINCELL_CHG_ENABLE
+};
+
+struct pm8xxx_coincell_chg {
+	enum pm8xxx_coincell_chg_state		state;
+	enum pm8xxx_coincell_chg_voltage	voltage;
+	enum pm8xxx_coincell_chg_resistor	resistor;
+};
+
+enum pm8xxx_smpl_delay {
+	PM8XXX_SMPL_DELAY_0p5,
+	PM8XXX_SMPL_DELAY_1p0,
+	PM8XXX_SMPL_DELAY_1p5,
+	PM8XXX_SMPL_DELAY_2p0,
+};
+
+enum pm8xxx_pon_config {
+	PM8XXX_DISABLE_HARD_RESET = 0,
+	PM8XXX_SHUTDOWN_ON_HARD_RESET,
+	PM8XXX_RESTART_ON_HARD_RESET,
+};
+
+enum pm8xxx_aux_clk_id {
+	CLK_MP3_1,
+	CLK_MP3_2,
+};
+
+enum pm8xxx_aux_clk_div {
+	XO_DIV_NONE,
+	XO_DIV_1,
+	XO_DIV_2,
+	XO_DIV_4,
+	XO_DIV_8,
+	XO_DIV_16,
+	XO_DIV_32,
+	XO_DIV_64,
+};
+
+enum pm8xxx_hsed_bias {
+	PM8XXX_HSED_BIAS0,
+	PM8XXX_HSED_BIAS1,
+	PM8XXX_HSED_BIAS2,
+};
+
+#if defined(CONFIG_MFD_PM8XXX_MISC) || defined(CONFIG_MFD_PM8XXX_MISC_MODULE)
+
+/**
+ * pm8xxx_reset_pwr_off - switch all PM8XXX PMIC chips attached to the system to
+ *			  either reset or shutdown when they are turned off
+ * @reset: 0 = shudown the PMICs, 1 = shutdown and then restart the PMICs
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_reset_pwr_off(int reset);
+
+int pm8xxx_uart_gpio_mux_ctrl(enum pm8xxx_uart_path_sel uart_path_sel);
+
+/**
+ * pm8xxx_coincell_chg_config - Disables or enables the coincell charger, and
+ *				configures its voltage and resistor settings.
+ * @chg_config:			Holds both voltage and resistor values, and a
+ *				switch to change the state of charger.
+ *				If state is to disable the charger then
+ *				both voltage and resistor are disregarded.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_coincell_chg_config(struct pm8xxx_coincell_chg *chg_config);
+
+/**
+ * pm8xxx_smpl_control - enables/disables SMPL detection
+ * @enable: 0 = shutdown PMIC on power loss, 1 = reset PMIC on power loss
+ *
+ * This function enables or disables the Sudden Momentary Power Loss detection
+ * module.  If SMPL detection is enabled, then when a sufficiently long power
+ * loss event occurs, the PMIC will automatically reset itself.  If SMPL
+ * detection is disabled, then the PMIC will shutdown when power loss occurs.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_smpl_control(int enable);
+
+/**
+ * pm8xxx_smpl_set_delay - sets the SMPL detection time delay
+ * @delay: enum value corresponding to delay time
+ *
+ * This function sets the time delay of the SMPL detection module.  If power
+ * is reapplied within this interval, then the PMIC reset automatically.  The
+ * SMPL detection module must be enabled for this delay time to take effect.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_smpl_set_delay(enum pm8xxx_smpl_delay delay);
+
+/**
+ * pm8xxx_watchdog_reset_control - enables/disables watchdog reset detection
+ * @enable: 0 = shutdown when PS_HOLD goes low, 1 = reset when PS_HOLD goes low
+ *
+ * This function enables or disables the PMIC watchdog reset detection feature.
+ * If watchdog reset detection is enabled, then the PMIC will reset itself
+ * when PS_HOLD goes low.  If it is not enabled, then the PMIC will shutdown
+ * when PS_HOLD goes low.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_watchdog_reset_control(int enable);
+
+/**
+ * pm8xxx_hard_reset_config - Allows different reset configurations
+ *
+ * config = DISABLE_HARD_RESET to disable hard reset
+ *	  = SHUTDOWN_ON_HARD_RESET to turn off the system on hard reset
+ *	  = RESTART_ON_HARD_RESET to restart the system on hard reset
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_hard_reset_config(enum pm8xxx_pon_config config);
+
+/**
+ * pm8xxx_stay_on - enables stay_on feature
+ *
+ * PMIC stay-on feature allows PMIC to ignore MSM PS_HOLD=low
+ * signal so that some special functions like debugging could be
+ * performed.
+ *
+ * This feature should not be used in any product release.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_stay_on(void);
+
+/**
+ * pm8xxx_preload_dVdd - preload the dVdd regulator during off state.
+ *
+ * This can help to reduce fluctuations in the dVdd voltage during startup
+ * at the cost of additional off state current draw.
+ *
+ * This API should only be called if dVdd startup issues are suspected.
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_preload_dVdd(void);
+
+/**
+ * pm8xxx_usb_id_pullup - Control a pullup for USB ID
+ *
+ * @enable: enable (1) or disable (0) the pullup
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_usb_id_pullup(int enable);
+
+/**
+ * pm8xxx_aux_clk_control - Control an auxiliary clock
+ * @clk_id: ID of clock to be programmed, registers of XO_CNTRL2
+ * @divider: divisor to use when configuring desired clock
+ * @enable: enable (1) the designated clock with the supplied division,
+ *		or disable (0) the designated clock
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_aux_clk_control(enum pm8xxx_aux_clk_id clk_id,
+				enum pm8xxx_aux_clk_div divider,
+				bool enable);
+
+/**
+ * pm8xxx_hsed_bias_control - Control the HSED_BIAS signal
+ * @bias: the bias line to be controlled (of the 3)
+ * @enable: enable/disable the bias line
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_hsed_bias_control(enum pm8xxx_hsed_bias bias, bool enable);
+#else
+
+static inline int pm8xxx_reset_pwr_off(int reset)
+{
+	return -ENODEV;
+}
+static inline int
+pm8xxx_uart_gpio_mux_ctrl(enum pm8xxx_uart_path_sel uart_path_sel)
+{
+	return -ENODEV;
+}
+static inline int
+pm8xxx_coincell_chg_config(struct pm8xxx_coincell_chg *chg_config)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_smpl_set_delay(enum pm8xxx_smpl_delay delay)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_smpl_control(int enable)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_watchdog_reset_control(int enable)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_hard_reset_config(enum pm8xxx_pon_config config)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_stay_on(void)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_preload_dVdd(void)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_usb_id_pullup(int enable)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_aux_clk_control(enum pm8xxx_aux_clk_id clk_id,
+			enum pm8xxx_aux_clk_div divider, bool enable)
+{
+	return -ENODEV;
+}
+static inline int pm8xxx_hsed_bias_control(enum pm8xxx_hsed_bias bias,
+							bool enable)
+{
+	return -ENODEV;
+}
+
+#endif
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/mpp.h b/include/linux/mfd/pm8xxx/mpp.h
new file mode 100644
index 0000000..2a934e5
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/mpp.h
@@ -0,0 +1,263 @@
+/* Copyright (c) 2011-2012, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __PM8XXX_MPP_H
+#define __PM8XXX_MPP_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_MPP_DEV_NAME	"pm8xxx-mpp"
+
+struct pm8xxx_mpp_core_data {
+	int	base_addr;
+	int	nmpps;
+};
+
+struct pm8xxx_mpp_platform_data {
+	struct pm8xxx_mpp_core_data	core_data;
+	int				mpp_base;
+};
+
+/**
+ * struct pm8xxx_mpp_config_data - structure to specify mpp configuration values
+ * @type:	MPP type which determines the overall MPP function (i.e. digital
+ *		in/out/bi, analog in/out, current sink, or test).  It should be
+ *		set to the value of one of PM8XXX_MPP_TYPE_D_*.
+ * @level:	meaning depends upon MPP type specified
+ * @control:	meaning depends upon MPP type specified
+ *
+ * Usage of level argument:
+ * 1. type = PM8XXX_MPP_TYPE_D_INPUT, PM8XXX_MPP_TYPE_D_OUTPUT,
+ *	     PM8XXX_MPP_TYPE_D_BI_DIR, or PM8XXX_MPP_TYPE_DTEST_OUTPUT -
+ *
+ *	level specifies that digital logic level to use for the MPP.  It should
+ *	be set to the value of one of PM8XXX_MPP_DIG_LEVEL_*.  Actual regulator
+ *	connections for these level choices are PMIC chip specific.
+ *
+ * 2. type = PM8XXX_MPP_TYPE_A_INPUT -
+ *
+ *	level specifies where in the PMIC chip the analog input value should
+ *	be routed to.  It should be set to the value of one of
+ *	PM8XXX_MPP_AIN_AMUX_*.
+ *
+ * 3. type = PM8XXX_MPP_TYPE_A_OUTPUT -
+ *
+ *	level specifies the output analog voltage reference level.  It should
+ *	be set to the value of one of PM8XXX_MPP_AOUT_LVL_*.
+ *
+ * 4. type = PM8XXX_MPP_TYPE_SINK or PM8XXX_MPP_TYPE_DTEST_SINK -
+ *
+ *	level specifies the output current level.  It should be set to the value
+ *	of one of PM8XXX_MPP_CS_OUT_*.
+ *
+ * Usage of control argument:
+ * 1. type = PM8XXX_MPP_TYPE_D_INPUT -
+ *
+ *	control specifies how the digital input should be routed in the chip.
+ *	It should be set to the value of one of PM8XXX_MPP_DIN_TO_*.
+ *
+ * 2. type = PM8XXX_MPP_TYPE_D_OUTPUT -
+ *
+ *	control specifies the digital output value.  It should be set to the
+ *	value of one of PM8XXX_MPP_DOUT_CTRL_*.
+ *
+ * 3. type = PM8XXX_MPP_TYPE_D_BI_DIR -
+ *
+ *	control specifies the pullup resistor value.  It should be set to the
+ *	value of one of PM8XXX_MPP_BI_PULLUP_*.
+ *
+ * 4. type = PM8XXX_MPP_TYPE_A_INPUT -
+ *
+ *	control is unused; a value of 0 is sufficient.
+ *
+ * 5. type = PM8XXX_MPP_TYPE_A_OUTPUT -
+ *
+ *	control specifies if analog output is enabled.  It should be set to the
+ *	value of one of PM8XXX_MPP_AOUT_CTRL_*.
+ *
+ * 6. type = PM8XXX_MPP_TYPE_SINK -
+ *
+ *	control specifies if current sinking is enabled.  It should be set to
+ *	the value of one of PM8XXX_MPP_CS_CTRL_*.
+ *
+ * 7. type = PM8XXX_MPP_TYPE_DTEST_SINK -
+ *
+ *	control specifies if current sinking is enabled.  It should be set to
+ *	the value of one of PM8XXX_MPP_DTEST_CS_CTRL_*.
+ *
+ * 8. type = PM8XXX_MPP_TYPE_DTEST_OUTPUT -
+ *
+ *	control specifies which DTEST bus value to output.  It should be set to
+ *	the value of one of PM8XXX_MPP_DTEST_*.
+ */
+struct pm8xxx_mpp_config_data {
+	unsigned	type;
+	unsigned	level;
+	unsigned	control;
+};
+
+/* API */
+#if defined(CONFIG_GPIO_PM8XXX_MPP) || defined(CONFIG_GPIO_PM8XXX_MPP_MODULE)
+
+/**
+ * pm8xxx_mpp_config() - configure control options of a multi-purpose pin (MPP)
+ * @mpp:	global GPIO number corresponding to the MPP
+ * @config:	configuration to set for this MPP
+ * Context: can sleep
+ *
+ * RETURNS: an appropriate -ERRNO error value on error, or zero for success.
+ */
+int pm8xxx_mpp_config(unsigned mpp, struct pm8xxx_mpp_config_data *config);
+
+#else
+
+static inline int pm8xxx_mpp_config(unsigned mpp,
+				    struct pm8xxx_mpp_config_data *config)
+{
+	return -ENXIO;
+}
+
+#endif
+
+/* MPP Type: type */
+#define	PM8XXX_MPP_TYPE_D_INPUT		0
+#define	PM8XXX_MPP_TYPE_D_OUTPUT	1
+#define	PM8XXX_MPP_TYPE_D_BI_DIR	2
+#define	PM8XXX_MPP_TYPE_A_INPUT		3
+#define	PM8XXX_MPP_TYPE_A_OUTPUT	4
+#define	PM8XXX_MPP_TYPE_SINK		5
+#define	PM8XXX_MPP_TYPE_DTEST_SINK	6
+#define	PM8XXX_MPP_TYPE_DTEST_OUTPUT	7
+
+/* Digital Input/Output: level */
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_0	0
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_1	1
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_2	2
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_3	3
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_4	4
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_5	5
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_6	6
+#define	PM8XXX_MPP_DIG_LEVEL_VIO_7	7
+
+/* Digital Input/Output: level [PM8058] */
+#define	PM8058_MPP_DIG_LEVEL_VPH	0
+#define	PM8058_MPP_DIG_LEVEL_S3		1
+#define	PM8058_MPP_DIG_LEVEL_L2		2
+#define	PM8058_MPP_DIG_LEVEL_L3		3
+
+/* Digital Input/Output: level [PM8901] */
+#define	PM8901_MPP_DIG_LEVEL_MSMIO	0
+#define	PM8901_MPP_DIG_LEVEL_DIG	1
+#define	PM8901_MPP_DIG_LEVEL_L5		2
+#define	PM8901_MPP_DIG_LEVEL_S4		3
+#define	PM8901_MPP_DIG_LEVEL_VPH	4
+
+/* Digital Input/Output: level [PM8921] */
+#define	PM8921_MPP_DIG_LEVEL_S4		1
+#define	PM8921_MPP_DIG_LEVEL_L15	3
+#define	PM8921_MPP_DIG_LEVEL_L17	4
+#define	PM8921_MPP_DIG_LEVEL_VPH	7
+
+/* Digital Input/Output: level [PM8821] */
+#define	PM8821_MPP_DIG_LEVEL_1P8	0
+#define	PM8821_MPP_DIG_LEVEL_VPH	7
+
+/* Digital Input/Output: level [PM8018] */
+#define	PM8018_MPP_DIG_LEVEL_L4		0
+#define	PM8018_MPP_DIG_LEVEL_L14	1
+#define	PM8018_MPP_DIG_LEVEL_S3		2
+#define	PM8018_MPP_DIG_LEVEL_L6		3
+#define	PM8018_MPP_DIG_LEVEL_L2		4
+#define	PM8018_MPP_DIG_LEVEL_L5		5
+#define	PM8018_MPP_DIG_LEVEL_VPH	7
+
+/* Digital Input/Output: level [PM8038] */
+#define	PM8038_MPP_DIG_LEVEL_L20	0
+#define	PM8038_MPP_DIG_LEVEL_L11	1
+#define	PM8038_MPP_DIG_LEVEL_L5		2
+#define	PM8038_MPP_DIG_LEVEL_L15	3
+#define	PM8038_MPP_DIG_LEVEL_L17	4
+#define	PM8038_MPP_DIG_LEVEL_VPH	7
+
+/* Digital Input: control */
+#define	PM8XXX_MPP_DIN_TO_INT		0
+#define	PM8XXX_MPP_DIN_TO_DBUS1		1
+#define	PM8XXX_MPP_DIN_TO_DBUS2		2
+#define	PM8XXX_MPP_DIN_TO_DBUS3		3
+
+/* Digital Output: control */
+#define	PM8XXX_MPP_DOUT_CTRL_LOW	0
+#define	PM8XXX_MPP_DOUT_CTRL_HIGH	1
+#define	PM8XXX_MPP_DOUT_CTRL_MPP	2
+#define	PM8XXX_MPP_DOUT_CTRL_INV_MPP	3
+
+/* Bidirectional: control */
+#define	PM8XXX_MPP_BI_PULLUP_1KOHM	0
+#define	PM8XXX_MPP_BI_PULLUP_OPEN	1
+#define	PM8XXX_MPP_BI_PULLUP_10KOHM	2
+#define	PM8XXX_MPP_BI_PULLUP_30KOHM	3
+
+/* Analog Input: level */
+#define	PM8XXX_MPP_AIN_AMUX_CH5		0
+#define	PM8XXX_MPP_AIN_AMUX_CH6		1
+#define	PM8XXX_MPP_AIN_AMUX_CH7		2
+#define	PM8XXX_MPP_AIN_AMUX_CH8		3
+#define	PM8XXX_MPP_AIN_AMUX_CH9		4
+#define	PM8XXX_MPP_AIN_AMUX_ABUS1	5
+#define	PM8XXX_MPP_AIN_AMUX_ABUS2	6
+#define	PM8XXX_MPP_AIN_AMUX_ABUS3	7
+
+/* Analog Output: level */
+#define	PM8XXX_MPP_AOUT_LVL_1V25	0
+#define	PM8XXX_MPP_AOUT_LVL_1V25_2	1
+#define	PM8XXX_MPP_AOUT_LVL_0V625	2
+#define	PM8XXX_MPP_AOUT_LVL_0V3125	3
+#define	PM8XXX_MPP_AOUT_LVL_MPP		4
+#define	PM8XXX_MPP_AOUT_LVL_ABUS1	5
+#define	PM8XXX_MPP_AOUT_LVL_ABUS2	6
+#define	PM8XXX_MPP_AOUT_LVL_ABUS3	7
+
+/* Analog Output: control */
+#define	PM8XXX_MPP_AOUT_CTRL_DISABLE		0
+#define	PM8XXX_MPP_AOUT_CTRL_ENABLE		1
+#define	PM8XXX_MPP_AOUT_CTRL_MPP_HIGH_EN	2
+#define	PM8XXX_MPP_AOUT_CTRL_MPP_LOW_EN		3
+
+/* Current Sink: level */
+#define	PM8XXX_MPP_CS_OUT_5MA		0
+#define	PM8XXX_MPP_CS_OUT_10MA		1
+#define	PM8XXX_MPP_CS_OUT_15MA		2
+#define	PM8XXX_MPP_CS_OUT_20MA		3
+#define	PM8XXX_MPP_CS_OUT_25MA		4
+#define	PM8XXX_MPP_CS_OUT_30MA		5
+#define	PM8XXX_MPP_CS_OUT_35MA		6
+#define	PM8XXX_MPP_CS_OUT_40MA		7
+
+/* Current Sink: control */
+#define	PM8XXX_MPP_CS_CTRL_DISABLE	0
+#define	PM8XXX_MPP_CS_CTRL_ENABLE	1
+#define	PM8XXX_MPP_CS_CTRL_MPP_HIGH_EN	2
+#define	PM8XXX_MPP_CS_CTRL_MPP_LOW_EN	3
+
+/* DTEST Current Sink: control */
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN1	0
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN2	1
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN3	2
+#define	PM8XXX_MPP_DTEST_CS_CTRL_EN4	3
+
+/* DTEST Digital Output: control */
+#define	PM8XXX_MPP_DTEST_DBUS1		0
+#define	PM8XXX_MPP_DTEST_DBUS2		1
+#define	PM8XXX_MPP_DTEST_DBUS3		2
+#define	PM8XXX_MPP_DTEST_DBUS4		3
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/nfc.h b/include/linux/mfd/pm8xxx/nfc.h
new file mode 100644
index 0000000..e58e0a9
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/nfc.h
@@ -0,0 +1,79 @@
+/* Copyright (c) 2010,2011 Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __PM8XXX_NFC_H__
+#define __PM8XXX_NFC_H__
+
+struct pm8xxx_nfc_device;
+
+#define PM8XXX_NFC_DEV_NAME		"pm8xxx-nfc"
+
+/* masks, flags and status */
+#define	PM_NFC_VDDLDO_MON_LEVEL		0x0003
+#define	PM_NFC_VPH_PWR_EN		0x0008
+#define	PM_NFC_EXT_VDDLDO_EN		0x0010
+#define	PM_NFC_EN			0x0020
+#define	PM_NFC_LDO_EN			0x0040
+#define	PM_NFC_SUPPORT_EN		0x0080
+
+#define	PM_NFC_EXT_EN_HIGH		0x0100
+#define	PM_NFC_MBG_EN_HIGH		0x0200
+#define	PM_NFC_VDDLDO_OK_HIGH		0x0400
+#define	PM_NFC_DTEST1_MODE		0x2000
+#define	PM_NFC_ATEST_EN			0x4000
+#define	PM_NFC_VDDLDO_MON_EN		0x8000
+
+#define	PM_NFC_CTRL_REQ			(PM_NFC_SUPPORT_EN |\
+					PM_NFC_LDO_EN |\
+					PM_NFC_EN |\
+					PM_NFC_EXT_VDDLDO_EN |\
+					PM_NFC_VPH_PWR_EN |\
+					PM_NFC_VDDLDO_MON_LEVEL)
+
+#define	PM_NFC_TEST_REQ			(PM_NFC_VDDLDO_MON_EN |\
+					PM_NFC_DTEST1_MODE |\
+					PM_NFC_ATEST_EN)
+
+#define	PM_NFC_TEST_STATUS		(PM_NFC_EXT_EN_HIGH |\
+					PM_NFC_MBG_EN_HIGH |\
+					PM_NFC_VDDLDO_OK_HIGH)
+
+/*
+ * pm8xxx_nfc_request - request a handle to access NFC device
+ */
+struct pm8xxx_nfc_device *pm8xxx_nfc_request(void);
+
+/*
+ * pm8xxx_nfc_config - configure NFC signals
+ *
+ * @nfcdev: the NFC device
+ * @mask: signal mask to configure
+ * @flags: control flags
+ */
+int pm8xxx_nfc_config(struct pm8xxx_nfc_device *nfcdev, u32 mask, u32 flags);
+
+/*
+ * pm8xxx_nfc_get_status - get NFC status
+ *
+ * @nfcdev: the NFC device
+ * @mask: of status mask to read
+ * @status: pointer to the status variable
+ */
+int pm8xxx_nfc_get_status(struct pm8xxx_nfc_device *nfcdev,
+			  u32 mask, u32 *status);
+
+/*
+ * pm8xxx_nfc_free - free the NFC device
+ */
+void pm8xxx_nfc_free(struct pm8xxx_nfc_device *nfcdev);
+
+#endif /* __PM8XXX_NFC_H__ */
diff --git a/include/linux/mfd/pm8xxx/tm.h b/include/linux/mfd/pm8xxx/tm.h
new file mode 100644
index 0000000..6974754
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/tm.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/*
+ * Qualcomm PMIC PM8xxx Thermal Manager driver
+ */
+
+#ifndef __PM8XXX_TM_H
+#define __PM8XXX_TM_H
+
+#include <linux/errno.h>
+
+#define PM8XXX_TM_DEV_NAME	"pm8xxx-tm"
+
+enum pm8xxx_tm_adc_type {
+	PM8XXX_TM_ADC_NONE,	/* Estimates temp based on overload level. */
+	PM8XXX_TM_ADC_PM8058_ADC,
+	PM8XXX_TM_ADC_PM8XXX_ADC,
+};
+
+struct pm8xxx_tm_core_data {
+	int				adc_channel;
+	unsigned long			default_no_adc_temp;
+	enum pm8xxx_tm_adc_type		adc_type;
+	u16				reg_addr_temp_alarm_ctrl;
+	u16				reg_addr_temp_alarm_pwm;
+	char				*tm_name;
+	char				*irq_name_temp_stat;
+	char				*irq_name_over_temp;
+};
+
+#endif
diff --git a/include/linux/mfd/pm8xxx/upl.h b/include/linux/mfd/pm8xxx/upl.h
new file mode 100644
index 0000000..b0e94a9
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/upl.h
@@ -0,0 +1,65 @@
+/* Copyright (c) 2010,2011 Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __PM8XXX_UPL_H__
+#define __PM8XXX_UPL_H__
+
+struct pm8xxx_upl_device;
+
+#define PM8XXX_UPL_DEV_NAME		"pm8xxx-upl"
+
+/* control masks and flags */
+#define PM8XXX_UPL_MOD_ENABLE_MASK	(0x10)
+#define PM8XXX_UPL_MOD_ENABLE		(0x10)
+#define PM8XXX_UPL_MOD_DISABLE		(0x00)
+
+#define PM8XXX_UPL_OUT_DTEST_MASK	(0xE0)
+#define PM8XXX_UPL_OUT_GPIO_ONLY	(0x00)
+#define PM8XXX_UPL_OUT_DTEST_1		(0x80)
+#define PM8XXX_UPL_OUT_DTEST_2		(0xA0)
+#define PM8XXX_UPL_OUT_DTEST_3		(0xC0)
+#define PM8XXX_UPL_OUT_DTEST_4		(0xE0)
+
+#define PM8XXX_UPL_IN_A_MASK		(0x01)
+#define PM8XXX_UPL_IN_A_GPIO		(0x00)
+#define PM8XXX_UPL_IN_A_DTEST		(0x01)
+#define PM8XXX_UPL_IN_B_MASK		(0x02)
+#define PM8XXX_UPL_IN_B_GPIO		(0x00)
+#define PM8XXX_UPL_IN_B_DTEST		(0x02)
+#define PM8XXX_UPL_IN_C_MASK		(0x04)
+#define PM8XXX_UPL_IN_C_GPIO		(0x00)
+#define PM8XXX_UPL_IN_C_DTEST		(0x04)
+#define PM8XXX_UPL_IN_D_MASK		(0x08)
+#define PM8XXX_UPL_IN_D_GPIO		(0x00)
+#define PM8XXX_UPL_IN_D_DTEST		(0x08)
+
+/*
+ * pm8xxx_upl_request - request a handle to access UPL device
+ */
+struct pm8xxx_upl_device *pm8xxx_upl_request(void);
+
+int pm8xxx_upl_read_truthtable(struct pm8xxx_upl_device *upldev,
+				u16 *truthtable);
+
+int pm8xxx_upl_write_truthtable(struct pm8xxx_upl_device *upldev,
+				u16 truthtable);
+
+/*
+ * pm8xxx_upl_config - configure UPL I/O settings and UPL enable/disable
+ *
+ * @upldev: the UPL device
+ * @mask: setting mask to configure
+ * @flags: setting flags
+ */
+int pm8xxx_upl_config(struct pm8xxx_upl_device *upldev, u32 mask, u32 flags);
+
+#endif /* __PM8XXX_UPL_H__ */
diff --git a/include/linux/mfd/pm8xxx/vibrator.h b/include/linux/mfd/pm8xxx/vibrator.h
new file mode 100644
index 0000000..cfea1c9
--- /dev/null
+++ b/include/linux/mfd/pm8xxx/vibrator.h
@@ -0,0 +1,39 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __PMIC8XXX_VIBRATOR_H__
+#define __PMIC8XXX_VIBRATOR_H__
+
+#define PM8XXX_VIBRATOR_DEV_NAME "pm8xxx-vib"
+
+enum pm8xxx_vib_en_mode {
+	PM8XXX_VIB_MANUAL,
+	PM8XXX_VIB_DTEST1,
+	PM8XXX_VIB_DTEST2,
+	PM8XXX_VIB_DTEST3
+};
+
+struct pm8xxx_vib_config {
+	u16			drive_mV;
+	u8			active_low;
+	enum pm8xxx_vib_en_mode	enable_mode;
+};
+
+struct pm8xxx_vibrator_platform_data {
+	int initial_vibrate_ms;
+	int max_timeout_ms;
+	int level_mV;
+};
+
+int pm8xxx_vibrator_config(struct pm8xxx_vib_config *vib_config);
+
+#endif /* __PMIC8XXX_VIBRATOR_H__ */
diff --git a/include/linux/mfd/pmic8058.h b/include/linux/mfd/pmic8058.h
new file mode 100644
index 0000000..7074c83
--- /dev/null
+++ b/include/linux/mfd/pmic8058.h
@@ -0,0 +1,137 @@
+/* Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+/*
+ * Qualcomm PMIC8058 driver header file
+ *
+ */
+
+#ifndef __MFD_PMIC8058_H__
+#define __MFD_PMIC8058_H__
+
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/pm8xxx/irq.h>
+#include <linux/mfd/pm8xxx/gpio.h>
+#include <linux/mfd/pm8xxx/mpp.h>
+#include <linux/mfd/pm8xxx/rtc.h>
+#include <linux/input/pmic8xxx-pwrkey.h>
+#include <linux/input/pmic8xxx-keypad.h>
+#include <linux/mfd/pm8xxx/vibrator.h>
+#include <linux/mfd/pm8xxx/nfc.h>
+#include <linux/mfd/pm8xxx/upl.h>
+#include <linux/mfd/pm8xxx/misc.h>
+#include <linux/mfd/pm8xxx/batt-alarm.h>
+#include <linux/leds-pmic8058.h>
+#include <linux/pmic8058-othc.h>
+#include <linux/mfd/pm8xxx/tm.h>
+#include <linux/pmic8058-xoadc.h>
+#include <linux/regulator/pmic8058-regulator.h>
+#include <linux/regulator/pm8058-xo.h>
+#include <linux/pwm.h>
+#include <linux/pmic8058-pwm.h>
+
+#ifdef CONFIG_CHARGER_SMB328A
+#define PM8058_GPIO(n)	((n) - 1)
+#endif
+
+#define PM8058_GPIOS		40
+#define PM8058_MPPS		12
+
+#define PM8058_GPIO_BLOCK_START	24
+#define PM8058_MPP_BLOCK_START	16
+
+#define PM8058_NR_IRQS		256
+
+#define PM8058_IRQ_BLOCK_BIT(block, bit) ((block) * 8 + (bit))
+
+/* MPPs and GPIOs [0,N) */
+#define PM8058_MPP_IRQ(base, mpp)	((base) + \
+					PM8058_IRQ_BLOCK_BIT(16, (mpp)))
+#define PM8058_GPIO_IRQ(base, gpio)	((base) + \
+					PM8058_IRQ_BLOCK_BIT(24, (gpio)))
+
+/* PM8058 IRQ's */
+#define PM8058_VCP_IRQ			PM8058_IRQ_BLOCK_BIT(1, 0)
+#define PM8058_CHGILIM_IRQ		PM8058_IRQ_BLOCK_BIT(1, 3)
+#define PM8058_VBATDET_LOW_IRQ		PM8058_IRQ_BLOCK_BIT(1, 4)
+#define PM8058_BATT_REPLACE_IRQ		PM8058_IRQ_BLOCK_BIT(1, 5)
+#define PM8058_CHGINVAL_IRQ		PM8058_IRQ_BLOCK_BIT(1, 6)
+#define PM8058_CHGVAL_IRQ		PM8058_IRQ_BLOCK_BIT(1, 7)
+#define PM8058_CHG_END_IRQ		PM8058_IRQ_BLOCK_BIT(2, 0)
+#define PM8058_FASTCHG_IRQ		PM8058_IRQ_BLOCK_BIT(2, 1)
+#define PM8058_CHGSTATE_IRQ		PM8058_IRQ_BLOCK_BIT(2, 3)
+#define PM8058_AUTO_CHGFAIL_IRQ		PM8058_IRQ_BLOCK_BIT(2, 4)
+#define PM8058_AUTO_CHGDONE_IRQ		PM8058_IRQ_BLOCK_BIT(2, 5)
+#define PM8058_ATCFAIL_IRQ		PM8058_IRQ_BLOCK_BIT(2, 6)
+#define PM8058_ATC_DONE_IRQ		PM8058_IRQ_BLOCK_BIT(2, 7)
+#define PM8058_OVP_OK_IRQ		PM8058_IRQ_BLOCK_BIT(3, 0)
+#define PM8058_COARSE_DET_OVP_IRQ	PM8058_IRQ_BLOCK_BIT(3, 1)
+#define PM8058_VCPMAJOR_IRQ		PM8058_IRQ_BLOCK_BIT(3, 2)
+#define PM8058_CHG_GONE_IRQ		PM8058_IRQ_BLOCK_BIT(3, 3)
+#define PM8058_CHGTLIMIT_IRQ		PM8058_IRQ_BLOCK_BIT(3, 4)
+#define PM8058_CHGHOT_IRQ		PM8058_IRQ_BLOCK_BIT(3, 5)
+#define PM8058_BATTTEMP_IRQ		PM8058_IRQ_BLOCK_BIT(3, 6)
+#define PM8058_BATTCONNECT_IRQ		PM8058_IRQ_BLOCK_BIT(3, 7)
+#define PM8058_BATFET_IRQ		PM8058_IRQ_BLOCK_BIT(5, 4)
+#define PM8058_VBATDET_IRQ		PM8058_IRQ_BLOCK_BIT(5, 5)
+#define PM8058_VBAT_IRQ			PM8058_IRQ_BLOCK_BIT(5, 6)
+
+#define PM8058_RTC_IRQ			PM8058_IRQ_BLOCK_BIT(6, 5)
+#define PM8058_RTC_ALARM_IRQ		PM8058_IRQ_BLOCK_BIT(4, 7)
+#define PM8058_PWRKEY_REL_IRQ		PM8058_IRQ_BLOCK_BIT(6, 2)
+#define PM8058_PWRKEY_PRESS_IRQ		PM8058_IRQ_BLOCK_BIT(6, 3)
+#define PM8058_KEYPAD_IRQ		PM8058_IRQ_BLOCK_BIT(9, 2)
+#define PM8058_KEYSTUCK_IRQ		PM8058_IRQ_BLOCK_BIT(9, 3)
+#define PM8058_BATT_ALARM_IRQ		PM8058_IRQ_BLOCK_BIT(5, 6)
+#define PM8058_SW_0_IRQ			PM8058_IRQ_BLOCK_BIT(7, 1)
+#define PM8058_IR_0_IRQ			PM8058_IRQ_BLOCK_BIT(7, 0)
+#define PM8058_SW_1_IRQ			PM8058_IRQ_BLOCK_BIT(7, 3)
+#define PM8058_IR_1_IRQ			PM8058_IRQ_BLOCK_BIT(7, 2)
+#define PM8058_SW_2_IRQ			PM8058_IRQ_BLOCK_BIT(7, 5)
+#define PM8058_IR_2_IRQ			PM8058_IRQ_BLOCK_BIT(7, 4)
+#define PM8058_TEMPSTAT_IRQ		PM8058_IRQ_BLOCK_BIT(6, 7)
+#define PM8058_OVERTEMP_IRQ		PM8058_IRQ_BLOCK_BIT(4, 2)
+#define PM8058_ADC_IRQ			PM8058_IRQ_BLOCK_BIT(9, 4)
+#define PM8058_OSCHALT_IRQ		PM8058_IRQ_BLOCK_BIT(4, 6)
+#define PM8058_CBLPWR_IRQ		PM8058_IRQ_BLOCK_BIT(4, 3)
+#define PM8058_RESOUT_IRQ		PM8058_IRQ_BLOCK_BIT(6, 4)
+
+struct pmic8058_charger_data {
+	unsigned int max_source_current;
+	int charger_type;
+	bool charger_data_valid;
+};
+
+struct pm8058_platform_data {
+	struct pm8xxx_mpp_platform_data		*mpp_pdata;
+	struct pm8xxx_keypad_platform_data      *keypad_pdata;
+	struct pm8xxx_gpio_platform_data	*gpio_pdata;
+	struct pm8xxx_irq_platform_data		*irq_pdata;
+	struct pm8xxx_rtc_platform_data		*rtc_pdata;
+	struct pm8xxx_pwrkey_platform_data	*pwrkey_pdata;
+	struct pm8xxx_vibrator_platform_data	*vibrator_pdata;
+	struct pm8xxx_misc_platform_data	*misc_pdata;
+	struct pmic8058_leds_platform_data	*leds_pdata;
+	struct pmic8058_othc_config_pdata	*othc0_pdata;
+	struct pmic8058_othc_config_pdata	*othc1_pdata;
+	struct pmic8058_othc_config_pdata	*othc2_pdata;
+	struct xoadc_platform_data		*xoadc_pdata;
+	struct pm8058_pwm_pdata			*pwm_pdata;
+	struct pm8058_vreg_pdata		*regulator_pdatas;
+	int					num_regulators;
+	struct pm8058_xo_pdata			*xo_buffer_pdata;
+	int					num_xo_buffers;
+	struct pmic8058_charger_data		*charger_pdata;
+};
+
+#endif  /* __MFD_PMIC8058_H__ */
diff --git a/include/linux/pmic8058-othc.h b/include/linux/pmic8058-othc.h
new file mode 100644
index 0000000..4c59845
--- /dev/null
+++ b/include/linux/pmic8058-othc.h
@@ -0,0 +1,146 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __PMIC8058_OTHC_H__
+#define __PMIC8058_OTHC_H__
+
+/* Accessory detecion flags */
+#define OTHC_MICBIAS_DETECT	BIT(0)
+#define OTHC_GPIO_DETECT	BIT(1)
+#define OTHC_SWITCH_DETECT	BIT(2)
+#define OTHC_ADC_DETECT		BIT(3)
+
+enum othc_accessory_type {
+	OTHC_NO_DEVICE = 0,
+	OTHC_HEADSET = 1 << 0,
+	OTHC_HEADPHONE = 1 << 1,
+	OTHC_MICROPHONE = 1 << 2,
+	OTHC_ANC_HEADSET = 1 << 3,
+	OTHC_ANC_HEADPHONE = 1 << 4,
+	OTHC_ANC_MICROPHONE = 1 << 5,
+	OTHC_SVIDEO_OUT = 1 << 6,
+};
+
+struct accessory_adc_thres {
+	int min_threshold;
+	int max_threshold;
+};
+
+struct othc_accessory_info {
+	unsigned int accessory;
+	unsigned int detect_flags;
+	unsigned int gpio;
+	unsigned int active_low;
+	unsigned int key_code;
+	bool enabled;
+	struct accessory_adc_thres adc_thres;
+};
+
+enum othc_headset_type {
+	OTHC_HEADSET_NO,
+	OTHC_HEADSET_NC,
+};
+
+struct othc_regulator_config {
+	const char *regulator;
+	unsigned int max_uV;
+	unsigned int min_uV;
+};
+
+/* Signal control for OTHC module */
+enum othc_micbias_enable {
+	/* Turn off MICBIAS signal */
+	OTHC_SIGNAL_OFF,
+	/* Turn on MICBIAS signal when TCXO is enabled */
+	OTHC_SIGNAL_TCXO,
+	/* Turn on MICBIAS signal when PWM is high or TCXO is enabled */
+	OTHC_SIGNAL_PWM_TCXO,
+	/* MICBIAS always enabled */
+	OTHC_SIGNAL_ALWAYS_ON,
+};
+
+/* Number of MICBIAS lines supported by PMIC8058 */
+enum othc_micbias {
+	OTHC_MICBIAS_0,
+	OTHC_MICBIAS_1,
+	OTHC_MICBIAS_2,
+	OTHC_MICBIAS_MAX,
+};
+
+enum othc_micbias_capability {
+	/* MICBIAS used only for BIAS with on/off capability */
+	OTHC_MICBIAS,
+	/* MICBIAS used to support HSED functionality */
+	OTHC_MICBIAS_HSED,
+};
+
+struct othc_switch_info {
+	u32 min_adc_threshold;
+	u32 max_adc_threshold;
+	u32 key_code;
+};
+
+struct othc_n_switch_config {
+	u32 voltage_settling_time_ms;
+	u8 num_adc_samples;
+	uint32_t adc_channel;
+	struct othc_switch_info *switch_info;
+	u8 num_keys;
+	bool default_sw_en;
+	u8 default_sw_idx;
+};
+
+struct hsed_bias_config {
+	enum othc_headset_type othc_headset;
+	u16 othc_lowcurr_thresh_uA;
+	u16 othc_highcurr_thresh_uA;
+	u32 othc_hyst_prediv_us;
+	u32 othc_period_clkdiv_us;
+	u32 othc_hyst_clk_us;
+	u32 othc_period_clk_us;
+	int othc_wakeup;
+};
+
+/* Configuration data for HSED */
+struct othc_hsed_config {
+	struct hsed_bias_config *hsed_bias_config;
+	unsigned long detection_delay_ms;
+	/* Switch configuration */
+	unsigned long switch_debounce_ms;
+	bool othc_support_n_switch; /* Set if supporting > 1 switch */
+	struct othc_n_switch_config *switch_config;
+	/* Accessory configuration */
+	bool accessories_support;
+	bool accessories_adc_support;
+	uint32_t accessories_adc_channel;
+	struct othc_accessory_info *accessories;
+	int othc_num_accessories;
+	int video_out_gpio;
+	int ir_gpio;
+};
+
+struct pmic8058_othc_config_pdata {
+	enum othc_micbias micbias_select;
+	enum othc_micbias_enable micbias_enable;
+	enum othc_micbias_capability micbias_capability;
+	struct othc_hsed_config *hsed_config;
+	const char *hsed_name;
+	struct othc_regulator_config *micbias_regulator;
+};
+
+int pm8058_micbias_enable(enum othc_micbias micbias,
+			enum othc_micbias_enable enable);
+int pm8058_othc_svideo_enable(enum othc_micbias micbias,
+			bool enable);
+
+#endif /* __PMIC8058_OTHC_H__ */
diff --git a/include/linux/pmic8058-pwm.h b/include/linux/pmic8058-pwm.h
new file mode 100644
index 0000000..d380170
--- /dev/null
+++ b/include/linux/pmic8058-pwm.h
@@ -0,0 +1,148 @@
+/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+#ifndef __PMIC8058_PWM_H__
+#define __PMIC8058_PWM_H__
+
+/* The MAX value is computation limit. Hardware limit is 393 seconds. */
+#define	PM_PWM_PERIOD_MAX		(274 * USEC_PER_SEC)
+/* The MIN value is hardware limit. */
+#define	PM_PWM_PERIOD_MIN		7 /* micro seconds */
+
+struct pm8058_pwm_pdata {
+	int 	(*config)(struct pwm_device *pwm, int ch, int on);
+	int 	(*enable)(struct pwm_device *pwm, int ch, int on);
+};
+
+#define	PM_PWM_LUT_SIZE			64
+#define	PM_PWM_LUT_DUTY_TIME_MAX	512	/* ms */
+#define	PM_PWM_LUT_PAUSE_MAX		(7000 * PM_PWM_LUT_DUTY_TIME_MAX)
+
+/* Flags for Look Up Table */
+#define	PM_PWM_LUT_LOOP		0x01
+#define	PM_PWM_LUT_RAMP_UP	0x02
+#define	PM_PWM_LUT_REVERSE	0x04
+#define	PM_PWM_LUT_PAUSE_HI_EN	0x10
+#define	PM_PWM_LUT_PAUSE_LO_EN	0x20
+
+#define	PM_PWM_LUT_NO_TABLE	0x100
+
+/* PWM LED ID */
+#define	PM_PWM_LED_0		0
+#define	PM_PWM_LED_1		1
+#define	PM_PWM_LED_2		2
+#define	PM_PWM_LED_KPD		3
+#define	PM_PWM_LED_FLASH	4
+#define	PM_PWM_LED_FLASH1	5
+
+/* PWM LED configuration mode */
+#define	PM_PWM_CONF_NONE	0x0
+#define	PM_PWM_CONF_PWM1	0x1
+#define	PM_PWM_CONF_PWM2	0x2
+#define	PM_PWM_CONF_PWM3	0x3
+#define	PM_PWM_CONF_DTEST1	0x4
+#define	PM_PWM_CONF_DTEST2	0x5
+#define	PM_PWM_CONF_DTEST3	0x6
+#define	PM_PWM_CONF_DTEST4	0x7
+
+/**
+ * PWM frequency/period control
+ *
+ * PWM Frequency = ClockFrequency / (N * T)
+ *   or
+ * PWM Period = Clock Period * (N * T)
+ *   where
+ * N = 2^9 or 2^6 for 9-bit or 6-bit PWM size
+ * T = Pre-divide * 2^m, m = 0..7 (exponent)
+ *
+ */
+
+enum pm_pwm_size {
+	PM_PWM_SIZE_6BIT =	6,
+	PM_PWM_SIZE_9BIT =	9,
+};
+
+enum pm_pwm_clk {
+	PM_PWM_CLK_1KHZ,
+	PM_PWM_CLK_32KHZ,
+	PM_PWM_CLK_19P2MHZ,
+};
+
+enum pm_pwm_pre_div {
+	PM_PWM_PDIV_2,
+	PM_PWM_PDIV_3,
+	PM_PWM_PDIV_5,
+	PM_PWM_PDIV_6,
+};
+
+/**
+ * struct pm8058_pwm_period - PWM period structure
+ * @pwm_size: enum pm_pwm_size
+ * @clk: enum pm_pwm_clk
+ * @pre_div: enum pm_pwm_pre_div
+ * @pre_div_exp: exponent of 2 as part of pre-divider: 0..7
+ */
+struct pm8058_pwm_period {
+	enum pm_pwm_size	pwm_size;
+	enum pm_pwm_clk		clk;
+	enum pm_pwm_pre_div	pre_div;
+	int			pre_div_exp;
+};
+
+/**
+ * pm8058_pwm_config_period - change PWM period
+ *
+ * @pwm: the PWM device
+ * @pwm_p: period in struct pm8058_pwm_period
+ */
+int pm8058_pwm_config_period(struct pwm_device *pwm,
+			     struct pm8058_pwm_period *pwm_p);
+
+/**
+ * pm8058_pwm_config_duty_cycle - change PWM duty cycle
+ *
+ * @pwm: the PWM device
+ * @pwm_value: the duty cycle in raw PWM value (< 2^pwm_size)
+ */
+int pm8058_pwm_config_duty_cycle(struct pwm_device *pwm, int pwm_value);
+
+/**
+ * pm8058_pwm_lut_config - change a PWM device configuration to use LUT
+ *
+ * @pwm: the PWM device
+ * @period_us: period in micro second
+ * @duty_pct: arrary of duty cycles in percent, like 20, 50.
+ * @duty_time_ms: time for each duty cycle in millisecond
+ * @start_idx: start index in lookup table from 0 to MAX-1
+ * @idx_len: number of index
+ * @pause_lo: pause time in millisecond at low index
+ * @pause_hi: pause time in millisecond at high index
+ * @flags: control flags
+ */
+int pm8058_pwm_lut_config(struct pwm_device *pwm, int period_us,
+			  int duty_pct[], int duty_time_ms, int start_idx,
+			  int len, int pause_lo, int pause_hi, int flags);
+
+/**
+ * pm8058_pwm_lut_enable - control a PWM device to start/stop LUT ramp
+ *
+ * @pwm: the PWM device
+ * @start: to start (1), or stop (0)
+ */
+int pm8058_pwm_lut_enable(struct pwm_device *pwm, int start);
+
+int pm8058_pwm_set_dtest(struct pwm_device *pwm, int enable);
+
+int pm8058_pwm_config_led(struct pwm_device *pwm, int id,
+			  int mode, int max_current);
+
+#endif /* __PMIC8058_PWM_H__ */
diff --git a/include/linux/pmic8058-xoadc.h b/include/linux/pmic8058-xoadc.h
new file mode 100644
index 0000000..5163b65
--- /dev/null
+++ b/include/linux/pmic8058-xoadc.h
@@ -0,0 +1,121 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Qualcomm XOADC Driver header file
+ */
+
+#ifndef _PMIC8058_XOADC_H_
+#define _PMIC8058_XOADC_H_
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/workqueue.h>
+
+struct xoadc_conv_state {
+	struct adc_conv_slot	*context;
+	struct list_head	slots;
+	struct mutex		list_lock;
+};
+
+#define CHANNEL_VCOIN		0
+#define CHANNEL_VBAT		1
+#define CHANNEL_VCHG		2
+#define CHANNEL_CHG_MONITOR	3
+#define CHANNEL_VPH_PWR		4
+#define CHANNEL_MPP5		5
+#define CHANNEL_MPP6		6
+#define CHANNEL_MPP7		7
+#define CHANNEL_MPP8		8
+#define CHANNEL_MPP9		9
+#define CHANNEL_USB_VBUS	0Xa
+#define CHANNEL_DIE_TEMP	0Xb
+#define CHANNEL_INTERNAL	0xc
+#define CHANNEL_125V		0xd
+#define CHANNEL_INTERNAL_2	0Xe
+#define CHANNEL_MUXOFF		0xf
+
+#define XOADC_MPP_3		0x2
+#define XOADC_MPP_4             0X3
+#define XOADC_MPP_5             0x4
+#define XOADC_MPP_7             0x6
+#define XOADC_MPP_8             0x7
+#define XOADC_MPP_10		0X9
+
+#define XOADC_PMIC_0		0x0
+
+#define CHANNEL_ADC_625_MV      625
+
+struct xoadc_platform_data {
+	struct adc_properties *xoadc_prop;
+	u32 (*xoadc_setup) (void);
+	void (*xoadc_shutdown) (void);
+	void (*xoadc_mpp_config) (void);
+	int (*xoadc_vreg_set) (int);
+	int (*xoadc_vreg_setup) (void);
+	void (*xoadc_vreg_shutdown) (void);
+	u32 xoadc_num;
+	u32 xoadc_wakeup;
+};
+
+#ifdef CONFIG_PMIC8058_XOADC
+int32_t pm8058_xoadc_read_adc_code(uint32_t adc_instance, int32_t *data);
+
+int32_t pm8058_xoadc_select_chan_and_start_conv(uint32_t adc_instance,
+						struct adc_conv_slot *slot);
+
+void pm8058_xoadc_slot_request(uint32_t adc_instance,
+		struct adc_conv_slot **slot);
+
+void pm8058_xoadc_restore_slot(uint32_t adc_instance,
+		struct adc_conv_slot *slot);
+
+struct adc_properties *pm8058_xoadc_get_properties(uint32_t dev_instance);
+
+int32_t pm8058_xoadc_calibrate(uint32_t dev_instance,
+		struct adc_conv_slot *slot, int * calib_status);
+
+int32_t pm8058_xoadc_registered(void);
+
+int32_t pm8058_xoadc_calib_device(uint32_t adc_instance);
+
+#else
+
+static inline int32_t pm8058_xoadc_read_adc_code(uint32_t adc_instance,
+		int32_t *data)
+{ return -ENXIO; }
+
+static inline int32_t pm8058_xoadc_select_chan_and_start_conv(
+		uint32_t adc_instance, struct adc_conv_slot *slot)
+{ return -ENXIO; }
+
+static inline void pm8058_xoadc_slot_request(uint32_t adc_instance,
+		struct adc_conv_slot **slot)
+{ return; }
+
+static inline void pm8058_xoadc_restore_slot(uint32_t adc_instance,
+		struct adc_conv_slot *slot)
+{ return; }
+
+static inline struct adc_properties *pm8058_xoadc_get_properties(
+		uint32_t dev_instance)
+{ return NULL; }
+
+static inline int32_t pm8058_xoadc_calibrate(uint32_t dev_instance,
+		struct adc_conv_slot *slot, int *calib_status)
+{ return -ENXIO; }
+
+static inline int32_t pm8058_xoadc_registered(void)
+{ return -ENXIO; }
+
+static inline int32_t pm8058_xoadc_calib_device(uint32_t adc_instance)
+{ return -ENXIO; }
+#endif
+#endif
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 804b906..f10829c 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -92,7 +92,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_AUTHENTIC,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	/* POWER_SUPPLY_PROP_CYCLE_COUNT, */
 	POWER_SUPPLY_PROP_VOLTAGE_MAX,
 	POWER_SUPPLY_PROP_VOLTAGE_MIN,
 	POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN,
@@ -134,6 +134,17 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MIN,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT_ALERT_MAX,
+        POWER_SUPPLY_PROP_BATT_TEMP,
+        POWER_SUPPLY_PROP_BATT_TEMP_ADC,
+        POWER_SUPPLY_PROP_BATT_VOL,
+        POWER_SUPPLY_PROP_BATT_VOL_ADC,
+        POWER_SUPPLY_PROP_BATT_VF_ADC,
+        POWER_SUPPLY_PROP_BATT_VOL_ADC_AVER,
+        POWER_SUPPLY_PROP_BATT_TEMP_ADC_AVER,
+        POWER_SUPPLY_PROP_BATT_VOL_AVER,
+        POWER_SUPPLY_PROP_BATT_TEMP_AVER,
+        POWER_SUPPLY_PROP_BATT_TYPE,
+        POWER_SUPPLY_PROP_BATT_FULL,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
diff --git a/include/linux/regulator/pm8058-xo.h b/include/linux/regulator/pm8058-xo.h
new file mode 100644
index 0000000..a2b8aeb
--- /dev/null
+++ b/include/linux/regulator/pm8058-xo.h
@@ -0,0 +1,31 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __PM8058_XO_H__
+#define __PM8058_XO_H__
+
+#include <linux/regulator/machine.h>
+
+#define PM8058_XO_BUFFER_DEV_NAME	"pm8058-xo-buffer"
+
+/* XO buffer control ids */
+#define PM8058_XO_ID_A0		0
+#define PM8058_XO_ID_A1		1
+
+#define PM8058_XO_ID_MAX	(PM8058_XO_ID_A1 + 1)
+
+struct pm8058_xo_pdata {
+	struct regulator_init_data	init_data;
+	int id;
+};
+
+#endif
diff --git a/include/linux/regulator/pmic8058-regulator.h b/include/linux/regulator/pmic8058-regulator.h
new file mode 100644
index 0000000..3eeaa61
--- /dev/null
+++ b/include/linux/regulator/pmic8058-regulator.h
@@ -0,0 +1,89 @@
+/* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __PMIC8058_REGULATOR_H__
+#define __PMIC8058_REGULATOR_H__
+
+#include <linux/regulator/machine.h>
+
+/* Low dropout regulator ids */
+#define PM8058_VREG_ID_L0	0
+#define PM8058_VREG_ID_L1	1
+#define PM8058_VREG_ID_L2	2
+#define PM8058_VREG_ID_L3	3
+#define PM8058_VREG_ID_L4	4
+#define PM8058_VREG_ID_L5	5
+#define PM8058_VREG_ID_L6	6
+#define PM8058_VREG_ID_L7	7
+#define PM8058_VREG_ID_L8	8
+#define PM8058_VREG_ID_L9	9
+#define PM8058_VREG_ID_L10	10
+#define PM8058_VREG_ID_L11	11
+#define PM8058_VREG_ID_L12	12
+#define PM8058_VREG_ID_L13	13
+#define PM8058_VREG_ID_L14	14
+#define PM8058_VREG_ID_L15	15
+#define PM8058_VREG_ID_L16	16
+#define PM8058_VREG_ID_L17	17
+#define PM8058_VREG_ID_L18	18
+#define PM8058_VREG_ID_L19	19
+#define PM8058_VREG_ID_L20	20
+#define PM8058_VREG_ID_L21	21
+#define PM8058_VREG_ID_L22	22
+#define PM8058_VREG_ID_L23	23
+#define PM8058_VREG_ID_L24	24
+#define PM8058_VREG_ID_L25	25
+
+/* Switched-mode power supply regulator ids */
+#define PM8058_VREG_ID_S0	26
+#define PM8058_VREG_ID_S1	27
+#define PM8058_VREG_ID_S2	28
+#define PM8058_VREG_ID_S3	29
+#define PM8058_VREG_ID_S4	30
+
+/* Low voltage switch regulator ids */
+#define PM8058_VREG_ID_LVS0	31
+#define PM8058_VREG_ID_LVS1	32
+
+/* Negative charge pump regulator id */
+#define PM8058_VREG_ID_NCP	33
+
+#define PM8058_VREG_MAX		(PM8058_VREG_ID_NCP + 1)
+
+#define PM8058_VREG_PIN_CTRL_NONE	0x00
+#define PM8058_VREG_PIN_CTRL_A0		0x01
+#define PM8058_VREG_PIN_CTRL_A1		0x02
+#define PM8058_VREG_PIN_CTRL_D0		0x04
+#define PM8058_VREG_PIN_CTRL_D1		0x08
+
+/* Minimum high power mode loads in uA. */
+#define PM8058_VREG_LDO_50_HPM_MIN_LOAD		5000
+#define PM8058_VREG_LDO_150_HPM_MIN_LOAD	10000
+#define PM8058_VREG_LDO_300_HPM_MIN_LOAD	10000
+#define PM8058_VREG_SMPS_HPM_MIN_LOAD		50000
+
+/* Pin ctrl enables/disables or toggles high/low power modes */
+enum pm8058_vreg_pin_fn {
+	PM8058_VREG_PIN_FN_ENABLE = 0,
+	PM8058_VREG_PIN_FN_MODE,
+};
+
+struct pm8058_vreg_pdata {
+	struct regulator_init_data	init_data;
+	int				id;
+	unsigned			pull_down_enable;
+	unsigned			pin_ctrl;
+	enum pm8058_vreg_pin_fn		pin_fn;
+};
+
+#endif
diff --git a/include/linux/wakelock.h b/include/linux/wakelock.h
new file mode 100644
index 0000000..5b2d0f3
--- /dev/null
+++ b/include/linux/wakelock.h
@@ -0,0 +1,90 @@
+/* include/linux/wakelock.h
+ *
+ * Copyright (C) 2007-2008 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _LINUX_WAKELOCK_H
+#define _LINUX_WAKELOCK_H
+
+#include <linux/list.h>
+#include <linux/ktime.h>
+
+/* A wake_lock prevents the system from entering suspend or other low power
+ * states when active. If the type is set to WAKE_LOCK_SUSPEND, the wake_lock
+ * prevents a full system suspend. If the type is WAKE_LOCK_IDLE, low power
+ * states that cause large interrupt latencies or that disable a set of
+ * interrupts will not entered from idle until the wake_locks are released.
+ */
+
+enum {
+	WAKE_LOCK_SUSPEND, /* Prevent suspend */
+	WAKE_LOCK_TYPE_COUNT
+};
+
+struct wake_lock {
+#ifdef CONFIG_HAS_WAKELOCK
+	struct list_head    link;
+	int                 flags;
+	const char         *name;
+	unsigned long       expires;
+#ifdef CONFIG_WAKELOCK_STAT
+	struct {
+		int             count;
+		int             expire_count;
+		int             wakeup_count;
+		ktime_t         total_time;
+		ktime_t         prevent_suspend_time;
+		ktime_t         max_time;
+		ktime_t         last_time;
+	} stat;
+#endif
+#endif
+};
+
+#ifdef CONFIG_HAS_WAKELOCK
+
+void wake_lock_init(struct wake_lock *lock, int type, const char *name);
+void wake_lock_destroy(struct wake_lock *lock);
+void wake_lock(struct wake_lock *lock);
+void wake_lock_timeout(struct wake_lock *lock, long timeout);
+void wake_unlock(struct wake_lock *lock);
+
+/* wake_lock_active returns a non-zero value if the wake_lock is currently
+ * locked. If the wake_lock has a timeout, it does not check the timeout
+ * but if the timeout had aready been checked it will return 0.
+ */
+int wake_lock_active(struct wake_lock *lock);
+
+/* has_wake_lock returns 0 if no wake locks of the specified type are active,
+ * and non-zero if one or more wake locks are held. Specifically it returns
+ * -1 if one or more wake locks with no timeout are active or the
+ * number of jiffies until all active wake locks time out.
+ */
+long has_wake_lock(int type);
+
+#else
+
+static inline void wake_lock_init(struct wake_lock *lock, int type,
+					const char *name) {}
+static inline void wake_lock_destroy(struct wake_lock *lock) {}
+static inline void wake_lock(struct wake_lock *lock) {}
+static inline void wake_lock_timeout(struct wake_lock *lock, long timeout) {}
+static inline void wake_unlock(struct wake_lock *lock) {}
+
+static inline int wake_lock_active(struct wake_lock *lock) { return 0; }
+static inline long has_wake_lock(int type) { return 0; }
+
+#endif
+
+#endif
+
-- 
1.8.3.2

