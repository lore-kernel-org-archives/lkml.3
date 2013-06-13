Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3FMIyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:54:23 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:34548 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758322Ab3FMIyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:54:19 -0400
Date: Thu, 13 Jun 2013 10:54:11 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: HATAYAMA Daisuke <d.hatayama@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 3/5] vmcore: Introduce remap_oldmem_pfn_range()
Message-ID: <20130613105411.5ddeccfd@holzheu>
In-Reply-To: <51B92140.9050407@jp.fujitsu.com>
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com>
	<1370624161-2298-4-git-send-email-holzheu@linux.vnet.ibm.com>
	<CABOkKT0yk6tytN=aTSdpECQWw_30m5qrZYH-W1msovkeiSeZCA@mail.gmail.com>
	<20130610173739.4d88d4ec@holzheu>
	<CABOkKT05VR3V9rEz1LWnEJSEvkevhBFfQVVX5_DS0Z4rBG9EyA@mail.gmail.com>
	<20130612111303.3323f24f@holzheu>
	<51B92140.9050407@jp.fujitsu.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061308-3548-0000-0000-000005A99C3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 10:32:48 +0900
HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> wrote:

> > Perhaps one open issue remains:
> >
> > Can we remove the page from the page cache if __read_vmcore() fails?
> >  
> 
> Yes, use page_cache_release() after unlocking the page like:
> 
>                     if (__read_vmcore(buf, PAGE_SIZE, &src, 0) < 0) {
>                             unlock_page(page);
> +                          page_cache_release(page);
>                             return VM_FAULT_SIGBUS;
>                     }
> 
> BTW, you now keep file->f_mapping in vma->vm_private_data, but the vma already has the file object in its vma->vm_file member. You can get the mapping by vma->vm_file->f_mapping without necessity of vma->vm_private_data.

Hello Hatayama,

Here the new function:

static int mmap_vmcore_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
{
        struct address_space *mapping = vma->vm_file->f_mapping;
        pgoff_t index = vmf->pgoff;
        struct page *page;
        loff_t src;
        char *buf;
        int rc;

        page = find_or_create_page(mapping, index, GFP_KERNEL);
        if (!page)
                return VM_FAULT_OOM;
        if (!PageUptodate(page)) {
                src = index << PAGE_CACHE_SHIFT;
                buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
                rc = __read_vmcore(buf, PAGE_SIZE, &src, 0);
                if (rc < 0) {
                        unlock_page(page);
                        page_cache_release(page);
                        return (rc == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
                }
                SetPageUptodate(page);
        }
        unlock_page(page);
        vmf->page = page;
        return 0;
}

Thanks for all the constructive feedback!

Best Regards,
Michael

