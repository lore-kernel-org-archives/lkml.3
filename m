Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460Ab3JIDhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 23:37:24 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:11583 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab3JIDhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:37:20 -0400
Message-ID: <1381289836.2308.26.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] lockstat: report avg wait and hold times
From: Davidlohr Bueso <davidlohr@hp.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        aswin@hp.com, linux-kernel@vger.kernel.org
Date: Tue, 08 Oct 2013 20:37:16 -0700
In-Reply-To: <20131003121513.GA6760@gmail.com>
References: <1380746928.2313.14.camel@buesod1.americas.hpqcorp.net>
	 <20131003121513.GA6760@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-03 at 14:15 +0200, Ingo Molnar wrote:
> * Davidlohr Bueso <davidlohr@hp.com> wrote:
[...]
> > --- a/kernel/lockdep_proc.c
> > +++ b/kernel/lockdep_proc.c
> > @@ -421,6 +421,7 @@ static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
> >  	seq_time(m, lt->min);
> >  	seq_time(m, lt->max);
> >  	seq_time(m, lt->total);
> > +	seq_time(m, lt->nr ? lt->total/lt->nr : 0);
> 
> That won't build on 32-bit systems as lt->total is s64.
> 
> You'll need to utilize do_div().

Oops, thanks for pointing that out. Below is v2.

8<-----------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: [PATCH v2] lockstat: Report avg wait and hold times

While both the nr and total times are showed, having the avg
lock hold and wait times show in the report is quite useful when
working on performance related issues. Furthermore, I find
myself constantly doing the calculations manually.

In addition, some of the documentation examples were changed to
easily update them to show the two new columns. No textual
change otherwise, as descriptions match the lockstat output.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: aswin@hp.com
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1380746928.2313.14.camel@buesod1.americas.hpqcorp.net
[ Fixlets: changed a seq_printf() to seq_puts(), converted spaces to tabs. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 Documentation/lockstat.txt | 123 ++++++++++++++++++++++-----------------------
 kernel/lockdep_proc.c      |  15 +++---
 2 files changed, 70 insertions(+), 68 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index dd2f7b2..72d0106 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -46,16 +46,14 @@ With these hooks we provide the following statistics:
  contentions       - number of lock acquisitions that had to wait
  wait time min     - shortest (non-0) time we ever had to wait for a lock
            max     - longest time we ever had to wait for a lock
-           total   - total time we spend waiting on this lock
+	   total   - total time we spend waiting on this lock
+	   avg     - average time spent waiting on this lock
  acq-bounces       - number of lock acquisitions that involved x-cpu data
  acquisitions      - number of times we took the lock
  hold time min     - shortest (non-0) time we ever held the lock
-           max     - longest time we ever held the lock
-           total   - total time this lock was held
-
-From these number various other statistics can be derived, such as:
-
- hold time average = hold time total / acquisitions
+	   max     - longest time we ever held the lock
+	   total   - total time this lock was held
+	   avg     - average time this lock was held
 
 These numbers are gathered per lock class, per read/write state (when
 applicable).
@@ -84,37 +82,38 @@ Look at the current lock statistics:
 
 # less /proc/lock_stat
 
-01 lock_stat version 0.3
-02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+01 lock_stat version 0.4
+02-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
+03                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total   waittime-avg    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total   holdtime-avg
+04-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 05
-06                          &mm->mmap_sem-W:           233            538 18446744073708       22924.27      607243.51           1342          45806           1.71        8595.89     1180582.34
-07                          &mm->mmap_sem-R:           205            587 18446744073708       28403.36      731975.00           1940         412426           0.58      187825.45     6307502.88
-08                          ---------------
-09                            &mm->mmap_sem            487          [<ffffffff8053491f>] do_page_fault+0x466/0x928
-10                            &mm->mmap_sem            179          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
-11                            &mm->mmap_sem            279          [<ffffffff80210a57>] sys_mmap+0x75/0xce
-12                            &mm->mmap_sem             76          [<ffffffff802a490b>] sys_munmap+0x32/0x59
-13                          ---------------
-14                            &mm->mmap_sem            270          [<ffffffff80210a57>] sys_mmap+0x75/0xce
-15                            &mm->mmap_sem            431          [<ffffffff8053491f>] do_page_fault+0x466/0x928
-16                            &mm->mmap_sem            138          [<ffffffff802a490b>] sys_munmap+0x32/0x59
-17                            &mm->mmap_sem            145          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
+06                         &mm->mmap_sem-W:            46             84           0.26         939.10       16371.53         194.90          47291        2922365           0.16     2220301.69 17464026916.32        5975.99
+07                         &mm->mmap_sem-R:            37            100           1.31      299502.61      325629.52        3256.30         212344       34316685           0.10        7744.91    95016910.20           2.77
+08                         ---------------
+09                           &mm->mmap_sem              1          [<ffffffff811502a7>] khugepaged_scan_mm_slot+0x57/0x280
+19                           &mm->mmap_sem             96          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
+11                           &mm->mmap_sem             34          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
+12                           &mm->mmap_sem             17          [<ffffffff81127e71>] vm_munmap+0x41/0x80
+13                         ---------------
+14                           &mm->mmap_sem              1          [<ffffffff81046fda>] dup_mmap+0x2a/0x3f0
+15                           &mm->mmap_sem             60          [<ffffffff81129e29>] SyS_mprotect+0xe9/0x250
+16                           &mm->mmap_sem             41          [<ffffffff815351c4>] __do_page_fault+0x1d4/0x510
+17                           &mm->mmap_sem             68          [<ffffffff81113d77>] vm_mmap_pgoff+0x87/0xd0
 18
-19 ...............................................................................................................................................................................................
+19.............................................................................................................................................................................................................................
 20
-21                              dcache_lock:           621            623           0.52         118.26        1053.02           6745          91930           0.29         316.29      118423.41
-22                              -----------
-23                              dcache_lock            179          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
-24                              dcache_lock            113          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
-25                              dcache_lock             99          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
-26                              dcache_lock            104          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
-27                              -----------
-28                              dcache_lock            192          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
-29                              dcache_lock             98          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
-30                              dcache_lock             72          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
-31                              dcache_lock            112          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
+21                         unix_table_lock:           110            112           0.21          49.24         163.91           1.46          21094          66312           0.12         624.42       31589.81           0.48
+22                         ---------------
+23                         unix_table_lock             45          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
+24                         unix_table_lock             47          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
+25                         unix_table_lock             15          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
+26                         unix_table_lock              5          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
+27                         ---------------
+28                         unix_table_lock             39          [<ffffffff8150b111>] unix_release_sock+0x31/0x250
+29                         unix_table_lock             49          [<ffffffff8150ad8e>] unix_create1+0x16e/0x1b0
+30                         unix_table_lock             20          [<ffffffff8150ca37>] unix_find_other+0x117/0x230
+31                         unix_table_lock              4          [<ffffffff8150a09f>] unix_autobind+0x11f/0x1b0
+
 
 This excerpt shows the first two lock class statistics. Line 01 shows the
 output version - each time the format changes this will be updated. Line 02-04
@@ -131,30 +130,30 @@ The integer part of the time values is in us.
 
 Dealing with nested locks, subclasses may appear:
 
-32...............................................................................................................................................................................................
+32...........................................................................................................................................................................................................................
 33
-34                               &rq->lock:         13128          13128           0.43         190.53      103881.26          97454        3453404           0.00         401.11    13224683.11
+34                               &rq->lock:       13128          13128           0.43         190.53      103881.26           7.91          97454        3453404           0.00         401.11    13224683.11           3.82
 35                               ---------
-36                               &rq->lock            645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
-37                               &rq->lock            297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
-38                               &rq->lock            360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
-39                               &rq->lock            428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
+36                               &rq->lock          645          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+37                               &rq->lock          297          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+38                               &rq->lock          360          [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
+39                               &rq->lock          428          [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
 40                               ---------
-41                               &rq->lock             77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
-42                               &rq->lock            174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
-43                               &rq->lock           4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
-44                               &rq->lock            893          [<ffffffff81340524>] schedule+0x157/0x7b8
+41                               &rq->lock           77          [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
+42                               &rq->lock          174          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+43                               &rq->lock         4715          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+44                               &rq->lock          893          [<ffffffff81340524>] schedule+0x157/0x7b8
 45
-46...............................................................................................................................................................................................
+46...........................................................................................................................................................................................................................
 47
-48                             &rq->lock/1:         11526          11488           0.33         388.73      136294.31          21461          38404           0.00          37.93      109388.53
+48                             &rq->lock/1:        1526          11488           0.33         388.73      136294.31          11.86          21461          38404           0.00          37.93      109388.53           2.84
 49                             -----------
-50                             &rq->lock/1          11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+50                             &rq->lock/1        11526          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
 51                             -----------
-52                             &rq->lock/1           5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
-53                             &rq->lock/1           1224          [<ffffffff81340524>] schedule+0x157/0x7b8
-54                             &rq->lock/1           4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
-55                             &rq->lock/1            181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
+52                             &rq->lock/1         5645          [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
+53                             &rq->lock/1         1224          [<ffffffff81340524>] schedule+0x157/0x7b8
+54                             &rq->lock/1         4336          [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
+55                             &rq->lock/1          181          [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
 
 Line 48 shows statistics for the second subclass (/1) of &rq->lock class
 (subclass starts from 0), since in this case, as line 50 suggests,
@@ -163,16 +162,16 @@ double_rq_lock actually acquires a nested lock of two spinlocks.
 View the top contending locks:
 
 # grep : /proc/lock_stat | head
-              &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
-              &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
-                             dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
-                         &inode->i_mutex:           161            286 18446744073709       62882.54     1244614.55           3653          20598 18446744073709       62318.60     1693822.74
-                         &zone->lru_lock:            94             94           0.53           7.33          92.10           4366          32690           0.29          59.81       16350.06
-              &inode->i_data.i_mmap_mutex:            79             79           0.40           3.77          53.03          11779          87755           0.28         116.93       29898.44
-                        &q->__queue_lock:            48             50           0.52          31.62          86.31            774          13131           0.17         113.08       12277.52
-                        &rq->rq_lock_key:            43             47           0.74          68.50         170.63           3706          33929           0.22         107.99       17460.62
-                      &rq->rq_lock_key#2:            39             46           0.75           6.68          49.03           2979          32292           0.17         125.17       17137.63
-                         tasklist_lock-W:            15             15           1.45          10.87          32.70           1201           7390           0.58          62.55       13648.47
+			clockevents_lock:       2926159        2947636           0.15       46882.81  1784540466.34         605.41        3381345        3879161           0.00        2260.97    53178395.68          13.71
+		     tick_broadcast_lock:        346460         346717           0.18        2257.43    39364622.71         113.54        3642919        4242696           0.00        2263.79    49173646.60          11.59
+		  &mapping->i_mmap_mutex:        203896         203899           3.36      645530.05 31767507988.39      155800.21        3361776        8893984           0.17        2254.15    14110121.02           1.59
+			       &rq->lock:        135014         136909           0.18         606.09      842160.68           6.15        1540728       10436146           0.00         728.72    17606683.41           1.69
+	       &(&zone->lru_lock)->rlock:         93000          94934           0.16          59.18      188253.78           1.98        1199912        3809894           0.15         391.40     3559518.81           0.93
+			 tasklist_lock-W:         40667          41130           0.23        1189.42      428980.51          10.43         270278         510106           0.16         653.51     3939674.91           7.72
+			 tasklist_lock-R:         21298          21305           0.20        1310.05      215511.12          10.12         186204         241258           0.14        1162.33     1179779.23           4.89
+			      rcu_node_1:         47656          49022           0.16         635.41      193616.41           3.95         844888        1865423           0.00         764.26     1656226.96           0.89
+       &(&dentry->d_lockref.lock)->rlock:         39791          40179           0.15        1302.08       88851.96           2.21        2790851       12527025           0.10        1910.75     3379714.27           0.27
+			      rcu_node_0:         29203          30064           0.16         786.55     1555573.00          51.74          88963         244254           0.00         398.87      428872.51           1.76
 
 Clear the statistics:
 
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index b2c71c5..0922065 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -421,6 +421,7 @@ static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
 	seq_time(m, lt->min);
 	seq_time(m, lt->max);
 	seq_time(m, lt->total);
+	seq_time(m, lt->nr ? do_div(lt->total, lt->nr) : 0);
 }
 
 static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
@@ -518,20 +519,20 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 	}
 	if (i) {
 		seq_puts(m, "\n");
-		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
+		seq_line(m, '.', 0, 40 + 1 + 12 * (14 + 1));
 		seq_puts(m, "\n");
 	}
 }
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.3\n");
+	seq_puts(m, "lock_stat version 0.4\n");
 
 	if (unlikely(!debug_locks))
 		seq_printf(m, "*WARNING* lock debugging disabled!! - possibly due to a lockdep warning\n");
 
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
-	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
+	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
+	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
 			"class name",
 			"con-bounces",
@@ -539,12 +540,14 @@ static void seq_header(struct seq_file *m)
 			"waittime-min",
 			"waittime-max",
 			"waittime-total",
+			"waittime-avg",
 			"acq-bounces",
 			"acquisitions",
 			"holdtime-min",
 			"holdtime-max",
-			"holdtime-total");
-	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
+			"holdtime-total",
+			"holdtime-avg");
+	seq_line(m, '-', 0, 40 + 1 + 12 * (14 + 1));
 	seq_printf(m, "\n");
 }
 
-- 
1.8.1.4



