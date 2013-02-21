Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3BUE62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 23:58:28 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:53971 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3BUE61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 23:58:27 -0500
Message-ID: <5125A966.6040601@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2013 12:58:14 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [RFC PATCH v3 1/3] sched: schedule balance map foundation
References: <51079178.3070002@linux.vnet.ibm.com> <510791B2.6090506@linux.vnet.ibm.com> <1361366720.10155.25.camel@laptop>
In-Reply-To: <1361366720.10155.25.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022104-7014-0000-0000-0000029ECAF1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 09:25 PM, Peter Zijlstra wrote:
> On Tue, 2013-01-29 at 17:09 +0800, Michael Wang wrote:
>> +struct sched_balance_map {
>> +       struct sched_domain **sd[SBM_MAX_TYPE];
>> +       int top_level[SBM_MAX_TYPE];
>> +       struct sched_domain *affine_map[NR_CPUS];
>> +};
> 
> Argh.. affine_map is O(n^2) in nr_cpus, that's not cool.

You are right, it cost space in order to accelerate the system, I've
calculated the cost once before (I'm really not good at this, please let
me know if I make any silly calculation...), the size of struct is:

SBM_MAX_TYPE * size of pointer * domain level
SBM_MAX_TYPE * size of int
NR_CPUS * size of pointer
padding

So for my 64bits box, which has 12 cpu and 3 domain level, the struct
size is:

3 * size of pointer * 3 = 9 pointer
3 * size of int		= 3 int
12 * size of pointer	= 12 pointer
padding

			= 3 int + 21 pointer + padding

And the final cost is 36 int and 252 pointer, add some padding, won't
over 5K, not a big deal.

Now suppose a big 64bits system with 1000 cpu and 10 level(I have no
idea how to calculate level from nodes, 10 is big in my mind...), the
struct size is:

3 * size of pointer * 10 = 30 pointer
3 * size of int		= 3 int
1000 * size of pointer	= 1000 pointer
padding

			= 3 int + 1030 pointer + padding

And the final cost is 3000 int and 1030000 pointer, and some padding,
but won't bigger than 10M, not a big deal for a system with 1000 cpu too.

Regards,
Michael Wang

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

