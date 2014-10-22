Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaJVKcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:32:20 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:36357 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbaJVKcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:32:18 -0400
Date: Wed, 22 Oct 2014 12:32:08 +0200
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Bob Liu <lliubbo@gmail.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        kvm@vger.kernel.org, linux390@de.ibm.com, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/4] s390/mm: prevent and break zero page mappings in
 case of storage keys
Message-ID: <20141022123208.3bcb6cfb@BR9TG4T3.de.ibm.com>
In-Reply-To: <5447825B.5040608@redhat.com>
References: <1413966624-12447-1-git-send-email-dingel@linux.vnet.ibm.com>
	<1413966624-12447-4-git-send-email-dingel@linux.vnet.ibm.com>
	<5447825B.5040608@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102210-0041-0000-0000-000001C500A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014 12:09:31 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 10/22/2014 10:30 AM, Dominik Dingel wrote:
> > As use_skey is already the condition on which we call s390_enable_skey
> > we need to introduce a new flag for the mm->context on which we decide
> > if zero page mapping is allowed.
> 
> Can you explain better why "mm->context.use_skey = 1" cannot be done
> before the walk_page_range?  Where does the walk or __s390_enable_skey
> or (after the next patch) ksm_madvise rely on
> "mm->context.forbids_zeropage && !mm->context.use_skey"?

I can't, my reasoning there is wrong.
I remembered incorrectly that we use mm_use_skey in arch/s390/kvm/priv.c to
check if we need to call s390_enable_skey, but that does happen
with the interception bits.

So every vCPU which get the a interception for a storage key instruction
will call s390_enable_skey and wait there for the mmap_sem.

> The only reason I can think of, is that the next patch does not reset
> "mm->context.forbids_zeropage" to 0 if the ksm_madvise fails.  Why
> doesn't it do that---or is it a bug?

You are right, this is a bug, where we will drop to userspace with -ENOMEM.

I will fix this as well. 


> Thanks, and sorry for the flurry of questions! :)

I really appreciate your questions and remarks. Thank you!

> Paolo
> 

