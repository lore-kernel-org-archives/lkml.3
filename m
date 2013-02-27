Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3B0QWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:22:48 -0500
Received: from mx2.promwad.com ([91.149.128.90]:49853 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3B0QWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:22:47 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>
CC: Michail Kurachkin <michail.kurachkin@promwad.com>
Subject: [PATCH 0/9] Support of TDM bus, TDM driver for Marvell Kirkwood and SLIC driver for Silabs Si3226x
Date: Wed, 27 Feb 2013 19:22:32 +0300
Message-ID: <1361982152-5131-1-git-send-email-michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi guys,

Thanks for your comments. Most of them were considered while I worked on the second revision of code. 
The most huge change includes rework of register/unregister and request/release voice channel related code.
The following are my replies on the disputable comments.


1)
+static int slic_chr_open(struct inode *inode, struct file *file)
+{
+ struct slic_chr_dev *chr_dev;
+ struct si3226x_slic *slic;
+ struct si3226x_line *line;
+ struct tdm_device *tdm_dev;
+ struct tdm_voice_channel *ch;
+ int status = -ENXIO;
+
+ mutex_lock(&slic_chr_dev_lock);
+
+ list_for_each_entry(chr_dev, &slic_chr_dev_list, list) {
+  switch (chr_dev->type) {
+  case SLIC_CHR_DEV:
+   slic = dev_get_drvdata(chr_dev->dev);

Ryan Mallon> It's a bit clunky having two device types on the same character device. Is there a better way to do this?

SLIC has two different types of configuration structures: general settings and channel specific.
There are 2 channels. For each of them I created one struct device. And one struct device more for the whole SLIC.



2) 
+slic_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+ struct slic_chr_dev *chr_dev = file->private_data;
+ struct si3226x_slic *slic;
+ struct si3226x_line *line;
+ int status = -ENXIO;
+
+ if (_IOC_TYPE(cmd) != SI3226X_IOC_MAGIC)
+  return -ENOTTY;
+
+ mutex_lock(&slic_chr_dev_lock);

Ryan Mallon> This locking is very heavy handed. You are holding it across the entire open, close, read, write, ioctl, and it is protecting a bunch of different things. Can you make the
locking a bit more fine grained?

Agreed. Will do it later when I will be able to test it as I currently have no suitable hardware.



3) 
+/*
+ * probe tdm driver
+ */
+static int probe_tdm_slic(struct tdm_device *tdm_dev)
+{
+ struct si3226x_slic *slic;
+ int rc;
+
+ dev_dbg(&tdm_dev->dev, "probe\n");
+
+ mutex_lock(&dev_list_lock);
+
+ rc = add_to_slic_devices_list(&tdm_dev->dev, TDM_DEVICE);

Ryan Mallon> This function is the same as probe_spi_slic, except for the device type. A single function would prevent the code duplication.

I thought about that. This would lead to much more code because there is not really much such a code duplication.



4)
> +static irqreturn_t kirkwood_tdm_irq(s32 irq, void *context_data)
> +{
[skipped]
> +
> +     enum irq_event_mode {
> +             IRQ_RECEIVE,
> +             IRQ_TRANSMIT,
> +     };
> +
> +     status = readl(&regs->int_status);
> +
> +     if ((status & 0xFF) == 0)
> +             return ret;
> +
> +     /*  Check first 8 bit in status mask register for detect event type */
> +     for(i = 0; i < 8; i++) {
> +             if((status & (1 << i)) == 0)
> +                     continue;
> +
> +             writel(status & ~(1 << i), &regs->int_status);
> +
> +             switch(i) {
> +             case 0:
> +                     mode = IRQ_RECEIVE;
> +                     voice_num = 0;
> +                     overflow = 1;
> +                     break;
> +
[skipped]
> +
> +             case 7:
> +                     mode = IRQ_TRANSMIT;
> +                     voice_num = 1;
> +                     overflow = 0;
> +                     full = 0;
> +                     break;
> +             }


Oliver Neukum> Are you really sure that you cannot have multiple reasons for an interrupt at once?

Yes, this can be happened. Why is this problem? This code can handle multiple interrupt events at once.




5)
> +
> +
> +static int tdm_match_device(struct device *dev, struct device_driver *drv)
> +{
> +        const struct tdm_device *tdm_dev = to_tdm_device(dev);
> +
> +        return strcmp(tdm_dev->modalias, drv->name) == 0;
> +}

Oliver Neukum> This seems to preclude two devices bound to the same driver.

Why do you think this is the case? I tested such condition and it works ok.


Regards,
Michail



Michail Kurachkin (4):
  remove device_attribute
  added issues description in TODO file
  removing of buffer filling flag and also reverting old buffer related
    fix which is not really effective
  fixed e-mail address

Michail Kurochkin (5):
  Initial commit of TDM core
  Initial commit of Kirkwood TDM driver
  Initial commit of SLIC si3226x driver
  added TODO file for si3226x
  refactoring request/free voice channels

 drivers/staging/Kconfig                            |    4 +
 drivers/staging/Makefile                           |    4 +-
 drivers/staging/si3226x/Kconfig                    |    9 +
 drivers/staging/si3226x/Makefile                   |    4 +
 drivers/staging/si3226x/TODO                       |    8 +
 drivers/staging/si3226x/si3226x_drv.c              | 1323 +++++++++++++++
 drivers/staging/si3226x/si3226x_drv.h              |  188 +++
 drivers/staging/si3226x/si3226x_hw.c               | 1691 ++++++++++++++++++++
 drivers/staging/si3226x/si3226x_hw.h               |  219 +++
 .../staging/si3226x/si3226x_patch_C_FB_2011MAY19.c |  176 ++
 drivers/staging/si3226x/si3226x_setup.c            | 1413 ++++++++++++++++
 drivers/staging/si3226x/slic_dtmf_table.c          |  127 ++
 drivers/staging/si3226x/slic_si3226x.h             |   75 +
 drivers/staging/tdm/Kconfig                        |   38 +
 drivers/staging/tdm/Makefile                       |   19 +
 drivers/staging/tdm/kirkwood_tdm.c                 |  998 ++++++++++++
 drivers/staging/tdm/kirkwood_tdm.h                 |  112 ++
 drivers/staging/tdm/tdm.h                          |  293 ++++
 drivers/staging/tdm/tdm_core.c                     |  809 ++++++++++
 19 files changed, 7509 insertions(+), 1 deletions(-)
 create mode 100644 drivers/staging/si3226x/Kconfig
 create mode 100644 drivers/staging/si3226x/Makefile
 create mode 100644 drivers/staging/si3226x/TODO
 create mode 100644 drivers/staging/si3226x/si3226x_drv.c
 create mode 100644 drivers/staging/si3226x/si3226x_drv.h
 create mode 100644 drivers/staging/si3226x/si3226x_hw.c
 create mode 100644 drivers/staging/si3226x/si3226x_hw.h
 create mode 100644 drivers/staging/si3226x/si3226x_patch_C_FB_2011MAY19.c
 create mode 100644 drivers/staging/si3226x/si3226x_setup.c
 create mode 100644 drivers/staging/si3226x/slic_dtmf_table.c
 create mode 100644 drivers/staging/si3226x/slic_si3226x.h
 create mode 100644 drivers/staging/tdm/Kconfig
 create mode 100644 drivers/staging/tdm/Makefile
 create mode 100644 drivers/staging/tdm/kirkwood_tdm.c
 create mode 100644 drivers/staging/tdm/kirkwood_tdm.h
 create mode 100644 drivers/staging/tdm/tdm.h
 create mode 100644 drivers/staging/tdm/tdm_core.c

-- 
1.7.5.4

