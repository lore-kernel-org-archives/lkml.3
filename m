Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3KEKrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:47:46 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:20543 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab3KEKrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:47:45 -0500
X-IronPort-AV: E=Sophos;i="4.93,639,1378857600"; 
   d="scan'208";a="68082275"
Message-ID: <5278CCC4.3020501@citrix.com>
Date: Tue, 5 Nov 2013 10:47:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3] p2m: use GNTTABOP_unmap_and_duplicate if available
References: <1383579524-12465-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1383579524-12465-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/13 15:38, Roger Pau Monne wrote:
> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
> code without requiring the use of a multicall.

Should the grant maps should be batched in a similar way?

> +int m2p_remove_override_batch(struct page **pages,
> +		struct gnttab_map_grant_ref *kmap_ops, int count)
> +{
> +	struct gnttab_unmap_and_duplicate *unmap_ops = NULL;
> +	int ret = 0, i;
> +
> +	for (i = 0; i < count; i++) {
> +		ret = remove_page_override(pages[i]);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (kmap_ops != NULL) {
> +		struct page *scratch_page = get_balloon_scratch_page();
> +		unsigned long scratch_page_address = (unsigned long)
> +					__va(page_to_pfn(scratch_page) << PAGE_SHIFT);
> +		int invcount = 0;
> +
> +		unmap_ops = kcalloc(count, sizeof(unmap_ops[0]), GFP_KERNEL);
> +		if (!unmap_ops) {
> +			put_balloon_scratch_page();
> +			ret = -ENOMEM;
> +			goto out;
> +		}

A memory allocation failure here looks bad as the grants will not be
unmapped which will have an impact on the granter domain.  Either: a)
the unmap ops should be constructed in advance (excluding high mem pages
at that point); or b) this should use a statically allocated per-cpu
array of unmap ops with the batch split as necessary to fit into the
static array.

David
