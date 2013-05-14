Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3ENSfI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:35:08 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:39079 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540Ab3ENSfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:35:06 -0400
Date: Tue, 14 May 2013 11:35:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Lingzhu Xiang <lxiang@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.9.0: panic during boot - kernel BUG at include/linux/gfp.h:323!
Message-ID: <20130514183500.GN6795@mtj.dyndns.org>
References: <22600323.7586117.1367826906910.JavaMail.root@redhat.com>
 <5191B101.1070000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5191B101.1070000@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 14, 2013 at 11:35:29AM +0800, Lingzhu Xiang wrote:
> On 05/06/2013 03:55 PM, CAI Qian wrote:
> >[    0.928031] ------------[ cut here ]------------
> >[    0.934231] kernel BUG at include/linux/gfp.h:323!
...
> >[    1.662913]  [<ffffffff812e3aa8>] alloc_cpumask_var_node+0x28/0x90
> >[    1.671224]  [<ffffffff81a0bdb3>] wq_numa_init+0x10d/0x1be
> >[    1.686085]  [<ffffffff81a0bec8>] init_workqueues+0x64/0x341

Does the following patch make the problem go away?  The dynamic paths
should be safe as they are synchronized against CPU hot plug paths and
don't allocate anything on nodes w/o any CPUs.

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4aa9f5b..232c1bb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -4895,7 +4895,8 @@ static void __init wq_numa_init(void)
 	BUG_ON(!tbl);
 
 	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL, node));
+		BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+				node_online(node) ? node : NUMA_NO_NODE));
 
 	for_each_possible_cpu(cpu) {
 		node = cpu_to_node(cpu);
