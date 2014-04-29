Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965123AbaD2TpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:45:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965044AbaD2TpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:45:10 -0400
Date: Tue, 29 Apr 2014 15:45:08 -0400 (EDT)
Message-Id: <20140429.154508.1310732534931361787.davem@davemloft.net>
To: reksio@newterm.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] Driver for Beckhoff CX5020 EtherCAT master
 module.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140428053658.GA20916@newterm.pl>
References: <20140428053658.GA20916@newterm.pl>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Apr 2014 12:45:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darek Marcinkiewicz <reksio@newterm.pl>
Date: Mon, 28 Apr 2014 07:36:58 +0200

> +void *ec_bh_alloc_dma_mem(struct bh_priv *priv,
> +			     int channel,
> +			     u8 **buf,
> +			     dma_addr_t *phys,
> +			     dma_addr_t *phys_buf,
> +			     size_t *len) {
> +	u32 mask;
> +	int offset = channel * DMA_CHAN_SIZE + DMA_CHAN_OFFSET;
> +
> +	iowrite32(0xffffffff, priv->dma_io + offset);
> +
> +	mask = ioread32(priv->dma_io + offset);
> +	mask &= 0xfffffffc;
> +	dev_info(PRIV_TO_DEV(priv),
> +		 "Read mask %x for channel %d\n",
> +		 mask, channel);
> +	*len = ~mask + 1;
> +
> +	dev_info(PRIV_TO_DEV(priv),
> +		 "Allocating %d bytes for channel %d",
> +		 (int)*len, channel);
> +	*buf = pci_alloc_consistent(priv->dev,
> +				    *len * 2,
> +				    phys_buf);

This is really confusing, the log message says that it allocates
"*len" bytes, but actually you are allocating "*len * 2" bytes as
per the arguments you are passing into pci_alloc_consistent.

Either one or the other is wrong, and if "*len * 2" is the correct
size then it should be explained why you're doubling this value
but providing just plain "*len" to the caller.

All of these *len values seem to be doubled over and over again,
in the memset() calls, in the pci_free_consistent() calls during
resource release on probe error and driver shutdown.

Why not just assign X * 2 to *len and get rid of this doubling all
over the place?
