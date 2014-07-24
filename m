Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbaGXPfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 11:35:38 -0400
Received: from sym2.noone.org ([178.63.92.236]:34666 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114AbaGXPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:35:35 -0400
Date: Thu, 24 Jul 2014 17:35:33 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: gregkh@linuxfoundation.org, rdunlap@infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk,
        ben.dooks@codethink.co.uk
Subject: Re: [PATCH 1/1] Managed Devices devres_debugfs file system
Message-ID: <20140724153533.GB3384@distanz.ch>
References: <1406215081-15113-1-git-send-email-rob.jones@codethink.co.uk>
 <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406215081-15113-2-git-send-email-rob.jones@codethink.co.uk>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-24 at 17:18:01 +0200, Rob Jones <rob.jones@codethink.co.uk> wrote:
> Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
> Suggested-by: Ben Dooks <ben.dooks@codethink.co.uk>
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
>  Documentation/driver-model/devres-debugfs.txt |  140 +++++++++
>  drivers/base/Kconfig                          |   18 ++
>  drivers/base/devres.c                         |  387 +++++++++++++++++++++++++
>  3 files changed, 545 insertions(+)
>  create mode 100644 Documentation/driver-model/devres-debugfs.txt

[...]

> diff --git a/drivers/base/devres.c b/drivers/base/devres.c
> index 5c88a27..41b6465 100644
> --- a/drivers/base/devres.c
> +++ b/drivers/base/devres.c
> @@ -7,9 +7,13 @@

[...]

> +/**
> + * devres_dbgfs_seq_show - seq file output routine for a devres debugfs file
> + * @s: pointer to seq file structure
> + * @v: pointer to private data set up by devres_dbgfs_seq_next().
> + *
> + * Static debug function called when the user reads from a device managed
> + * resources debugfs file. It outputs to the user buffer using seq_file
> + * function seq_printf();
> + *
> + * This function locks devres_lock in the device structure.
> + */
> +static int devres_dbgfs_seq_show(struct seq_file *s, void *v)
> +{
> +	struct devres_dbgfs_private *priv = v;
> +	struct device *dev = priv->dev;
> +	int size, i, pos = priv->pos;
> +	struct devres *dr;
> +	struct list_head *head;
> +	struct list_head *item;
> +	unsigned long flags;
> +	char data[16];
> +	char *dataptr;
> +
> +	if (pos == 0) {
> +		seq_printf(s, "dev: %p %s\n", dev, dev_name(dev));
> +		return 0;
> +	}
> +
> +	spin_lock_irqsave(&dev->devres_lock, flags);
> +
> +	head = &dev->devres_head;
> +	if (!head || list_empty(head))
> +		goto out_eof;
> +	item = head;
> +
> +	/* Walk the device resource list to item number *position */
> +	while (pos--) {
> +		item = item->next;
> +		/* Check for end of list before required item */
> +		if (item == head)
> +			goto out_eof;
> +	}
> +
> +	/* Node found, grab the details */
> +	dr = container_of(item, struct devres, node.entry);
> +	size = dr->node.size;
> +	dataptr = (char *)dr->data;
> +
> +	/* Take a copy of the data before unlock */
> +	memcpy(data, dataptr, (size < 16 ? size : 16));

How about using min_t(size_t, size, 16) and making size of type size_t
for that matter, since dr->node.size is size_t anyway?

> +
> +	spin_unlock_irqrestore(&dev->devres_lock, flags);
> +
> +	/* Print the node details */
> +	seq_printf(s, "res: %p %9d ", dataptr, size);
> +
> +	for (i = 0; i < 16; i++) {

Use ARRAY_SIZE(data) here, instead of the 'magic' number 16?

> +		if (size-- > 0)
> +			seq_printf(s, "%02x", data[i]);
> +		else
> +			seq_puts(s, "  ");
> +	}
> +
> +	if (dr->node.name)
> +		seq_printf(s, " %s", dr->node.name);
> +
> +	seq_putc(s, '\n');
> +
> +	return 0;
> +
> +out_eof:
> +	spin_unlock_irqrestore(&dev->devres_lock, flags);
> +	priv->eof = true;
> +	return 0; /* Seek past EOF */
> +}
> +
> +static const struct seq_operations devres_dbgfs_seq_ops = {
> +	.start = devres_dbgfs_seq_start,
> +	.show  = devres_dbgfs_seq_show,
> +	.next  = devres_dbgfs_seq_next,
> +	.stop  = devres_dbgfs_seq_stop,
> +};
