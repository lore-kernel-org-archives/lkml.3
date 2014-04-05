Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaDED2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 23:28:30 -0400
Received: from numascale.com ([213.162.240.84]:55886 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaDED22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 23:28:28 -0400
Message-ID: <533F7851.30803@numascale.com>
Date: Sat, 05 Apr 2014 11:28:17 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: ext4 performance falloff
References: <533EE547.3030504@numascale.com> <20140404205604.GC10275@thunk.org>
In-Reply-To: <20140404205604.GC10275@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OutGoing-Spam-Status: No, score=-2.9
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2014 04:56 AM, Theodore Ts'o wrote:
> On Sat, Apr 05, 2014 at 01:00:55AM +0800, Daniel J Blueman wrote:
>> On a larger system 1728 cores/4.5TB memory and 3.13.9, I'm seeing very low
>> 600KB/s cached write performance to a local ext4 filesystem:

 > Thanks for the heads up.  Most (all?) of the ext4 don't have systems
 > with thousands of cores, so these issues generally don't come up for
 > us, and so we're not likely (hell, very unlikely!) to notice potential
 > problems cause by these sorts of uber-large systems.

Hehe. It's not every day we get access to these systems also.

>> Analysis shows that ext4 is reading from all cores' cpu-local data (thus
>> expensive off-NUMA-node access) for each block written:
>>
>> if (free_clusters - (nclusters + rsv + dirty_clusters) <
>> 				EXT4_FREECLUSTERS_WATERMARK) {
>> 	free_clusters  = percpu_counter_sum_positive(fcc);
>> 	dirty_clusters = percpu_counter_sum_positive(dcc);
>> }
>>
>> This threshold is defined as:
>>
>> #define EXT4_FREECLUSTERS_WATERMARK (4 * (percpu_counter_batch *
>> nr_cpu_ids))
...
> The problem we are trying to solve here is that when we do delayed
> allocation, we're making an implicit promise that there will be space
> available
>
> I've done the calculations, and 4 * 32 * 1728 cores = 221184 blocks,
> or 864 megabytes.  That would mean that the file system is over 98%
> full, so that's actually pretty reasonable; most of the time there's
> more free space than that.

The filesystem is empty after the mkfs; the approach here may make sense 
if we want to allow all cores to write to this FS, but here we have one.

Instrumenting shows that free_clusters=16464621 nclusters=1 rsv=842790 
dirty_clusters=0 percpu_counter_batch=3456 nr_cpu_ids=1728; below 91GB 
space, we'd hit this issue. It feels more sensible to start this 
behaviour when the FS is say 98% full, irrespective of the number of 
cores, but that's not why the behaviour is there.

Since these block devices are attached to a single NUMA node's IO link, 
there is a scaling limitation there anyway, so there may be rationale in 
limiting this to use min(256,nr_cpu_ids) maybe?

> It looks like the real problem is that we're using nr_cpu_ids, which
> is the maximum possible number of cpu's that the system can support,
> which is different from the number of cpu's that you currently have.
> For normal kernels nr_cpu_ids is small, so that has never been a
> problem, but I bet you have nr_cpu_ids set to something really large,
> right?
>
> If you change nr_cpu_ids to total_cpus in the definition of
> EXT4_FREECLUSTERS_WATERMARK, does that make things better for your
> system?

I have reproduced this with CPU hotplug disabled, so nr_cpu_ids is 
nicely at 1728.

Thanks,
   Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
