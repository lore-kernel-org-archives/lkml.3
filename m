Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbbAQPiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:38:12 -0500
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:43073 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751633AbbAQPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:38:09 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3867:3870:3871:3874:4423:4432:5007:6261:7903:8660:9040:9121:10004:10400:10848:11026:11233:11658:11914:12043:12291:12438:12517:12519:12555:12679:12683:13018:13019:13148:13161:13229:13230:13870:14096:14097:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: burn17_cb391d8e3559
X-Filterd-Recvd-Size: 3062
Date: Sat, 17 Jan 2015 10:38:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH][v3.2 stable tree] dcache: Balance rcu_read_lock in
 have_submounts()
Message-ID: <20150117103806.0a7d3898@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Porting -rt to the latest 3.2 stable tree I triggered this bug:

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
rm/1638 is trying to release lock (rcu_read_lock) at:
[<c04fde6c>] rcu_read_unlock+0x0/0x23
but there are no more locks to release!

other info that might help us debug this:
2 locks held by rm/1638:
 #0:  (&sb->s_type->i_mutex_key#9/1){+.+.+.}, at: [<c04f93eb>] do_rmdir+0x5f/0xd2
 #1:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<c04f9329>] vfs_rmdir+0x49/0xac

stack backtrace:
Pid: 1638, comm: rm Not tainted 3.2.66-test-rt96+ #2
Call Trace:
 [<c083f390>] ? printk+0x1d/0x1f
 [<c0463cdf>] print_unlock_inbalance_bug+0xc3/0xcd
 [<c04653a8>] lock_release_non_nested+0x98/0x1ec
 [<c046228d>] ? trace_hardirqs_off_caller+0x18/0x90
 [<c0456f1c>] ? local_clock+0x2d/0x50
 [<c04fde6c>] ? d_hash+0x2f/0x2f
 [<c04fde6c>] ? d_hash+0x2f/0x2f
 [<c046568e>] lock_release+0x192/0x1ad
 [<c04fde83>] rcu_read_unlock+0x17/0x23
 [<c04ff344>] shrink_dcache_parent+0x227/0x270
 [<c04f9348>] vfs_rmdir+0x68/0xac
 [<c04f9424>] do_rmdir+0x98/0xd2
 [<c04f03ad>] ? fput+0x1a3/0x1ab
 [<c084dd42>] ? sysenter_exit+0xf/0x1a
 [<c0465b58>] ? trace_hardirqs_on_caller+0x118/0x149
 [<c04fa3e0>] sys_unlinkat+0x2b/0x35
 [<c084dd13>] sysenter_do_call+0x12/0x12




There's a path to calling rcu_read_unlock() without calling
rcu_read_lock() in have_submounts().

	goto positive;

positive:
	if (!locked && read_seqretry(&rename_lock, seq))
		goto rename_retry;

rename_retry:
	rcu_read_unlock();

in the above path, rcu_read_lock() is never done before calling
rcu_read_unlock();

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/dcache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 98cc4508e140..0d0ba5b2a8ae 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1035,8 +1035,10 @@ ascend:
 		write_sequnlock(&rename_lock);
 	return 0; /* No mount points found in tree */
 positive:
-	if (!locked && read_seqretry(&rename_lock, seq))
+	if (!locked && read_seqretry(&rename_lock, seq)) {
+		rcu_read_lock();
 		goto rename_retry;
+	}
 	if (locked)
 		write_sequnlock(&rename_lock);
 	return 1;
-- 
2.1.4

