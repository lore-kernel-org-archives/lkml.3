Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3A2PRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 10:17:17 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41549 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3A2PRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 10:17:16 -0500
In-Reply-To: <1359443521-24670-9-git-send-email-hare@suse.de>
References: <1359443521-24670-1-git-send-email-hare@suse.de> <1359443521-24670-9-git-send-email-hare@suse.de>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        mschwid2@linux.vnet.ibm.com
MIME-Version: 1.0
Subject: Re: [PATCH 8/9] dasd: Add 'timeout' attribute
X-KeepSent: 5B1E9925:8182C1D5-C1257B02:004C182F;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
From: Stefan Weinhuber <WEIN@de.ibm.com>
Message-ID: <OF5B1E9925.8182C1D5-ONC1257B02.004C182F-C1257B02.0053F88F@de.ibm.com>
Date: Tue, 29 Jan 2013 16:17:01 +0100
X-MIMETrack: Serialize by Router on D06ML030/06/M/IBM(Release 8.5.3 ZX853HP5|January 12, 2012) at
 29/01/2013 16:17:01,
	Serialize complete at 29/01/2013 16:17:01
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
x-cbid: 13012915-0342-0000-0000-00000410331C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Reinecke <hare@suse.de> wrote on 2013-01-29 08:12:00:
[..]
> +static ssize_t
> +dasd_timeout_store(struct device *dev, struct device_attribute *attr,
> +         const char *buf, size_t count)
> +{
> +   struct dasd_device *device;
> +   struct request_queue *q;
> +   unsigned long val, flags;
> +
> +   device = dasd_device_from_cdev(to_ccwdev(dev));
> +   if (IS_ERR(device))
> +      return -ENODEV;
> +
> +   if ((strict_strtoul(buf, 10, &val) != 0) ||
> +       val > ULONG_MAX / HZ) {
> +      dasd_put_device(device);
> +      return -EINVAL;
> +   }
> +   q = device->block->request_queue;

You need to check device->block before using it.
For alias devices the device->block pointer is NULL, as an alias device
has no fixed association with a block device.

> +   if (!q) {
> +      dasd_put_device(device);
> +      return -ENODEV;
> +   }
> +   spin_lock_irqsave(&device->block->request_queue_lock, flags);
> +   if (!val)
> +      blk_queue_rq_timed_out(q, NULL);
> +   else
> +      blk_queue_rq_timed_out(q, dasd_times_out);
> +
> +   device->blk_timeout = val;
> +
> +   blk_queue_rq_timeout(q, device->blk_timeout * HZ);
> +   spin_unlock_irqrestore(&device->block->request_queue_lock, flags);
> +
> +   dasd_put_device(device);
> +   return count;
> +}
> +
[..]

Mit freundlichen Grüßen / Kind regards
 
Stefan Weinhuber

-- 
Linux for zSeries kernel development
IBM Systems &Technology Group, Systems Software Development / SW Linux für 
zSeries Entwicklung

IBM Deutschland
Schoenaicher Str. 220
71032 Boeblingen
Phone: +49-7031-16-4018
E-Mail: wein@de.ibm.com

IBM Deutschland Research & Development GmbH / Vorsitzender des 
Aufsichtsrats: Martina Koederitz
Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, 
HRB 243294

