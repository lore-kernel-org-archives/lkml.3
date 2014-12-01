Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaLAAPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:15:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45891 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaLAAPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:15:08 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <547BB2F0.5040708@jp.fujitsu.com>
Date: Mon, 1 Dec 2014 09:14:40 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>, <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: Fix nodeid bounds check for non-contiguous node
 IDs
References: <20141130221606.GA25929@iris.ozlabs.ibm.com>
In-Reply-To: <20141130221606.GA25929@iris.ozlabs.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/01 7:16), Paul Mackerras wrote:
> The bounds check for nodeid in ____cache_alloc_node gives false
> positives on machines where the node IDs are not contiguous, leading
> to a panic at boot time.  For example, on a POWER8 machine the node
> IDs are typically 0, 1, 16 and 17.  This means that num_online_nodes()
> returns 4, so when ____cache_alloc_node is called with nodeid = 16 the
> VM_BUG_ON triggers.

Do you have the call trace? If you have it, please add it in the description.

> To fix this, we instead compare the nodeid with MAX_NUMNODES, and
> additionally make sure it isn't negative (since nodeid is an int).
> The check is there mainly to protect the array dereference in the
> get_node() call in the next line, and the array being dereferenced is
> of size MAX_NUMNODES.  If the nodeid is in range but invalid, the
> BUG_ON in the next line will catch that.
>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Do you need to backport it into -stable kernels?

> ---
> diff --git a/mm/slab.c b/mm/slab.c
> index eb2b2ea..f34e053 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3076,7 +3076,7 @@ static void *____cache_alloc_node(struct kmem_cache *cachep, gfp_t flags,
>   	void *obj;
>   	int x;
>

> -	VM_BUG_ON(nodeid > num_online_nodes());
> +	VM_BUG_ON(nodeid < 0 || nodeid >= MAX_NUMNODES);

How about use:
	VM_BUG_ON(!node_online(nodeid));

When allocating the memory, the node of the memory being allocated must be
online. But your code cannot check the condition.

Thanks,
Yasuaki Ishimatsu

>   	n = get_node(cachep, nodeid);
>   	BUG_ON(!n);
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>


