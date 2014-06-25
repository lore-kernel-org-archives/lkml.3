Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaFYT16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:27:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbaFYT14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:27:56 -0400
Date: Wed, 25 Jun 2014 12:27:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 01/22] pci-dma-compat: Add pci_zalloc_consistent helper
Message-Id: <20140625122755.152685fadbc9cffe7a298dc6@linux-foundation.org>
In-Reply-To: <2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
	<2248b3ffe86cd8995a809bf7e2871f38039979c1.1403530604.git.joe@perches.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 06:41:29 -0700 Joe Perches <joe@perches.com> wrote:

> Add this helper for consistency with pci_zalloc_coherent
> and the ability to remove unnecessary memset(,0,) uses.

While we're being anal..  I'm not a big fan of the patch titles.  Worst
is "amd: Use pci_zalloc_consistent".  "amd" is quite a poor identifier
- it's only when you get in and look at the diff that you realise it's
an ethernet driver.

People sometimes address this by using

	"drivers: net: ethernet: amd: use pci_zalloc_consistent"

which strikes me as utterly perverse.  We already have a nice way of
representing the hierarchy and that's using '/'.

So when the irritation gets too high and when I can be bothered I'll
rewrite things like that to

	"drivers/net/ethernet/amd: use pci_zalloc_consistent"

which strikes me as being blindingly obvious, but apparently I'm in a
small minority :(

> --- a/include/asm-generic/pci-dma-compat.h
> +++ b/include/asm-generic/pci-dma-compat.h
> @@ -19,6 +19,14 @@ pci_alloc_consistent(struct pci_dev *hwdev, size_t size,
>  	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
>  }
>  
> +static inline void *
> +pci_zalloc_consistent(struct pci_dev *hwdev, size_t size,
> +		      dma_addr_t *dma_handle)
> +{
> +	return dma_zalloc_coherent(hwdev == NULL ? NULL : &hwdev->dev,
> +				   size, dma_handle, GFP_ATOMIC);
> +}
> +

We'd get a smaller kernel by uninlining this.  It is hardly
performance-sensitive.  Uninlining would presumably use more stack,
but GFP_ATOMIC won't use a ton of stack anyway.

