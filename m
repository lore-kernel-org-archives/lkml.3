Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaKGKoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:44:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:47515 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaKGKoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:44:18 -0500
X-IronPort-AV: E=Sophos;i="5.07,331,1413244800"; 
   d="scan'208";a="190513031"
Message-ID: <545CA27F.4070400@citrix.com>
Date: Fri, 7 Nov 2014 10:44:15 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: BUG in xennet_make_frags with paged skb data
References: <20141106214940.GD44162@ubuntu-hedt>
In-Reply-To: <20141106214940.GD44162@ubuntu-hedt>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 21:49, Seth Forshee wrote:
> We've had several reports of hitting the following BUG_ON in
> xennet_make_frags with 3.2 and 3.13 kernels (I'm currently awaiting
> results of testing with 3.17):
> 
>         /* Grant backend access to each skb fragment page. */
>         for (i = 0; i < frags; i++) {
>                 skb_frag_t *frag = skb_shinfo(skb)->frags + i;
>                 struct page *page = skb_frag_page(frag);
> 
>                 len = skb_frag_size(frag);
>                 offset = frag->page_offset;
> 
>                 /* Data must not cross a page boundary. */
>                 BUG_ON(len + offset > PAGE_SIZE<<compound_order(page));
> 
> When this happens the page in question is a "middle" page in a compound
> page (i.e. it's a tail page but not the last tail page), and the data is
> fully contained within the compound page. The data does however cross
> the hardware page boundary, and since compound_order evaluates to 0 for
> tail pages the check fails.
> 
> In going over this I've been unable to determine whether the BUG_ON in
> xennet_make_frags is incorrect or the paged skb data is wrong. I can't
> find that it's documented anywhere, and the networking code itself is a
> bit ambiguous when it comes to compound pages. On the one hand
> __skb_fill_page_desc specifically handles adding tail pages as paged
> data, but on the other hand skb_copy_bits kmaps frag->page.p which could
> fail with data that extends into another page.

netfront will safely handle this case so you can remove this BUG_ON()
(and the one later on).  But it would be better to find out were these
funny-looking skbs are coming from and (if necessary) fixing the bug there.

David
