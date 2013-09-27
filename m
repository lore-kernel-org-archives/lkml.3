Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3I0VBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:01:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:47490 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab3I0VBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:01:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,995,1371106800"; 
   d="scan'208";a="402117944"
Message-ID: <5245F222.1000603@intel.com>
Date: Fri, 27 Sep 2013 14:01:22 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCHv4 02/10] mm: convert mm->nr_ptes to atomic_t
References: <1380287787-30252-1-git-send-email-kirill.shutemov@linux.intel.com> <1380287787-30252-3-git-send-email-kirill.shutemov@linux.intel.com> <5245EEAD.7010901@linux.vnet.ibm.com>
In-Reply-To: <5245EEAD.7010901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 01:46 PM, Cody P Schafer wrote:
> On 09/27/2013 06:16 AM, Kirill A. Shutemov wrote:
>> @@ -339,6 +339,7 @@ struct mm_struct {
>>       pgd_t * pgd;
>>       atomic_t mm_users;            /* How many users with user space? */
>>       atomic_t mm_count;            /* How many references to "struct
>> mm_struct" (users count as 1) */
>> +    atomic_t nr_ptes;            /* Page table pages */
>>       int map_count;                /* number of VMAs */
...
> 
> Will 32bits always be enough here? Should atomic_long_t be used instead?

There are 48 bits of virtual address space on x86 today.  12 bits of
that is the address inside the page, so we've at *most* 2^36 pages.  2^9
(512) pages are mapped by a pte page, so that means the page tables only
hold 2^27 pte pages in a single process.

We've got 31 bits of usable space in the atomic_t, so that definitely
works _today_.  If the virtual address space ever gets bigger, we might
have problems, though.

In practice, though, we steal a big chunk of that virtual address space
for the kernel, and that doesn't get accounted in mm->nr_ptes, so we've
got a _bit_ more wiggle room than just 4 bits.  Also, anybody that's
mapping >4 petabytes of memory with 4k ptes is just off their rocker.

I'm also not sure what the virtual address limits are for the more
obscure architectures, so I guess it's also possible they'll hit this.
I guess it wouldn't hurt to stick an overflow check in there for VM
debugging purposes.
