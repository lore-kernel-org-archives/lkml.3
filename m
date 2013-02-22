Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab3BVCgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 21:36:33 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52193 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab3BVCgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 21:36:32 -0500
Message-ID: <5126D9A2.8090404@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 10:36:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361427108.5861.41.camel@marge.simpson.net> <5125C607.8090909@linux.vnet.ibm.com> <1361434231.5861.61.camel@marge.simpson.net> <5125E40D.6050006@linux.vnet.ibm.com> <1361439789.5861.70.camel@marge.simpson.net>
In-Reply-To: <1361439789.5861.70.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022202-3568-0000-0000-00000331AAF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2013 05:43 PM, Mike Galbraith wrote:
> On Thu, 2013-02-21 at 17:08 +0800, Michael Wang wrote:
> 
>> But is this patch set really cause regression on your Q6600? It may
>> sacrificed some thing, but I still think it will benefit far more,
>> especially on huge systems.
> 
> We spread on FORK/EXEC, and will no longer will pull communicating tasks
> back to a shared cache with the new logic preferring to leave wakee
> remote, so while no, I haven't tested (will try to find round tuit) it
> seems  it _must_ hurt.  Dragging data from one llc to the other on Q6600
> hurts a LOT.  Every time a client and server are cross llc, it's a huge
> hit.  The previous logic pulled communicating tasks together right when
> it matters the most, intermittent load... or interactive use.

I agree that this is a problem need to be solved, but don't agree that
wake_affine() is the solution.

According to my understanding, in the old world, wake_affine() will only
be used if curr_cpu and prev_cpu share cache, which means they are in
one package, whatever search in llc sd of curr_cpu or prev_cpu, we won't
have the chance to spread the task out of that package.

I'm going to recover the logical that only do select_idle_sibling() when
prev_cpu and curr_cpu are affine, so now the new logical will only
prefer leaving task in old package if both prev_cpu and curr_cpu are in
that package, I think this could solve the problem, isn't it?

Regards,
Michael Wang



> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

