Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3CUMX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 08:23:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40183 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab3CUMX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 08:23:57 -0400
Message-ID: <514AFBD4.2050201@linux.vnet.ibm.com>
Date: Thu, 21 Mar 2013 08:23:48 -0400
From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH] rdma: don't make pages writeable if not requiested
References: <20130321061838.GA28319@redhat.com>
In-Reply-To: <20130321061838.GA28319@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032112-5806-0000-0000-0000206CF057
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, I'd be happy to try the patch.

Got meetings all day...... but will dive in soon.

On 03/21/2013 02:18 AM, Michael S. Tsirkin wrote:
> core/umem.c seems to get the arguments to get_user_pages
> in the reverse order: it sets writeable flag and
> breaks COW for MAP_SHARED if and only if hardware needs to
> write the page.
>
> This breaks memory overcommit for users such as KVM:
> each time we try to register a page to send it to remote, this
> breaks COW.  It seems that for applications that only have
> REMOTE_READ permission, there is no reason to break COW at all.
>
> If the page that is COW has lots of copies, this makes the user process
> quickly exceed the cgroups memory limit.  This makes RDMA mostly useless
> for virtualization, thus the stable tag.
>
> Reported-by: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> Note: compile-tested only, I don't have RDMA hardware at the moment.
> Michael, could you please try this patch (also fixing your
> usespace code not to request write access) and report?
>
> Note2: grep for get_user_pages in infiniband drivers turns up
> lots of users who set write to 1 unconditionally.
> These might be bugs too, should be checked.
>
>   drivers/infiniband/core/umem.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index a841123..5929598 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -152,7 +152,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>   		ret = get_user_pages(current, current->mm, cur_base,
>   				     min_t(unsigned long, npages,
>   					   PAGE_SIZE / sizeof (struct page *)),
> -				     1, !umem->writable, page_list, vma_list);
> +				     !umem->writable, 1, page_list, vma_list);
>
>   		if (ret < 0)
>   			goto out;

