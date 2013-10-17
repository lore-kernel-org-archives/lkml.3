Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab3JQIhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:37:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58504 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab3JQIhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:37:48 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <525FA177.1030506@jp.fujitsu.com>
Date: Thu, 17 Oct 2013 17:36:07 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix proc_reg_get_unmapped_area()
References: <525E957802000078000FB6FE@nat28.tlf.novell.com> <20131016134044.d1bd8004f4fb94df405a541d@linux-foundation.org> <525FAC8B02000078000FBAE8@nat28.tlf.novell.com>
In-Reply-To: <525FAC8B02000078000FBAE8@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/17 16:23), Jan Beulich wrote:
>>>> On 16.10.13 at 22:40, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Wed, 16 Oct 2013 12:32:40 +0100 "Jan Beulich" <JBeulich@suse.com> wrote:
>>
>>> Commit c4fe24485729fc2cbff324c111e67a1cc2f9adea ("sparc: fix PCI device
>>> proc file mmap(2)"), while fixing one problem, introduced two new ones:
>>> - the function truncates the return value from ->get_unmapped_area() on
>>>    64-bit architectures,
>>> - _all_ descendants are now required to set .get_unmapped_area to non-
>>>    NULL, which wasn't necessary before (and shouldn't be).
>>>
>>> Both - afaict - are a result from a too simplistic copy'n'paste from
>>> proc_reg_mmap() done in that change.
>>>
>>> This likely also addresses reports like the one at
>>>
>> http://linux-kernel.2935.n7.nabble.com/mmap-for-proc-vmcore-broken-since-3-12-rc1-td729
>> 326.html.
>>>
>>> ...
>>>
>>> --- 3.12-rc5/fs/proc/inode.c
>>> +++ 3.12-rc5-proc-get-unmapped-area/fs/proc/inode.c
>>> @@ -288,12 +288,12 @@ static int proc_reg_mmap(struct file *fi
>>>   static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned
>> long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
>>>   {
>>>   	struct proc_dir_entry *pde = PDE(file_inode(file));
>>> -	int rv = -EIO;
>>> -	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned
>> long, unsigned long, unsigned long);
>>> +	unsigned long rv = -EIO;
>>> +
>>>   	if (use_pde(pde)) {
>>> -		get_unmapped_area = pde->proc_fops->get_unmapped_area;
>>> -		if (get_unmapped_area)
>>> -			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
>>> +		rv = (pde->proc_fops->get_unmapped_area
>>> +		      ?: current->mm->get_unmapped_area)(file, orig_addr, len,
>>> +							 pgoff, flags);
>>>   		unuse_pde(pde);
>>>   	}
>>>   	return rv;
>>
>> I think these two patches will address the problems:
>>
>> http://ozlabs.org/~akpm/mmots/broken-out/procfs-fix-unintended-truncation-of-retur
>> ned-mapped-address.patch
>> http://ozlabs.org/~akpm/mmots/broken-out/procfs-call-default-get_unmapped_area-on-
>> mmu-present-architectures.patch
>>
>> I'll be sending those Linuswards today.  Please check them.  (I think
>> your version would break the nommu build).
>
> Yes indeed - I did search for existing patches, but didn't find them.
> I see Linus merged them already, so there's no point anymore
> sending Reviewed-by tags.
>
> I think though that in the !MMU case the second of them leaves an
> issue unfixed nevertheless: If the specific procfs handler has no
> .get_unmapped_area, the operation would still fail in that case
> rather than succeed as it did before that wrapper got added.)
>
> Jan
>

Yes, there remains difference on no-mmu that if mmap is not defined, mmap() now returns
EIO, it should return ENODEV.

In mm/nommu.c,

                 /* eliminate any capabilities that we can't support on this
                  * device */
                 if (!file->f_op->get_unmapped_area)
                         capabilities &= ~BDI_CAP_MAP_DIRECT;

and

                  */
                 if (capabilities & BDI_CAP_MAP_DIRECT) {
                         addr = file->f_op->get_unmapped_area(file, addr, len,
                                                              pgoff, flags);
                         if (IS_ERR_VALUE(addr)) {
                                 ret = addr;
                                 if (ret != -ENOSYS)
                                         goto error_just_free;

                                 /* the driver refused to tell us where to site
                                  * the mapping so we'll have to attempt to copy
                                  * it */
                                 ret = -ENODEV;
                                 if (!(capabilities & BDI_CAP_MAP_COPY))
                                         goto error_just_free;

                                 capabilities &= ~BDI_CAP_MAP_DIRECT;
                         } else {
                                 vma->vm_start = region->vm_start = addr;
                                 vma->vm_end = region->vm_end = addr + len;
                         }
                 }

So, how about let proc_reg_get_unmapped_area() return ENOSYS, not EIO?

-- 
Thanks.
HATAYAMA, Daisuke

