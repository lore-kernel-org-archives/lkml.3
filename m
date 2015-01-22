Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbbAVP54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:57:56 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:47180 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbbAVP5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:57:54 -0500
Date: Thu, 22 Jan 2015 16:57:48 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: Call rcu_read_unlock() before copy_to_user()
Message-ID: <20150122165748.08136865@holzheu>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012215-0009-0000-0000-000002DCF151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We must not hold locks when calling copy_to_user():

BUG: sleeping function called from invalid context at mm/memory.c:3732
in_atomic(): 0, irqs_disabled(): 0, pid: 671, name: test_maps
1 lock held by test_maps/671:
 #0:  (rcu_read_lock){......}, at: [<0000000000264190>] map_lookup_elem+0xe8/0x260
Preemption disabled at:[<00000000001be3b6>] vprintk_default+0x56/0x68

CPU: 0 PID: 671 Comm: test_maps Not tainted 3.19.0-rc5-00117-g5eb11d6-dirty #424
       000000001e447bb0 000000001e447c40 0000000000000002 0000000000000000 
       000000001e447ce0 000000001e447c58 000000001e447c58 0000000000115c8a 
       0000000000000000 0000000000c08246 0000000000c27e8a 000000000000000b 
       000000001e447ca0 000000001e447c40 0000000000000000 0000000000000000 
       0000000000000000 0000000000115c8a 000000001e447c40 000000001e447ca0 
Call Trace:
([<0000000000115b7e>] show_trace+0x12e/0x150)
 [<0000000000115c40>] show_stack+0xa0/0x100
 [<00000000009b163c>] dump_stack+0x74/0xc8
 [<000000000017424a>] ___might_sleep+0x23a/0x248
 [<00000000002b58e8>] might_fault+0x70/0xe8
 [<0000000000264230>] map_lookup_elem+0x188/0x260
 [<0000000000264716>] SyS_bpf+0x20e/0x840
 [<00000000009bbe3a>] system_call+0xd6/0x24c
 [<000003fffd15f566>] 0x3fffd15f566
1 lock held by test_maps/671:
 #0:  (rcu_read_lock){......}, at: [<0000000000264190>] map_lookup_elem+0xe8/0x260

So call rcu_read_unlock() before copy_to_user(). We can
release the lock earlier because it is not needed for copy_to_user().

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 kernel/bpf/syscall.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -172,17 +172,16 @@ static int map_lookup_elem(union bpf_att
 	err = -ENOENT;
 	rcu_read_lock();
 	value = map->ops->map_lookup_elem(map, key);
+	rcu_read_unlock();
 	if (!value)
-		goto err_unlock;
+		goto free_key;
 
 	err = -EFAULT;
 	if (copy_to_user(uvalue, value, map->value_size) != 0)
-		goto err_unlock;
+		goto free_key;
 
 	err = 0;
 
-err_unlock:
-	rcu_read_unlock();
 free_key:
 	kfree(key);
 err_put:

