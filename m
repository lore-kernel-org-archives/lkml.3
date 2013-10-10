Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3JJIad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:30:33 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:59826 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab3JJIaa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Thu, 10 Oct 2013 04:30:30 -0400
Message-Id: <525681BD020000A100012B70@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 10 Oct 2013 10:30:21 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>,
        <linux-kernel@vger.kernel.org>
Subject: Antw: read stalls with large RAM: transparent huges pages,
 dirty buffers, or I/O (block) scheduler?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention: CPU power is not the problem: We have 2 * 6 Cores (2 Threads each), making 24 logical CPUs...

>>> Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de> schrieb am 10.10.2013 um 10:15
in Nachricht <52566237.478 : 161 : 60728>:
> Hi!
> 
> We are running some x86_64 servers with large RAM (128GB). Just to imagine: 
> With a memory speed of a little more than 9GB/s it takes > 10 seconds to read 
> all RAM...
> 
> In the past and recently we had problems with read() stalls when the kernel 
> was writing back big amounts (like 80GB) of dirty buffers on a somewhat slow 
> (40MB/s) device. The problem is old and well-known, it seems, but to really 
> solved.
> 
> One recommendation was to limit the amount of dirty buffers, which actually 
> did not help to really avoid the problem, specifically if new dirty buffers 
> are used as soon as they are available (i.e.: some were flushed). I had 
> success with limiting the used memory (including dirty pages) with control 
> groups (memory:iothrottle, SLES11 SP2), but the control framework (rccgconfig 
> setting up proper rights for /sys/fs/cgroup/mem/iothrottle/tasks) is quite 
> incomplete (no group write permission or ACL setup possible), so the end user 
> can hardly use that.
> 
> I still don't know whether read stalls are caused by the I/O channel or 
> device being saturated, or whether the kernel is waiting for unused buffers 
> to receive the read data, but I learned that I/O schedulers (and possibly the 
> block layer optimizations) can cause extra delays, too.
> 
> We had one situation where a single sector could not be read with direct I/O 
> for 10 seconds.
> 
> Recently we had the problem again, but it was clear that it was _not_ the 
> device being overloaded, nor was it the I/O channel. The read problem was 
> reported for a devioce that was almost idle, and the I/O channel (FC) can 
> handle much more than the disk system can in both directions. So the problem 
> seems to be inside the kernel.
> 
> Oracle recommends (in article  1557478.1, without explaining the details) to 
> turn off transparent huge pages. Before that I didn't think much about that 
> feature. It seems the kernel is not just creating huge pages when they are 
> requested explicitly (that's what I had thought), but also implicitly to 
> reduce the number of pages to me managed. Collecting smaller pages to combine 
> them for huge pages may also involve moving memory around (compaction), it 
> seems. I still don't know whether the kernel will also try to compact dirty 
> cache pages to huge pages, but we still see read stalls when there are many 
> dirty pages (like when copying 400GB of data to a somewhat slow (30MB/s) 
> disk.
> 
> Now I wonder what the real solution to the problem (not the numerous 
> work-arounds) would be. Obviously simply stopping (yield) dirty buffer flush 
> to give read a chance may not be sufficient when read needs to wait for 
> unused pages, especially if the disks being read from are faster than those 
> being written to.
> To my understanding dirty pages have an "age" that is used to decide whether 
> to flush them or not. Also the I/O scheduler seems to prefer read requests 
> over write requests. What I do not know is whether a read request is sent to 
> the I/O scheduler before buffer pages are assigned to the request, or after 
> the pages were assigned. So a read request only has the chance to have an 
> "age" once it entered the I/O scheduler, right?
> 
> So if read and writes had an "age" both, some EDF (earliest deadline first) 
> scheduling could be used to perform I/O (which would be controlling buffer 
> usage as a side-effect). For transparent huge pages, requests for a huge page 
> should also have an age and a priority that is significantly below that of 
> I/O buffers. If there exists an efficient algorithm and data model to perform 
> these tasks, the problem may be solved.
> 
> Unfortunately if many buffers are dirtied at one moment and reads are 
> requested significantly later, there may be an additional need for 
> time-slices when doing I/O (note: I'm not talking about quotas of some MB, 
> but quotas of time). The I/O throughput may vary a lot, and time seems the 
> only way to manage latency correctly. To avoid a situation where reads may 
> cause stalling writes (and thus the age of dirty buffers growing without 
> bounds), the priority of writes should be _carefully_ increased, taking care 
> not to create a "fright train of dirty buffers" to be flushed. So maybe 
> "smuggle in" a few dirty buffers between read requests. As a high-level flow 
> control (like for the cgroups mechanism), processes with a high amount of 
> dirty buffers should be suspended or scheduled with very low priority to give 
> the memory and I/O systems a change to process the dirty buffers.
> 
> For reference: The machine in question is at 3.0.74-0.6.10-default with the 
> latest SLES11 SP2 kernel being 3.0.93-0.5.
> 
> I'd like to know what the gurus thing about that. I think with increasing 
> RAM this issue will become extremely important soon.
> 
> Regards,
> Ulrich
> P.S: Not subscribed to linux-kernel, so keep me on CC:, please
> 
> 


