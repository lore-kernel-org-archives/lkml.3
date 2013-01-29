Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889Ab3A2Lgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 06:36:49 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43350 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3A2Lgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 06:36:44 -0500
Date: Tue, 29 Jan 2013 12:36:27 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        Stefan Weinhuber <wein@de.ibm.com>
Subject: Re: [PATCH 8/9] dasd: Add 'timeout' attribute
Message-ID: <20130129113627.GB5984@osiris>
References: <1359443521-24670-1-git-send-email-hare@suse.de>
 <1359443521-24670-9-git-send-email-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359443521-24670-9-git-send-email-hare@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 13012911-2966-0000-0000-0000069521AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 08:12:00AM +0100, Hannes Reinecke wrote:
> This patch adds a 'timeout' attibute to the DASD driver.
> When set to non-zero, the blk_timeout function will
> be enabled with the timeout specified in the attribute.
> Setting 'timeout' to '0' will disable block timeouts.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

[...]

> +static ssize_t
> +dasd_timeout_store(struct device *dev, struct device_attribute *attr,
> +		   const char *buf, size_t count)
> +{
> +	struct dasd_device *device;
> +	struct request_queue *q;
> +	unsigned long val, flags;
> +
> +	device = dasd_device_from_cdev(to_ccwdev(dev));
> +	if (IS_ERR(device))
> +		return -ENODEV;
> +
> +	if ((strict_strtoul(buf, 10, &val) != 0) ||
> +	    val > ULONG_MAX / HZ) {

Probably this should be UINT_MAX instead of ULONG_MAX, otherwise it
might overflow since blk_queue_rq_timeout(...) expects only an
unsigned int.


> +		dasd_put_device(device);
> +		return -EINVAL;
> +	}
> +	q = device->block->request_queue;
> +	if (!q) {
> +		dasd_put_device(device);
> +		return -ENODEV;
> +	}
> +	spin_lock_irqsave(&device->block->request_queue_lock, flags);
> +	if (!val)
> +		blk_queue_rq_timed_out(q, NULL);
> +	else
> +		blk_queue_rq_timed_out(q, dasd_times_out);
> +
> +	device->blk_timeout = val;
> +
> +	blk_queue_rq_timeout(q, device->blk_timeout * HZ);
> +	spin_unlock_irqrestore(&device->block->request_queue_lock, flags);
> +
> +	dasd_put_device(device);
> +	return count;
> +}

