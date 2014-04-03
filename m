Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaDCXZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 19:25:07 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:50557 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaDCXZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 19:25:02 -0400
Message-ID: <533DEDC5.5070500@oracle.com>
Date: Thu, 03 Apr 2014 19:24:53 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr@hp.com>, linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] mm,tracing: improve current situation
References: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1396561440.4661.33.camel@buesod1.americas.hpqcorp.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 05:44 PM, Davidlohr Bueso wrote:
> Hi All,
> 
> During LSFMM Dave Jones discussed the current situation around
> testing/trinity in the mm. One of the conclusions was that basically we
> lack tools to gather the necessary information to make debugging a less
> painful process, making it pretty much a black box for a lot of cases.
> 
> One of the suggested ways to do so was to improve our tracing. Currently
> we have events for kmem, vmscan and oom (which really just traces the
> tunable updates) -- In addition Dave Hansen also also been trying to add
> tracing for TLB range flushing, hopefully that can make it in some time
> soon. However, this lacks the more general data that governs all of the
> core VM, such as vmas and of course the mm_struct.
> 
> To this end, I've started adding events to trace the vma lifecycle,
> including: creating, removing, splitting, merging, copying and
> adjusting. Currently it only prints out the start and end virtual
> addresses, such as:
> 
> bash-3661   [000]  ....  222.964847: split_vma: [8a8000-9a6000] => new: [9a6000-9b6000]
> 
> Now, on a more general scenario, I basically would like to know, 1) is
> this actually useful... I'm hoping that, if in fact something like this
> gets merged, it won't just sit there. 2) What other general data would
> be useful for debugging purposes? I'm happy to collect feedback and send
> out something we can all benefit from.

There's another thing we have to think about, which is the bottleneck of
getting that debug info out.

Turning on any sort of tracing/logging in mm/ would trigger huge amounts
of data flowing out. Any attempt to store that data anywhere would result
either in too much interference to the tests so that issues stop reproducing,
or way too much data to even be able to get through the guest <-> host pipe.

I was working on a similar idea, which is similar to what lockdep does now:
when you get a lockdep spew you see a nice output which also shows call
traces of relevant locks. What if, for example, we could make dump_page()
also dump the traces of where each of it's flags was set or cleared?


Thanks,
Sasha
