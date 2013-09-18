Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab3IRQLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:11:13 -0400
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:34582 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751537Ab3IRQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:11:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:4117:4250:4321:5007:6119:6120:7652:7875:7903:904
X-HE-Tag: cord26_610f1e59d4c4f
X-Filterd-Recvd-Size: 6362
Message-ID: <1379520665.1787.40.camel@joe-AO722>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
From: Joe Perches <joe@perches.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Date: Wed, 18 Sep 2013 09:11:05 -0700
In-Reply-To: <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
	 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 17:56 +0200, Michal Simek wrote:
> This new subsystem should unify all fpga drivers which
> do the same things. Load configuration data to fpga
> or another programmable logic through common interface.
> It doesn't matter if it is MMIO device, gpio bitbanging,
> etc. connection. The point is to have the same
> inteface for these drivers.

Is this really a "driver".
Perhaps it's more of a core kernel function
and belongs in kernel.

> diff --git a/drivers/fpga/fpga-mgr.c b/drivers/fpga/fpga-mgr.c

The error messages are a little shouty with all
the unnecessary "!" uses.  

[]

> +/**
> + * fpga_mgr_read - Read data from fpga
> + * @mgr: Pointer to the fpga manager structure
> + * @buf: Pointer to the buffer location
> + * @count: Pointer to the number of copied bytes
> + *
> + * Function reads fpga bitstream and copy them to output buffer.
> + *
> + * Returns the number of bytes copied to @buf, a negative error number otherwise
> + */
> +static int fpga_mgr_read(struct fpga_manager *mgr, char *buf, ssize_t *count)
> +{
> +	int ret;
> +
> +	if (test_and_set_bit_lock(FPGA_MGR_DEV_BUSY, &mgr->flags))
> +		return -EBUSY;
> +
> +	if (!mgr->mops || !mgr->mops->read) {
> +		dev_err(mgr->dev,
> +			"Controller doesn't support read operations!\n");
> +		return -EPERM;
> +	}
> +
> +	if (mgr->mops->read_init) {
> +		ret = mgr->mops->read_init(mgr);
> +		if (ret) {
> +			dev_err(mgr->dev, "Failed in read-init!\n");
> +			return ret;
> +		}
> +	}
> +
> +	if (mgr->mops->read) {
> +		ret = mgr->mops->read(mgr, buf, count);
> +		if (ret) {
> +			dev_err(mgr->dev, "Failed to read firmware!\n");
> +			return ret;
> +		}
> +	}
> +
> +	if (mgr->mops->read_complete) {
> +		ret = mgr->mops->read_complete(mgr);
> +		if (ret) {
> +			dev_err(mgr->dev, "Failed in read-complete!\n");
> +			return ret;
> +		}
> +	}
> +
> +	clear_bit_unlock(FPGA_MGR_DEV_BUSY, &mgr->flags);
> +
> +	return 0;
> +}
> +
> +/**
> + * fpga_mgr_attr_read - Read data from fpga
> + * @dev: Pointer to the device structure
> + * @attr: Pointer to the device attribute structure
> + * @buf: Pointer to the buffer location
> + *
> + * Function reads fpga bitstream and copy them to output buffer
> + *
> + * Returns the number of bytes copied to @buf, a negative error number otherwise
> + */
> +static ssize_t fpga_mgr_attr_read(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> +	ssize_t count;
> +	int ret;
> +
> +	if (mgr && mgr->fpga_read)
> +		ret = mgr->fpga_read(mgr, buf, &count);
> +
> +	return ret == 0 ? count : -EPERM;

EPERM isn't the only error return from fpga_read.

> +}
> +
> +/**
> + * fpga_mgr_write - Write data to fpga
> + * @mgr: Pointer to the fpga manager structure
> + * @fw_name: Pointer to the buffer location with bistream firmware filename
> + *
> + * @buf contains firmware filename which is loading through firmware
> + * interface and passed to the fpga driver.
> + *
> + * Returns string lenght added to @fw_name, a negative error number otherwise
> + */
> +static int fpga_mgr_write(struct fpga_manager *mgr, const char *fw_name)
> +{
> +	int ret = 0;
> +	const struct firmware *fw;
> +
> +	if (!fw_name || !strlen(fw_name)) {
> +		dev_err(mgr->dev, "Firmware name is not specified!\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!mgr->mops || !mgr->mops->write) {
> +		dev_err(mgr->dev,
> +			"Controller doesn't support write operations!\n");
> +		return -EPERM;

I think you should revisit the return codes.


> +/**
> + * fpga_mgr_attr_write - Write data to fpga
> + * @dev: Pointer to the device structure
> + * @attr: Pointer to the device attribute structure
> + * @buf: Pointer to the buffer location with bistream firmware filename
> + * @count: Number of characters in @buf
> + *
> + * @buf contains firmware filename which is loading through firmware
> + * interface and passed to the fpga driver.
> + *
> + * Returns string lenght added to @buf, a negative error number otherwise
> + */
> +static ssize_t fpga_mgr_attr_write(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct fpga_manager *mgr = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (mgr && mgr->fpga_write)
> +		ret = mgr->fpga_write(mgr, buf);
> +
> +	return ret == 0 ? strlen(buf) : -EPERM;
> +}

Same -EPERM issue as read

> +	mgr = devm_kzalloc(&pdev->dev, sizeof(*mgr), GFP_KERNEL);
> +	if (!mgr) {
> +		dev_err(&pdev->dev, "Failed to alloc mgr struct!\n");

Unnecessary OOM message as there's a general dump_stack()
already done on any OOM without GFP_NOWARN

> diff --git a/include/linux/fpga.h b/include/linux/fpga.h
[]
> +struct fpga_manager {
> +	char name[48];

Maybe a #define instead of 48?


