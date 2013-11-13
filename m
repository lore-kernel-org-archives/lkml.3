Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab3KMKhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 05:37:11 -0500
Received: from smtp.citrix.com ([66.165.176.89]:26158 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab3KMKg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 05:36:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,691,1378857600"; 
   d="scan'208";a="73952297"
Message-ID: <52835646.5040907@citrix.com>
Date: Wed, 13 Nov 2013 10:36:54 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: <xen-devel@lists.xen.org>, Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>, <linux-kernel@vger.kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Anthony Liguori <aliguori@amazon.com>
Subject: Re: [PATCH] xen-gnttab: do not add m2p override entries for blkback
 mappings
References: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
In-Reply-To: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/11/13 01:48, Anthony Liguori wrote:
> From: Anthony Liguori <aliguori@amazon.com>
> 
> Commit 5dc03639 switched blkback to also add m2p override entries
> when mapping grant pages but history seems to have forgotten why
> this is useful if it ever was.
> 
> The blkback driver does not need m2p override entries to exist
> and there is significant overhead due to the locking in the m2p
> override table.  We see about a 10% improvement in IOP rate with
> this patch applied running FIO in the guest.
> 
> See http://article.gmane.org/gmane.linux.kernel/1590932 for a full
> analysis of current users.

I think it would be better if it was made clearer what
m2p_add/remove_override() is for (i.e., allowing get_user_pages_fast()
to work) so there isn't this confusion in the future.  Please add some
comments for this and move the calls into the gntdev driver.

In the future I would like to see the grant map/unmap done in
m2p_add/remove_override() moved into gntdev as well, but this isn't a
requirement for this performance fix.

As a prerequiste, the call to dma_mark_clean() in xen_swiotlb_unmap()
needs to be removed and replaced with a comment explaining why this now
differs from the generic implementation.  i.e., the necessary
phys_to_virt() will not work for foreign pages and dma_mark_clean() is a
nop on all Xen supported architectures.

David
