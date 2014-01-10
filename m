Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaAJNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:16:29 -0500
Received: from smtp.citrix.com ([66.165.176.89]:56972 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaAJNQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:16:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,638,1384300800"; 
   d="scan'208";a="91660148"
Date: Fri, 10 Jan 2014 13:16:25 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: Wei Liu <wei.liu2@citrix.com>, <ian.campbell@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v3 2/9] xen-netback: Change TX path from grant
 copy to mapping
Message-ID: <20140110131625.GJ29180@zion.uk.xensource.com>
References: <1389139818-24458-1-git-send-email-zoltan.kiss@citrix.com>
 <1389139818-24458-3-git-send-email-zoltan.kiss@citrix.com>
 <20140109153015.GF12164@zion.uk.xensource.com>
 <52CFDAEC.5080708@citrix.com>
 <20140110114534.GE29180@zion.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140110114534.GE29180@zion.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 11:45:34AM +0000, Wei Liu wrote:
> On Fri, Jan 10, 2014 at 11:35:08AM +0000, Zoltan Kiss wrote:
> [...]
> > 
> > >>@@ -920,6 +852,18 @@ static int xenvif_tx_check_gop(struct xenvif *vif,
> > >>  	err = gop->status;
> > >>  	if (unlikely(err))
> > >>  		xenvif_idx_release(vif, pending_idx, XEN_NETIF_RSP_ERROR);
> > >>+	else {
> > >>+		if (vif->grant_tx_handle[pending_idx] !=
> > >>+			NETBACK_INVALID_HANDLE) {
> > >>+			netdev_err(vif->dev,
> > >>+				"Stale mapped handle! pending_idx %x handle %x\n",
> > >>+				pending_idx, vif->grant_tx_handle[pending_idx]);
> > >>+			BUG();
> > >>+		}
> > >>+		set_phys_to_machine(idx_to_pfn(vif, pending_idx),
> > >>+			FOREIGN_FRAME(gop->dev_bus_addr >> PAGE_SHIFT));
> > >
> > >What happens when you don't have this?
> > Your frags will be filled with garbage. I don't understand exactly
> > what this function does, someone might want to enlighten us? I've
> > took it's usage from classic kernel.
> > Also, it might be worthwhile to check the return value and BUG if
> > it's false, but I don't know what exactly that return value means.
> > 
> 
> This is actually part of gnttab_map_refs. As you're using hypercall
> directly this becomes very fragile.
> 

To make it clear, set_phys_to_machine is done within m2p_add_override.

Wei.
