Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBSJyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:54:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:1964 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbaBSJyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:54:33 -0500
X-IronPort-AV: E=Sophos;i="4.97,504,1389744000"; 
   d="scan'208";a="103834096"
Message-ID: <1392803670.23084.100.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH net-next v5 2/9] xen-netback: Change TX path
 from grant copy to mapping
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <xen-devel@lists.xenproject.org>,
        <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Wed, 19 Feb 2014 09:54:30 +0000
In-Reply-To: <5303AA97.3010202@citrix.com>
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com>
		<1390253069-25507-3-git-send-email-zoltan.kiss@citrix.com>
	 <1392745235.23084.60.camel@kazak.uk.xensource.com>
	 <5303AA97.3010202@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 18:46 +0000, David Vrabel wrote:
> On 18/02/14 17:40, Ian Campbell wrote:
> > On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
> >> 
> >> @@ -344,8 +346,26 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
> >>  	vif->pending_prod = MAX_PENDING_REQS;
> >>  	for (i = 0; i < MAX_PENDING_REQS; i++)
> >>  		vif->pending_ring[i] = i;
> >> -	for (i = 0; i < MAX_PENDING_REQS; i++)
> >> -		vif->mmap_pages[i] = NULL;
> >> +	spin_lock_init(&vif->dealloc_lock);
> >> +	spin_lock_init(&vif->response_lock);
> >> +	/* If ballooning is disabled, this will consume real memory, so you
> >> +	 * better enable it.
> > 
> > Almost no one who would be affected by this is going to read this
> > comment. And it doesn't just require enabling ballooning, but actually
> > booting with some maxmem "slack" to leave space.
> > 
> > Classic-xen kernels used to add 8M of slop to the physical address space
> > to leave a suitable pool for exactly this sort of thing. I never liked
> > that but perhaps it should be reconsidered (or at least raised as a
> > possibility with the core-Xen Linux guys).
> 
> I plan to fix the balloon memory hotplug stuff to do the right thing

Which is for alloc_xenballoon_pages to hotplug a new empty region,
rather than inflating the balloon if it doesn't have enough pages to
satisfy the allocation? Or something else?

> (it's almost there -- it just tries to overlap the new memory with
> existing stuff).
> 
> David


