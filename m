Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbaJYTQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:16:55 -0400
Received: from mail-bl2on0128.outbound.protection.outlook.com ([65.55.169.128]:22973
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751019AbaJYTQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:16:52 -0400
X-WSS-ID: 0NE0LJY-07-EVH-02
X-M-MSG: 
Message-ID: <544BF71B.1030707@amd.com>
Date: Sat, 25 Oct 2014 22:16:43 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] iommu/amd: Use delayed mmu release notifier
References: <54418D7F.3050304@amd.com>
In-Reply-To: <54418D7F.3050304@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(51704005)(479174003)(199003)(24454002)(164054003)(189002)(102836001)(86362001)(92566001)(83506001)(84676001)(54356999)(76176999)(87266999)(85852003)(50466002)(59896002)(23676002)(31966008)(85306004)(50986999)(64126003)(4396001)(68736004)(65816999)(46102003)(101416001)(33656002)(87936001)(80022003)(92726001)(80316001)(19580395003)(19580405001)(44976005)(21056001)(99396003)(120916001)(64706001)(107046002)(76482002)(97736003)(110136001)(105586002)(95666004)(36756003)(20776003)(47776003)(65956001)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB203;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB203;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0375972289
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Could anyone please review this patch ?

Thanks,
	Oded

On 18/10/14 00:43, Oded Gabbay wrote:
> This patch makes use of the new delayed mmu release notifier feature in
> mm code. This is necessary because on the one hand amd_iommu_unbind_pasid
> must be called explicitly during the tear-down of a process, but on the
> other hand, it could be called from a function (e.g. in amdkfd)
> which is a call-back function for the mmu notifier release.
> In such a case, amd_iommu_unbind_pasid must not free the pasid_state
> object, as it is a member in the list of mmu release notifiers (and
> freeing it in the middle of iterating the list will break the list).
> 
> Therefore, this patch delays the release of pasid_state to a later
> call-back, which is called inside an srcu, and there we can freely
> release the object.
> 
> The flow of function calls when a process is teared-down looks like this:
> (This flow assumes that amdkfd is the client of amd_iommu_v2)
> 
> 1. mmu release notifiers for the destroyed process are started to get called.
> 
> 2. amd_iommu_v2 notifier gets called, and it calls a call-back
>    function (inv_ctx_cb). amdkfd, which implements this call-back function,
>    performs tear-down of the relevant queues per device per process.
> 
> 3. Later, amdkfd's mmu notifier callback (kfd_process_notifier_release()) gets
>    called and releases more things that are related to the process.
>    In that function, amd_iommu_unbind_pasid() is explicitly called.
> 
> 4. (current code) amd_iommu_unbind_pasid() frees the mmu notifier
>    object itself, which mustn't be freed while iterating over the list
>    of mmu notifiers.
> 
> 4. (new code in this patch) amd_iommu_unbind_pasid() sets a delayed notifier,
>    using the delayed mmu release notifier feature (new in 3.17),
>    which does the actual release later, after the iteration over the list of
>    mmu notifiers is over.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  drivers/iommu/amd_iommu_v2.c | 32 +++++++++++++++++++++++++++++---
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
> index 5f578e8..1e83bdd 100644
> --- a/drivers/iommu/amd_iommu_v2.c
> +++ b/drivers/iommu/amd_iommu_v2.c
> @@ -57,6 +57,9 @@ struct pasid_state {
>  	spinlock_t lock;			/* Protect pri_queues and
>  						   mmu_notifer_count */
>  	wait_queue_head_t wq;			/* To wait for count == 0 */
> +
> +	struct rcu_head	rcu;			/* Use for delayed freeing of
> +						   pasid_state structure */
>  };
>  
>  struct device_state {
> @@ -297,7 +300,6 @@ static void put_pasid_state_wait(struct pasid_state *pasid_state)
>  		schedule();
>  
>  	finish_wait(&pasid_state->wq, &wait);
> -	free_pasid_state(pasid_state);
>  }
>  
>  static void unbind_pasid(struct pasid_state *pasid_state)
> @@ -369,6 +371,8 @@ static void free_pasid_states(struct device_state *dev_state)
>  		put_pasid_state_wait(pasid_state); /* Reference taken in
>  						      amd_iommu_bind_pasid */
>  
> +		free_pasid_state(pasid_state);
> +
>  		/* Drop reference taken in amd_iommu_bind_pasid */
>  		put_device_state(dev_state);
>  	}
> @@ -711,6 +715,17 @@ out:
>  }
>  EXPORT_SYMBOL(amd_iommu_bind_pasid);
>  
> +static void pasid_state_destroy_delayed(struct rcu_head *rcu)
> +{
> +	struct pasid_state *pasid_state;
> +
> +	pasid_state = container_of(rcu, struct pasid_state, rcu);
> +
> +	mmdrop(pasid_state->mm);
> +
> +	free_pasid_state(pasid_state);
> +}
> +
>  void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
>  {
>  	struct pasid_state *pasid_state;
> @@ -743,13 +758,24 @@ void amd_iommu_unbind_pasid(struct pci_dev *pdev, int pasid)
>  	clear_pasid_state(dev_state, pasid_state->pasid);
>  
>  	/*
> +	 * Because we drop mm_count inside pasid_state_destroy_delayed
> +	 * and because the mmu_notifier_unregister function also drop
> +	 * mm_count we need to take an extra count here.
> +	 */
> +	atomic_inc(&pasid_state->mm->mm_count);
> +
> +	/*
>  	 * Call mmu_notifier_unregister to drop our reference
>  	 * to pasid_state->mm
>  	 */
> -	mmu_notifier_unregister(&pasid_state->mn, pasid_state->mm);
> +	mmu_notifier_unregister_no_release(&pasid_state->mn, pasid_state->mm);
>  
>  	put_pasid_state_wait(pasid_state); /* Reference taken in
> -					      amd_iommu_bind_pasid */
> +				      amd_iommu_pasid_bind */
> +
> +	mmu_notifier_call_srcu(&pasid_state->rcu,
> +				&pasid_state_destroy_delayed);
> +
>  out:
>  	/* Drop reference taken in this function */
>  	put_device_state(dev_state);
> 
