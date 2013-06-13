Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208Ab3FMBdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:33:14 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47472 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3FMBdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:33:13 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <51B92140.9050407@jp.fujitsu.com>
Date: Thu, 13 Jun 2013 10:32:48 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: HATAYAMA Daisuke <d.hatayama@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kexec@lists.infradead.org,
        Jan Willeke <willeke@de.ibm.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 3/5] vmcore: Introduce remap_oldmem_pfn_range()
References: <1370624161-2298-1-git-send-email-holzheu@linux.vnet.ibm.com> <1370624161-2298-4-git-send-email-holzheu@linux.vnet.ibm.com> <CABOkKT0yk6tytN=aTSdpECQWw_30m5qrZYH-W1msovkeiSeZCA@mail.gmail.com> <20130610173739.4d88d4ec@holzheu> <CABOkKT05VR3V9rEz1LWnEJSEvkevhBFfQVVX5_DS0Z4rBG9EyA@mail.gmail.com> <20130612111303.3323f24f@holzheu>
In-Reply-To: <20130612111303.3323f24f@holzheu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/12 18:13), Michael Holzheu wrote:
> On Tue, 11 Jun 2013 21:42:15 +0900
> HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:
>
>> 2013/6/11 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
>>> On Mon, 10 Jun 2013 22:40:24 +0900
>>> HATAYAMA Daisuke <d.hatayama@gmail.com> wrote:
>>>
>>>> 2013/6/8 Michael Holzheu <holzheu@linux.vnet.ibm.com>:
<cut>
> static int mmap_vmcore_fault(struct vm_area_struct *vma, struct'vm_fault *vmf)
> {
>          struct address_space *mapping = vma->vm_private_data;
>          pgoff_t index = vmf->pgoff;
>          struct page *page;
>          loff_t src;
>          char *buf;
>
>          page = find_or_create_page(mapping, index, GFP_KERNEL);
>          if (!page)
>                  return VM_FAULT_OOM;
>          if (!PageUptodate(page)) {
>                  src = index << PAGE_CACHE_SHIFT;
>                  buf = (void *) (page_to_pfn(page) << PAGE_SHIFT);
>                  if (__read_vmcore(buf, PAGE_SIZE, &src, 0) < 0) {
>                          unlock_page(page);
>                          return VM_FAULT_SIGBUS;
>                  }
>                  SetPageUptodate(page);
>          }
>          unlock_page(page);
>          vmf->page = page;
>          return 0;
> }
>
> Perhaps one open issue remains:
>
> Can we remove the page from the page cache if __read_vmcore() fails?
>

Yes, use page_cache_release() after unlocking the page like:

                    if (__read_vmcore(buf, PAGE_SIZE, &src, 0) < 0) {
                            unlock_page(page);
+                          page_cache_release(page);
                            return VM_FAULT_SIGBUS;
                    }

BTW, you now keep file->f_mapping in vma->vm_private_data, but the vma already has the file object in its vma->vm_file member. You can get the mapping by vma->vm_file->f_mapping without necessity of vma->vm_private_data.

-- 
Thanks.
HATAYAMA, Daisuke

