Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3JQHX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:23:28 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:55193 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3JQHX1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 17 Oct 2013 03:23:27 -0400
Message-Id: <525FAC8B02000078000FBAE8@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 17 Oct 2013 08:23:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <davem@davemloft.net>, <adobriyan@gmail.com>, <d.hatayama@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix proc_reg_get_unmapped_area()
References: <525E957802000078000FB6FE@nat28.tlf.novell.com>
 <20131016134044.d1bd8004f4fb94df405a541d@linux-foundation.org>
In-Reply-To: <20131016134044.d1bd8004f4fb94df405a541d@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.10.13 at 22:40, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 16 Oct 2013 12:32:40 +0100 "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> Commit c4fe24485729fc2cbff324c111e67a1cc2f9adea ("sparc: fix PCI device
>> proc file mmap(2)"), while fixing one problem, introduced two new ones:
>> - the function truncates the return value from ->get_unmapped_area() on
>>   64-bit architectures,
>> - _all_ descendants are now required to set .get_unmapped_area to non-
>>   NULL, which wasn't necessary before (and shouldn't be).
>> 
>> Both - afaict - are a result from a too simplistic copy'n'paste from
>> proc_reg_mmap() done in that change.
>> 
>> This likely also addresses reports like the one at
>> 
> http://linux-kernel.2935.n7.nabble.com/mmap-for-proc-vmcore-broken-since-3-12-rc1-td729 
> 326.html.
>> 
>> ...
>>
>> --- 3.12-rc5/fs/proc/inode.c
>> +++ 3.12-rc5-proc-get-unmapped-area/fs/proc/inode.c
>> @@ -288,12 +288,12 @@ static int proc_reg_mmap(struct file *fi
>>  static unsigned long proc_reg_get_unmapped_area(struct file *file, unsigned 
> long orig_addr, unsigned long len, unsigned long pgoff, unsigned long flags)
>>  {
>>  	struct proc_dir_entry *pde = PDE(file_inode(file));
>> -	int rv = -EIO;
>> -	unsigned long (*get_unmapped_area)(struct file *, unsigned long, unsigned 
> long, unsigned long, unsigned long);
>> +	unsigned long rv = -EIO;
>> +
>>  	if (use_pde(pde)) {
>> -		get_unmapped_area = pde->proc_fops->get_unmapped_area;
>> -		if (get_unmapped_area)
>> -			rv = get_unmapped_area(file, orig_addr, len, pgoff, flags);
>> +		rv = (pde->proc_fops->get_unmapped_area
>> +		      ?: current->mm->get_unmapped_area)(file, orig_addr, len,
>> +							 pgoff, flags);
>>  		unuse_pde(pde);
>>  	}
>>  	return rv;
> 
> I think these two patches will address the problems:
> 
> http://ozlabs.org/~akpm/mmots/broken-out/procfs-fix-unintended-truncation-of-retur 
> ned-mapped-address.patch
> http://ozlabs.org/~akpm/mmots/broken-out/procfs-call-default-get_unmapped_area-on- 
> mmu-present-architectures.patch
> 
> I'll be sending those Linuswards today.  Please check them.  (I think
> your version would break the nommu build).

Yes indeed - I did search for existing patches, but didn't find them.
I see Linus merged them already, so there's no point anymore
sending Reviewed-by tags.

I think though that in the !MMU case the second of them leaves an
issue unfixed nevertheless: If the specific procfs handler has no
.get_unmapped_area, the operation would still fail in that case
rather than succeed as it did before that wrapper got added.)

Jan

