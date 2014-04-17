Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaDQITh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:19:37 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37288 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaDQITc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:19:32 -0400
Subject: [PATCH -tip v9 24/26] kprobes: Enlarge hash table to 512 entries
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Sandeepa Prabhu <sandeepa.prabhu@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, fche@redhat.com,
        mingo@redhat.com, systemtap@sourceware.org,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 17 Apr 2014 17:19:24 +0900
Message-ID: <20140417081924.26341.23535.stgit@ltc230.yrl.intra.hitachi.co.jp>
In-Reply-To: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
References: <20140417081636.26341.87858.stgit@ltc230.yrl.intra.hitachi.co.jp>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, since the kprobes expects to be used with less than
100 probe points, its hash table just has 64 entries. This is
too little to handle several thousands of probes.
Enlarge the size of kprobe_table to 512 entries which just
consumes 4KB (on 64bit arch) for better scalability.

Note that this also decouples the hash sizes of kprobe_table and
kretprobe_inst_table/locks, since those use different sources
for hash (kprobe uses probed address, whereas kretprobe uses
task structure.)

Without this patch, enabling 17787 probes takes more than 2 hours!
(9428sec, 1 min intervals for each 2000 probes enabled)

  Enabling trace events: start at 1392782584
  0 1392782585 a2mp_chan_alloc_skb_cb_38556
  1 1392782585 a2mp_chan_close_cb_38555
  ....
  17785 1392792008 lookup_vport_34987
  17786 1392792010 loop_add_23485
  17787 1392792012 loop_attr_do_show_autoclear_23464

I profiled it and saw that more than 90% of cycles are consumed
on get_kprobe.

  Samples: 18K of event 'cycles', Event count (approx.): 37759714934
  +  95.90%  [k] get_kprobe
  +   0.76%  [k] ftrace_lookup_ip
  +   0.54%  [k] kprobe_trace_func

And also more than 60% of executed instructions were in get_kprobe
too.

  Samples: 17K of event 'instructions', Event count (approx.): 1321391290
  +  65.48%  [k] get_kprobe
  +   4.07%  [k] kprobe_trace_func
  +   2.93%  [k] optimized_callback


And annotating get_kprobe also shows the hlist is too long and takes
a time on tracking it. Thus I guess it mostly comes from tracking
too long hlist at the table entry.

       |            struct hlist_head *head;
       |            struct kprobe *p;
       |
       |            head = &kprobe_table[hash_ptr(addr, KPROBE_HASH_BITS)];
       |            hlist_for_each_entry_rcu(p, head, hlist) {
 86.33 |      mov    (%rax),%rax
 11.24 |      test   %rax,%rax
       |      jne    60
       |                    if (p->addr == addr)
       |                            return p;
       |            }

To fix this issue, I tried to enlarge the size of kprobe_table
from 6(current) to 12, and profiled cycles% on the get_kprobe
with 10k probes enabled / 37k probes registered.

  Size  Cycles%
  2^6   95.58%
  2^7   85.83%
  2^8   68.43%
  2^9   48.61%
  2^10  46.95%
  2^11  48.46%
  2^12  56.95%

Here, we can see the hash tables larger than 2^9 (512 entries)
have no much performance improvement. So I decided to enlarge
it to 512 entries.

With this fix, enabling 20,000 probes just took
about 45 min (2934 sec, 1 min intervals for
each 2000 probes enabled)

  Enabling trace events: start at 1393921862
  0 1393921864 a2mp_chan_alloc_skb_cb_38581
  1 1393921864 a2mp_chan_close_cb_38580
  ...
  19997 1393924927 nfs4_match_stateid_11750
  19998 1393924927 nfs4_negotiate_security_12137
  19999 1393924928 nfs4_open_confirm_done_11785

And it reduced cycles on get_kprobe (with 20,000 probes).

  Samples: 691  of event 'cycles', Event count (approx.): 1743375714
  +  67.68%  [k] get_kprobe
  +   5.98%  [k] ftrace_lookup_ip
  +   4.03%  [k] kprobe_trace_func

Changes from v7:
 - Evaluate the size of hash table and reduce it to 512 entries.
 - Decouple the hash size of kprobe_table from others.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 kernel/kprobes.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index abdede5..a29e622 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -54,9 +54,10 @@
 #include <asm/errno.h>
 #include <asm/uaccess.h>
 
-#define KPROBE_HASH_BITS 6
+#define KPROBE_HASH_BITS 9
+#define KRETPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
-
+#define KRETPROBE_TABLE_SIZE (1 << KRETPROBE_HASH_BITS)
 
 /*
  * Some oddball architectures like 64bit powerpc have function descriptors
@@ -69,7 +70,7 @@
 
 static int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
-static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
+static struct hlist_head kretprobe_inst_table[KRETPROBE_TABLE_SIZE];
 
 /* NOTE: change this value only with kprobe_mutex held */
 static bool kprobes_all_disarmed;
@@ -79,7 +80,7 @@ static DEFINE_MUTEX(kprobe_mutex);
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
 static struct {
 	raw_spinlock_t lock ____cacheline_aligned_in_smp;
-} kretprobe_table_locks[KPROBE_TABLE_SIZE];
+} kretprobe_table_locks[KRETPROBE_TABLE_SIZE];
 
 static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
 {
@@ -1096,7 +1097,7 @@ void kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 __acquires(hlist_lock)
 {
-	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	unsigned long hash = hash_ptr(tsk, KRETPROBE_HASH_BITS);
 	raw_spinlock_t *hlist_lock;
 
 	*head = &kretprobe_inst_table[hash];
@@ -1118,7 +1119,7 @@ void kretprobe_hash_unlock(struct task_struct *tsk,
 			   unsigned long *flags)
 __releases(hlist_lock)
 {
-	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	unsigned long hash = hash_ptr(tsk, KRETPROBE_HASH_BITS);
 	raw_spinlock_t *hlist_lock;
 
 	hlist_lock = kretprobe_table_lock_ptr(hash);
@@ -1153,7 +1154,7 @@ void kprobe_flush_task(struct task_struct *tk)
 		return;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	hash = hash_ptr(tk, KPROBE_HASH_BITS);
+	hash = hash_ptr(tk, KRETPROBE_HASH_BITS);
 	head = &kretprobe_inst_table[hash];
 	kretprobe_table_lock(hash, &flags);
 	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
@@ -1187,7 +1188,7 @@ static void cleanup_rp_inst(struct kretprobe *rp)
 	struct hlist_head *head;
 
 	/* No race here */
-	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
+	for (hash = 0; hash < KRETPROBE_TABLE_SIZE; hash++) {
 		kretprobe_table_lock(hash, &flags);
 		head = &kretprobe_inst_table[hash];
 		hlist_for_each_entry_safe(ri, next, head, hlist) {
@@ -1778,7 +1779,7 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	struct kretprobe_instance *ri;
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
-	hash = hash_ptr(current, KPROBE_HASH_BITS);
+	hash = hash_ptr(current, KRETPROBE_HASH_BITS);
 	raw_spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
 		ri = hlist_entry(rp->free_instances.first,
@@ -2164,8 +2165,10 @@ static int __init init_kprobes(void)
 
 	/* FIXME allocate the probe table, currently defined statically */
 	/* initialize all list heads */
-	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++)
 		INIT_HLIST_HEAD(&kprobe_table[i]);
+
+	for (i = 0; i < KRETPROBE_TABLE_SIZE; i++) {
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
 		raw_spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}


