Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbbANDUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 22:20:12 -0500
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:47089 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbbANDUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 22:20:10 -0500
X-Greylist: delayed 7748 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2015 22:20:10 EST
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Shiraz Hashim <shashim@codeaurora.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mm: pagemap: limit scan to virtual region being
 asked
Thread-Topic: [PATCH 1/1] mm: pagemap: limit scan to virtual region being
 asked
Thread-Index: AQHQL5aiJDYEXiZIpk2KU/wUdIu3CQ==
Date: Wed, 14 Jan 2015 01:08:40 +0000
Message-ID: <20150114010830.GA16100@hori1.linux.bs1.fc.nec.co.jp>
References: <1421152024-6204-1-git-send-email-shashim@codeaurora.org>
In-Reply-To: <1421152024-6204-1-git-send-email-shashim@codeaurora.org>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.14]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <D1A14A54079C204688E385502014D5D0@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 05:57:04PM +0530, Shiraz Hashim wrote:
> pagemap_read scans through the virtual address space of a
> task till it prepares 'count' pagemaps or it reaches end
> of task.
> 
> This presents a problem when the page walk doesn't happen
> for vma with VM_PFNMAP set. In which case walk is silently
> skipped and no pagemap is prepare, in turn making
> pagemap_read to scan through task end, even crossing beyond
> 'count', landing into a different vma region. This leads to
> wrong presentation of mappings for that vma.
> 
> Fix this by limiting end_vaddr to the end of the virtual
> address region being scanned.
> 
> Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>

This patch works in some case, but there still seems a problem in another case.

Consider that we have two vmas within some narrow (PAGEMAP_WALK_SIZE) region.
One vma in lower address is VM_PFNMAP, and the other vma in higher address is not.
Then a single call of walk_page_range() skips the first vma and scans the
second vma, but the pagemap record of the second vma will be stored on the
wrong offset in the buffer, because we just skip vma(VM_PFNMAP) without calling
any callbacks (within which add_to_pagemap() increments pm.pos).

So calling pte_hole() for vma(VM_PFNMAP) looks a better fix to me.

Thanks,
Naoya Horiguchi

> ---
>  fs/proc/task_mmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 246eae8..04362e4 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1270,7 +1270,9 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
>  	src = *ppos;
>  	svpfn = src / PM_ENTRY_BYTES;
>  	start_vaddr = svpfn << PAGE_SHIFT;
> -	end_vaddr = TASK_SIZE_OF(task);
> +	end_vaddr = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
> +	if ((end_vaddr > TASK_SIZE_OF(task)) || (end_vaddr < start_vaddr))
> +		end_vaddr = TASK_SIZE_OF(task);
>  
>  	/* watch out for wraparound */
>  	if (svpfn > TASK_SIZE_OF(task) >> PAGE_SHIFT)
> -- 
> 
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
> member of the Code Aurora Forum, hosted by The Linux Foundation
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>