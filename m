Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935359Ab3DJX0O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:26:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36512 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761256Ab3DJX0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:26:12 -0400
Message-ID: <5165F508.4020207@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 16:26:00 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: akpm@linux-foundation.org, mgorman@suse.de, matthew.garrett@nebula.com,
        dave@sr71.net, rientjes@google.com, riel@redhat.com,
        arjan@linux.intel.com, srinivas.pandruvada@linux.intel.com,
        maxime.coquelin@stericsson.com, loic.pallardy@stericsson.com,
        kamezawa.hiroyu@jp.fujitsu.com, lenb@kernel.org, rjw@sisk.pl,
        gargankita@gmail.com, paulmck@linux.vnet.ibm.com,
        amit.kachhap@linaro.org, svaidy@linux.vnet.ibm.com,
        andi@firstfloor.org, wujianguo@huawei.com, kmpark@infradead.org,
        thomas.abraham@linaro.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 14/15] mm: Add alloc-free handshake to trigger
 memory region compaction
References: <20130409214443.4500.44168.stgit@srivatsabhat.in.ibm.com> <20130409214853.4500.63619.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130409214853.4500.63619.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041023-9360-0000-0000-000011B03694
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 02:48 PM, Srivatsa S. Bhat wrote:
> We need a way to decide when to trigger the worker threads to perform
> region evacuation/compaction. So the strategy used is as follows:
>
> Alloc path of page allocator:
> ----------------------------
>
> This accurately tracks the allocations and detects the first allocation
> in a new region and notes down that region number. Performing compaction
> rightaway is not going to be helpful because we need free pages in the
> lower regions to be able to do that. And the page allocator allocated in
> this region precisely because there was no memory available in lower regions.
> So the alloc path just notes down the freshly used region's id.
>
> Free path of page allocator:
> ---------------------------
>
> When we enter this path, we know that some memory is being freed. Here we
> check if the alloc path had noted down any region for compaction. If so,
> we trigger the worker function that tries to compact that memory.
>
> Also, we avoid any locking/synchronization overhead over this worker
> function in the alloc/free path, by attaching appropriate semantics to the
> available status flags etc, such that we won't need any special locking
> around them.
>

Can you explain why avoiding locking works in this case?

It appears the lack of locking is only on the worker side, and the 
mem_power_ctrl is implicitly protected by zone->lock on the alloc & free 
side.

In the previous patch I see smp_mb(), but no explanation is provided for 
why they are needed. Are they related to/necessary for this lack of locking?

What happens when a region is passed over for compaction because the 
worker is already compacting another region? Can this occur? Will the 
compaction re-trigger appropriately?

I recommend combining this patch and the previous patch to make the 
interface more clear, or make functions that explicitly handle the 
interface for accessing mem_power_ctrl.

