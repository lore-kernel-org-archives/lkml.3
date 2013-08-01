Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3HAJxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:53:50 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:60080 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3HAJxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:53:49 -0400
X-IronPort-AV: E=Sophos;i="4.89,793,1367971200"; 
   d="scan'208";a="38741852"
Message-ID: <51FA302B.90106@citrix.com>
Date: Thu, 1 Aug 2013 10:53:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH RFC] p2m: use GNTTABOP_unmap_and_duplicate
 if	available
References: <1375286855-4861-1-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1375286855-4861-1-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/07/13 17:07, Roger Pau Monne wrote:
> The new GNTTABOP_unmap_and_duplicate operation doesn't zero the
> mapping passed in new_addr, allowing us to perform batch unmaps in p2m
> code without requiring the use of a multicall.

Thanks. This looks like it should be a good performance improvement for
userspace-based backends.  Do you have any performance measurements for
(e.g.) qemu's disk backend?

> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
[...]
> +int m2p_remove_override_batch(struct page **pages,
> +		struct gnttab_map_grant_ref *kmap_ops, int count)
> +{

Is it possible to refactor this function and
m2p_remove_override_single() to share some common helper functions?

> +	struct gnttab_unmap_and_duplicate *unmap_ops = NULL;
> +	unsigned long *mfn = kcalloc(count, sizeof(mfn[0]), GFP_KERNEL);
> +	unsigned long flags;
> +	unsigned long pfn;
> +	unsigned long uninitialized_var(address);
> +	unsigned level;
> +	struct page *page;
> +	pte_t *ptep = NULL;
> +	int ret = 0, i;
> +
> +
> +	for (i = 0; i < count; i++) {
> +		page = pages[i];
> +		pfn = page_to_pfn(page);

The bits in this loop...

[...]
> +	for (i = 0; i < count; i++) {
> +		/* p2m(m2p(mfn)) == FOREIGN_FRAME(mfn): the mfn is already present
> +		 * somewhere in this domain, even before being added to the

... and this one look they should be common between the two.

David
