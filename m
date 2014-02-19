Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaBST2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:28:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbaBST2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:28:05 -0500
Date: Wed, 19 Feb 2014 11:28:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, chegu_vinod@hp.com, aarcange@redhat.com
Subject: Re: [PATCH -mm 0/3] fix numa vs kvm scalability issue
Message-Id: <20140219112803.75c6daf470dad88eb10f5dab@linux-foundation.org>
In-Reply-To: <20140219085917.GJ27965@twins.programming.kicks-ass.net>
References: <1392761566-24834-1-git-send-email-riel@redhat.com>
	<20140219085917.GJ27965@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 09:59:17 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Feb 18, 2014 at 05:12:43PM -0500, riel@redhat.com wrote:
> > The NUMA scanning code can end up iterating over many gigabytes
> > of unpopulated memory, especially in the case of a freshly started
> > KVM guest with lots of memory.
> > 
> > This results in the mmu notifier code being called even when
> > there are no mapped pages in a virtual address range. The amount
> > of time wasted can be enough to trigger soft lockup warnings
> > with very large (>2TB) KVM guests.
> > 
> > This patch moves the mmu notifier call to the pmd level, which
> > represents 1GB areas of memory on x86-64. Furthermore, the mmu
> > notifier code is only called from the address in the PMD where
> > present mappings are first encountered.
> > 
> > The hugetlbfs code is left alone for now; hugetlb mappings are
> > not relocatable, and as such are left alone by the NUMA code,
> > and should never trigger this problem to begin with.
> > 
> > The series also adds a cond_resched to task_numa_work, to
> > fix another potential latency issue.
> 
> Andrew, I'll pick up the first kernel/sched/ patch; do you want the
> other two mm/ patches?

That works, thanks.
