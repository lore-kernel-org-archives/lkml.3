Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3BVJLe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 04:11:34 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:48848 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab3BVJL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 04:11:28 -0500
Message-ID: <51273636.6080907@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2013 17:11:18 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
References: <51079178.3070002@linux.vnet.ibm.com> <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com> <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com> <1361522197.26780.39.camel@laptop>
In-Reply-To: <1361522197.26780.39.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022209-6102-0000-0000-0000030BA659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 04:36 PM, Peter Zijlstra wrote:
> On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
>> But that's really some benefit hardly to be estimate, especially when
>> the workload is heavy, the cost of wake_affine() is very high to
>> calculated se one by one, is that worth for some benefit we could not
>> promise?
> 
> Look at something like pipe-test.. wake_affine() used to ensure both
> client/server ran on the same cpu, but then I think we added
> select_idle_sibling() and wrecked it again :/
> 
> $ taskset 1 perf bench sched pipe
> # Running sched/pipe benchmark...
> # Extecuted 1000000 pipe operations between two tasks
> 
>      Total time: 3.761 [sec]
> 
>        3.761725 usecs/op
>          265835 ops/sec
> 
> $ perf bench sched pipe
> # Running sched/pipe benchmark...
> # Extecuted 1000000 pipe operations between two tasks
> 
>      Total time: 29.809 [sec]
> 
>       29.809720 usecs/op
>           33546 ops/sec
> 

Ok, it do looks like wake_affine() lost it's value...

> 
> Now as far as I can see there's two options, either we find there's
> absolutely no benefit in wake_affine() as it stands today and we simply
> disable/remove it, or we go fix it. What we don't do is completely
> wreck it at atrocious cost.

I get your point, we should replace wake_affine() with some feature
which could really achieve the goal to make client and server on same cpu.

But is the logical that the waker/wakee are server/client(or reversed)
still works now? that sounds a little arbitrary to me...

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

