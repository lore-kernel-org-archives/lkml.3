Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190AbaFLVmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:42:37 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48859 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaFLVmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:42:35 -0400
Date: Thu, 12 Jun 2014 14:42:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Zhouyi Zhou <zhouzhouyi@gmail.com>
cc: joe@perches.com, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org, cpw@sgi.com,
        Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: Re: [PATCH v2]x86/tlb_uv: Fixing all memory allocation failure
 handling in UV
In-Reply-To: <1402565554-30298-1-git-send-email-zhouzhouyi@gmail.com>
Message-ID: <alpine.DEB.2.02.1406121433280.11812@chino.kir.corp.google.com>
References: <1402565554-30298-1-git-send-email-zhouzhouyi@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Zhouyi Zhou wrote:

> According to Peter, Thomas, Joe and David's advices, try fixing all memory allocation 
> failure handling in tlb_uv.c
> 

This changelog still isn't complete, it needs to describe what specific 
issues the patch is addressing: what kind of memory allocation failure?  
What happens currently with such failure?  What changes to that are you 
making?  Why is this a helpful change?

You'll also need a space between "[PATCH v2]" and "x86/tlb_uv:" in your 
subject line.

> compiled in x86_64
> Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
> ---
>  arch/x86/platform/uv/tlb_uv.c |  122 +++++++++++++++++++++++++++++------------
>  1 file changed, 87 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
> index dfe605a..1a45dfa 100644
> --- a/arch/x86/platform/uv/tlb_uv.c
> +++ b/arch/x86/platform/uv/tlb_uv.c
> @@ -1680,7 +1680,7 @@ static int __init uv_ptc_init(void)
>  /*
>   * Initialize the sending side's sending buffers.
>   */
> -static void activation_descriptor_init(int node, int pnode, int base_pnode)
> +static int activation_descriptor_init(int node, int pnode, int base_pnode)
>  {
>  	int i;
>  	int cpu;
> @@ -1701,7 +1701,9 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
>  	 */
>  	dsize = sizeof(struct bau_desc) * ADP_SZ * ITEMS_PER_DESC;
>  	bau_desc = kmalloc_node(dsize, GFP_KERNEL, node);
> -	BUG_ON(!bau_desc);
> +	if (!bau_desc)
> +		return -ENOMEM;
> +
>  
>  	gpa = uv_gpa(bau_desc);
>  	n = uv_gpa_to_gnode(gpa);

This is done on bootstrap, so if we are really out of memory here then 
what is the net result of returning -ENOMEM to the initcall handler?  In 
other words, what functionality do we lose and is it appropriate?  Is 
there any chance that we're in an inconsistent state?

You've also added a blank line for no reason.

> @@ -1756,6 +1758,8 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
>  		bcp = &per_cpu(bau_control, cpu);
>  		bcp->descriptor_base = bau_desc;
>  	}
> +
> +	return 0;
>  }
>  
>  /*

You've turned a non-failable function into a failable one but there's 
nothing provided that suggests we can handle failure appropriately.  It's 
not sufficient to simply start returning errno when the result may be 
inconsistent.  How have you proven that returning -ENOMEM to the initcall 
handler works?

> @@ -1764,7 +1768,7 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
>   * - node is first node (kernel memory notion) on the uvhub
>   * - pnode is the uvhub's physical identifier
>   */
> -static void pq_init(int node, int pnode)
> +static int pq_init(int node, int pnode)
>  {
>  	int cpu;
>  	size_t plsize;
> @@ -1776,12 +1780,16 @@ static void pq_init(int node, int pnode)
>  	unsigned long last;
>  	struct bau_pq_entry *pqp;
>  	struct bau_control *bcp;
> +	int ret = 0;
>  
>  	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
>  	vp = kmalloc_node(plsize, GFP_KERNEL, node);
> -	pqp = (struct bau_pq_entry *)vp;
> -	BUG_ON(!pqp);
> +	if (!vp) {
> +		ret =  -ENOMEM;
> +		goto fail;
> +	}
>  
> +	pqp = (struct bau_pq_entry *)vp;
>  	cp = (char *)pqp + 31;
>  	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
>  
> @@ -1808,29 +1816,40 @@ static void pq_init(int node, int pnode)
>  
>  	/* in effect, all msg_type's are set to MSG_NOOP */
>  	memset(pqp, 0, sizeof(struct bau_pq_entry) * DEST_Q_SIZE);
> +
> +	return 0;
> +fail:
> +	return ret;
>  }

Same concern about pq_init(), it also makes init_uvhub() failable for the 
first time and nothing is proving we can do that.

>  
>  /*
>   * Initialization of each UV hub's structures
>   */
> -static void __init init_uvhub(int uvhub, int vector, int base_pnode)
> +static int __init init_uvhub(int uvhub, int vector, int base_pnode)
>  {
>  	int node;
>  	int pnode;
>  	unsigned long apicid;
> +	int ret;
>  
>  	node = uvhub_to_first_node(uvhub);
>  	pnode = uv_blade_to_pnode(uvhub);
>  
> -	activation_descriptor_init(node, pnode, base_pnode);
> +	ret = activation_descriptor_init(node, pnode, base_pnode);
> +	if (ret)
> +		return ret;
>  
> -	pq_init(node, pnode);
> +	ret = pq_init(node, pnode);
> +	if (ret)
> +		return ret;

And now I see this entire patch is wrong because you're returning failure 
without cleaning up what activation_descriptor_init() did.

If you're going to suggest patches, please ensure that there is an actual 
problem being resolved.
