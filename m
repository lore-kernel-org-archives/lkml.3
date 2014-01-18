Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbaARDcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:32:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbaARDcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:32:09 -0500
Message-ID: <52D9F599.3040508@redhat.com>
Date: Fri, 17 Jan 2014 22:31:37 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-mm@kvack.org, chegu_vinod@hp.com, peterz@infradead.org,
        mgorman@suse.de, mingo@redhat.com, Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH 7/7] numa,sched: do statistics calculation using local
 variables only
References: <1389993129-28180-1-git-send-email-riel@redhat.com> <1389993129-28180-8-git-send-email-riel@redhat.com>
In-Reply-To: <1389993129-28180-8-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 04:12 PM, riel@redhat.com wrote:
> From: Rik van Riel <riel@redhat.com>
> 
> The current code in task_numa_placement calculates the difference
> between the old and the new value, but also temporarily stores half
> of the old value in the per-process variables.
> 
> The NUMA balancing code looks at those per-process variables, and
> having other tasks temporarily see halved statistics could lead to
> unwanted numa migrations. This can be avoided by doing all the math
> in local variables.
> 
> This change also simplifies the code a little.

I am seeing what looks like a performance improvement
with this patch, so it is not just a theoretical bug.
The improvement is small, as is to be expected with
such a small race, but with two 32-warehouse specjbb
instances on a 4-node, 10core/20thread per node system,
I see the following change in performance, and reduced
numa page migrations.

Without the patch:
run 1: throughput 367660 367660, migrated 3112982
run 2: throughput 353821 355612, migrated 2881317
run 3: throughput 355027 355027, migrated 3358105
run 4: throughput 354366 354366, migrated 3466687
run 5: throughput 356186 356186, migrated 3152194
run 6: throughput 361431 361431, migrated 3336219
run 7: throughput 354704 354704, migrated 3345418
run 8: throughput 363770 363770, migrated 3642925
run 9: throughput 363380 363380, migrated 3192836
run 10: throughput 358440 358440, migrated 3354028
  avg: througphut 358968, migrated 3284271

With the patch:
run 1: throughput 360580 360580, migrated 3169872
run 2: throughput 361303 361303, migrated 3220280
run 3: throughput 367692 367692, migrated 3096093
run 4: throughput 362320 362320, migrated 2981762
run 5: throughput 364201 364201, migrated 3089107
run 6: throughput 364561 364561, migrated 2892364
run 7: throughput 360771 360771, migrated 3086638
run 8: throughput 361530 361530, migrated 2933256
run 9: throughput 365841 365841, migrated 3356944
run 10: throughput 359188 359188, migrated 3394545
  avg: througphut 362798, migrated 3122086


-- 
All rights reversed
