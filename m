Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaBJRa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23532 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaBJRav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:30:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 09/21] perf, c2c: Add rbtree sorted on mmap2 data
Date: Mon, 10 Feb 2014 12:29:04 -0500
Message-Id: <1392053356-23024-10-git-send-email-dzickus@redhat.com>
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the c2c tool to work correctly, it needs to properly
sort all the records on uniquely identifiable data addresses.  These
unique addresses are converted from virtual addresses provided by the
hardware into a kernel address using an mmap2 record as the decoder.

Once a unique address is converted, we can sort on them based on
various rules.  Then it becomes clear which address are overlapping
with each other across mmap regions or pid spaces.

This patch just creates the rules and inserts the records into an
rbtree for safe keeping until later patches process them.

The general sorting rule is:

o group cpumodes together
o group similar major, minor, inode, inode generation numbers togther
o if (nonzero major/minor number - ie mmap'd areas)
  o sort on data addresses
  o sort on instruction address
  o sort on pid
  o sort on tid
o if cpumode is kernel
  o sort on data addresses
  o sort on instruction address
  o sort on pid
  o sort on tid
o else (private to pid space)
  o sort on pid
  o sort on tid
  o sort on data addresses
  o sort on instruction address

I also hacked in the concept of 'color'.  The purpose of that bit is to
provides hints later when processing these records that indicate a new unique
address has been encountered.  Because later processing only checks the data
addresses, there can be a theoretical scenario that similar sequential data
addresses (when walking the rbtree) could be misinterpreted as overlapping
when in fact they are not.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-c2c.c | 145 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index b062485..a9c536b 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -13,15 +13,20 @@
 struct perf_c2c {
 	struct perf_tool tool;
 	bool		 raw_records;
+	struct rb_root   tree_physid;
 };
 
+#define REGION_SAME	1 << 0;
+
 struct c2c_entry {
+	struct rb_node		rb_node;
 	struct thread		*thread;
 	struct mem_info		*mi;
 	u32			cpu;
 	u8			cpumode;
 	int			weight;
 	int			period;
+	int			color;
 };
 
 enum { OP, LVL, SNP, LCK, TLB };
@@ -96,6 +101,133 @@ static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 	return printed;
 }
 
+static int physid_cmp(struct c2c_entry *left, struct c2c_entry *right)
+{
+	u64 l, r;
+	struct map *l_map = left->mi->daddr.map;
+	struct map *r_map = right->mi->daddr.map;
+
+	/* group event types together */
+	if (left->cpumode > right->cpumode) return 1;
+	if (left->cpumode < right->cpumode) return -1;
+
+	if (l_map->maj > r_map->maj) return 1;
+	if (l_map->maj < r_map->maj) return -1;
+
+	if (l_map->min > r_map->min) return 1;
+	if (l_map->min < r_map->min) return -1;
+
+	if (l_map->ino > r_map->ino) return 1;
+	if (l_map->ino < r_map->ino) return -1;
+
+	if (l_map->ino_generation > r_map->ino_generation) return 1;
+	if (l_map->ino_generation < r_map->ino_generation) return -1;
+
+	/*
+	 * Addresses with no major/minor numbers are assumed to be
+	 * anonymous in userspace.  Sort those on pid then address.
+	 *
+	 * The kernel and non-zero major/minor mapped areas are
+	 * assumed to be unity mapped.  Sort those on address then pid.
+	 */
+
+	/* al_addr does all the right addr - start + offset calculations */
+	l = left->mi->daddr.al_addr;
+	r = right->mi->daddr.al_addr;
+
+	if (l_map->maj || l_map->min) {
+		/* mmapped areas */
+
+		/* hack to mark similar regions, 'right' is new entry */
+		/* entries with same maj/min/ino/inogen are in same address space */
+		right->color = REGION_SAME;
+
+		if (l > r) return 1;
+		if (l < r) return -1;
+
+		/* sorting by iaddr makes calculations easier later */
+		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
+		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
+
+		if (left->thread->pid_ > right->thread->pid_) return 1;
+		if (left->thread->pid_ < right->thread->pid_) return -1;
+
+		if (left->thread->tid > right->thread->tid) return 1;
+		if (left->thread->tid < right->thread->tid) return -1;
+	} else if (left->cpumode == PERF_RECORD_MISC_KERNEL) {
+		/* kernel mapped areas where 'start' doesn't matter */
+
+		/* hack to mark similar regions, 'right' is new entry */
+		/* whole kernel region is in the same address space */
+		right->color = REGION_SAME;
+
+		if (l > r) return 1;
+		if (l < r) return -1;
+
+		/* sorting by iaddr makes calculations easier later */
+		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
+		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
+
+		if (left->thread->pid_ > right->thread->pid_) return 1;
+		if (left->thread->pid_ < right->thread->pid_) return -1;
+
+		if (left->thread->tid > right->thread->tid) return 1;
+		if (left->thread->tid < right->thread->tid) return -1;
+	} else {
+		/* userspace anonymous */
+		if (left->thread->pid_ > right->thread->pid_) return 1;
+		if (left->thread->pid_ < right->thread->pid_) return -1;
+
+		if (left->thread->tid > right->thread->tid) return 1;
+		if (left->thread->tid < right->thread->tid) return -1;
+
+		/* hack to mark similar regions, 'right' is new entry */
+		/* userspace anonymous address space is contained within pid */
+		right->color = REGION_SAME;
+
+		if (l > r) return 1;
+		if (l < r) return -1;
+
+		/* sorting by iaddr makes calculations easier later */
+		if (left->mi->iaddr.al_addr > right->mi->iaddr.al_addr) return 1;
+		if (left->mi->iaddr.al_addr < right->mi->iaddr.al_addr) return -1;
+	}
+
+	return 0;
+}
+static struct c2c_entry *c2c_entry__add_to_list(struct perf_c2c *c2c, struct c2c_entry *entry)
+{
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	struct c2c_entry *ce;
+	int64_t cmp;
+
+	p = &c2c->tree_physid.rb_node;
+
+	while (*p != NULL) {
+		parent = *p;
+		ce = rb_entry(parent, struct c2c_entry, rb_node);
+
+		cmp = physid_cmp(ce, entry);
+
+		/* FIXME wrap this with a #ifdef debug or something */
+		if (!cmp)
+			if ((entry->mi->daddr.map != ce->mi->daddr.map) &&
+				!entry->mi->daddr.map->maj && !entry->mi->daddr.map->min)
+				pr_err("Similar entries have different maps\n");
+
+		if (cmp > 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&entry->rb_node, parent, p);
+	rb_insert_color(&entry->rb_node, &c2c->tree_physid);
+
+	return entry;
+}
+
 static int perf_c2c__fprintf_header(FILE *fp)
 {
 	int printed = fprintf(fp, "%c %-16s  %6s  %6s  %4s  %18s  %18s  %18s  %6s  %-10s %-60s %s\n", 
@@ -171,10 +303,12 @@ static struct c2c_entry *c2c_entry__new(struct perf_sample *sample,
 	return entry;
 }
 
-static int perf_c2c__process_load_store(struct perf_c2c *c2c __maybe_unused,
+static int perf_c2c__process_load_store(struct perf_c2c *c2c,
 				  struct perf_sample *sample __maybe_unused,
 				  struct c2c_entry *entry)
 {
+	c2c_entry__add_to_list(c2c, entry);
+
 	/* don't lose the maps if remapped */
 	entry->mi->iaddr.map->referenced = true;
 	entry->mi->daddr.map->referenced = true;
@@ -280,10 +414,19 @@ out:
 	return err;
 }
 
+static int perf_c2c__init(struct perf_c2c *c2c)
+{
+	c2c->tree_physid = RB_ROOT;
+
+	return 0;
+}
 static int perf_c2c__report(struct perf_c2c *c2c)
 {
 	setup_pager();
 
+	if (perf_c2c__init(c2c))
+		return -1;
+
 	if (c2c->raw_records)
 		perf_c2c__fprintf_header(stdout);
 
-- 
1.7.11.7

