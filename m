Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935338Ab3DPAqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 20:46:15 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:39563 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3DPAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 20:46:13 -0400
Message-ID: <516C9F00.9020009@huawei.com>
Date: Tue, 16 Apr 2013 08:44:48 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Libin <huawei.libin@huawei.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        "Hans J. Koch" <hjk@hansjkoch.de>,
        Petr Vandrovec <petr@vandrovec.name>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Michel Lespinasse <walken@google.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-pci@vger.kernel.org>,
        <linux-mm@kvack.org>, <guohanjun@huawei.com>, <wangyijing@huawei.com>
Subject: Re: [PATCH 4/6] char: use vma_pages() to replace (vm_end - vm_start)
 >> PAGE_SHIFT
References: <1366030138-71292-1-git-send-email-huawei.libin@huawei.com> <1366030138-71292-4-git-send-email-huawei.libin@huawei.com>
In-Reply-To: <1366030138-71292-4-git-send-email-huawei.libin@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/15 20:48, Libin wrote:
> (*->vm_end - *->vm_start) >> PAGE_SHIFT operation is implemented
> as a inline funcion vma_pages() in linux/mm.h, so using it.
> 
> Signed-off-by: Libin <huawei.libin@huawei.com>
> ---
>  drivers/char/mspec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
> index e1f60f9..ed0703f 100644
> --- a/drivers/char/mspec.c
> +++ b/drivers/char/mspec.c
> @@ -168,7 +168,7 @@ mspec_close(struct vm_area_struct *vma)
>  	if (!atomic_dec_and_test(&vdata->refcnt))
>  		return;
>  
> -	last_index = (vdata->vm_end - vdata->vm_start) >> PAGE_SHIFT;
> +	last_index = vma_pages(vdata);
>  	for (index = 0; index < last_index; index++) {
>  		if (vdata->maddr[index] == 0)
>  			continue;
> 

This function mspec_mmap also need modification...
And you can change int to unsigned long.

static int
mspec_mmap(struct file *file, struct vm_area_struct *vma,
					enum mspec_page_type type)
{
	struct vma_data *vdata;
	int pages, vdata_size, flags = 0;

	if (vma->vm_pgoff != 0)
		return -EINVAL;

	if ((vma->vm_flags & VM_SHARED) == 0)
		return -EINVAL;

	if ((vma->vm_flags & VM_WRITE) == 0)
		return -EPERM;

	pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
	vdata_size = sizeof(struct vma_data) + pages * sizeof(long);
	if (vdata_size <= PAGE_SIZE)
		vdata = kzalloc(vdata_size, GFP_KERNEL);
	else {
		vdata = vzalloc(vdata_size);
		flags = VMD_VMALLOCED;
	}
	if (!vdata)
		return -ENOMEM;


