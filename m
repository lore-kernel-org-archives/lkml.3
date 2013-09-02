Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab3IBQWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:22:06 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48353 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758442Ab3IBQWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:22:04 -0400
Message-ID: <1378138922.1953.73.camel@joe-AO722>
Subject: Re: [PATCH 1/5] xhci: fix usb3 streams
From: Joe Perches <joe@perches.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Date: Mon, 02 Sep 2013 09:22:02 -0700
In-Reply-To: <1378121129-32594-2-git-send-email-kraxel@redhat.com>
References: <1378121129-32594-1-git-send-email-kraxel@redhat.com>
	 <1378121129-32594-2-git-send-email-kraxel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 13:25 +0200, Gerd Hoffmann wrote:
> xhci maintains a radix tree for each stream endpoint because it must
> be able to map a trb address to the stream ring.  Each ring segment
> must be added to the ring for this to work.  Currently xhci sticks
> only the first segment of each stream ring into the radix tree.
[]
> This patch adds a helper function to update the radix tree.  It can
> both insert and remove ring segments.  It loops over the segment list
> and handles all segments instead of just the first.  It is called
> whenever an update is needed:  When allocating a ring, when expanding
> a ring and when releasing a ring.
[]
> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
[]
> @@ -601,6 +609,33 @@ static int xhci_test_radix_tree(struct xhci_hcd *xhci,
>   * extended systems (where the DMA address can be bigger than 32-bits),
>   * if we allow the PCI dma mask to be bigger than 32-bits.  So don't do that.
>   */
> +
> +int xhci_update_stream_ring(struct xhci_ring *ring, bool insert)
> +{
> +	struct xhci_segment *seg;
> +	unsigned long key;
> +	bool present;
> +	int ret;
> +
> +	BUG_ON(ring->trb_address_map == NULL);

BUG_ON is really not nice.  Maybe:

	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
		return 0;


