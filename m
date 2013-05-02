Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669Ab3EBOSJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:18:09 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:61896 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab3EBOSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:18:06 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anatolij Gustschin <agust@denx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Timur Tabi <timur@tabi.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 2/2] powerpc/512x: DMA via LocalPlus Bus testing driver
Date: Thu,  2 May 2013 19:23:15 +0400
Message-Id: <1367508195-2420-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This module tests Direct Memory Access to some device on LocalPlus Bus
for Freescale MPC512x. In other words it tests the bundle
of mpc512x_lpbfifo and mpc512x_dma drivers.

This testing driver was multiply used with static RAM (CY62167EV30LL-45ZXI)
which lives on LocalPlus Bus on our board. This testing driver was used
instead of the original static RAM driver and it is an abnormal hack.
That is why I just provide the driver code and don't modify any environment.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 drivers/misc/mpc512x_lpbdma_test.c | 310 +++++++++++++++++++++++++++++++++++++
 1 file changed, 310 insertions(+)
 create mode 100644 drivers/misc/mpc512x_lpbdma_test.c

diff --git a/drivers/misc/mpc512x_lpbdma_test.c b/drivers/misc/mpc512x_lpbdma_test.c
new file mode 100644
index 0000000..4fdd052
--- /dev/null
+++ b/drivers/misc/mpc512x_lpbdma_test.c
@@ -0,0 +1,310 @@
+/*
+ * Tests for DMA via LocalPlus Bus for the Freescale MPC512x.
+ *
+ * Copyright (C) Promcontroller, 2013.
+ * Author is Alexander Popov <a13xp0p0v88@gmail.com>.
+ *
+ * This module tests Direct Memory Access to the devices on LocalPlus Bus.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/io.h>
+#include <linux/workqueue.h>
+#include <linux/slab.h>
+#include <linux/random.h>
+#include <linux/string.h>
+#include <asm/mpc5121.h>
+
+MODULE_AUTHOR("Alexander Popov <a13xp0p0v88@gmail.com>");
+MODULE_LICENSE("GPL");
+
+#define DRV_NAME "mpc512x_lpbdma_test"
+#define ENOUGH 131072
+
+static int repeat = 1;
+
+enum test_iteration_result {
+	NEXT_TEST_PLEASE,
+	TRANSFER_LAUNCHED,
+	ALL_TESTS_DONE,
+};
+
+static struct lpbdma_test_data {
+	struct device *dev;
+	struct resource r_io;
+	void __iomem *bus_vaddr;
+	void *ram_vaddr;
+
+	/* Current data */
+	int current_repeat;
+	int current_test_case;
+	enum mpc512x_lpbfifo_req_dir current_dir;
+	struct mpc512x_lpbfifo_request current_req;
+} tt;
+
+static void lpbdma_prepare_next_iteration(void);
+static void lpbdma_testing(struct work_struct *w);
+static void lpbdma_test_callback(struct mpc512x_lpbfifo_request *req);
+static enum test_iteration_result lpbdma_test_iteration(unsigned int test_case,
+					enum mpc512x_lpbfifo_req_dir dir);
+
+static DECLARE_WORK(lpbdma_work, lpbdma_testing);
+static struct workqueue_struct *wq;
+
+static void lpbdma_prepare_next_iteration(void)
+{
+	tt.current_repeat++;
+
+	if (tt.current_repeat > repeat) {
+		tt.current_repeat = 1;
+		if (tt.current_dir == MPC512X_LPBFIFO_REQ_DIR_READ)
+			tt.current_dir = MPC512X_LPBFIFO_REQ_DIR_WRITE;
+		else {
+			tt.current_dir = MPC512X_LPBFIFO_REQ_DIR_READ;
+			tt.current_test_case += 1;
+		}
+	}
+}
+
+static void lpbdma_testing(struct work_struct *w)
+{
+	lpbdma_prepare_next_iteration();
+	while (lpbdma_test_iteration(tt.current_test_case,
+				tt.current_dir) == NEXT_TEST_PLEASE) {
+		lpbdma_prepare_next_iteration();
+	}
+}
+
+static enum test_iteration_result lpbdma_test_iteration(unsigned int test_case,
+					enum mpc512x_lpbfifo_req_dir dir)
+{
+	struct mpc512x_lpbfifo_request *req = &(tt.current_req);
+	int will_work;
+	unsigned int i;
+	unsigned int bufn;
+	u16 buf;
+
+	/* Prepare request for data transfer */
+	req->cs = 0;
+	req->bus_phys = tt.r_io.start;
+	req->ram_virt = tt.ram_vaddr;
+	req->dir = dir;
+	req->callback = lpbdma_test_callback;
+
+	switch (test_case) {
+	case 0:
+		/* normal LPB_DEV <-> RAM transfer */
+		will_work = 1;
+		req->size = 32768;	/* 32 kBytes, for example */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	case 1:
+		/* maximum size transfer */
+		will_work = 1;
+		req->size = 131068;	/* 128 kBytes - 4 Bytes */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	case 2:
+		/* maximum transfer size is exceeded */
+		will_work = 0;
+		req->size = 133120;	/* 130 kBytes, for example */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	case 3:
+		/* LPB_DEV has own FIFO register
+		 * It's width is 8 bytes, for example */
+		will_work = 1;
+		req->size = 16384;	/* 16 kBytes, for example */
+		req->portsize = LPB_DEV_PORTSIZE_8_BYTES;
+		break;
+	case 4:
+		/* Ditto. But size is not aligned on portsize */
+		will_work = 0;
+		req->size = 16382;
+		req->portsize = LPB_DEV_PORTSIZE_8_BYTES;
+		break;
+	case 5:
+		/* size is not aligned on 4 */
+		will_work = 0;
+		req->size = 42;		/* eh! */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	case 6:
+		/* ram address is not aligned on 4
+		 * but is aligned on 2 */
+		will_work = 1;
+		req->ram_virt += 2;
+		req->size = 65536;	/* 64 kBytes, for example */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	case 7:
+		/* ram address is not aligned even on 2 */
+		will_work = 1;
+		req->ram_virt += 3;
+		req->size = 8192;	/* 8 kBytes, for example */
+		req->portsize = LPB_DEV_PORTSIZE_UNDEFINED;
+		break;
+	default:
+		dev_info(tt.dev, "All tests are done\n");
+		return ALL_TESTS_DONE;
+	}
+
+	if (will_work) {
+		/* prepare source data */
+		if (dir == MPC512X_LPBFIFO_REQ_DIR_READ) {
+			if (req->portsize == LPB_DEV_PORTSIZE_UNDEFINED)
+				bufn = req->size / sizeof(buf);
+			else
+				bufn = req->portsize / sizeof(buf);
+
+			for (i = 0; i < bufn; i++) {
+				get_random_bytes(&buf, sizeof(buf));
+				out_be16(tt.bus_vaddr + i * sizeof(buf), buf);
+			}
+		} else
+			get_random_bytes(req->ram_virt, req->size);
+	}
+
+	if (mpc512x_lpbfifo_submit(req)) {
+		/* submit failed */
+		if (!will_work)
+			dev_info(tt.dev, "Test %u.%i passed\n", test_case, dir);
+		else
+			dev_err(tt.dev, "TEST %u.%i FAILED\n", test_case, dir);
+		return NEXT_TEST_PLEASE;
+	} else {
+		/* Request is submitted. Let's wait
+		 * for lpbdma_test_callback() to be called */
+		dev_info(tt.dev, "Test %u.%i is launched\n", test_case, dir);
+		return TRANSFER_LAUNCHED;
+	}
+}
+
+static void lpbdma_test_callback(struct mpc512x_lpbfifo_request *req)
+{
+	int test_passed = 1;
+	int i = 0;
+	u16 val1, val2;
+
+	if (req->portsize != LPB_DEV_PORTSIZE_UNDEFINED &&
+		req->dir == MPC512X_LPBFIFO_REQ_DIR_WRITE) {
+		/* During that transfer the next portion of data
+		 * overwrites the previous one.
+		 * Let's check the last portion of data */
+
+		for (i = 0; i < req->portsize / sizeof(val1); i++) {
+			val1 = in_be16(tt.bus_vaddr + i * sizeof(val1));
+			/* Since req->ram_virt
+			 * might not be aligned: */
+			memcpy(&val2, req->ram_virt + req->size -
+					req->portsize + i * sizeof(val2),
+								sizeof(val2));
+			if (val1 != val2) {
+				test_passed = 0;
+				dev_err(tt.dev, "ERROR: %i: %x != %x\n",
+							i, val2, val1);
+			}
+		}
+	} else {
+		for (i = 0; i < req->size / sizeof(val1); i++) {
+			if (req->portsize != LPB_DEV_PORTSIZE_UNDEFINED) {
+				val1 = in_be16(tt.bus_vaddr +
+					i * sizeof(val1) % req->portsize);
+			} else
+				val1 = in_be16(tt.bus_vaddr + i * sizeof(val1));
+
+			/* Ditto */
+			memcpy(&val2, req->ram_virt + i * sizeof(val2),
+							sizeof(val2));
+
+			if (val1 != val2) {
+				test_passed = 0;
+				dev_err(tt.dev, "ERROR: %i: %x != %x\n",
+							i, val2, val1);
+			}
+		}
+	}
+
+	if (test_passed)
+		dev_info(tt.dev, "...Passed\n");
+	else
+		dev_err(tt.dev, "...FAILED\n");
+
+	/* Next test please */
+	if (wq)
+		queue_work(wq, &lpbdma_work);
+}
+
+static int mpc512x_lpbdma_test_probe(struct platform_device *pdev)
+{
+	struct resource *rio_ptr = &tt.r_io;
+	tt.dev = &pdev->dev;
+
+	if (of_address_to_resource(pdev->dev.of_node, 0, rio_ptr)) {
+		dev_err(tt.dev, "can't find the resource\n");
+		return 1;
+	}
+	dev_info(tt.dev, "Resource on LPB: 0x%x, size %u bytes\n",
+				rio_ptr->start, resource_size(rio_ptr));
+
+	if (!request_mem_region(rio_ptr->start,
+					resource_size(rio_ptr), DRV_NAME)) {
+		dev_err(tt.dev, "can't request_mem_region\n");
+		return 1;
+	}
+
+	tt.bus_vaddr = ioremap(rio_ptr->start, resource_size(rio_ptr));
+	if (!tt.bus_vaddr) {
+		dev_err(tt.dev, "ioremap failed\n");
+		release_mem_region(rio_ptr->start, resource_size(rio_ptr));
+		return 1;
+	}
+
+	tt.ram_vaddr = kmalloc(ENOUGH, GFP_DMA | GFP_KERNEL);
+
+	dev_info(tt.dev, "Let's go!\n");
+
+	tt.current_repeat = 0;
+	tt.current_test_case = 0;
+	tt.current_dir = MPC512X_LPBFIFO_REQ_DIR_READ;
+
+	wq = create_singlethread_workqueue("mpc512x_lpbdma_test");
+	if (wq)
+		queue_work(wq, &lpbdma_work);
+
+	return 0;
+}
+
+static int mpc512x_lpbdma_test_remove(struct platform_device *pdev)
+{
+	if (wq)
+		destroy_workqueue(wq);
+
+	release_mem_region(tt.r_io.start, resource_size(&tt.r_io));
+	iounmap(tt.bus_vaddr);
+	kfree(tt.ram_vaddr);
+	return 0;
+}
+
+static const struct of_device_id lpbdma_test_match[] = {
+	{ .compatible = "tecon,mpc512x_lpbdma_test", },
+	{},
+};
+
+static struct platform_driver mpc512x_lpbdma_test_driver = {
+	.probe = mpc512x_lpbdma_test_probe,
+	.remove = mpc512x_lpbdma_test_remove,
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = lpbdma_test_match,
+	},
+};
+module_platform_driver(mpc512x_lpbdma_test_driver);
+
+module_param(repeat, int, 0);
-- 
1.7.11.3

