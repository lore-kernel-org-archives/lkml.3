Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbaHAVmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 17:42:23 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35352 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAVmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 17:42:21 -0400
Date: Fri, 1 Aug 2014 14:42:19 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch 2/3] mm, oom: remove unnecessary check for NULL
 zonelist
In-Reply-To: <20140801133444.GH9952@cmpxchg.org>
Message-ID: <alpine.DEB.2.02.1408011434330.11532@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1407231814110.22326@chino.kir.corp.google.com> <alpine.DEB.2.02.1407231815090.22326@chino.kir.corp.google.com> <20140731152659.GB9952@cmpxchg.org> <alpine.DEB.2.02.1408010159500.4061@chino.kir.corp.google.com>
 <20140801133444.GH9952@cmpxchg.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Aug 2014, Johannes Weiner wrote:

> > > out_of_memory() wants the zonelist that was used during allocation,
> > > not just the random first node's zonelist that's simply picked to
> > > serialize page fault OOM kills system-wide.
> > > 
> > > This would even change how panic_on_oom behaves for page fault OOMs
> > > (in a completely unpredictable way) if we get CONSTRAINED_CPUSET.
> > > 
> > > This change makes no sense to me.
> > > 
> > 
> > Allocations during fault will be constrained by the cpuset's mems, if we 
> > are oom then why would we panic when panic_on_oom == 1?
> 
> Can you please address the concerns I raised?
> 

I see one concern: that panic_on_oom == 1 will not trigger on pagefault 
when constrained by cpusets.  To address that, I'll state that, since 
cpuset-constrained allocations are the allocation context for pagefaults,
panic_on_oom == 1 should not trigger on pagefault when constrained by 
cpusets.

> And please describe user-visible changes in the changelog.
> 

Ok, Andrew please annotate the changelog for 
mm-oom-remove-unnecessary-check-for-null-zonelist.patch by including:

This also causes panic_on_oom == 1 to not panic the machine when the 
pagefault is constrained by the mems of current's cpuset.  That behavior 
agrees with the semantics of the sysctl in Documentation/sysctl/vm.txt.
