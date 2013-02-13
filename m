Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab3BMUFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 15:05:46 -0500
Received: from leased-line-91-149-128-89.telecom.by ([91.149.128.89]:44084
	"EHLO sp-git01-lo1.promwad.corp" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759545Ab3BMUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 15:05:05 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 15:05:04 EST
From: Michail Kurochkin <michail.kurachkin@promwad.com>
Date: Wed, 13 Feb 2013 19:10:44 +0300
Subject: [PATCH] Initial commit of SLIC si3226x driver
Message-Id: <20130213195709.22E9E34C6293@sp-git01-lo1.promwad.corp>
To: undisclosed-recipients:;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michail Kurochkin <michail.kurachkin@promwad.com>
---
 drivers/staging/si3226x/Kconfig                    |    9 +
 drivers/staging/si3226x/Makefile                   |    4 +
 drivers/staging/si3226x/si3226x_drv.c              | 1323 +++++++++++++++
 drivers/staging/si3226x/si3226x_drv.h              |  189 +++
 drivers/staging/si3226x/si3226x_hw.c               | 1691 ++++++++++++++++++++
 drivers/staging/si3226x/si3226x_hw.h               |  219 +++
 .../staging/si3226x/si3226x_patch_C_FB_2011MAY19.c |  176 ++
 drivers/staging/si3226x/si3226x_setup.c            | 1413 ++++++++++++++++
 drivers/staging/si3226x/slic_dtmf_table.c          |  127 ++
 include/linux/slic_si3226x.h                       |   75 +
 10 files changed, 5226 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/si3226x/Kconfig
 create mode 100644 drivers/staging/si3226x/Makefile
 create mode 100644 drivers/staging/si3226x/si3226x_drv.c
 create mode 100644 drivers/staging/si3226x/si3226x_drv.h
 create mode 100644 drivers/staging/si3226x/si3226x_hw.c
 create mode 100644 drivers/staging/si3226x/si3226x_hw.h
 create mode 100644 drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c
 create mode 100644 drivers/staging/si3226x/si3226x_setup.c
 create mode 100644 drivers/staging/si3226x/slic_dtmf_table.c
 create mode 100644 include/linux/slic_si3226x.h

diff --git a/drivers/staging/si3226x/Kconfig b/drivers/staging/si3226x/Kconfig
new file mode 100644
index 0000000..a378dd1
--- /dev/null
+++ b/drivers/staging/si3226x/Kconfig
@@ -0,0 +1,9 @@
+config SI3226X
+	tristate "Silicon Labs SLIC driver si3226x"
+	depends on TDM && SPI
+	default n
+	help
+	  This driver supports SLIC chip si3226x.
+	  si3226x provide two FXS ports. For transport
+	  audiodata used tdm framework, for control used
+	  spi framework.
diff --git a/drivers/staging/si3226x/Makefile b/drivers/staging/si3226x/Makefile
new file mode 100644
index 0000000..279d813
--- /dev/null
+++ b/drivers/staging/si3226x/Makefile
@@ -0,0 +1,4 @@
+
+si3226x-y := si3226x_drv.o si3226x_hw.o
+
+obj-$(CONFIG_SI3226X) += si3226x.o
diff --git a/drivers/staging/si3226x/si3226x_drv.c b/drivers/staging/si3226x/si3226x_drv.c
new file mode 100644
index 0000000..2e515de
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_drv.c
@@ -0,0 +1,1323 @@
+/**********************************************************************
+ * Author: Michail Kurachkin
+ *
+ * Contact: michail.kurachkin@promwad.com
+ *
+ * Copyright (c) 2013 Promwad Inc.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This file is distributed in the hope that it will be useful, but
+ * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ * NONINFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this file; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ * or visit http://www.gnu.org/licenses/.
+**********************************************************************/
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/ioctl.h>
+#include <linux/poll.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/slic_si3226x.h>
+#include <linux/tdm/tdm.h>
+#include <linux/spi/spi.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include "si3226x_drv.h"
+#include "si3226x_hw.h"
+
+
+/**
+ * spi_dev_list necessary for
+ * accumulate corresponding devices while
+ * this registering. SLIC driver requirement one spi_device,
+ * two tdm_device, and platform_device
+ */
+static LIST_HEAD(slic_dev_list);
+static DEFINE_MUTEX(dev_list_lock);
+
+
+/*
+ * list all existing character devices
+ */
+static LIST_HEAD(slic_chr_dev_list);
+static DEFINE_MUTEX(slic_chr_dev_lock);
+
+/*
+ * class for character devices
+ */
+static struct class *slic_class;
+
+
+/**
+ * slic controls over ioctl
+ * @param slic - slic descriptor
+ * @param cmd - ioctl command
+ * @param arg - ioctl argument
+ * @return 0 - ok
+ */
+static int slic_control(struct si3226x_slic *slic, unsigned int cmd, unsigned long arg)
+{
+	int rc;
+	struct si3226x_line *line = slic->lines;
+	int i;
+
+	switch(cmd) {
+	case SI3226X_SET_COMPANDING_MODE:
+		if (arg != SI_ALAW && arg != SI_MLAW)
+			return -EINVAL;
+
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+			if (line->state == SI_LINE_DISABLE)
+				continue;
+
+			line->companding_mode = arg;
+
+			rc = slic_setup_audio(line);
+			if (rc)
+			{
+				dev_err(&slic->pdev->dev, "Can`t setup slic audio settings\n");
+				return rc;
+			}
+		}
+		break;
+
+	case SI3226X_SET_CALLERID_MODE:
+		if(	arg != SI_FSK_BELLCORE && arg != SI_FSK_ETSI
+		    && arg != SI_CALLERID_DTMF)
+			return -EINVAL;
+
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+			if (line->state == SI_LINE_DISABLE)
+				continue;
+
+			line->callerid_mode = arg;
+		}
+		break;
+	}
+
+	return 0;
+}
+
+/**
+ * slic line controls over ioctl
+ * @param line - line descriptor
+ * @param cmd - command
+ * @param arg - argument
+ * @return 0 - ok
+ */
+static int line_control(struct si3226x_line *line, unsigned int cmd, unsigned long arg)
+{
+	int rc = 0;
+	u8 data;
+	struct si3226x_caller_id caller_id;
+	u8 callerid_buffer[CALLERID_BUF_SIZE];
+
+	switch(cmd) {
+	case SI3226X_SET_CALLERID_MODE:
+		if( arg != SI_FSK_BELLCORE && arg != SI_FSK_ETSI
+		    && arg != SI_CALLERID_DTMF && arg != SI_CALLERID_NONE)
+			return -EINVAL;
+
+		line->callerid_mode = arg;
+		break;
+
+	case SI3226X_SET_ECHO_CANCELATION:
+		if(arg)
+			rc = slic_enable_echo(line);
+		else
+			rc = slic_disable_echo(line);
+		break;
+
+	case SI3226X_SET_LINE_STATE:
+		rc = slic_set_line_state(line, arg);
+		break;
+
+	case SI3226X_CALL:
+		rc = copy_from_user(&caller_id, (__u8 __user *)arg, sizeof caller_id);
+		if (rc)
+			rc = -EFAULT;
+
+		if(caller_id.size > CALLERID_BUF_SIZE)
+			caller_id.size = CALLERID_BUF_SIZE;
+
+		rc = copy_from_user(callerid_buffer, (__u8 __user *)caller_id.data, caller_id.size);
+		if (rc)
+			rc = -EFAULT;
+
+		rc = slic_line_call(line, callerid_buffer, caller_id.size);
+		break;
+
+	case SI3226X_SEND_DTMF:
+		rc = slic_send_dtmf_digit(line, arg);
+		break;
+
+	case SI3226X_GET_HOOK_STATE:
+		rc = __put_user(line->hook_state, (__u8 __user *)arg);
+		if (rc)
+			rc = -EFAULT;
+		break;
+
+	case SI3226X_GET_DTMF_DIGIT:
+		rc = slic_get_dtmf_data(line, &data);
+		if (rc)
+			return -ENODATA;
+
+		rc = __put_user(data, (__u8 __user *)arg);
+		if (rc)
+			rc = -EFAULT;
+		break;
+
+	case SI3226X_GET_AUDIO_BLOCK_SIZE:
+		rc = __put_user(line->audio_buffer_size, (__u8 __user *)arg);
+		if (rc)
+			rc = -EFAULT;
+		break;
+
+	case SI3226X_SET_COMPANDING_MODE:
+		if(	arg != SI_ALAW && arg != SI_MLAW)
+			return -EINVAL;
+
+		rc = slic_set_companding_mode(line, arg);
+		if (rc)
+		{
+			dev_err(&line->tdm_dev->dev, "Can`t change companding mode\n");
+			return rc;
+		}
+
+		break;
+
+	case SI3226X_ENABLE_AUDIO:
+		if (line->tdm_dev == NULL)
+			return -ENODEV;
+
+		rc = tdm_run_audio(line->tdm_dev);
+		break;
+
+	case SI3226X_DISABLE_AUDIO:
+		if (line->tdm_dev == NULL)
+			return -ENODEV;
+
+		rc = tdm_stop_audio(line->tdm_dev);
+		break;
+	}
+
+	return rc;
+}
+
+static int slic_chr_open(struct inode *inode, struct file *file)
+{
+	struct slic_chr_dev *chr_dev;
+	struct si3226x_slic *slic;
+	struct si3226x_line *line;
+	struct tdm_device *tdm_dev;
+	struct tdm_voice_channel *ch;
+	int status = -ENXIO;
+
+	mutex_lock(&slic_chr_dev_lock);
+
+	list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+		smp_read_barrier_depends();
+
+		switch (chr_dev->type) {
+		case SLIC_CHR_DEV:
+			slic = dev_get_drvdata(chr_dev->dev);
+
+			if (slic->devt != inode->i_rdev)
+				continue;
+
+			if (slic->file_opened) {
+				status = -EBUSY;
+				goto out;
+			}
+
+			slic->file_opened = 1;
+			status = 0;
+			break;
+
+		case LINE_CHR_DEV:
+			line = dev_get_drvdata(chr_dev->dev);
+			tdm_dev = line->tdm_dev;
+
+			if (line->devt != inode->i_rdev)
+				continue;
+
+			if (line->file_opened) {
+				status = -EBUSY;
+				goto out;
+			}
+
+			line->audio_buffer_size = tdm_get_voice_block_size(tdm_dev);
+
+			line->rx_buffer = kzalloc(line->audio_buffer_size, GFP_KERNEL);
+			if (!line->rx_buffer) {
+				status = -ENOMEM;
+				goto out;
+			}
+
+			line->tx_buffer = kzalloc(line->audio_buffer_size, GFP_KERNEL);
+			if (!line->tx_buffer) {
+				kfree(line->rx_buffer);
+				status = -ENOMEM;
+				goto out;
+			}
+
+			/* store pointer to transmit wait_queue_head_t for use in poll() */
+			ch = tdm_dev->ch;
+			line->tx_wait_queue = &ch->tx_queue;
+			line->rx_wait_queue = &ch->rx_queue;
+
+			line->file_opened = 1;
+			status = 0;
+			break;
+		}
+
+		file->private_data = chr_dev;
+		status = 0;
+	}
+
+out:
+	smp_mb();
+	mutex_unlock(&slic_chr_dev_lock);
+	return status;
+}
+
+
+/*
+ * method "release" for character device
+ */
+static int slic_chr_release(struct inode *inode, struct file *file)
+{
+	struct slic_chr_dev *chr_dev = file->private_data;
+	struct si3226x_slic *slic;
+	struct si3226x_line *line;
+	struct tdm_device *tdm_dev;
+	int status = -ENXIO;
+
+	mutex_lock(&slic_chr_dev_lock);
+
+	switch (chr_dev->type) {
+	case SLIC_CHR_DEV:
+		slic = dev_get_drvdata(chr_dev->dev);
+
+		if(!slic->file_opened) {
+			status = -ENODEV;
+			goto out;
+		}
+
+		slic->file_opened = 0;
+		status = 0;
+		break;
+
+	case LINE_CHR_DEV:
+		line = dev_get_drvdata(chr_dev->dev);
+		tdm_dev = line->tdm_dev;
+
+		if(!line->file_opened) {
+			status = -ENODEV;
+			goto out;
+		}
+
+		kfree(line->rx_buffer);
+		kfree(line->tx_buffer);
+		line->file_opened = 0;
+		status = 0;
+	}
+
+	file->private_data = NULL;
+
+out:
+	mutex_unlock(&slic_chr_dev_lock);
+
+	return status;
+}
+
+/*
+ * method "ioctl" for character device
+ */
+static long
+slic_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct slic_chr_dev *chr_dev = file->private_data;
+	struct si3226x_slic *slic;
+	struct si3226x_line *line;
+	int status = -ENXIO;
+
+	if (_IOC_TYPE(cmd) != SI3226X_IOC_MAGIC)
+		return -ENOTTY;
+
+	mutex_lock(&slic_chr_dev_lock);
+
+	if (!file->private_data) {
+		status = -ENODEV;
+		goto out;
+	}
+
+	switch(chr_dev->type) {
+	case SLIC_CHR_DEV:
+		slic = dev_get_drvdata(chr_dev->dev);
+		if (!slic->file_opened) {
+			status = -ENODEV;
+			goto out;
+		}
+
+		status = slic_control(slic, cmd, arg);
+		break;
+
+	case LINE_CHR_DEV:
+		line = dev_get_drvdata(chr_dev->dev);
+		if (!line->file_opened) {
+			status = -ENODEV;
+			goto out;
+		}
+
+		status = line_control(line, cmd, arg);
+		break;
+	}
+
+out:
+	mutex_unlock(&slic_chr_dev_lock);
+	return status;
+}
+
+
+/*
+ * method "read" for character device
+ */
+static ssize_t
+slic_chr_read(struct file *file, char *buff, size_t count, loff_t *offp)
+{
+	struct slic_chr_dev *chr_dev = file->private_data;
+	struct si3226x_line *line;
+	struct tdm_device *tdm_dev;
+	int rc;
+
+	if (!file->private_data)
+		return -EPERM;
+
+	if(chr_dev->type != LINE_CHR_DEV)
+		return -EPERM;
+
+	mutex_lock(&slic_chr_dev_lock);
+
+	line = dev_get_drvdata(chr_dev->dev);
+	tdm_dev = line->tdm_dev;
+
+	if (count != line->audio_buffer_size) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = tdm_recv(tdm_dev, line->rx_buffer);
+	if (rc) {
+		rc = -EIO;
+		goto out;
+	}
+
+	rc = copy_to_user(buff, line->rx_buffer, count);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = count;
+out:
+	mutex_unlock(&slic_chr_dev_lock);
+	return rc;
+}
+
+
+/*
+ * method "write" for character device
+ */
+static ssize_t
+slic_chr_write(struct file *file, const char *buf, size_t count, loff_t *offp)
+{
+	struct slic_chr_dev *chr_dev = file->private_data;
+	struct si3226x_line *line;
+	struct tdm_device *tdm_dev;
+	int rc;
+
+	if (!file->private_data)
+		return -EPERM;
+
+	if (chr_dev->type != LINE_CHR_DEV)
+		return -EPERM;
+
+	mutex_lock(&slic_chr_dev_lock);
+
+	line = dev_get_drvdata(chr_dev->dev);
+	tdm_dev = line->tdm_dev;
+
+	if (count != line->audio_buffer_size) {
+		rc = -EINVAL;
+		goto out;
+	}
+
+	rc = copy_from_user(line->tx_buffer, buf, count);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = tdm_send(tdm_dev, line->tx_buffer);
+	if (rc) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	rc = line->audio_buffer_size;
+out:
+	mutex_unlock(&slic_chr_dev_lock);
+	return rc;
+}
+
+
+/*
+ * method "poll" for character device
+ */
+static unsigned int slic_chr_poll(struct file *file, poll_table *wait)
+{
+	struct slic_chr_dev *chr_dev = file->private_data;
+	struct si3226x_line *line;
+	int mask = 0;
+
+	if (!file->private_data)
+		return -EPERM;
+
+	if (chr_dev->type != LINE_CHR_DEV)
+		return -EPERM;
+
+	line = dev_get_drvdata(chr_dev->dev);
+
+	poll_wait(file, line->rx_wait_queue,  wait);
+	poll_wait(file, line->tx_wait_queue,  wait);
+
+	if (tdm_poll_rx(line->tdm_dev))
+		mask |= POLLIN;
+
+	if (tdm_poll_tx(line->tdm_dev))
+		mask |= POLLOUT;
+
+	return mask;
+}
+
+
+/*
+ * file operations for slic character devices
+ */
+static struct file_operations slic_cnt_ops = {
+	.unlocked_ioctl = slic_chr_ioctl,
+	.open = slic_chr_open,
+	.read = slic_chr_read,
+	.write = slic_chr_write,
+	.poll = slic_chr_poll,
+	.release = slic_chr_release,
+	.llseek = no_llseek,
+	.owner = THIS_MODULE,
+};
+
+
+/**
+ * add to list slic character device.
+ * @param dev - character device
+ * @param type - type of character device
+ * @return 0 - ok
+ */
+static int add_slic_chr_dev(struct device *dev, enum chr_dev_type type)
+{
+	struct slic_chr_dev *chr_dev;
+
+	chr_dev = kzalloc(sizeof(*chr_dev), GFP_KERNEL);
+	if (!chr_dev)
+		return -ENOMEM;
+
+	mutex_lock(&slic_chr_dev_lock);
+	chr_dev->dev = dev;
+	chr_dev->type = type;
+	smp_wmb();
+	list_add(&chr_dev->list, &slic_chr_dev_list);
+	mutex_unlock(&slic_chr_dev_lock);
+
+	return 0;
+}
+
+
+/**
+ * delete slic character device form list
+ * @param dev - character device
+ * @return 0 - ok
+ */
+static int del_slic_chr_dev(struct device *dev)
+{
+	struct slic_chr_dev *chr_dev;
+
+	list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+		if (chr_dev->dev == dev) {
+			list_del(&chr_dev->list);
+			kfree(chr_dev);
+			return 0;
+		}
+	}
+
+	return -ENODEV;
+}
+
+
+/**
+ * Init slic driver
+ * @return 0 - ok
+ */
+static int init_slic_drv(struct si3226x_slic *slic)
+{
+	struct platform_device *pdev = slic->pdev;
+	struct si3226x_platform_data *plat = 	pdev->dev.platform_data;
+	struct si3226x_line *line = slic->lines;
+	struct device *chr_dev;
+	int rc;
+	int i;
+
+	dev_dbg(&pdev->dev, "run initialization slic driver\n");
+
+	/* set default companding_mode for all lines */
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++)
+		line->companding_mode = plat->companding_mode;
+
+	/* request reset GPIO */
+	rc = gpio_request(slic->reset_gpio, DRIVER_NAME "_reset");
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to request slic reset GPIO pin\n");
+		goto out0;
+	}
+	gpio_direction_output(slic->reset_gpio, 1);
+
+	/* request interrupt GPIO */
+	rc = gpio_request(slic->int_gpio, DRIVER_NAME "_irq");
+	if (rc < 0) {
+		dev_err(&pdev->dev, "failed to request slic irq GPIO pin\n");
+		goto out1;
+	}
+	gpio_direction_input(slic->int_gpio);
+
+	slic->irq = gpio_to_irq(slic->int_gpio);
+
+	INIT_WORK(&slic->irq_work, slic_irq_callback);
+
+#ifdef CONFIG_SI3226X_POLLING
+	INIT_DELAYED_WORK(&slic->delayed_work, slic_delayed_work);
+#endif
+
+
+	line = slic->lines;
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		if (plat->fxs_tdm_ch[i] < 0) {
+			line->state = SI_LINE_DISABLE;
+			continue;
+		}
+
+		line->state = SI_LINE_SILENCE;
+
+		/* added class device and create /dev/si3226x_fxsX.X */
+		line->devt = MKDEV(SI3226X_MAJOR, pdev->id + 1 + i);
+		chr_dev = device_create(slic_class, &pdev->dev, line->devt,
+		                        line, DRIVER_NAME "_fxs%d.%d", i, pdev->id);
+
+		if (IS_ERR(chr_dev)) {
+			dev_err(&pdev->dev, "can not added class device\n");
+			goto out4;
+		}
+
+		/*  added created character device into device list
+		    for use in file operations
+		*/
+		rc = add_slic_chr_dev(chr_dev, LINE_CHR_DEV);
+		if (rc) {
+			dev_err(&pdev->dev, "can't added character device\n");
+			goto out4;
+		}
+	}
+
+	rc = init_slic(slic);
+	if (rc) {
+		dev_err(&pdev->dev, "slic initialization fail\n");
+		goto out4;
+	}
+
+#ifdef CONFIG_SI3226X_POLLING
+	dev_info(&pdev->dev, "schedule delayed work\n");
+	schedule_delayed_work(&slic->delayed_work, msecs_to_jiffies(50));
+#else
+	dev_dbg(&pdev->dev, "request irq\n");
+
+	/* set interrupt callback slic_irq */
+	rc = request_irq(slic->irq, slic_irq,
+	                 IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+	                 dev_name(&slic->pdev->dev), slic);
+
+	if (rc) {
+		dev_err(&pdev->dev, "can not request IRQ\n");
+		rc = -EINVAL;
+		goto out5;
+	}
+#endif
+
+	/* register slic character device */
+	rc = register_chrdev(SI3226X_MAJOR, DRIVER_NAME, &slic_cnt_ops);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "can not register character device\n");
+		goto out2;
+	}
+
+	/* added class device and create /dev/si3226x_cnt.X */
+	slic->devt = MKDEV(SI3226X_MAJOR, pdev->id);
+	chr_dev = device_create(slic_class, &pdev->dev, slic->devt,
+	                        slic, DRIVER_NAME "_cnt.%d", pdev->id);
+
+	if (IS_ERR(chr_dev)) {
+		dev_err(&pdev->dev, "can not added class device\n");
+		goto out3;
+	}
+
+	/*  added character device into device list
+	    for use in file operations */
+	rc = add_slic_chr_dev(chr_dev, SLIC_CHR_DEV);
+	if (rc) {
+		dev_err(&pdev->dev, "can not added character device\n");
+		goto out4;
+	}
+
+	dev_dbg(&pdev->dev, "success initialization slic driver\n");
+	return 0;
+
+out5:
+	free_irq(slic->irq, slic);
+	deinit_slic(slic);
+
+out4:
+	{
+		/* remove all character devices */
+		struct slic_chr_dev *chr_dev, *chr_dev_tmp;
+		list_for_each_entry_safe(chr_dev, chr_dev_tmp,
+		                         &slic_chr_dev_list, list) {
+			device_del(chr_dev->dev);
+			del_slic_chr_dev(chr_dev->dev);
+		}
+	}
+
+out3:
+	unregister_chrdev(SI3226X_MAJOR, DRIVER_NAME);
+
+out2:
+	gpio_free(slic->int_gpio);
+
+out1:
+	gpio_free(slic->reset_gpio);
+
+out0:
+	return rc;
+}
+
+
+
+/**
+ * DeInit slic driver
+ */
+void release_slic_drv(struct si3226x_slic *slic)
+{
+	struct platform_device *pdev = slic->pdev;
+	struct slic_chr_dev *chr_dev, *chr_dev_tmp;
+	int i;
+
+	dev_dbg(&pdev->dev, "release slic\n");
+
+	free_irq(slic->irq, slic);
+
+	/* delete slic character device */
+	list_for_each_entry_safe(chr_dev, chr_dev_tmp, &slic_chr_dev_list, list) {
+		struct si3226x_line *line;
+		struct si3226x_slic *s;
+		struct si3226x_line *l;
+
+		switch (chr_dev->type) {
+		case SLIC_CHR_DEV:
+			s = dev_get_drvdata(chr_dev->dev);
+			if (s == slic) {
+				device_del(chr_dev->dev);
+				list_del(&chr_dev->list);
+				kfree(chr_dev);
+			}
+			break;
+
+		case LINE_CHR_DEV:
+			l = dev_get_drvdata(chr_dev->dev);
+			for (i = 0, line = slic->lines;
+					i < SI3226X_MAX_CHANNELS; i++, line++)
+				if (l == line) {
+					device_del(chr_dev->dev);
+					list_del(&chr_dev->list);
+					kfree(chr_dev);
+				}
+			break;
+		}
+	}
+
+	unregister_chrdev(SI3226X_MAJOR, DRIVER_NAME);
+	gpio_free(slic->int_gpio);
+	gpio_free(slic->reset_gpio);
+
+	deinit_slic(slic);
+}
+
+
+
+/**
+ * Add device to slic devices list
+ * @param dev - device (spi, tdm or platform)
+ * @return 0 - ok
+ */
+static int add_to_slic_devices_list(struct device *dev, enum slic_dev_type type)
+{
+	struct slic_dev_list *slic_dev_item;
+
+	slic_dev_item = kzalloc(sizeof(*slic_dev_item), GFP_KERNEL);
+	if (!slic_dev_item)
+		return -ENOMEM;
+
+	mutex_lock(&dev_list_lock);
+	slic_dev_item->dev = dev;
+	slic_dev_item->type = type;
+	list_add_tail(&slic_dev_item->list, &slic_dev_list);
+	mutex_unlock(&dev_list_lock);
+
+	return 0;
+}
+
+
+/**
+ * remove device from slic devices list
+ * @param dev - device (spi, tdm or platform)
+ * @return 0 - ok
+ */
+static int remove_from_slic_devices_list(struct device *dev)
+{
+	struct slic_dev_list *slic_dev_item, *slic_dev_item_tmp;
+
+	list_for_each_entry_safe(slic_dev_item, slic_dev_item_tmp, &slic_dev_list, list)
+		if(slic_dev_item->dev == dev) {
+			list_del(&slic_dev_item->list);
+			kzfree(slic_dev_item);
+			return 0;
+		}
+
+	return -ENODEV;
+}
+
+
+/**
+ * allocate memory and configure slic descriptor.
+ * @param pdev - platform device
+ * @return allocated slic controller descriptor
+ */
+struct si3226x_slic *alloc_slic(struct platform_device *pdev) {
+	int i;
+	struct si3226x_slic 	*slic;
+	struct si3226x_line *line;
+
+	slic = kzalloc(sizeof *slic, GFP_KERNEL);
+	if (!slic)
+		return NULL;
+
+	platform_set_drvdata(pdev, slic);
+
+	slic->pdev = pdev;
+
+	line = slic->lines;
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++)
+		line->ch = i;
+
+	return slic;
+}
+
+
+/**
+ * free memory allocated alloc_slic()
+ * @param slic - slic controller descriptor
+ * @return 0 - ok
+ */
+int free_slic(struct si3226x_slic *slic)
+{
+	if (!slic)
+		return -EINVAL;
+
+	kfree(slic);
+	return 0;
+}
+
+/**
+ * match all devices necessery for slic
+ * @param slic - pointer to pointer on slic private data
+ * @return 0 - ok, 1 - incomplete device list, 0< - any errors
+ */
+int slic_match_bus_devices(struct si3226x_slic **slic)
+{
+	struct slic_dev_list *plat_list_item;
+	struct slic_dev_list *spi_list_item;
+	struct slic_dev_list *tdm_list_item;
+	int i;
+
+
+	list_for_each_entry(plat_list_item, &slic_dev_list, list) {
+		struct platform_device *pdev =
+				to_platform_device(plat_list_item->dev);
+		struct si3226x_platform_data *plat = pdev->dev.platform_data;
+		struct tdm_device *found_tdm_devices[SI3226X_MAX_CHANNELS];
+		struct spi_device *found_spi_dev = NULL;
+		struct si3226x_line *slic_line;
+		int count_found_tdm;
+		int count_fxs = 0;
+
+		if (plat_list_item->type != PLAT_DEVICE)
+			continue;
+
+		/* increment count enabled fxs ports */
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++)
+			if(plat->fxs_tdm_ch[i] >= 0)
+				count_fxs++;
+
+		if (!count_fxs) {
+			dev_err(&pdev->dev, "Init slic fail. Disabled all FXS ports\n");
+			return -EINVAL;
+		}
+
+		dev_dbg(&pdev->dev, "count_fxs = %d\n", count_fxs);
+
+		/* foreach all spi devices and match with current slic */
+		list_for_each_entry(spi_list_item, &slic_dev_list, list) {
+			struct spi_device *spi_dev = to_spi_device(spi_list_item->dev);
+
+			if (spi_list_item->type != SPI_DEVICE)
+				continue;
+
+			if(plat->spi_chip_select != spi_dev->chip_select)
+				continue;
+
+			found_spi_dev = to_spi_device(spi_list_item->dev);
+		}
+
+		if (found_spi_dev == NULL) {
+			dev_dbg(&pdev->dev, "not found_spi_dev\n");
+			return 1;
+		}
+
+		dev_dbg(&pdev->dev, "found_spi_dev = %s\n",
+		        dev_name(&found_spi_dev->dev));
+
+		/* foreach all registered tdm devices for current slic */
+		/* and match tdm channel with fxs port tdm channel */
+		memset(found_tdm_devices, 0, sizeof *found_tdm_devices);
+		count_found_tdm = 0;
+		for (i = 0; i < SI3226X_MAX_CHANNELS; i++) {
+			if(plat->fxs_tdm_ch[i] < 0)
+				continue;
+
+			list_for_each_entry(tdm_list_item, &slic_dev_list, list) {
+				struct tdm_device *tdm_dev = to_tdm_device(tdm_list_item->dev);
+
+				if (tdm_list_item->type != TDM_DEVICE)
+					continue;
+
+				/* Match device tdm channel with corresponding fxs port */
+				if (plat->fxs_tdm_ch[i] == tdm_dev->tdm_channel_num) {
+					found_tdm_devices[i] = to_tdm_device(tdm_list_item->dev);
+					count_found_tdm++;
+				}
+			}
+		}
+
+		/* if found needed tdm devices for current slic */
+		if (count_fxs != count_found_tdm) {
+			dev_dbg(&pdev->dev, "tdm devices not found\n");
+			return 1;
+		}
+
+		*slic = alloc_slic(pdev);
+		if (!*slic) {
+			dev_err(&pdev->dev, "can't alloc slic\n");
+			return -ENOMEM;
+		}
+
+		(*slic)->spi_dev = found_spi_dev;
+		(*slic)->reset_gpio = plat->reset_gpio;
+		(*slic)->int_gpio = plat->int_gpio;
+
+
+		for (i = 0, slic_line = (*slic)->lines;
+		     i < SI3226X_MAX_CHANNELS; i++, slic_line++) {
+			slic_line->tdm_dev = found_tdm_devices[i];
+
+			/* Remove devices from list slic devices */
+			remove_from_slic_devices_list(&found_tdm_devices[i]->dev);
+		}
+
+		/* Remove devices from list slic devices */
+		remove_from_slic_devices_list(&found_spi_dev->dev);
+		remove_from_slic_devices_list(plat_list_item->dev);
+
+		return 0;
+	}
+
+	return 1;
+}
+
+
+
+/*
+ * probe spi driver
+ */
+static int probe_spi_slic(struct spi_device *spi_dev)
+{
+	struct si3226x_slic *slic;
+	int rc;
+
+	rc = add_to_slic_devices_list(&spi_dev->dev, SPI_DEVICE);
+	if (rc < 0) {
+		dev_err(&spi_dev->dev, "can't added spi device to slic list devices: %d\n", rc);
+		goto out;
+	}
+
+	rc = slic_match_bus_devices(&slic);
+	if (rc < 0) {
+		dev_err(&spi_dev->dev, "Error: %d\n", rc);
+		goto out;
+	}
+
+	if (rc) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = init_slic_drv(slic);
+	if (rc)
+		free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+/*
+ * probe tdm driver
+ */
+static int probe_tdm_slic(struct tdm_device *tdm_dev)
+{
+	struct si3226x_slic *slic;
+	int rc;
+
+	mutex_lock(&dev_list_lock);
+
+	rc = add_to_slic_devices_list(&tdm_dev->dev, TDM_DEVICE);
+	if (rc < 0) {
+		dev_err(&tdm_dev->dev, "can't added tdm device to slic list devices: %d\n", rc);
+		goto out;
+	}
+
+	rc = slic_match_bus_devices(&slic);
+	if (rc < 0) {
+		dev_err(&tdm_dev->dev, "Error: %d\n", rc);
+		goto out;
+	}
+
+	if (rc) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = init_slic_drv(slic);
+	if (rc)
+		free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+/*
+ * probe slic platform driver
+ */
+static int probe_slic(struct platform_device *pdev)
+{
+	struct si3226x_slic *slic;
+	int rc;
+
+	mutex_lock(&dev_list_lock);
+
+	rc = add_to_slic_devices_list(&pdev->dev, PLAT_DEVICE);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "can't added platform device to slic list devices: %d\n", rc);
+		goto out;
+	}
+
+	rc = slic_match_bus_devices(&slic);
+	if (rc < 0) {
+		dev_err(&pdev->dev, "Error: %d\n", rc);
+		goto out;
+	}
+
+	if (rc) {
+		rc = 0;
+		goto out;
+	}
+
+	rc = init_slic_drv(slic);
+	if (rc)
+		free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+
+/*
+ * called when remove spi device
+ */
+static int __exit remove_spi_slic(struct spi_device *spi_dev)
+{
+	struct si3226x_slic *slic = NULL;
+	struct slic_chr_dev *chr_dev;
+	int rc = 0;
+
+	mutex_lock(&dev_list_lock);
+
+	/* find slic device supported current spi device */
+	list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+		struct si3226x_slic *p;
+		p = dev_get_drvdata(chr_dev->dev);
+
+		if (p->spi_dev == spi_dev) {
+			slic = p;
+			break;
+		}
+	}
+
+	/* If line device not found in character devices list */
+	if (!slic) {
+		remove_from_slic_devices_list(&spi_dev->dev);
+		goto out;
+	}
+
+	release_slic_drv(slic);
+	rc = free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+/*
+ * remove tdm driver
+ */
+static int __exit remove_tdm_slic(struct tdm_device *tdm_dev)
+{
+	struct si3226x_slic *slic = NULL;
+	struct si3226x_line *line = NULL;
+	struct slic_chr_dev *chr_dev;
+	int rc = 0;
+
+	mutex_lock(&dev_list_lock);
+
+	/* find slic device supported current tdm device */
+	list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+		struct si3226x_line *p;
+		p = dev_get_drvdata(chr_dev->dev);
+
+		if (p->tdm_dev == tdm_dev) {
+			line = p;
+			break;
+		}
+	}
+
+	/* If line device not found in character devices list */
+	if (!line) {
+		remove_from_slic_devices_list(&tdm_dev->dev);
+		goto out;
+	}
+
+	slic = to_si3226x_slic(line);
+
+	release_slic_drv(slic);
+	rc = free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+/*
+ * remove slic platform driver
+ */
+static int __exit remove_slic(struct platform_device *pdev)
+{
+	struct si3226x_slic *slic = NULL;
+	struct slic_chr_dev *chr_dev;
+	int rc = 0;
+
+	mutex_lock(&dev_list_lock);
+
+	/* find slic device supported current tdm device */
+	list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+		struct si3226x_slic *p;
+		p = dev_get_drvdata(&pdev->dev);
+
+		if (p->pdev == pdev) {
+			slic = p;
+			break;
+		}
+	}
+
+	/* If line device not found in character devices list */
+	if (!slic) {
+		remove_from_slic_devices_list(&pdev->dev);
+		goto out;
+	}
+
+	release_slic_drv(slic);
+	rc = free_slic(slic);
+
+out:
+	mutex_unlock(&dev_list_lock);
+	return rc;
+}
+
+
+/*
+ * spi interface
+ */
+static struct spi_driver spi_slic_driver = {
+	.driver =
+	{
+		.name = "si3226x",
+		.bus    = &spi_bus_type,
+		.owner    = THIS_MODULE,
+	},
+	.probe    = probe_spi_slic,
+	.remove    = __exit_p(remove_spi_slic),
+};
+
+
+/*
+ * tdm Interface
+ */
+static struct tdm_driver tdm_slic_driver = {
+	.driver =
+	{
+		.name = "si3226x",
+		.bus    = &tdm_bus_type,
+		.owner    = THIS_MODULE,
+	},
+	.probe    = probe_tdm_slic,
+	.remove    = __exit_p(remove_tdm_slic),
+};
+
+
+/*
+ * slic platform interface
+ */
+static struct platform_driver slic_driver = {
+	.driver =
+	{
+		.name = "si3226x",
+		.bus    = &platform_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe	= probe_slic,
+	.remove	= __exit_p(remove_slic),
+};
+
+
+/*
+ * init kernel module
+ */
+static int __init si3226x_mod_init(void)
+{
+	int rc = 0;
+
+	slic_class = class_create(THIS_MODULE, "slic");
+	if (IS_ERR(slic_class)) {
+		pr_debug("failed to register new class slic\n");
+		goto out0;
+	}
+
+	rc = spi_register_driver(&spi_slic_driver);
+	if (rc) {
+		pr_debug("failed to register SPI for SLIC, error: %d\n", rc);
+		goto out1;
+	}
+
+
+	rc = tdm_register_driver(&tdm_slic_driver);
+	if (rc) {
+		pr_debug("failed to register TDM for SLIC, error: %d\n", rc);
+		goto out2;
+	}
+
+
+	rc = platform_driver_register(&slic_driver);
+	if (rc) {
+		pr_debug("failed to register SLIC on platform, error: %d\n", rc);
+		goto out3;
+	}
+
+	return rc;
+
+out3:
+	tdm_unregister_driver(&tdm_slic_driver);
+
+out2:
+	spi_unregister_driver(&spi_slic_driver);
+out1:
+	class_destroy(slic_class);
+out0:
+	return rc;
+}
+
+
+/*
+ * deinit kernel module
+ */
+static void __exit si3226x_mod_exit(void)
+{
+	tdm_unregister_driver(&tdm_slic_driver);
+	spi_unregister_driver(&spi_slic_driver);
+	platform_driver_unregister(&slic_driver);
+	class_destroy(slic_class);
+}
+
+module_init(si3226x_mod_init);
+module_exit(si3226x_mod_exit);
+#define MODULE_NAME DRIVER_NAME
+//MODULE_NAME("si3226x");
+MODULE_AUTHOR("Michail Kurochkin <michail.kurachkin@promwad.com>");
+MODULE_LICENSE("GPL");
+
diff --git a/drivers/staging/si3226x/si3226x_drv.h b/drivers/staging/si3226x/si3226x_drv.h
new file mode 100644
index 0000000..d6b21ce
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_drv.h
@@ -0,0 +1,189 @@
+/*
+ * si3226x_drv.h
+ * Driver SLIC Silabs si3226x
+ *
+ *  Created on: 01.03.2012
+ *      Author: Michail Kurochkin
+ */
+
+#ifndef SI3226X_DRV_H_
+#define SI3226X_DRV_H_
+
+#include <linux/device.h>
+#include <linux/spi/spi.h>
+#include <linux/tdm/tdm.h>
+#include <linux/slic_si3226x.h>
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+
+#define DRIVER_NAME "si3226x"
+
+/**
+ * Calculate jiffies value for miliseconds
+ * @param ms - time in miliseconds
+ */
+#define RESET_SLIC_PERIOD 100 /*  100ms */
+#define DTMF_DIGIT_PERIOD 70 /*  DTMF tone delay */
+#define INCOMING_DTMF_BUF_SIZE 10 /*  Buffer size for incommint DTMF digits */
+#define CALLERID_BUF_SIZE 128 /*  buffer size for FSK caller id information */
+#define CALIBRATE_TIMEOUT 5000 /*  5s */
+#define ACCESS_TIMEOUT msecs_to_jiffies(1000) /*  register access timeout */
+#define WAIT_RING_TIMEOUT msecs_to_jiffies(3000) /*  waiting ring signal timeout */
+
+#define SI3226X_MAJOR 40
+/*
+ * Caller ID modes
+ */
+enum callerid_modes
+{
+	SI_FSK_BELLCORE,
+	SI_FSK_ETSI,
+	SI_CALLERID_DTMF,
+	SI_CALLERID_NONE,
+};
+
+
+/*
+ * high level line states
+ */
+enum line_states
+{
+	SI_LINE_DISABLE, /*  disable line and voltage */
+	SI_LINE_SILENCE, /*  hook on */
+	SI_LINE_WAIT, /*  generate long tone signals */
+	SI_LINE_INVITATION, /*  generate permanent tone to line */
+	SI_LINE_BUSY, /*  generate short tone signals to line */
+	SI_LINE_TALK, /*  voice transaction, audio enable */
+};
+
+/*
+ * current telephone hook states
+ */
+enum hook_states
+{
+	SI_HOOK_ON,
+	SI_HOOK_OFF,
+};
+
+/*
+ * universal circular fifo buffer
+ */
+struct circ_buffer {
+	u8 *buf;
+	int count;
+	int item_size;
+	int read_pointer;
+	int write_pointer;
+};
+
+
+/*
+ * si3226x line structure
+ */
+struct si3226x_line
+{
+	u8 ch; /*  number of fxs channel */
+
+	dev_t devt; /*  major/minor number of line device */
+
+	enum line_states state; /*  current line state */
+	enum hook_states hook_state; /*  current telephone hook state */
+
+	enum companding_modes companding_mode; /*  a-law or m-law */
+
+	/*  audio buffers */
+	u8 *tx_buffer; /*  private transmit buffer */
+	u8 *rx_buffer; /*  private receive buffer */
+	int audio_buffer_size; /*  audio buffer size */
+
+	wait_queue_head_t *rx_wait_queue;
+	wait_queue_head_t *tx_wait_queue;
+
+	struct tdm_device *tdm_dev; /*  tdm device for transfer audio data */
+
+	u8 file_opened;  /*  flag indicate opened device file */
+
+	enum callerid_modes callerid_mode; /*  SI_CALLERID_DTMF, SI_FSK_BELLCORE, SI_FSK_ETSI */
+	struct work_struct line_call_work; /*  work queue for line call and caller_id routine */
+	u8 caller_id_buf[255]; /*  caller_id data buffer for send in line */
+	int caller_id_buf_size; /*  caller_id size of data buffer */
+
+	struct circ_buffer dtmf; /* buffer for incomming all DTMF digits */
+	struct circ_buffer fsk; /* buffer for transmit fsk */
+};
+
+
+/*
+ * si3226x controller structure
+ */
+struct si3226x_slic
+{
+	dev_t devt;
+
+	struct platform_device *pdev;
+	struct spi_device *spi_dev;
+	struct si3226x_line lines[SI3226X_MAX_CHANNELS];
+
+	int irq; /*  IRQ number for slic */
+	int reset_gpio; /*  GPIO for reset slic */
+	int int_gpio; /*  GPIO interrupt for slic */
+	struct work_struct irq_work;
+
+#ifdef CONFIG_SI3226X_POLLING
+	struct delayed_work delayed_work;
+#endif
+
+	u8 file_opened : 1;  /*  flag indicate opened device file */
+};
+
+
+/*
+ * slic device types
+ */
+enum slic_dev_type
+{
+	PLAT_DEVICE,
+	SPI_DEVICE,
+	TDM_DEVICE,
+};
+
+/*
+ * container for slic list probed devices
+ */
+struct slic_dev_list
+{
+	struct list_head list;
+	struct device *dev;
+	enum slic_dev_type type;
+};
+
+/*
+ * device data types
+ */
+enum chr_dev_type
+{
+	SLIC_CHR_DEV, /*  type si3226x_slic */
+	LINE_CHR_DEV, /*  type si3226x_line */
+};
+
+/*
+ * container for list registred character devices
+ */
+struct slic_chr_dev
+{
+	struct list_head list;
+	struct device *dev; /*  character device; */
+	enum chr_dev_type type; /*  character device type; */
+};
+
+
+static inline struct si3226x_slic *to_si3226x_slic(struct si3226x_line *line)
+{
+	return line ? container_of(line - line->ch, struct si3226x_slic, lines[0]) : NULL;
+}
+
+void release_slic_drv(struct si3226x_slic *slic);
+int free_slic(struct si3226x_slic *slic);
+
+#endif /* SI3226X_DRV_H_ */
diff --git a/drivers/staging/si3226x/si3226x_hw.c b/drivers/staging/si3226x/si3226x_hw.c
new file mode 100644
index 0000000..6c353ef
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_hw.c
@@ -0,0 +1,1691 @@
+/**********************************************************************
+ * Author: Michail Kurachkin
+ *
+ * Contact: michail.kurachkin@promwad.com
+ *
+ * Copyright (c) 2013 Promwad Inc.
+ *
+ * This file is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, Version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This file is distributed in the hope that it will be useful, but
+ * AS-IS and WITHOUT ANY WARRANTY; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE, TITLE, or
+ * NONINFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this file; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ * or visit http://www.gnu.org/licenses/.
+**********************************************************************/
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slic_si3226x.h>
+#include <linux/tdm/tdm.h>
+#include <linux/mutex.h>
+#include "si3226x_drv.h"
+#include "si3226x_hw.h"
+
+/*  Include patch for si3226x */
+#include "si3226x_patch_C_FB_2011MAY19.c"
+
+/*  Include generated early setup file */
+#include "si3226x_setup.c"
+
+/*  Include generated dtmf digit table */
+#include "slic_dtmf_table.c"
+
+static DEFINE_MUTEX(spi_add_lock);
+
+
+/*
+ * si3226x register configurations for line tones
+ */
+struct si3226x_timer_regs slic_tones[] = {
+	{   /*  signal invitation */
+		.osc_amp = 0x784000,
+		.osc_freq = 0x78F0000,
+		.o_talo = 0,
+		.o_tahi = 0,
+		.o_tilo = 0,
+		.o_tihi = 0,
+	},
+	{   /*  signal busy */
+		.osc_amp = 0x784000,
+		.osc_freq = 0x78F0000,
+		.o_talo = 0xF0,
+		.o_tahi = 0xA,
+		.o_tilo = 0xF0,
+		.o_tihi = 0xA,
+	},
+	{   /*  signal wait */
+		.osc_amp = 0x7FC000,
+		.osc_freq = 0x7810000,
+		.o_talo = 0xE0,
+		.o_tahi = 0x2E,
+		.o_tilo = 0x0,
+		.o_tihi = 0x7D,
+	},
+};
+
+
+
+
+
+/**
+ * Increment pointer in circular buffer
+ * @param pointer - pointer in circular buffer
+ * @param item_size - item size in bytes
+ * @param count_items - count items in fifo
+ */
+static void inc_pointer(int *pointer, int item_size, int count_items)
+{
+	(*pointer) += item_size;
+
+	if(*pointer >= (count_items * item_size))
+		*pointer = 0;
+}
+
+
+/**
+ * Init circular fifo buffer
+ * @param buf - buffer descriptor
+ * @param item_size - item size in bytes
+ * @param count - count items in buffer
+ * @return 0 - ok
+ */
+static int cb_init(struct circ_buffer *cb, int item_size, int count)
+{
+	cb->read_pointer = 0;
+	cb->write_pointer = 0;
+
+	cb->buf = kzalloc(item_size * count, GFP_KERNEL);
+	if (!cb->buf)
+		return -ENOMEM;
+
+	cb->count = count;
+	cb->item_size = item_size;
+	return 0;
+}
+
+
+/**
+ * free fifo buffer
+ * @param cb
+ */
+static void cb_free(struct circ_buffer *cb)
+{
+	if (!cb)
+		return;
+
+	if (cb->buf)
+		kfree(cb->buf);
+
+	kfree(cb);
+}
+
+
+/**
+ * Push into fifo
+ * @param cb - fifo descriptor
+ * @param item - pointer to item
+ * @return 0 - ok, 1 - item pushed and buffer is full
+ */
+static int cb_push(struct circ_buffer *cb, void *item)
+{
+	memcpy(cb->buf + cb->write_pointer, item, cb->item_size);
+
+	inc_pointer(&cb->write_pointer, cb->item_size, cb->count);
+
+	if(cb->write_pointer == cb->read_pointer) { // If fifo is full
+		inc_pointer(&cb->read_pointer, cb->item_size, cb->count);
+		return 1;
+	}
+
+	return 0;
+}
+
+
+
+/**
+ * Check fifo is empty
+ * @param cb - fifo descriptor
+ * @return 1 - buffer is empty
+ */
+static int cb_iis_empty(struct circ_buffer *cb)
+{
+	return cb->read_pointer == cb->write_pointer;
+}
+
+
+/**
+ * Pop from fifo buffer
+ * @param cb - fifo descriptor
+ * @param item - pointer to poped item
+ * @return 0 - ok, 1 - buffer is empty
+ */
+static int cb_pop(struct circ_buffer *cb, void *item)
+{
+	if(cb->read_pointer == cb->write_pointer)
+		return 1;
+
+	memcpy(item, cb->buf + cb->read_pointer, cb->item_size);
+	inc_pointer(&cb->read_pointer, cb->item_size, cb->count);
+	return 0;
+}
+
+
+
+
+
+/**
+ * convert heximal dtmf code to ASCII code
+ * @param dtmf - heximal dtmf code
+ * @return ASCII code
+ */
+static char conv_dtmf_to_char(u8 dtmf)
+{
+	return dtmf_codes[dtmf];
+}
+
+/**
+ * ASCII code to convert heximal dtmf code
+ * @param �� - ASCII code
+ * @return heximal dtmf code or -EINVAL
+ */
+static int conv_char_to_dtmf(char ch)
+{
+	int i;
+
+	for(i = 0; i < sizeof dtmf_codes - 1; i++)
+		if(dtmf_codes[i] == ch)
+			return i;
+
+	return -EINVAL;
+}
+
+
+/**
+ * Reset SLIC
+ */
+static int slic_reset(struct si3226x_slic *slic)
+{
+	gpio_set_value(slic->reset_gpio, 0);
+	msleep(RESET_SLIC_PERIOD);
+	gpio_set_value(slic->reset_gpio, 1);
+
+	return 0;
+}
+
+
+/**
+ * Write value into SLIC register
+ * @param channel - channel number
+ * @param addr - address SLIC register
+ * @param data - register value
+ * @return
+ * 		0 - OK
+ * 		1 - ERROR
+ */
+int slic_write_reg(struct si3226x_line *line, u8 addr, u8 data)
+{
+	u8 ch;
+	int rc;
+	int i;
+	struct si3226x_slic *slic = to_si3226x_slic(line);
+
+	mutex_lock(&spi_add_lock);
+
+	if (line && line->ch >= SI3226X_MAX_CHANNELS) {
+		mutex_unlock(&spi_add_lock);
+		dev_err(&line->tdm_dev->dev, "Incorrect slic line number\n");
+		return -EINVAL;
+	}
+
+	if(line == NULL)
+		ch = 0;
+	else
+		ch = line->ch;
+
+
+	/**
+	 * bit 7 - BRDCST - Indicates a broadcast operation that is intended
+	 * for all devices in the daisy chain. This is
+	 * only valid for write operations since it would cause contention
+	 * on the SDO pin during a read.
+		bit 6 - R/W - Read/Write Bit.
+			0 = Write operation.
+			1 = Read operation.
+		bit 5 - REG/RAM - Register/RAM Access Bit.
+			0 = RAM access.
+			1 = Register access.
+		bit 4:0 -  CID[4:0] - Indicates the channel that is targeted by
+		 	the operation. Note that the 4-bit channel value is
+		 	provided LSB first. The devices reside on the daisy
+		 	chain such that device 0 is nearest to the controller,
+		 	and device 15 is furthest down the SDI/SDU_THRU chain.
+		 	(See Figure 41.)
+			As the CID information propagates down the daisy chain,
+			each channel decrements the CID by 1. The SDI nodes
+			between devices reflect a decrement of 2 per device
+			since each device contains two channels. The device
+			receiving a value of 0 in the CID field responds
+			to the SPI transaction. (See Figure 42.) If a broadcast
+			to all devices connected to the chain is requested,
+			the CID does not  decrement. In this case, the same
+			8-bit or 16-bit data is pre-sented to all channels
+			regardless of the CID values.
+	 */
+	{
+
+		u8 write_transaction[] = {
+			(1 << 5) | ((ch & 1) << 4), /*  control byte */
+			addr,
+			data,
+		};
+
+		for(i = 0; i < sizeof write_transaction; i++) {
+			rc = spi_write(slic->spi_dev, write_transaction + i, 1);
+			if (rc) {
+				dev_err(&line->tdm_dev->dev,
+						"Can't write slic register addr: %d, value: %d\n",
+						addr, data);
+				mutex_unlock(&spi_add_lock);
+				return rc;
+			}
+		}
+	}
+
+	mutex_unlock(&spi_add_lock);
+	return rc;
+}
+
+
+/**
+ * Read value from SLIC register
+ * @param line - line descriptor or NULL if read GLOBAL register
+ * @param addr - address SLIC register
+ * @param data - pointer to read data
+ * @return 0 - ok
+ */
+static int slic_read_reg(struct si3226x_line *line, u8 addr, u8 *data)
+{
+	int rc;
+	u8 ch;
+	int i;
+	struct si3226x_slic *slic = to_si3226x_slic(line);
+
+	mutex_lock(&spi_add_lock);
+
+	if (line && line->ch >= SI3226X_MAX_CHANNELS) {
+		mutex_unlock(&spi_add_lock);
+		return -EINVAL;
+	}
+
+	ch = line->ch;
+
+	{
+		u8 read_transaction[] = {
+			(1 << 5) | (1 << 6) | ((ch & 1) << 4), /*  control byte */
+			addr,
+		};
+
+		for(i = 0; i < sizeof read_transaction; i++) {
+			rc = spi_write(slic->spi_dev, read_transaction + i, 1);
+			if (rc) {
+				mutex_unlock(&spi_add_lock);
+				return rc;
+			}
+		}
+	}
+
+	rc = spi_read(slic->spi_dev, data, 1);
+
+	mutex_unlock(&spi_add_lock);
+	return rc;
+}
+
+
+
+/**
+ * Write value into SLIC RAM
+ * @param channel - channel number
+ * @param addr - address SLIC RAM
+ * @param value - value of SLIC RAM
+ * @return
+ *
+ */
+int slic_write_ram(struct si3226x_line *line, u16 addr, u32 value)
+{
+	int rc;
+	unsigned long timeout;
+	u8 state;
+	u8 *write_data;
+	u32 val = value << 3;
+
+	write_data = (u8 *)&val;
+
+	if((!line) || line->ch >= SI3226X_MAX_CHANNELS)
+		return -EINVAL;
+
+	value <<= 3;
+
+	rc = slic_write_reg(line, SI_RAM_ADDR_HI, (addr >> 3) & 0xe0);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_RAM_DATA_B0,  write_data[0] & 0xF8);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_RAM_DATA_B1,  write_data[1]);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_RAM_DATA_B2,  write_data[2]);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_RAM_DATA_B3,  write_data[3]);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_RAM_ADDR_LO, addr & 0xFF);
+	if (rc)
+		return rc;
+
+	timeout = jiffies + ACCESS_TIMEOUT;
+	do {
+		rc = slic_read_reg(line, SI_REG_RAMSTAT, &state);
+		if (rc)
+			return rc;
+
+		state &= 1;
+		if(time_after(jiffies, timeout)) {
+			dev_err(&line->tdm_dev->dev, "Can`t write access to slic RAM\n");
+			return -EBUSY;
+		}
+	} while (state);
+
+	return 0;
+}
+
+
+
+/**
+ * Lock channel. To protect against undersirable/unintended
+ * system operation, there are certain critical register control
+ * bits that are protected by default against unintentional
+ * modification.
+ * @param channel - channel number
+ * @return 0 - ok
+ */
+int slic_lock_channel(struct si3226x_line *line)
+{
+	int rc;
+	int i;
+	u8 state;
+	unsigned long timeout;
+	u8 unlock_data[] = {0x2, 0x8, 0xE, 0};
+
+	timeout = jiffies + ACCESS_TIMEOUT;
+	do {
+		rc = slic_read_reg(line, SI_REG_UAM, &state);
+		if (rc)
+			return rc;
+
+		if((state & 1) == 0) /*  if channel already locked */
+			return 0;
+
+		for(i = 0; i < sizeof unlock_data; i++) {
+			rc = slic_write_reg(line, SI_REG_UAM, unlock_data[i]);
+			if (rc)
+				return rc;
+		}
+
+		rc = slic_read_reg(line, SI_REG_UAM, &state);
+		if (rc)
+			return rc;
+
+		if(time_after(jiffies, timeout)) {
+			dev_err(&line->tdm_dev->dev,
+				"can`t lock slic channel %d\n", line->ch);
+			return -EBUSY;
+		}
+	} while ((state & 1));
+
+	return 0;
+}
+
+
+/**
+ * Unlock channel. While in protected mode, any writes to
+ * protected register bits or protected RAM space are simply
+ * ignored by the si3226x.
+ * @param channel - channel number
+ * @return 0 - ok
+ */
+int slic_unlock_channel(struct si3226x_line *line)
+{
+	int rc;
+	int i;
+	u8 state;
+	unsigned long timeout;
+
+	/* unlock data consecution */
+	u8 unlock_data[] = {0x2, 0x8, 0xE, 0};
+
+	timeout = jiffies + ACCESS_TIMEOUT;
+	do {
+		rc = slic_read_reg(line, SI_REG_UAM, &state);
+		if (rc)
+			return rc;
+
+		if((state & 1) != 0) /*  if channel already unlocked */
+			return 0;
+
+		for(i = 0; i < sizeof unlock_data; i++) {
+			rc = slic_write_reg(line, SI_REG_UAM, unlock_data[i]);
+			if (rc)
+				return rc;
+		}
+
+		rc = slic_read_reg(line, SI_REG_UAM, &state);
+		if (rc)
+			return rc;
+
+		if(time_after(jiffies, timeout)) {
+			dev_err(&line->tdm_dev->dev,
+				"can`t unlock slic channel %d\n", line->ch);
+			return -EBUSY;
+		}
+	} while ((!(state & 1)));
+
+	return 0;
+}
+
+
+/**
+ * Calibrate slic
+ * @param slic - slic descriptor
+ * @return 0 - ok
+ */
+int slic_calibrate(struct si3226x_line *line)
+{
+	int rc;
+	u8 data;
+	unsigned long timeout;
+
+	rc = slic_write_reg(line, SI_REG_CALR3, SI_VAL_CAL_EN);
+	if (rc)
+		return rc;
+
+	timeout = jiffies + msecs_to_jiffies(CALIBRATE_TIMEOUT);
+	do {
+		rc = slic_read_reg(line, SI_REG_CALR3, &data);
+		if (rc)
+			return rc;
+
+		data &= SI_VAL_CAL_EN;
+
+		if(time_after(jiffies, timeout)) {
+			dev_err(&line->tdm_dev->dev,
+			        "Can`t calibrate slic line %d\n",
+			        line->ch);
+			return -EBUSY;
+		}
+	} while(data);
+
+
+	return 0;
+}
+
+
+/**
+ * Enable hardware echo cancelation
+ * @param line - line
+ * @return 0 - ok
+ */
+int slic_enable_echo(struct si3226x_line *line)
+{
+	int rc;
+	u8 data;
+
+	rc = slic_read_reg(line, SI_REG_DIGCON, &data);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_DIGCON, data & (~SI_VAL_HYB_DIS));
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+
+/**
+ * Disable hardware echo cancelation
+ * @param line - line descriptor
+ * @return 0 - ok
+ */
+int slic_disable_echo(struct si3226x_line *line)
+{
+	int rc;
+	u8 data;
+
+	rc = slic_read_reg(line, SI_REG_DIGCON, &data);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_DIGCON, data | SI_VAL_HYB_DIS);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+
+/**
+ * function send FSK data from fifo to FXS line.
+ * called by irq when hardware fsk buffer is empty
+ * @param line - line descriptor
+ */
+static void do_fsk(struct si3226x_line *line)
+{
+	u8 data;
+	int rc;
+
+	/*  put 8 byte into hardware fsk fifo */
+	rc = cb_pop(&line->fsk, &data);
+	if (rc) {
+		mdelay(300);
+		slic_write_reg(line, SI_REG_OCON, 0);
+		return;
+	}
+
+	slic_write_reg(line, SI_REG_FSKDAT, data);
+}
+
+
+/**
+ * Run sending fsk caller id procedure.
+ * asynchronous send fsk data by irq
+ * @param line - line descriptor
+ * @param mode - type of caller id. Declared in enum callerid_modes
+ * @param buf - caller id data
+ * @param size - caller id size
+ * @return 0 - ok
+ */
+static int
+slic_send_fsk(struct si3226x_line *line, int mode, u8 *buf, int size)
+{
+	int rc;
+	int i;
+	u8 data;
+
+	if (!size)
+		return -EINVAL;
+
+	if (!cb_iis_empty(&line->fsk)) {
+		rc = cb_init(&line->fsk, 1, CALLERID_BUF_SIZE);
+		if (rc)
+			return rc;
+	}
+
+	data = 0x55;
+	for (i = 0; i < 38; i++)
+		cb_push(&line->fsk, &data);
+
+	data = 0xFF;
+	for (i = 0; i < 19; i++)
+		cb_push(&line->fsk, &data);
+
+	for (i = 0; i < size; i++)
+		cb_push(&line->fsk, buf + i);
+
+	rc = slic_write_reg(line, SI_REG_OMODE,
+	                    SI_VAL_OSC1_FSK | SI_VAL_ROUTING_1_2);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_FSKDEPTH, SI_VAL_FSK_FLUSH);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_FSKDEPTH, 0);
+	if (rc)
+		return rc;
+
+
+	switch (mode) {
+	case SI_FSK_BELLCORE:
+		rc = slic_write_ram(line, SI_RAM_FSKAMP0, 0x105E000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKAMP1, 0x8BE000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKFREQ0, 0x6B60000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKFREQ1, 0x79C0000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSK01, 0x2232000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSK10, 0x77C2000);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_FSK_ETSI:
+		rc = slic_write_ram(line, SI_RAM_FSKAMP0, 0x340000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKAMP1, 0x1FA000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKFREQ0, 0x6D20000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSKFREQ1, 0x78B0000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSK01, 0x26E4000);
+		if (rc)
+			return rc;
+
+		rc = slic_write_ram(line, SI_RAM_FSK10, 0x694C000);
+		if (rc)
+			return rc;
+
+		break;
+	}
+
+	rc = slic_write_reg(line, SI_REG_O1TALO, 0x14);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_O1TAHI, 0);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_OCON, SI_VAL_OSC1_EN | SI_VAL_OSC1_TA_EN);
+	if (rc)
+		return rc;
+
+	do_fsk(line);
+	return 0;
+}
+
+
+/**
+ * Disable DTMF recognizing on FXS line
+ * @param line
+ * @return 0 - ok
+ */
+static int disable_dtmf_detect(struct si3226x_line *line)
+{
+	return slic_write_reg(line, SI_REG_TONEN, 0xe3);
+}
+
+/**
+ * Enable DTMF recognizing on FXS line
+ * @param line
+ * @return 0 - ok
+ */
+static int enable_dtmf_detect(struct si3226x_line *line)
+{
+	return slic_write_reg(line, SI_REG_TONEN, 0xe0);
+}
+
+/**
+ * Send callerID data
+ * @param line - line
+ * @param buf - callerID buffer
+ * @param size - buffer size
+ * @return 0 - ok
+ */
+static int slic_send_callerid(struct si3226x_line *line, char *buf, int size)
+{
+	int rc;
+	int i;
+
+	switch(line->callerid_mode) {
+	case SI_CALLERID_DTMF:
+		rc = disable_dtmf_detect(line);
+		if (rc)
+			return rc;
+
+		for(i = 0; i < size; i++) {
+			rc = slic_send_dtmf_digit(line, buf[i]);
+
+			if(rc || line->hook_state)
+				return enable_dtmf_detect(line);
+
+			msleep(70);
+		}
+
+		rc = enable_dtmf_detect(line);
+		if (rc)
+			return rc;
+
+		break;
+
+
+	case SI_FSK_BELLCORE:
+		rc = slic_send_fsk(line, SI_FSK_BELLCORE, buf, size);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_FSK_ETSI:
+		rc = slic_send_fsk(line, SI_FSK_ETSI, buf, size);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_CALLERID_NONE:
+		break;
+	}
+
+	return 0;
+}
+
+
+
+/**
+ * Set hardware slic channel state
+ * @param line - line descriptor
+ * @param state - hardware line state
+ * @return 0 - ok
+ */
+static int
+slic_set_linefeed_state(struct si3226x_line *line, enum fxs_states state)
+{
+	int rc;
+
+	rc = slic_write_reg(line, SI_REG_LINEFEED, state);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+
+/**
+ * send ring signal to line and send callerid if not null.
+ * Functon is blocking while sending callerid
+ * @param line - line descriptor
+ * @param callerid_buf - buffer witch callerid
+ * @param size - caller id buffer size
+ * @return 0 - ok
+ */
+int slic_line_call(struct si3226x_line *line, u8 *callerid_buf, int size)
+{
+	int stored_size;
+
+	stored_size = min((int)sizeof(line->caller_id_buf) - 1, size);
+	memcpy(line->caller_id_buf, callerid_buf, stored_size);
+	line->caller_id_buf_size = stored_size;
+
+	schedule_work(&line->line_call_work);
+	return 0;
+}
+
+int slic_get_dtmf_data(struct si3226x_line *line, char *data)
+{
+	return cb_pop(&line->dtmf, data);
+}
+
+/**
+ * Work queue IRQ callback handled all slic events
+ * @param work - work queue item
+ */
+static void do_line_call(struct work_struct *work)
+{
+	struct si3226x_line *line = container_of(work, struct si3226x_line, line_call_work);
+	unsigned long timeout;
+	u8 data;
+	int rc;
+
+	rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_OHT);
+	if (rc)
+		return;
+
+	rc = slic_set_linefeed_state(line, SI_FXS_RINGING);
+	if (rc)
+		return;
+
+	if(line->callerid_mode == SI_CALLERID_NONE)
+		return;
+
+	msleep(30);
+
+	timeout = jiffies + WAIT_RING_TIMEOUT;
+	do {
+		rc = slic_read_reg(line, SI_REG_LINEFEED, &data);
+		if (rc)
+			return;
+
+		if(time_after(jiffies, timeout)) {
+			dev_err(&line->tdm_dev->dev,
+			        "ring signal not detected on line %d\n",
+			        line->ch);
+			return;
+		}
+		schedule();
+	} while (data & (1 << 6));
+
+	msleep(200);
+
+	rc = slic_send_callerid(line, line->caller_id_buf, line->caller_id_buf_size);
+	if (rc)
+		return;
+}
+
+/**
+ * Setup slic hardware timer
+ * @param line - line descriptor
+ * @param timer_num - number of timer
+ * @param timer_regs - list specified timer registers values
+ * @return 0 - ok
+ */
+static int
+slic_set_timer(struct si3226x_line *line, u8 timer_num,
+               struct si3226x_timer_regs *timer_regs)
+{
+	int rc;
+
+	if(timer_num > 1)
+		return -EINVAL;
+
+	rc = slic_write_ram(line, SI_RAM_OSC1AMP + timer_num * 3,
+	                    timer_regs->osc_amp);
+	if (rc)
+		return rc;
+
+	rc = slic_write_ram(line, SI_RAM_OSC1FREQ + timer_num * 3,
+	                    timer_regs->osc_freq);
+	if (rc)
+		return rc;
+
+	rc = slic_write_ram(line, SI_RAM_OSC1PHAS + timer_num * 3, 0);
+	if (rc)
+		return rc;
+
+	/*  configure timer delay */
+	rc = slic_write_reg(line, SI_REG_O1TALO + timer_num * 4,
+	                    timer_regs->o_talo);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_O1TAHI + timer_num * 4,
+	                    timer_regs->o_tahi);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_O1TILO + timer_num * 4,
+	                    timer_regs->o_tilo);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_O1TIHI + timer_num * 4,
+	                    timer_regs->o_tihi);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+
+/**
+ * Send tone signal to line
+ * @param line - line descriptor
+ * @param type - type of signal (defined in array slic_tones[])
+ * @return 0 - ok
+ */
+static int
+slic_set_signal_to_line(struct si3226x_line *line, enum tone_types type)
+{
+	int rc;
+
+	if (type >= ARRAY_SIZE(slic_tones))
+		return -EINVAL;
+
+	/*  disable tone if needed */
+	if(type == SI_TONE_NONE) {
+		rc = slic_write_reg(line, SI_REG_OCON, 0);
+		return rc;
+	}
+
+	rc = slic_set_timer(line, 0, slic_tones +(int)type);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_OMODE,
+	                    SI_VAL_ROUTING_1_3 | SI_VAL_ZERO_EN_1);
+	if (rc)
+		return rc;
+
+	switch(type) {
+	case SI_TONE_INVITATION:
+		rc = slic_write_reg(line, SI_REG_OCON, SI_VAL_OSC1_EN);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_TONE_BUSY:
+	case SI_TONE_WAIT:
+		rc = slic_write_reg(line, SI_REG_OCON,
+		                    SI_VAL_OSC1_EN | SI_VAL_OSC1_TA_EN | SI_VAL_OSC1_TI_EN);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_TONE_NONE:
+		break;
+	}
+
+	return 0;
+}
+
+
+/**
+ * Set high level line state
+ * @param line - line descriptor
+ * @param state - needed line state
+ * @return 0 - ok
+ */
+int slic_set_line_state(struct si3226x_line *line, int state)
+{
+	int rc;
+
+	if (state > SI_LINE_TALK)
+		return -EINVAL;
+
+	switch(state) {
+	case SI_LINE_DISABLE:
+		rc = slic_set_linefeed_state(line, SI_FXS_OPEN);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_LINE_SILENCE:
+		rc = slic_set_signal_to_line(line, SI_TONE_NONE);
+		if (rc)
+			return rc;
+
+		rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_ACTIVE);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_LINE_INVITATION:
+		rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_ACTIVE);
+		if (rc)
+			return rc;
+
+		rc = slic_set_signal_to_line(line, SI_TONE_INVITATION);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_LINE_WAIT:
+		rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_ACTIVE);
+		if (rc)
+			return rc;
+
+		rc = slic_set_signal_to_line(line, SI_TONE_WAIT);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_LINE_BUSY:
+		rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_ACTIVE);
+		if (rc)
+			return rc;
+
+		rc = slic_set_signal_to_line(line, SI_TONE_BUSY);
+		if (rc)
+			return rc;
+
+		break;
+
+	case SI_LINE_TALK:
+		rc = slic_set_signal_to_line(line, SI_TONE_NONE);
+		if (rc)
+			return rc;
+
+		rc = slic_set_linefeed_state(line, SI_FXS_FORWARD_ACTIVE);
+		if (rc)
+			return rc;
+
+		break;
+	}
+
+	return 0;
+}
+
+
+
+/**
+ * Send one digit by DTMF
+ * @param line - line
+ * @param ch - heximal DTMF code
+ * @return 0 - ok
+ */
+int slic_send_dtmf_digit(struct si3226x_line *line, char ch)
+{
+	int rc;
+	int i;
+	unsigned long timeout;
+	u8 data;
+	int dtmf_ch;
+	static struct si3226x_timer_regs timer_regs[2];
+	u16 dtmf_delay = DTMF_DIGIT_PERIOD * 1000 / 125;
+
+	dtmf_ch = conv_char_to_dtmf(ch);
+	if (dtmf_ch < 0)
+		return dtmf_ch;
+
+	if(dtmf_ch > 0xF)
+		return -EINVAL;
+
+	timer_regs[0].osc_amp = slic_dtmf_table[dtmf_ch].osc1amp;
+	timer_regs[0].osc_freq = slic_dtmf_table[dtmf_ch].osc1freq;
+	timer_regs[0].o_talo = (u8)(dtmf_delay & 0xFF);
+	timer_regs[0].o_tahi = (u8)((dtmf_delay >> 8) & 0xFF);
+
+	timer_regs[1].osc_amp = slic_dtmf_table[dtmf_ch].osc2amp;
+	timer_regs[1].osc_freq = slic_dtmf_table[dtmf_ch].osc2freq;
+	timer_regs[1].o_talo = (u8)(dtmf_delay & 0xFF);
+	timer_regs[1].o_tahi = (u8)((dtmf_delay >> 8) & 0xFF);
+
+	for(i = 0; i < 2; i++) {
+		rc = slic_set_timer(line, i, timer_regs + i);
+		if (rc)
+			return rc;
+	}
+
+	/*  Sending tone to */
+	rc = slic_write_reg(line, SI_REG_OMODE,
+	                    SI_VAL_ROUTING_1_3 | SI_VAL_ZERO_EN_1 |
+	                    SI_VAL_ROUTING_2_3 | SI_VAL_ZERO_EN_2);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_OCON,
+	                    SI_VAL_OSC1_EN | SI_VAL_OSC1_TA_EN |
+	                    SI_VAL_OSC2_EN | SI_VAL_OSC2_TA_EN);
+	if (rc)
+		return rc;
+
+	/*  sleeping by DTMF is signalling */
+	msleep(DTMF_DIGIT_PERIOD);
+
+	timeout = jiffies + ACCESS_TIMEOUT;
+	do {
+		rc = slic_read_reg(line, SI_REG_OCON, &data);
+		if (rc)
+			return rc;
+
+		data &= (SI_VAL_EN_SYNC_1 | SI_VAL_EN_SYNC_2);
+		if(time_after(jiffies, timeout))
+			return -EBUSY;
+	} while(data);
+
+	return 0;
+}
+
+
+/**
+ * Mask irq for slic line
+ * @param line - line descriptor
+ * @return 0 - ok
+ */
+static int slic_mask_irq(struct si3226x_line *line)
+{
+	int rc;
+	u8 data;
+	int i;
+
+	/*  Cleanup all irq flags */
+	for(i = SI_REG_IRQ0; i < SI_REG_IRQ4; i++) {
+		rc = slic_read_reg(line, i, &data);
+		if (rc)
+			return rc;
+	}
+
+	/*  FSK empty buffer */
+	rc = slic_write_reg(line, SI_REG_IRQEN1, SI_VAL_FSKBUF_AVAIL_IA);
+	if (rc)
+		return rc;
+
+	/*  RX,TX modem tone detector, DTMF, on/off hook */
+	rc = slic_write_reg(line, SI_REG_IRQEN2,
+	                    SI_VAL_TXMDM_IA | SI_VAL_RXMDM_IA | SI_VAL_DTMF_IA | SI_VAL_LCR_IA);
+	if (rc)
+		return rc;
+
+	/*  Termo alarm */
+	rc = slic_write_reg(line, SI_REG_IRQEN3, SI_VAL_P_TERM_IA);
+	if (rc)
+		return rc;
+
+	/*  disable unused irq */
+	rc = slic_write_reg(line, SI_REG_IRQEN4, 0);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
+
+/**
+ * Upload patch for si3226x
+ * @param line - patch upload for line
+ * @return 0 - ok
+ */
+static int upload_patch(struct si3226x_line *line)
+{
+	int rc;
+	int i;
+
+	rc = slic_write_reg(line, SI_REG_JMPEN, 0);
+	if (rc)
+		return rc;
+
+	/*  load patch ram */
+	rc = slic_write_ram(line, SI_RAM_PRAM_ADDR, 0);
+	if (rc)
+		return rc;
+
+	for(i = 0; i < ARRAY_SIZE(si3226x_patch_data); i++) {
+		rc = slic_write_ram(line, SI_RAM_PRAM_DATA,
+		                    si3226x_patch_data[i]);
+		if (rc)
+			return rc;
+	}
+
+	/*  load jump table */
+	for(i = SI_REG_JMP0LO; i < SI_REG_JMP7HI; i++) {
+		rc = slic_write_reg(line, i,
+		                    si3226x_patch_entries[i - SI_REG_JMP0LO]);
+		if (rc)
+			return rc;
+	}
+
+	/*  load RAM */
+	for(i = 0; i < ARRAY_SIZE(si3226x_patch_support_addr); i++) {
+		rc = slic_write_ram(line, si3226x_patch_support_addr[i],
+		                    si3226x_patch_support_data[i]);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+
+/**
+ * Setup audio companding mode
+ * @param line
+ * @param companding_mode
+ * @return 0 - ok
+ */
+int slic_set_companding_mode(struct si3226x_line *line, u8 companding_mode)
+{
+	u8 reg_val;
+	int rc = 0;
+	u8 bus_format = 0;
+
+	switch(companding_mode) {
+	case SI_ALAW:
+		bus_format = SI_VAL_PCM_FMT_0 | SI_VAL_PCM_ALAW_1;
+		break;
+
+	case SI_MLAW:
+		bus_format = SI_VAL_PCM_FMT_1;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	rc = slic_read_reg(line, SI_REG_PCMMODE, &reg_val);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_PCMMODE, reg_val | bus_format);
+	if (rc)
+		return rc;
+
+	line->companding_mode = companding_mode;
+	return rc;
+}
+
+
+/**
+ * Setup slic hardware audio settings
+ * @param line - line descriptor
+ * @return 0 - ok
+ */
+int slic_setup_audio(struct si3226x_line *line)
+{
+	struct tdm_device *tdm_dev = line->tdm_dev;
+	struct tdm_controller_hw_settings *tdm_controller_hw =
+			    tdm_dev->controller->settings;
+	u16 time_slot_pos =
+	    tdm_dev->tdm_channel_num * tdm_controller_hw->channel_size * 8;
+	u8 tx_edge;
+	int rc = 0;
+	u8 reg_val;
+
+	tx_edge = (tdm_controller_hw->data_polarity == TDM_POLAR_NEGATIVE) << 4;
+
+	rc = slic_write_reg(line, SI_REG_PCMTXLO, (u8)(time_slot_pos & 0xFF));
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_PCMTXHI,
+	                    (u8)((time_slot_pos >> 8) & 0x3) | tx_edge);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_PCMRXLO, (u8)(time_slot_pos & 0xFF));
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_PCMRXHI,
+	                    (u8)((time_slot_pos >> 8) & 0x3));
+	if (rc)
+		return rc;
+
+	rc = slic_set_companding_mode(line, line->companding_mode);
+	if (rc)
+		return rc;
+
+	rc = slic_read_reg(line, SI_REG_PCMMODE, &reg_val);
+	if (rc)
+		return rc;
+
+	rc = slic_write_reg(line, SI_REG_PCMMODE, reg_val | SI_VAL_PCM_EN);
+	if (rc)
+		return rc;
+
+	rc = tdm_run_audio(tdm_dev);
+	if (!rc)
+		dev_err(&line->tdm_dev->dev, "Can't run audio\n");
+
+	return rc;
+}
+
+
+/**
+ * Init hardware slic line
+ * @param line - line descriptor
+ * @return 0 - ok
+ */
+static int init_line(struct si3226x_line *line)
+{
+	int rc;
+
+	dev_info(&line->tdm_dev->dev, "run init line\n");
+
+	line->callerid_mode = SI_CALLERID_NONE;
+
+	INIT_WORK(&line->line_call_work, do_line_call);
+
+	rc = cb_init(&line->dtmf, 1, INCOMING_DTMF_BUF_SIZE);
+	if (rc)
+		return rc;
+
+	rc = cb_init(&line->fsk, 1, CALLERID_BUF_SIZE);
+	if (rc)
+		return rc;
+
+
+	rc = slic_setup_audio(line);
+	if (rc)
+		return rc;
+
+	rc = slic_set_line_state(line, SI_LINE_SILENCE);
+	if (rc)
+		return rc;
+
+	rc = slic_mask_irq(line);
+	if (rc)
+		return rc;
+
+	dev_dbg(&line->tdm_dev->dev, "init line done\n");
+	return 0;
+}
+
+
+/**
+ * Init hardware slic
+ * @param slic - slic descriptor
+ * @return 0 - ok
+ */
+int init_slic(struct si3226x_slic *slic)
+{
+	int rc;
+	int i;
+	struct si3226x_line *line = slic->lines;
+	struct platform_device *pdev = slic->pdev;
+	u8 chip_id;
+
+	dev_info(&pdev->dev, "run slic initialization\n");
+
+	rc = slic_reset(slic);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to reset SLIC\n");
+		return rc;
+	}
+
+	mdelay(50);
+
+	rc = slic_read_reg(line, 0, &chip_id);
+	if (rc)
+		return rc;
+
+	if (chip_id != 0xC3) {
+		dev_err(&pdev->dev, "Incorrect slic chip ID: 0x%X\n", chip_id);
+		return -ENODEV;
+	}
+
+
+
+	for (i = 0; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		if (line->state == SI_LINE_DISABLE)
+			continue;
+
+		rc = slic_unlock_channel(line);
+		if (rc)
+			return rc;
+
+		rc = upload_patch(line);
+		if (rc)
+			return rc;
+
+		rc = slic_lock_channel(line);
+		if (rc)
+			return rc;
+
+		dev_info(&pdev->dev, "line: %d, patch uploaded\n", line->ch);
+	}
+
+	rc = slic_load_settings(slic);
+	if (rc)
+		return rc;
+
+	dev_info(&pdev->dev, "settings loaded\n");
+
+	for (i = 0, line = slic->lines; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		if (line->state == SI_LINE_DISABLE)
+			continue;
+
+		rc = init_line(line);
+		if (rc)
+			return rc;
+	}
+
+	return 0;
+}
+
+
+/**
+ * deInit hardware slic. stop slic.
+ * @param slic - slic descriptor
+ * @return 0 - ok
+ */
+int deinit_slic(struct si3226x_slic *slic)
+{
+	struct si3226x_line *line;
+	int i;
+
+	for (i = 0, line = slic->lines; i < SI3226X_MAX_CHANNELS; i++, line++) {
+		if (line->state == SI_LINE_DISABLE)
+			continue;
+
+		slic_set_line_state(line, SI_LINE_SILENCE);
+
+		cb_free(&line->dtmf);
+		cb_free(&line->fsk);
+	}
+
+	return 0;
+}
+
+
+
+/*
+ * IRQ event handlers - event_xxx...
+ */
+static void event_modem_detect(struct si3226x_line *line)
+{
+
+}
+
+static void event_dtmf_detect(struct si3226x_line *line)
+{
+	u8 ch;
+	u8 data = 0;
+
+	slic_read_reg(line, SI_REG_TONDTMF, &data);
+
+	/*  if dtmf not recognized */
+	if (!(data & SI_VAL_VALID))
+		return;
+
+	ch = conv_dtmf_to_char(data & 0xF);
+
+	cb_push(&line->dtmf, &ch);
+}
+
+static void event_hook_detect(struct si3226x_line *line)
+{
+	u8 data = 0;
+
+	slic_read_reg(line, SI_REG_LCRRTP, &data);
+	line->hook_state = !!(data & SI_VAL_LCR);
+}
+
+static void event_error_detect(struct si3226x_line *line, enum si3226x_errors err)
+{
+	struct si3226x_slic *slic = to_si3226x_slic(line);
+
+	switch(err) {
+	case SI_ERR_TERMAL_SHOCK:
+		dev_err(&slic->pdev->dev, "SLIC Termal shock! Stopped driver\n");
+		release_slic_drv(slic);
+		free_slic(slic);
+		break;
+	}
+}
+
+
+
+#ifdef CONFIG_SI3226X_POLLING
+void slic_delayed_work(struct delayed_work *work)
+{
+	struct si3226x_slic *slic =
+	    container_of(work, struct si3226x_slic, delayed_work);
+
+	slic_irq_callback(&slic->irq_work);
+
+	schedule_delayed_work(work, MSEC(50));
+}
+#endif
+
+/**
+ * Interrupt handler for slic
+ * @param irq - irq number
+ * @param context_data - slic private data
+ */
+irqreturn_t slic_irq(s32 irq, void *context_data)
+{
+	struct si3226x_slic *slic = context_data;
+	int value = gpio_get_value(slic->int_gpio);
+
+	if (value == 0)
+		schedule_work(&slic->irq_work);
+
+	return IRQ_HANDLED;
+}
+
+
+/**
+ * Work queue IRQ callback handled all slic events
+ * @param work - work queue item
+ */
+void slic_irq_callback(struct work_struct *work)
+{
+	struct si3226x_slic *slic =
+	    container_of(work, struct si3226x_slic, irq_work);
+
+	struct si3226x_line *line = 0;
+	u8 global_irq_status;
+	u8 data;
+	int rc;
+	int i;
+
+	rc = slic_read_reg(slic->lines, SI_REG_IRQ0, &global_irq_status);
+	if (rc)
+		return;
+
+	/*  identificate irq reason */
+	for (i = 0; i < 8; i++) {
+		if (!(global_irq_status & (1 << i)))
+			continue;
+
+		switch (i) {
+		case 0:
+			line = slic->lines + 0;
+			rc = slic_read_reg(line, SI_REG_IRQ1, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_FSKBUF_AVAIL_IA)
+				do_fsk(line);
+			break;
+
+		case 1:
+			line = slic->lines + 0;
+			rc = slic_read_reg(line, SI_REG_IRQ2, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_RXMDM_IA)
+				event_modem_detect(line);
+
+			if (data & SI_VAL_TXMDM_IA)
+				event_modem_detect(line);
+
+			if (data & SI_VAL_DTMF_IA)
+				event_dtmf_detect(line);
+
+			if (data & SI_VAL_LCR_IA)
+				event_hook_detect(line);
+			break;
+
+		case 2:
+			line = slic->lines + 0;
+			rc = slic_read_reg(line, SI_REG_IRQ3, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_P_TERM_IA)
+				event_error_detect(line, SI_ERR_TERMAL_SHOCK);
+			break;
+
+		case 3:
+			line = slic->lines + 0;
+			rc = slic_read_reg(line, SI_REG_IRQ4, &data);
+			if (rc)
+				return;
+
+			break;
+
+		case 4:
+			line = slic->lines + 1;
+			rc = slic_read_reg(line, SI_REG_IRQ1, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_FSKBUF_AVAIL_IA)
+				do_fsk(line);
+			break;
+
+		case 5:
+			line = slic->lines + 1;
+			rc = slic_read_reg(line, SI_REG_IRQ2, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_RXMDM_IA)
+				event_modem_detect(line);
+
+			if (data & SI_VAL_TXMDM_IA)
+				event_modem_detect(line);
+
+			if (data & SI_VAL_DTMF_IA)
+				event_dtmf_detect(line);
+
+			if (data & SI_VAL_LCR_IA)
+				event_hook_detect(line);
+			break;
+
+		case 6:
+			line = slic->lines + 1;
+			rc = slic_read_reg(line, SI_REG_IRQ3, &data);
+			if (rc)
+				return;
+
+			if (data & SI_VAL_P_TERM_IA)
+				event_error_detect(line, 0);
+			break;
+
+		case 7:
+			line = slic->lines + 1;
+			rc = slic_read_reg(line, SI_REG_IRQ4, &data);
+			if (rc)
+				return;
+
+			break;
+		}
+	}
+}
+
+
diff --git a/drivers/staging/si3226x/si3226x_hw.h b/drivers/staging/si3226x/si3226x_hw.h
new file mode 100644
index 0000000..9900591
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_hw.h
@@ -0,0 +1,219 @@
+/*
+ * si3226x_hw.h
+ *
+ *  Created on: 14.03.2012
+ *      Author: Michail Kurochkin
+ */
+
+#ifndef SI3226X_HW_H_
+#define SI3226X_HW_H_
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/interrupt.h>
+#include "si3226x_drv.h"
+
+/* define slic ram registers */
+#define SI_RAM_ADDR_HI 5
+#define SI_RAM_DATA_B0 6
+#define SI_RAM_DATA_B1 7
+#define SI_RAM_DATA_B2 8
+#define SI_RAM_DATA_B3 9
+#define SI_RAM_ADDR_LO 10
+
+#define SI_RAM_OSC1FREQ 26
+#define SI_RAM_OSC1AMP 27
+#define SI_RAM_OSC1PHAS 28
+#define SI_RAM_OSC2FREQ 29
+#define SI_RAM_OSC2AMP 30
+#define SI_RAM_OSC2PHAS 31
+
+#define SI_RAM_FSKAMP0 836
+#define SI_RAM_FSKAMP1 837
+#define SI_RAM_FSKFREQ0 834
+#define SI_RAM_FSKFREQ1 835
+#define SI_RAM_FSK01 838
+#define SI_RAM_FSK10 839
+
+#define SI_RAM_PRAM_ADDR 1358
+#define SI_RAM_PRAM_DATA 1359
+
+#define SI_RAM_PD_DCDC 1538
+
+/* define slic ram values */
+#define SI_RAM_VAL_REG (u32)(1 << 23)
+#define SI_RAM_VAL_OFF (u32)(1 << 20)
+
+/* define slic registers */
+#define SI_REG_MSTRSTAT 3
+#define SI_REG_RAMSTAT 4
+
+#define SI_REG_PCMMODE 11
+#define SI_REG_PCMTXLO 12
+#define SI_REG_PCMTXHI 13
+#define SI_REG_PCMRXLO 14
+#define SI_REG_PCMRXHI 15
+
+#define SI_REG_IRQ0 17
+#define SI_REG_IRQ1 18
+#define SI_REG_IRQ2 19
+#define SI_REG_IRQ3 20
+#define SI_REG_IRQ4 21
+
+#define SI_REG_IRQEN1 22
+#define SI_REG_IRQEN2 23
+#define SI_REG_IRQEN3 24
+#define SI_REG_IRQEN4 25
+
+#define SI_REG_CALR3 29
+
+#define SI_REG_LINEFEED 30
+
+#define SI_REG_LCRRTP 34
+
+#define SI_REG_DIGCON 44
+#define SI_REG_OMODE 48
+#define SI_REG_OCON 49
+#define SI_REG_TONEN 62
+
+#define SI_REG_O1TALO 50
+#define SI_REG_O1TAHI 51
+#define SI_REG_O1TILO 52
+#define SI_REG_O1TIHI 53
+#define SI_REG_O2TALO 54
+#define SI_REG_O2TAHI 55
+#define SI_REG_O2TILO 56
+#define SI_REG_O2TIHI 57
+
+#define SI_REG_FSKDAT 58
+#define SI_REG_FSKDEPTH 59
+#define SI_REG_TONDTMF 60
+
+#define SI_REG_JMPEN 81
+#define SI_REG_JMP0LO 82
+#define SI_REG_JMP7HI 97
+#define SI_REG_UAM 126
+
+
+/* define slic register values */
+#define SI_VAL_FSKBUF_AVAIL_IA ((u8)0x40)
+#define SI_VAL_RXMDM_IA ((u8)0x80)
+#define SI_VAL_TXMDM_IA ((u8)0x40)
+#define SI_VAL_DTMF_IA ((u8)0x10)
+#define SI_VAL_LCR_IA ((u8)0x2)
+#define SI_VAL_P_TERM_IA ((u8)0x2)
+#define SI_VAL_HYB_DIS ((u8)0x10)
+#define SI_VAL_CAL_EN ((u8)0x80)
+#define SI_VAL_ROUTING_1_3 ((u8)0x3)
+#define SI_VAL_ROUTING_1_2 ((u8)0x2)
+#define SI_VAL_ROUTING_2_3 ((u8)0x30)
+#define SI_VAL_OSC1_TA_EN ((u8)0x4)
+#define SI_VAL_OSC1_TI_EN ((u8)0x2)
+#define SI_VAL_OSC1_EN ((u8)0x1)
+#define SI_VAL_OSC2_TA_EN ((u8)0x40)
+#define SI_VAL_OSC2_TI_EN ((u8)0x20)
+#define SI_VAL_OSC2_EN ((u8)0x10)
+
+#define SI_VAL_VALID ((u8)0x20)
+
+#define SI_VAL_ZERO_EN_1 ((u8)0x4)
+#define SI_VAL_ZERO_EN_2 ((u8)0x40)
+
+#define SI_VAL_OSC1_FSK ((u8)0x8)
+
+#define SI_VAL_FSK_FLUSH ((u8)0x8)
+#define SI_VAL_FSKBUF_DEPTH_7 ((u8)0x7)
+
+#define SI_VAL_PCM_EN ((u8)0x10)
+#define SI_VAL_PCM_FMT_0 ((u8)0x0)
+#define SI_VAL_PCM_FMT_1 ((u8)0x1)
+
+#define SI_VAL_PCM_ALAW_0 ((u8)0x0)
+#define SI_VAL_PCM_ALAW_1 ((u8)0x4)
+#define SI_VAL_PCM_ALAW_2 ((u8)0x8)
+#define SI_VAL_PCM_ALAW_3 ((u8)0xC)
+
+#define SI_VAL_LCR ((u8)0x2)
+
+#define SI_VAL_EN_SYNC_1 ((u8)0x8)
+#define SI_VAL_EN_SYNC_2 ((u8)0x80)
+
+/*
+ * si3226x hardware line states
+ */
+enum fxs_states {
+        SI_FXS_OPEN,
+        SI_FXS_FORWARD_ACTIVE,
+        SI_FXS_FORWARD_OHT,
+        SI_FXS_TIP_OPEN,
+        SI_FXS_RINGING,
+        SI_FXS_REVERSE_ACTIVE,
+        SI_FXS_REVERSE_OHT,
+        SI_FXS_RING_OPEN,
+};
+
+/*
+ * registers content for generate one DTMF digit
+ */
+struct si3226x_dtmf_digit {
+        u32 osc1amp;
+        u32 osc2amp;
+        u32 osc1freq;
+        u32 osc2freq;
+};
+
+/*
+ * ATS answer tone register values
+ */
+struct si3226x_timer_regs {
+        u32 osc_amp;
+        u32 osc_freq;
+        u8 o_talo;
+        u8 o_tahi;
+        u8 o_tilo;
+        u8 o_tihi;
+        u8 o_con;
+};
+
+/*
+ * ATS answer tone types
+ */
+enum tone_types {
+        SI_TONE_INVITATION,
+        SI_TONE_BUSY,
+        SI_TONE_WAIT,
+        SI_TONE_NONE,
+};
+
+
+/*
+ * si3226x hardware errors
+ */
+enum si3226x_errors {
+        SI_ERR_TERMAL_SHOCK,
+};
+
+
+int init_slic(struct si3226x_slic *slic);
+int deinit_slic(struct si3226x_slic *slic);
+int slic_setup_audio(struct si3226x_line *line);
+int slic_set_companding_mode(struct si3226x_line *line, u8 companding_mode);
+int slic_set_line_state(struct si3226x_line *line, int state);
+int slic_line_call(struct si3226x_line *line, u8 *callerid_buf, int size);
+int slic_get_dtmf_data(struct si3226x_line *line, char *data);
+int slic_send_dtmf_digit(struct si3226x_line *line, char ch);
+int slic_calibrate(struct si3226x_line *line);
+int slic_enable_echo(struct si3226x_line *line);
+int slic_disable_echo(struct si3226x_line *line);
+irqreturn_t slic_irq(s32 irq, void *context_data);
+int slic_unlock_channel(struct si3226x_line *line);
+int slic_lock_channel(struct si3226x_line *line);
+int slic_write_ram(struct si3226x_line *line, u16 addr, u32 value);
+int slic_write_reg(struct si3226x_line *line, u8 addr, u8 data);
+void slic_irq_callback(struct work_struct *work);
+
+#ifdef CONFIG_SI3226X_POLLING
+void slic_delayed_work(struct delayed_work *work);
+#endif
+
+#endif /* SI3226X_HW_H_ */
diff --git a/drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c b/drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c
new file mode 100644
index 0000000..998bc8a
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c
@@ -0,0 +1,176 @@
+/*
+** Generated from si3226x_patch_C_FB_2011MAY19.dsp_prom
+** Based on design file si32260C_firmware_1_0_0_4_20110517
+** on 05-19-2011 at 14:58:49
+** Patch ID = 0x1004C000
+*/
+
+const u32 si3226x_patch_data[] =
+{
+	141541L,
+	540867L,
+	141541L,
+	543427L,
+	141541L,
+	553155L,
+	141541L,
+	577731L,
+	141541L,
+	579779L,
+	141541L,
+	581315L,
+	141541L,
+	581827L,
+	141541L,
+	582339L,
+	141541L,
+	582851L,
+	141541L,
+	583363L,
+	141541L,
+	583875L,
+	141541L,
+	584387L,
+	141541L,
+	584899L,
+	141541L,
+	585411L,
+	141541L,
+	585923L,
+	141541L,
+	586435L,
+	736L,
+	491712L,
+	452200L,
+	141541L,
+	491200L,
+	5733L,
+	524290L,
+	142565L,
+	550083L,
+	3685L,
+	519266L,
+	5220L,
+	144098L,
+	550083L,
+	3685L,
+	524291L,
+	141541L,
+	551619L,
+	5221L,
+	3682L,
+	524292L,
+	5L,
+	141541L,
+	135362L,
+	98021L,
+	727745L,
+	474213L,
+	17637L,
+	557251L,
+	101093L,
+	557251L,
+	473701L,
+	515653L,
+	843365L,
+	188002L,
+	843355L,
+	145125L,
+	560835L,
+	524290L,
+	660069L,
+	518053L,
+	517224L,
+	518244L,
+	142565L,
+	564419L,
+	524288L,
+	521733L,
+	843365L,
+	188002L,
+	524315L,
+	145125L,
+	568003L,
+	843365L,
+	522850L,
+	523387L,
+	147685L,
+	573123L,
+	522363L,
+	145125L,
+	575171L,
+	521826L,
+	141541L,
+	575683L,
+	518757L,
+	521826L,
+	141541L,
+	575683L,
+	521824L,
+	522245L,
+	522338L,
+	141541L,
+	716481L,
+	173669L,
+	523845L,
+	141541L,
+	730304L,
+	523877L,
+	141541L,
+	690368L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	524293L,
+	0L
+};
+
+const u16 si3226x_patch_entries[] =
+{
+	950,
+	4347,
+	3431,
+	1425,
+	1347,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0,
+	0
+};
+
+const u16 si3226x_patch_support_addr[] =
+{
+	925,
+	926,
+	1014,
+	1020,
+	1021,
+	1022,
+	0
+};
+
+const u32 si3226x_patch_support_data[] =
+{
+	0xA00000L,
+	0x1F00000L,
+	0x2D8000L,
+	0x0L,
+	0x1A9FBDAL,
+	0x1C28F4EL,
+	0x0L
+};
+
diff --git a/drivers/staging/si3226x/si3226x_setup.c b/drivers/staging/si3226x/si3226x_setup.c
new file mode 100644
index 0000000..a8a706b
--- /dev/null
+++ b/drivers/staging/si3226x/si3226x_setup.c
@@ -0,0 +1,1413 @@
+
+int slic_load_settings(struct si3226x_slic *slic)
+{
+	int rc = 0;
+	struct si3226x_line *lines = slic->lines;
+	
+	rc = slic_unlock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 47, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 80, 0x2F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 764, 0x0020C480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 768, 0x051EB82A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 767, 0x03D70A20);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 915, 0x0FFF0000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 916, 0x01999A00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 919, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 920, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 970, 0x00800000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1004, 0x00F18900);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1005, 0x00809D80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1006, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1007, 0x01C00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1540, 0x00400000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1541, 0x00400000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1542, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1545, 0x00500000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1546, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1547, 0x00500000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1553, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1554, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1558, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1560, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1585, 0x00300000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1586, 0x00300000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1587, 0x00100000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1588, 0x00FFC000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1589, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1590, 0x0FDA4000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 759, 0x07FEB800);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 756, 0x005B05B2);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 73, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 967, 0x03A2E8BA);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1018, 0x03000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1017, 0x05000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1013, 0x01000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1012, 0x03700000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1011, 0x04B80200);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1010, 0x00823000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 68, 0x60);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 98, 0x80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 533, 0x71EB851);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 626, 0x723F235);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 627, 0x57A9804);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 918, 0x0036000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1616, 0x1100000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 973, 0xFFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 975, 0xE49BA5);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 516, 0x10038D);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 513, 0x4EDDB9);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 514, 0x0806D6);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1641, 0x200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1643, 0x000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1565, 0xC00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 750, 0x206280);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 971, 0x1F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 972, 0x51EB80);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 47, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 80, 0x2F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 764, 0x0020C480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 768, 0x051EB82A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 767, 0x03D70A20);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 915, 0x0FFF0000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 916, 0x01999A00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 919, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 920, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 970, 0x00800000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1004, 0x00F18900);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1005, 0x00809D80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1006, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1007, 0x01C00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1540, 0x00400000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1541, 0x00400000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1542, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1545, 0x00500000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1546, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1547, 0x00500000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1553, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1554, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1558, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1560, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1585, 0x00300000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1586, 0x00300000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1587, 0x00100000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1588, 0x00FFC000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1589, 0x00F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1590, 0x0FDA4000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 759, 0x07FEB800);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 756, 0x005B05B2);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 73, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 967, 0x03A2E8BA);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1018, 0x03000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1017, 0x05000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1013, 0x01000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1012, 0x03700000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1011, 0x04B80200);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1010, 0x00823000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 68, 0x60);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 98, 0x80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 533, 0x71EB851);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 626, 0x723F235);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 627, 0x57A9804);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 918, 0x0036000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1616, 0x1100000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 973, 0xFFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 975, 0xE49BA5);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 516, 0x10038D);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 513, 0x4EDDB9);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 514, 0x0806D6);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1641, 0x200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1643, 0x000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1565, 0xC00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 750, 0x206280);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 971, 0x1F00000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 972, 0x51EB80);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 27, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 28, 0x01);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 27, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 28, 0x01);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1548, 0x00800000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 30, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 47, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1538, 0x700000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1555, 0x100000);
+	if (rc)
+		return rc;
+	
+    msleep(100);
+    
+	rc = slic_write_ram(lines + 0, 1538, 0x600000);
+	if (rc)
+		return rc;
+	
+    msleep(500);
+    
+	rc = slic_write_ram(lines + 0, 1551, 0x000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1538, 0x400000);
+	if (rc)
+		return rc;
+	
+    msleep(500);
+    
+	rc = slic_lock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1548, 0x00800000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 30, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 47, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1538, 0x700000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1555, 0x100000);
+	if (rc)
+		return rc;
+	
+    msleep(100);
+    
+	rc = slic_write_ram(lines + 1, 1538, 0x600000);
+	if (rc)
+		return rc;
+	
+    msleep(500);
+    
+	rc = slic_write_ram(lines + 1, 1551, 0x000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1538, 0x400000);
+	if (rc)
+		return rc;
+	
+    msleep(500);
+    
+	rc = slic_lock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 27, 0xC0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 28, 0x18);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 27, 0xC0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 28, 0x18);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 47, 0x10);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 80, 0x3F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 46, 0x04);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 47, 0x10);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 80, 0x3F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 46, 0x04);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 540, 0x07F97D80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 541, 0x0006CC00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 542, 0x1FFC1480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 543, 0x1FFC7B80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 546, 0x07F36B80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 547, 0x000A8E00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 548, 0x1FF90F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 549, 0x1FFAE500);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 563, 0x001AF400);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 564, 0x1FC86A80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 565, 0x01E9AE00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 566, 0x00652F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 567, 0x01F4AF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 568, 0x1F57E000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 569, 0x00485E00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 570, 0x1FF3A680);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 571, 0x1FF83700);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 572, 0x00011D00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 573, 0x01706980);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 574, 0x066A8480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 653, 0x00920F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 654, 0x1EE31980);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 655, 0x008ADF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 656, 0x0F92E500);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 657, 0x186CE880);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 45, 0x53);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 544, 0x085C6880);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 906, 0x013E3100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 545, 0x013E3100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 658, 0x07AF6F80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 659, 0x18509100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 660, 0x075EDF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 27, 0x40);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 28, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 540, 0x07F97D80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 541, 0x0006CC00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 542, 0x1FFC1480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 543, 0x1FFC7B80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 546, 0x07F36B80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 547, 0x000A8E00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 548, 0x1FF90F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 549, 0x1FFAE500);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 563, 0x001AF400);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 564, 0x1FC86A80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 565, 0x01E9AE00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 566, 0x00652F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 567, 0x01F4AF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 568, 0x1F57E000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 569, 0x00485E00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 570, 0x1FF3A680);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 571, 0x1FF83700);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 572, 0x00011D00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 573, 0x01706980);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 574, 0x066A8480);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 653, 0x00920F00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 654, 0x1EE31980);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 655, 0x008ADF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 656, 0x0F92E500);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 657, 0x186CE880);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 45, 0x53);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 544, 0x085C6880);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 906, 0x013E3100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 545, 0x013E3100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 658, 0x07AF6F80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 659, 0x18509100);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 660, 0x075EDF00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 26, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 27, 0x40);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 28, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_calibrate(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 755, 0x00050000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 844, 0x07EFE000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 845, 0x001B9F2E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 846, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 843, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 637, 0x15E5200E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 860, 0x00D16348);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 848, 0x0068E9B4);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 847, 0x0FFFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 850, 0x00006000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 849, 0x00006000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 753, 0x00C49BA0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 896, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 768, 0x051EB82A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 39, 0x80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 40, 0x3E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 41, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 42, 0x7D);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 920, 0x01893740);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 38, 0x98);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 66, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 749, 0x02AC55FE);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 482, 0x02AC55FE);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 483, 0x003126E8);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 972, 0x00FFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 974, 0x0083126A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 975, 0x009374B8);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 1560, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 755, 0x00050000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 844, 0x07EFE000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 845, 0x001B9F2E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 846, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 843, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 637, 0x15E5200E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 860, 0x00D16348);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 848, 0x0068E9B4);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 847, 0x0FFFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 850, 0x00006000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 849, 0x00006000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 753, 0x00C49BA0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 896, 0x00000000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 768, 0x051EB82A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 39, 0x80);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 40, 0x3E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 41, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 42, 0x7D);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 920, 0x01893740);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 38, 0x98);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 66, 0x00);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 749, 0x02AC55FE);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 482, 0x02AC55FE);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 483, 0x003126E8);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 972, 0x00FFFFFF);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 974, 0x0083126A);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 975, 0x009374B8);
+	if (rc)
+		return rc;
+	
+	rc = slic_unlock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 1560, 0x00200000);
+	if (rc)
+		return rc;
+	
+	rc = slic_lock_channel(lines + 1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 634, 0x1C8A024C);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 635, 0x1F909679);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 636, 0x0040A0E0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 638, 0x1D5B21A9);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 639, 0x1DD87A3E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 640, 0x05A38633);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 641, 0x050D2839);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 642, 0x03FE7F0F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 643, 0x00B4F3C3);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 644, 0x005D0FA6);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 645, 0x002D8D96);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 853, 0x005B0AFB);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 852, 0x006D4060);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 701, 0x00008000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 858, 0x0048D595);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 859, 0x003FBAE2);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 702, 0x00008000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 854, 0x000F0000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 855, 0x00080000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 856, 0x00140000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 857, 0x00140000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 748, 0x01BA5E35);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 752, 0x0051EB85);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 0, 751, 0x00418937);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 634, 0x1C8A024C);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 635, 0x1F909679);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 636, 0x0040A0E0);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 638, 0x1D5B21A9);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 639, 0x1DD87A3E);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 640, 0x05A38633);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 641, 0x050D2839);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 642, 0x03FE7F0F);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 643, 0x00B4F3C3);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 644, 0x005D0FA6);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 645, 0x002D8D96);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 853, 0x005B0AFB);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 852, 0x006D4060);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 701, 0x00008000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 858, 0x0048D595);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 859, 0x003FBAE2);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 702, 0x00008000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 854, 0x000F0000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 855, 0x00080000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 856, 0x00140000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 857, 0x00140000);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 748, 0x01BA5E35);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 752, 0x0051EB85);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_ram(lines + 1, 751, 0x00418937);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 0, 30, 0x1);
+	if (rc)
+		return rc;
+	
+	rc = slic_write_reg(lines + 1, 30, 0x1);
+	if (rc)
+		return rc;
+	
+	return rc;
+}
+
diff --git a/drivers/staging/si3226x/slic_dtmf_table.c b/drivers/staging/si3226x/slic_dtmf_table.c
new file mode 100644
index 0000000..e0923db
--- /dev/null
+++ b/drivers/staging/si3226x/slic_dtmf_table.c
@@ -0,0 +1,127 @@
+
+/*
+ * dtmf table for convert DTMF - ASCII
+ */
+char dtmf_codes[] = {"D1234567890*#ABC"};
+
+
+/*
+ * si3226x DTMF tone registers configure per digit
+ */
+struct si3226x_dtmf_digit slic_dtmf_table[] =
+{
+	
+    {  // D
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0xb2c000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x5e9c000,
+    },
+	
+    {  // 1
+        .osc1amp = 0xed2000,
+        .osc2amp = 0x818000,
+        .osc1freq = 0x4a82000,
+        .osc2freq = 0x6d4c000,
+    },
+	
+    {  // 2
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0x818000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x6d4c000,
+    },
+	
+    {  // 3
+        .osc1amp = 0x12e4000,
+        .osc2amp = 0x818000,
+        .osc1freq = 0x331e000,
+        .osc2freq = 0x6d4c000,
+    },
+	
+    {  // 4
+        .osc1amp = 0xed2000,
+        .osc2amp = 0x900000,
+        .osc1freq = 0x4a82000,
+        .osc2freq = 0x694e000,
+    },
+	
+    {  // 5
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0x900000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x694e000,
+    },
+	
+    {  // 6
+        .osc1amp = 0x12e4000,
+        .osc2amp = 0x900000,
+        .osc1freq = 0x331e000,
+        .osc2freq = 0x694e000,
+    },
+	
+    {  // 7
+        .osc1amp = 0xed2000,
+        .osc2amp = 0xa06000,
+        .osc1freq = 0x4a82000,
+        .osc2freq = 0x6466000,
+    },
+	
+    {  // 8
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0xa06000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x6466000,
+    },
+	
+    {  // 9
+        .osc1amp = 0x12e4000,
+        .osc2amp = 0xa06000,
+        .osc1freq = 0x331e000,
+        .osc2freq = 0x6466000,
+    },
+	
+    {  // 0
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0xb2c000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x5e9c000,
+    },
+	
+    {  // *
+        .osc1amp = 0xed2000,
+        .osc2amp = 0xb2c000,
+        .osc1freq = 0x4a82000,
+        .osc2freq = 0x5e9c000,
+    },
+	
+    {  // #
+        .osc1amp = 0x10b0000,
+        .osc2amp = 0xb2c000,
+        .osc1freq = 0x3fc6000,
+        .osc2freq = 0x5e9c000,
+    },
+	
+    {  // A
+        .osc1amp = 0x1586000,
+        .osc2amp = 0x818000,
+        .osc1freq = 0x2464000,
+        .osc2freq = 0x6d4c000,
+    },
+	
+    {  // B
+        .osc1amp = 0x1586000,
+        .osc2amp = 0x900000,
+        .osc1freq = 0x2464000,
+        .osc2freq = 0x694e000,
+    },
+	
+    {  // C
+        .osc1amp = 0x1586000,
+        .osc2amp = 0xa06000,
+        .osc1freq = 0x2464000,
+        .osc2freq = 0x6466000,
+    },
+	
+};
+
diff --git a/include/linux/slic_si3226x.h b/include/linux/slic_si3226x.h
new file mode 100644
index 0000000..e046140
--- /dev/null
+++ b/include/linux/slic_si3226x.h
@@ -0,0 +1,75 @@
+/*
+ * si3226x.h
+ *
+ *  Created on: 02.03.2012
+ *      Author: Michail Kurochkin
+ */
+
+#ifndef SLIC_SI3226X_H_
+#define SLIC_SI3226X_H_
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#define SI3226X_MAX_CHANNELS 2 // Count channels
+
+#define SI3226X_IOC_MAGIC 0xde
+
+// SLIC control methods
+#define SI3226X_SET_COMPANDING_MODE  _IO(SI3226X_IOC_MAGIC, 0)
+#define SI3226X_SET_CALLERID_MODE		_IO(SI3226X_IOC_MAGIC, 1)
+
+// Line control methods
+#define SI3226X_SET_ECHO_CANCELATION _IO(SI3226X_IOC_MAGIC, 10)
+#define SI3226X_SET_LINE_STATE 		_IO(SI3226X_IOC_MAGIC, 11)
+#define SI3226X_CALL					 		_IO(SI3226X_IOC_MAGIC, 12)
+#define SI3226X_SEND_DTMF		 		_IO(SI3226X_IOC_MAGIC, 13)
+#define SI3226X_GET_HOOK_STATE 		_IO(SI3226X_IOC_MAGIC, 14)
+#define SI3226X_GET_DTMF_DIGIT 		_IO(SI3226X_IOC_MAGIC, 15)
+#define SI3226X_GET_AUDIO_BLOCK_SIZE _IO(SI3226X_IOC_MAGIC, 16)
+#define SI3226X_ENABLE_AUDIO 			_IO(SI3226X_IOC_MAGIC, 17)
+#define SI3226X_DISABLE_AUDIO 		_IO(SI3226X_IOC_MAGIC, 18)
+
+/*
+ * conteiner for transfer caller id data over ioctl
+ */
+struct si3226x_caller_id {
+	u8 *data;
+	int size;
+};
+
+
+/*
+ * audio compaunding modes
+ */
+enum companding_modes {
+	SI_ALAW,
+	SI_MLAW,
+};
+
+
+/*
+ * Board specific data for setup driver SLIC Silabs si3226x
+ */
+struct si3226x_platform_data {
+	int reset_gpio; // number GPIO for reset SLIC
+	int int_gpio; // number GPIO for interrupt SLIC
+
+	/*
+	 *  fxs_tdm_ch array FXS channels.
+	 *  one item is a number of tdm channel number for
+	 *  corresponding FXS channel.
+	 *  if fxs_tdm_ch[x] == -1 then disable this FXS port
+	 */
+	int fxs_tdm_ch[SI3226X_MAX_CHANNELS];
+
+	/**
+	 * spi chip select requested for si3226x
+	 */
+	u16 spi_chip_select;
+
+	enum companding_modes companding_mode;
+};
+
+#endif /* SLIC_SI3226X_H_ */
-- 
1.7.5.4

