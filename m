Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab3J1PRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:17:55 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55292 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab3J1PRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:17:54 -0400
Date: Mon, 28 Oct 2013 23:17:46 +0800
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>, cl@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] percpu: stop the loop when a cpu belongs to a new
 group
Message-ID: <20131028151746.GA7548@weiyang.vnet.ibm.com>
Reply-To: Wei Yang <weiyang@linux.vnet.ibm.com>
References: <1382345893-6644-1-git-send-email-weiyang@linux.vnet.ibm.com>
 <20131027123008.GJ14934@mtj.dyndns.org>
 <20131028030055.GC15642@weiyang.vnet.ibm.com>
 <20131028113120.GB11541@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131028113120.GB11541@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102815-6102-0000-0000-00000469F17C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 07:31:20AM -0400, Tejun Heo wrote:
>Hello,
>
>On Mon, Oct 28, 2013 at 11:00:55AM +0800, Wei Yang wrote:
>> >Does this actually matter?  If so, it'd probably make a lot more sense
>> >to start inner loop at @cpu + 1 so that it becomes O(N).
>> 
>> One of the worst case in my mind:
>> 
>> CPU:        0    1    2    3    4    ...
>> Group:      0    1    2    3    4    ...
>> (sounds it is impossible in the real world)
>
>I was wondering whether you had an actual case where this actually
>matters or it's just something you thought of while reading the code.

Tejun,

Thanks for your comments.

I found this just in code review. :-)

>
>> Every time, when we encounter a new CPU and try to assign it to a group, we
>> found it belongs to a new group. The original logic will iterate on all old
>> CPUs again, while the new logic could skip this and assign it to a new group.
>> 
>> Again, this is a tiny change, which doesn't matters a lot.
>
>I think it *could* matter because the current implementation is O(N^2)
>where N is the number of CPUs.  On machines, say, with 4k CPU, it's
>gonna loop 16M times but then again even that takes only a few
>millisecs on modern machines.

I am not familiar with the real cases of the CPU numbers. Thanks for leting me
know there could be 4K CPUs.

Yep, a few millisecs sounds not a big a mount.

>
>> BTW, I don't get your point for "start inner loop at @cpu+1".
>> 
>> The original logic is:
>> 	loop 1:   0 - nr_cpus
>> 	loop 2:      0 - (cpu - 1)
>> 
>> If you found one better approach to improve the logic, I believe all the users
>> will appreciate your efforts :-)
>
>Ooh, right, I forgot about the break and then I thought somehow that
>would make it O(N).  Sorry about that.  I blame jetlag. :)
>
>Yeah, I don't know.  The function is quite hairy which makes me keep
>things simpler and reluctant to make changes unless it actually makes
>non-trivial difference.  The change looks okay to me but it seems
>neither necessary or substantially beneficial and if my experience is
>anything to go by, *any* change involves some risk of brekage no
>matter how innocent it may look, so given the circumstances, I'd like
>to keep things the way they are.

Yep, I really agree with you. If no big improvement, it is really not
necessary to change the code, which will face some risk.

Here I have another one, which in my mind will improve it in one case. Looking
forward to your comments :-) If I am not correct, please let me know. :-)

>From bd70498b9df47b25ff20054e24bb510c5430c0c3 Mon Sep 17 00:00:00 2001
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Date: Thu, 10 Oct 2013 09:42:14 +0800
Subject: [PATCH] percpu: optimize group assignment when cpu_distance_fn is
 NULL

When cpu_distance_fn is NULL, all CPUs belongs to group 0. The original logic
will continue to go through each CPU and its predecessor. cpu_distance_fn is
always NULL when pcpu_build_alloc_info() is called from pcpu_page_first_chunk().

By applying this patch, the time complexity will drop to O(n) form O(n^2) in
case cpu_distance_fn is NULL.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
---
 mm/percpu.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f79c807..8e6034f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1481,20 +1481,21 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(
 	for_each_possible_cpu(cpu) {
 		group = 0;
 	next_group:
-		for_each_possible_cpu(tcpu) {
-			if (cpu == tcpu)
-				break;
-			if (group_map[tcpu] == group && cpu_distance_fn &&
-			    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
-			     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
-				group++;
-				if (group == nr_groups) {
-					nr_groups++;
+		if (cpu_distance_fn)
+			for_each_possible_cpu(tcpu) {
+				if (cpu == tcpu)
 					break;
+				if (group_map[tcpu] == group &&
+				    (cpu_distance_fn(cpu, tcpu) > LOCAL_DISTANCE ||
+				     cpu_distance_fn(tcpu, cpu) > LOCAL_DISTANCE)) {
+					group++;
+					if (group == nr_groups) {
+						nr_groups++;
+						break;
+					}
+					goto next_group;
 				}
-				goto next_group;
 			}
-		}
 		group_map[cpu] = group;
 		group_cnt[group]++;
 	}
-- 
1.7.5.4

BTW, this one is based on my previous patch.

>
>Thanks a lot!
>
>-- 
>tejun

-- 
Richard Yang
Help you, Help me

