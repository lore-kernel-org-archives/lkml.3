Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110AbaIRGNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:13:33 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59749 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbaIRGNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:13:31 -0400
Date: Thu, 18 Sep 2014 09:13:26 +0300
From: Gleb Natapov <gleb@kernel.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] kvm: Faults which trigger IO release the mmap_sem
Message-ID: <20140918061326.GC30733@minantech.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
 <1410976308-7683-1-git-send-email-andreslc@google.com>
 <20140918002917.GA3921@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918002917.GA3921@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 08:29:17AM +0800, Wanpeng Li wrote:
> Hi Andres,
> On Wed, Sep 17, 2014 at 10:51:48AM -0700, Andres Lagar-Cavilla wrote:
> [...]
> > static inline int check_user_page_hwpoison(unsigned long addr)
> > {
> > 	int rc, flags = FOLL_TOUCH | FOLL_HWPOISON | FOLL_WRITE;
> >@@ -1177,9 +1214,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> > 		npages = get_user_page_nowait(current, current->mm,
> > 					      addr, write_fault, page);
> > 		up_read(&current->mm->mmap_sem);
> >-	} else
> >-		npages = get_user_pages_fast(addr, 1, write_fault,
> >-					     page);
> >+	} else {
> >+		/*
> >+		 * By now we have tried gup_fast, and possibly async_pf, and we
> >+		 * are certainly not atomic. Time to retry the gup, allowing
> >+		 * mmap semaphore to be relinquished in the case of IO.
> >+		 */
> >+		npages = kvm_get_user_page_io(current, current->mm, addr,
> >+					      write_fault, page);
> >+	}
> 
> try_async_pf 
>  gfn_to_pfn_async 
>   __gfn_to_pfn  			async = false 
                                        *async = false

>    __gfn_to_pfn_memslot
>     hva_to_pfn 
> 	 hva_to_pfn_fast 
> 	 hva_to_pfn_slow 
hva_to_pfn_slow checks async not *async.

> 	  kvm_get_user_page_io
> 
> page will always be ready after kvm_get_user_page_io which leads to APF
> don't need to work any more.
> 
> Regards,
> Wanpeng Li
> 
> > 	if (npages != 1)
> > 		return npages;
> > 
> >-- 
> >2.1.0.rc2.206.gedb03e5
> >
> >--
> >To unsubscribe, send a message with 'unsubscribe linux-mm' in
> >the body to majordomo@kvack.org.  For more info on Linux MM,
> >see: http://www.linux-mm.org/ .
> >Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

--
			Gleb.
