Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbaD2NKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:10:25 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57628 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaD2NKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:10:21 -0400
Message-ID: <535FA488.8020405@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 18:39:28 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] vmacache: change vmacache_find() to always check ->vm_mm
References: <535EA976.1080402@linux.vnet.ibm.com> <CA+55aFxgW0fS=6xJsKP-WiOUw=aiCEvydj+pc+zDF8Pvn4v+Jw@mail.gmail.com> <CA+55aFzXAnTzfNL-bfUFnu15=4Z9HNigoo-XyjmwRvAWX_xz0A@mail.gmail.com> <1398724754.25549.35.camel@buesod1.americas.hpqcorp.net> <CA+55aFz0jrk-O9gq9VQrFBeWTpLt_5zPt9RsJO9htrqh+nKTfA@mail.gmail.com> <20140428161120.4cad719dc321e3c837db3fd6@linux-foundation.org> <CA+55aFwLSW3V76Y_O37Y8r_yaKQ+y0VMk=6SEEBpeFfGzsJUKA@mail.gmail.com> <1398730319.25549.40.camel@buesod1.americas.hpqcorp.net> <535F78A8.80403@linux.vnet.ibm.com> <20140429125255.GA13934@redhat.com>
In-Reply-To: <20140429125255.GA13934@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042913-5490-0000-0000-0000058699A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2014 06:22 PM, Oleg Nesterov wrote:
> On 04/29, Srivatsa S. Bhat wrote:
>>
>> I guess I'll hold off on testing this fix until I get to reproduce
>> the bug more reliably..
> 
> perhaps the patch below can help a bit?
> 
> -------------------------------------------------------------------------------
> Subject: [PATCH] vmacache: change vmacache_find() to always check ->vm_mm
> 
> If ->vmacache was corrupted it would be better to detect and report
> the problem asap, check vma->vm_mm before vm_start/vm_end.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  mm/vmacache.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmacache.c b/mm/vmacache.c
> index d4224b3..952a324 100644
> --- a/mm/vmacache.c
> +++ b/mm/vmacache.c
> @@ -81,9 +81,10 @@ struct vm_area_struct *vmacache_find(struct mm_struct *mm, unsigned long addr)
>  	for (i = 0; i < VMACACHE_SIZE; i++) {
>  		struct vm_area_struct *vma = current->vmacache[i];
> 
> -		if (vma && vma->vm_start <= addr && vma->vm_end > addr) {
> +		if (vma) {
>  			BUG_ON(vma->vm_mm != mm);
> -			return vma;
> +			if (vma->vm_start <= addr && vma->vm_end > addr)
> +				return vma;
>  		}
>  	}
> 

IIUC, this is similar to commit 50f5aa8a9b2 (mm: don't pointlessly use
BUG_ON() for sanity check). But even with that commit included I was
not able to reproduce the bug again, as reported here:

https://lkml.org/lkml/2014/4/29/187

Regards,
Srivatsa S. Bhat

