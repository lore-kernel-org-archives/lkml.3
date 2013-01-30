Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3A3N2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:28:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3A3N2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:28:43 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Kurachkin Michail <Michail.Kurachkin@promwad.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>
Subject: Re: TDM bus support in Linux Kernel [PATCH]
Date: Wed, 30 Jan 2013 14:28:47 +0100
Message-ID: <1803515.qlJg32fkH4@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
References: <F7F628C32E67B04DAECC5CA53521253E5FAB15CE@sv-exmb01-lo1.promwad.corp>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013 12:37:25 Kurachkin Michail wrote:
> Hi Greg,
> 
> I followed your recommendations and created a diff using Linux 3.8-rc5 sources. Please review it and give your comments.

Part #3

+/*
+ * method "open" for character device
+ */
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
+		switch (chr_dev->type) {
+		case SLIC_CHR_DEV:
+			slic = dev_get_drvdata(chr_dev->dev);
+
+			if (slic->devt != inode->i_rdev)
+				continue;;
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
+				status = -ENOMEM;

memory leak of line->rx_buffer

+				goto out;
+			}
+
+			/* store pointer to transmit wait_queue_head_t for use in poll() */
+			ch = tdm_dev->ch;
+			line->tx_wait_queue = &ch->tx_queue;
+			line->rx_wait_queue = &ch->rx_queue;
+			line->file_opened = 1;
+			status = 0;
+
+			break;
+		}
+
+		file->private_data = chr_dev;
+		status = 0;
+		goto out;

a bit pointless

+	}
+
+out:
+	mutex_unlock(&slic_chr_dev_lock);
+	return status;
+}

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
+		status = -EPERM;

-EPERM?

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
+		rc = -ENODATA;
+		goto out;
+	}
+
+	rc = tdm_recv(tdm_dev, line->rx_buffer);
+	if (rc) {
+		rc = -EFAULT;

EFAULT is usually not what you return upon a read error.

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
