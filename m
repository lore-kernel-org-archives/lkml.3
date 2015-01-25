Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbbAYO7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:59:02 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60460 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbbAYO7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:59:01 -0500
Date: Sun, 25 Jan 2015 06:59:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Yan Liu <yan@purestorage.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NVMe: Do not take nsid while a passthrough IO
 command is being issued via a block device file descriptor
Message-ID: <20150125145900.GA15231@infradead.org>
References: <1422057426-8014-1-git-send-email-yan@purestorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422057426-8014-1-git-send-email-yan@purestorage.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 03:57:06PM -0800, Yan Liu wrote:
> When a passthrough IO command is issued with a specific block device file descriptor. It should be applied at
> the namespace which is associated with that block device file descriptor. This patch makes such passthrough
> command ignore nsid in nvme_passthru_cmd structure. Instead it takes the namespace ID asscoiated with the
> block device descriptor.

This looks good to me.  If Keith can point to a use case for magic or
hidden nsids we'll have to find a bypass for them, but this certainly
is the right short term fix:

Reviewed-by: Christoph Hellwig <hch@lst.de>

>  {
>  	struct nvme_dev *dev = f->private_data;
>  	struct nvme_ns *ns;
> +	int ret;
>  
>  	switch (cmd) {
>  	case NVME_IOCTL_ADMIN_CMD:
>  		return nvme_user_cmd(dev, NULL, (void __user *)arg);
>  	case NVME_IOCTL_IO_CMD:
> -		if (list_empty(&dev->namespaces))
> -			return -ENOTTY;
> -		ns = list_first_entry(&dev->namespaces, struct nvme_ns, list);
> +		ret = nvme_namespace_sel(dev, &ns, (void __user *)arg);
> +		if (ret)
> +			return ret;
>  		return nvme_user_cmd(dev, ns, (void __user *)arg);
>  	default:

This function would benefit from a local variable ala:

	void __user *argp = (void __user *)arg;

but that might be done in a follow up patch, or postponed for now.
