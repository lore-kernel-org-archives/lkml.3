Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239AbaAOPQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 10:16:22 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:10310 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOPQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:16:19 -0500
X-IronPort-AV: E=Sophos;i="4.95,663,1384300800"; 
   d="scan'208";a="90996549"
Message-ID: <52D6A640.8000805@citrix.com>
Date: Wed, 15 Jan 2014 15:16:16 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: Re: [PATCH net-next v4 1/9] xen-netback: Introduce TX grant map definitions
References: <1389731995-9887-1-git-send-email-zoltan.kiss@citrix.com> <1389731995-9887-2-git-send-email-zoltan.kiss@citrix.com>
In-Reply-To: <1389731995-9887-2-git-send-email-zoltan.kiss@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/14 20:39, Zoltan Kiss wrote:
> @@ -1677,6 +1793,31 @@ static void xenvif_idx_release(struct xenvif *vif, u16 pending_idx,
>   	vif->mmap_pages[pending_idx] = NULL;
>   }
>
> +void xenvif_idx_unmap(struct xenvif *vif, u16 pending_idx)
> +{
> +	int ret;
> +	struct gnttab_unmap_grant_ref tx_unmap_op;
> +
> +	if (vif->grant_tx_handle[pending_idx] == NETBACK_INVALID_HANDLE) {
> +		netdev_err(vif->dev,
> +			   "Trying to unmap invalid handle! pending_idx: %x\n",
> +			   pending_idx);
> +		return;
> +	}
> +	gnttab_set_unmap_op(&tx_unmap_op,
> +			    idx_to_kaddr(vif, pending_idx),
> +			    GNTMAP_host_map,
> +			    vif->grant_tx_handle[pending_idx]);
> +	ret = gnttab_unmap_refs(&tx_unmap_op,
> +				&vif->mmap_pages[pending_idx],
> +				1);
> +
> +	ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
> +					&tx_unmap_op,
> +					1);
> +	BUG_ON(ret);
> +	vif->grant_tx_handle[pending_idx] = NETBACK_INVALID_HANDLE;
> +}

Awkward mistake, I forgot to delete the hypercall ... Even more 
interesting, it caused troubles only very rarely ...

Zoli
