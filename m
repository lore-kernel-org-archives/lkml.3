Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaJBMcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaJBMby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:31:54 -0400
Date: Thu, 2 Oct 2014 14:31:17 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: RFC: get_user_pages_locked|unlocked to leverage VM_FAULT_RETRY
Message-ID: <20141002123117.GB2342@redhat.com>
References: <20140926172535.GC4590@redhat.com>
 <20141001153611.GC2843@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001153611.GC2843@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 05:36:11PM +0200, Peter Zijlstra wrote:
> For all these and the other _fast() users, is there an actual limit to
> the nr_pages passed in? Because we used to have the 64 pages limit from
> DIO, but without that we get rather long IRQ-off latencies.

Ok, I would tend to think this is an issue to solve in gup_fast
implementation, I wouldn't blame or modify the callers for it.

I don't think there's anything that prevents gup_fast to enable irqs
after certain number of pages have been taken, nop; and disable the
irqs again.

If the TLB flush runs in parallel with gup_fast the result is
undefined anyway so there's no point to wait all pages to be taken
before letting the TLB flush go through. All it matters is that
gup_fast don't take pages that have been invalidated after the
tlb_flush returns on the other side. So I don't see issues in
releasing irqs and be latency friendly inside gup_fast fast path loop.

In fact gup_fast should also cond_resched() after releasing irqs, it's
not just an irq latency matter.

I could fix x86-64 for it in the same patchset unless somebody sees a
problem in releasing irqs inside the gup_fast fast path loop.

__gup_fast is an entirely different beast and that needs the callers to
be fixed but I didn't alter its callers.
