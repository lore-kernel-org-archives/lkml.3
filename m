Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615AbaFYXFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 19:05:07 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43113 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756638AbaFYXFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 19:05:05 -0400
Date: Thu, 26 Jun 2014 00:04:50 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dann Frazier <dann.frazier@canonical.com>
Cc: Iyappan Subramanian <isubramanian@apm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        jcm@redhat.com, netdev@vger.kernel.org, patches@apm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keyur Chudgar <kchudgar@apm.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, Ravi Patel <rapatel@apm.com>
Subject: Re: [PATCH v8 4/4] drivers: net: Add APM X-Gene SoC ethernet
	driver support.
Message-ID: <20140625230450.GO32514@n2100.arm.linux.org.uk>
References: <1403306296-26198-1-git-send-email-isubramanian@apm.com> <1403306296-26198-5-git-send-email-isubramanian@apm.com> <CALdTtnvHt5mYMC3619E4F3KK0jPOw7mCpKE6bTn0Um6fdZ4rbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdTtnvHt5mYMC3619E4F3KK0jPOw7mCpKE6bTn0Um6fdZ4rbw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:29:48PM -0600, Dann Frazier wrote:
> On Fri, Jun 20, 2014 at 5:18 PM, Iyappan Subramanian
> <isubramanian@apm.com> wrote:
> > +       ring->desc_addr = dma_zalloc_coherent(dev, size, &ring->dma,
> > +                                             GFP_KERNEL);
> 
> Iyappan,
> When testing this driver on a 3.16-rc2 base, I'm finding that
> desc_addr gets assigned to NULL here, which results in an oops later
> on (see below).

Note that on failure here...

> > +       if (!ring->desc_addr)
> > +               goto err;

we jump to 'err'.

> > +err:
> > +       dma_free_coherent(dev, size, ring->desc_addr, ring->dma);

which then tries to call dma_free_coherent on a NULL pointer, and
possibly undefined ring->dma value.  That's not a nice thing to do,
and will probably lead to problems.  I know that none of the ARM
flavours of this function will handle this gracefully, and neither
does x86's version either.  So this is very probably illegal.

> > +static int xgene_enet_create_desc_rings(struct net_device *ndev)
> > +{
> > +       struct xgene_enet_pdata *pdata = netdev_priv(ndev);
> > +       struct device *dev = &pdata->pdev->dev;
> > +       struct xgene_enet_desc_ring *rx_ring, *tx_ring, *cp_ring;
> > +       struct xgene_enet_desc_ring *buf_pool = NULL;
> > +       u8 cpu_bufnum = 0, eth_bufnum = 0;
> > +       u8 bp_bufnum = 0x20;
> > +       u16 ring_id, ring_num = 0;
> > +       int ret;
> > +
> > +       /* allocate rx descriptor ring */
> > +       ring_id = xgene_enet_get_ring_id(RING_OWNER_CPU, cpu_bufnum++);
> > +       rx_ring = xgene_enet_create_desc_ring(ndev, ring_num++,
> > +                                             RING_CFGSIZE_16KB, ring_id);
> > +       if (IS_ERR_OR_NULL(rx_ring)) {
> > +               ret = PTR_ERR(rx_ring);
> > +               goto err;
> > +       }
> 
> Here we test for IS_ERR_OR_NULL. In the oops I'm hitting, rx_ring is
> NULL here - but PTR_ERR() apparently returns 0 in that case. So this
> function ends up returning no error.

Yes, IS_ERR_OR_NULL is evil for this very reason and should be avoided
where possible.  There were discussions a while back about removing it,
or at least deprecating it because it causes more bugs (exactly of this
type) than it solves.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
