Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030939Ab3HIT4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:56:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030897Ab3HIT4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:56:07 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2 v3] dm: add statistics support
Date: Fri,  9 Aug 2013 15:56:04 -0400
Message-Id: <1376078164-23147-2-git-send-email-snitzer@redhat.com>
In-Reply-To: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
References: <1376078164-23147-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>

Support the collection of I/O statistics on user-defined regions of
a DM device.  Only bio-based DM devices are currently supported.

Each user-defined region specifies a starting sector, ending sector
and step.  Individual statistics will be collected for each step-sized
area between the starting and ending sector.

The I/O statistics counters for each step-sized area of a region are
in the same format as /sys/block/*/stat or /proc/diskstats but extra
counters (12 and 13) are provided: total time spent reading and
writing in milliseconds.  These counters may be accessed by sending
the @stats_print message to the appropriate DM device via dmsetup.

DM statistics creation will allocate memory via kmalloc or fallback to
using vmalloc space.  At most, 1/4 of the overall system memory may be
allocated by DM statistics.  The admin can see how much memory is used
by reading /sys/module/dm_mod/parameters/stats_current_allocated_bytes

See Documentation/device-mapper/statistics.txt for more details.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/statistics.txt |  132 ++++
 drivers/md/Makefile                        |    2 +-
 drivers/md/dm-ioctl.c                      |   22 +-
 drivers/md/dm-stats.c                      |  950 ++++++++++++++++++++++++++++
 drivers/md/dm-stats.h                      |   40 ++
 drivers/md/dm.c                            |   63 ++-
 drivers/md/dm.h                            |   17 +
 include/linux/device-mapper.h              |   13 +
 8 files changed, 1228 insertions(+), 11 deletions(-)

diff --git a/Documentation/device-mapper/statistics.txt b/Documentation/device-mapper/statistics.txt
new file mode 100644
index 0000000..164b99c
--- /dev/null
+++ b/Documentation/device-mapper/statistics.txt
@@ -0,0 +1,132 @@
+DM statistics
+=============
+
+Device Mapper supports the collection of I/O statistics on user-defined
+regions of a DM device.  Only bio-based DM devices are currently
+supported.
+
+Each user-defined region specifies a starting sector, ending sector
+and step.  Individual statistics will be collected for each step-sized
+area between the starting and ending sector.
+
+The I/O statistics counters for each step-sized area of a region are
+in the same format as /sys/block/*/stat or /proc/diskstats but extra
+counters (12 and 13) are provided: total time spent reading and
+writing in milliseconds.  These counters may be accessed by sending the
+@stats_print message to the appropriate DM device via dmsetup.
+
+Each region has a corresponding unique identifier that is assigned when
+the region is created.  The region id must be supplied when querying
+statistics about the region, deleting the region, etc.  Unique region
+ids enable multiple userspace programs to request and process statistics
+for the same DM device without stepping over each other's data.
+
+DM statistics creation will allocate memory via kmalloc or fallback to
+using vmalloc space.  At most, 1/4 of the overall system memory may be
+allocated by DM statistics.  The admin can see how much memory is used
+by reading /sys/module/dm_mod/parameters/stats_current_allocated_bytes
+
+Messages
+========
+
+    @stats_create <range> <step> [<program id> [<auxiliary data>]]
+
+	Create a new region and return the region id.
+	<range>
+	  "-" - whole device
+	  "<start>-<end>" - a specified range in 512-byte sectors
+	<step>
+	  "<number>" - the number of sectors in each area
+	  "/<number>" - the range is subdivided into the specified
+	   	      	number of areas
+	<program id>
+	  An optional parameter.  The string that identifies a program
+  	  that created this range. The kernel returns this string back
+ 	  in the output of @stats_list message, but it doesn't use this
+  	  value for anything.
+	<auxiliary data>
+	  An optional parameter.  The string that identifies data which
+	  is useful to the client program that created the range.  The
+	  kernel returns this string back in the output of @stats_list
+	  message, but it doesn't use this value for anything.
+
+    @stats_delete <region id>
+
+    	Delete the region with the specified id.
+	<region id>
+	  region id returned from @stats_create
+
+    @stats_clear <region id>
+
+	Clear all the counters except the in-flight i/o counters.
+	<region id>
+	  region id returned from @stats_create
+
+    @stats_list [<program id>]
+
+    	List all regions registered with @stats_create.
+	<program id>
+	  An optional parameter specifying the program that queries the
+	  parameters. If this parameter is specified, only regions
+	  belonging to this program are returned.  If it is not
+	  specified, all regions are returned.
+	Output format:
+	  <id>: <start>-<end> <step size> <program id> <auxiliary data>
+
+    @stats_print <region id> [<starting_line> <number_of_lines>]
+
+	Print counters for each step-sized area of a region.
+	<region id>
+	  region id returned from @stats_create
+	<starting_line>
+	  The index of the starting line in the output.  If omitted, all
+	  lines are returned.
+	<number_of_lines>
+	  The number of lines in the output.  If omitted, all lines are
+	  returned.
+	Output format for each step-sized area of a region:
+	  <starting sector>-<ending sector> counters
+	  The first 11 counters have the same meaning as
+	  /sys/block/*/stat or /proc/diskstats.
+	  Additional counters:
+	  12. the total time spent reading in milliseconds
+	  13. the total time spent writing in milliseconds
+
+    @stats_print_clear <region id> [<starting_line> <number_of_lines>]
+
+    	Atomically print and then clear all the counters except the
+	in-flight i/o counters.  Useful when client consuming the
+	statistics does not want to lose any statistics (those updated
+	between printing and clearing).
+	<region id>
+	  region id returned from @stats_create
+	<starting_line>
+	  The index of the starting line in the output.  If omitted, all
+	  lines are returned/cleared.
+	<number_of_lines>
+	  The number of lines in the output.  If omitted, all lines are
+	  returned/cleared.
+
+    @stats_set_aux <region id> <auxiliary data>
+
+    	Set the auxiliary data for the region with the specified id.
+	<region id>
+	  region id returned from @stats_create
+	<auxiliary data>
+  	  The string that identifies data which is useful to the client
+	  program that created the range.  The kernel returns this
+	  string back in the output of @stats_list message, but it
+	  doesn't use this value for anything.
+
+Examples
+========
+
+Subdivide the DM device 'vol' into 100 pieces and start collecting
+statistics on them:
+dmsetup message vol 0 @stats_create - /100
+
+Print the statistics:
+dmsetup message vol 0 @stats_print 0
+
+Delete the statistics:
+dmsetup message vol 0 @stats_delete 0
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 5ef78ef..2acc43f 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -3,7 +3,7 @@
 #
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
+		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-stats.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index f1b7586..40e6dce 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1455,20 +1455,26 @@ static int table_status(struct dm_ioctl *param, size_t param_size)
 	return 0;
 }
 
-static bool buffer_test_overflow(char *result, unsigned maxlen)
-{
-	return !maxlen || strlen(result) + 1 >= maxlen;
-}
-
 /*
- * Process device-mapper dependent messages.
+ * Process device-mapper dependent messages.  Messages prefixed with '@'
+ * are processed by the DM core.  All others are delivered to the target.
  * Returns a number <= 1 if message was processed by device mapper.
  * Returns 2 if message should be delivered to the target.
  */
 static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
 			  char *result, unsigned maxlen)
 {
-	return 2;
+	int r;
+
+	if (**argv != '@')
+		return 2; /* no '@' prefix, deliver to target */
+
+	r = dm_stats_message(md, argc, argv, result, maxlen);
+	if (r < 2)
+		return r;
+
+	DMERR("Unsupported message sent to DM core: %s", argv[0]);
+	return -EINVAL;
 }
 
 /*
@@ -1542,7 +1548,7 @@ static int target_message(struct dm_ioctl *param, size_t param_size)
 
 	if (r == 1) {
 		param->flags |= DM_DATA_OUT_FLAG;
-		if (buffer_test_overflow(result, maxlen))
+		if (dm_message_test_buffer_overflow(result, maxlen))
 			param->flags |= DM_BUFFER_FULL_FLAG;
 		else
 			param->data_size = param->data_start + strlen(result) + 1;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
new file mode 100644
index 0000000..35c2767
--- /dev/null
+++ b/drivers/md/dm-stats.c
@@ -0,0 +1,950 @@
+#include <linux/errno.h>
+#include <linux/numa.h>
+#include <linux/slab.h>
+#include <linux/rculist.h>
+#include <linux/threads.h>
+#include <linux/preempt.h>
+#include <linux/irqflags.h>
+#include <linux/vmalloc.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/device-mapper.h>
+
+#include "dm.h"
+#include "dm-stats.h"
+
+#define DM_MSG_PREFIX "stats"
+
+static int dm_stat_need_rcu_barrier;
+
+/*
+ * Using 64-bit values to avoid overflow (which is a
+ * problem that block/genhd.c's IO accounting has).
+ */
+struct dm_stat_percpu {
+	unsigned long long sectors[2];
+	unsigned long long ios[2];
+	unsigned long long merges[2];
+	unsigned long long ticks[2];
+	unsigned long long io_ticks[2];
+	unsigned long long io_ticks_total;
+	unsigned long long time_in_queue;
+};
+
+struct dm_stat_shared {
+	atomic_t in_flight[2];
+	unsigned long stamp;
+	struct dm_stat_percpu tmp;
+};
+
+struct dm_stat {
+	struct list_head list_entry;
+	int id;
+	size_t n_entries;
+	sector_t start;
+	sector_t end;
+	sector_t step;
+	const char *program_id;
+	const char *aux_data;
+	struct rcu_head rcu_head;
+	size_t shared_alloc_size;
+	size_t percpu_alloc_size;
+	struct dm_stat_percpu *stat_percpu[NR_CPUS];
+	struct dm_stat_shared stat_shared[0];
+};
+
+struct dm_stats_last_position {
+	sector_t last_sector;
+	unsigned last_rw;
+};
+
+/*
+ * A typo on the command line could possibly make the kernel run out of memory
+ * and crash. To prevent the crash we account all used memory. We fail if we
+ * exhaust 1/4 of all memory or 1/2 of vmalloc space.
+ */
+#define DM_STATS_MEMORY_RATIO		1 / 4
+#define DM_STATS_VMALLOC_RATIO		1 / 2
+
+static DEFINE_SPINLOCK(shared_memory_lock);
+
+static unsigned long shared_memory_amount;
+
+static bool __check_shared_memory(size_t alloc_size)
+{
+	size_t a;
+
+	a = shared_memory_amount + alloc_size;
+	if (a < shared_memory_amount)
+		return false;
+	if (a >> PAGE_SHIFT > totalram_pages * DM_STATS_MEMORY_RATIO)
+		return false;
+#ifdef CONFIG_MMU
+	if (a > (VMALLOC_END - VMALLOC_START) * DM_STATS_VMALLOC_RATIO)
+		return false;
+#endif
+	return true;
+}
+
+static bool check_shared_memory(size_t alloc_size)
+{
+	bool ret;
+
+	spin_lock_irq(&shared_memory_lock);
+
+	ret = __check_shared_memory(alloc_size);
+
+	spin_unlock_irq(&shared_memory_lock);
+
+	return ret;
+}
+
+static bool claim_shared_memory(size_t alloc_size)
+{
+	spin_lock_irq(&shared_memory_lock);
+
+	if (!__check_shared_memory(alloc_size)) {
+		spin_unlock_irq(&shared_memory_lock);
+		return false;
+	}
+
+	shared_memory_amount += alloc_size;
+
+	spin_unlock_irq(&shared_memory_lock);
+
+	return true;
+}
+
+static void free_shared_memory(size_t alloc_size)
+{
+	unsigned long flags;
+
+	if (WARN_ON_ONCE(shared_memory_amount < alloc_size)) {
+		DMCRIT("Memory usage accounting bug.");
+		return;
+	}
+
+	spin_lock_irqsave(&shared_memory_lock, flags);
+
+	shared_memory_amount -= alloc_size;
+
+	spin_unlock_irqrestore(&shared_memory_lock, flags);
+}
+
+static void *dm_kvzalloc(size_t alloc_size, int node)
+{
+	void *p;
+
+	if (!claim_shared_memory(alloc_size))
+		return NULL;
+
+	if (alloc_size <= KMALLOC_MAX_SIZE) {
+		p = kzalloc_node(alloc_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
+		if (p)
+			return p;
+	}
+	p = vzalloc_node(alloc_size, node);
+	if (p)
+		return p;
+
+	free_shared_memory(alloc_size);
+
+	return NULL;
+}
+
+static void dm_kvfree(void *ptr, size_t alloc_size)
+{
+	if (!ptr)
+		return;
+
+	free_shared_memory(alloc_size);
+
+	if (is_vmalloc_addr(ptr))
+		vfree(ptr);
+	else
+		kfree(ptr);
+}
+
+static void dm_stat_free(struct rcu_head *head)
+{
+	int cpu;
+	struct dm_stat *s = container_of(head, struct dm_stat, rcu_head);
+
+	kfree(s->program_id);
+	kfree(s->aux_data);
+	for_each_possible_cpu(cpu)
+		dm_kvfree(s->stat_percpu[cpu], s->percpu_alloc_size);
+	dm_kvfree(s, s->shared_alloc_size);
+}
+
+static int dm_stat_in_flight(struct dm_stat_shared *shared)
+{
+	return atomic_read(&shared->in_flight[READ]) +
+	       atomic_read(&shared->in_flight[WRITE]);
+}
+
+void dm_stats_init(struct dm_stats *stats)
+{
+	int cpu;
+	struct dm_stats_last_position *last;
+
+	mutex_init(&stats->mutex);
+	INIT_LIST_HEAD(&stats->list);
+	stats->last = alloc_percpu(struct dm_stats_last_position);
+	for_each_possible_cpu(cpu) {
+		last = per_cpu_ptr(stats->last, cpu);
+		last->last_sector = -1;
+		last->last_rw = -1;
+	}
+}
+
+void dm_stats_cleanup(struct dm_stats *stats)
+{
+	size_t ni;
+	struct dm_stat *s;
+	struct dm_stat_shared *shared;
+
+	while (!list_empty(&stats->list)) {
+		s = container_of(stats->list.next, struct dm_stat, list_entry);
+		list_del(&s->list_entry);
+		for (ni = 0; ni < s->n_entries; ni++) {
+			shared = &s->stat_shared[ni];
+			if (WARN_ON(dm_stat_in_flight(shared))) {
+				DMCRIT("leaked in-flight counter at index %lu "
+				       "(start %llu, end %llu, step %llu): reads %d, writes %d",
+				       (unsigned long)ni,
+				       (unsigned long long)s->start,
+				       (unsigned long long)s->end,
+				       (unsigned long long)s->step,
+				       atomic_read(&shared->in_flight[READ]),
+				       atomic_read(&shared->in_flight[WRITE]));
+			}
+		}
+		dm_stat_free(&s->rcu_head);
+	}
+	free_percpu(stats->last);
+}
+
+static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
+			   sector_t step, const char *program_id, const char *aux_data,
+			   void (*suspend_callback)(struct mapped_device *),
+			   void (*resume_callback)(struct mapped_device *),
+			   struct mapped_device *md)
+{
+	struct list_head *l;
+	struct dm_stat *s, *tmp_s;
+	sector_t n_entries;
+	size_t ni;
+	size_t shared_alloc_size;
+	size_t percpu_alloc_size;
+	struct dm_stat_percpu *p;
+	int cpu;
+	int ret_id;
+	int r;
+
+	if (end < start || !step)
+		return -EINVAL;
+
+	n_entries = end - start;
+	if (dm_sector_div64(n_entries, step))
+		n_entries++;
+
+	if (n_entries != (size_t)n_entries || !(n_entries + 1))
+		return -EOVERFLOW;
+
+	shared_alloc_size = sizeof(struct dm_stat) + (size_t)n_entries * sizeof(struct dm_stat_shared);
+	if ((shared_alloc_size - sizeof(struct dm_stat)) / sizeof(struct dm_stat_shared) != n_entries)
+		return -EOVERFLOW;
+
+	percpu_alloc_size = (size_t)n_entries * sizeof(struct dm_stat_percpu);
+	if (percpu_alloc_size / sizeof(struct dm_stat_percpu) != n_entries)
+		return -EOVERFLOW;
+
+	if (!check_shared_memory(shared_alloc_size + num_possible_cpus() * percpu_alloc_size))
+		return -ENOMEM;
+
+	s = dm_kvzalloc(shared_alloc_size, NUMA_NO_NODE);
+	if (!s)
+		return -ENOMEM;
+
+	s->n_entries = n_entries;
+	s->start = start;
+	s->end = end;
+	s->step = step;
+	s->shared_alloc_size = shared_alloc_size;
+	s->percpu_alloc_size = percpu_alloc_size;
+
+	s->program_id = kstrdup(program_id, GFP_KERNEL);
+	if (!s->program_id) {
+		r = -ENOMEM;
+		goto out;
+	}
+	s->aux_data = kstrdup(aux_data, GFP_KERNEL);
+	if (!s->aux_data) {
+		r = -ENOMEM;
+		goto out;
+	}
+
+	for (ni = 0; ni < n_entries; ni++) {
+		atomic_set(&s->stat_shared[ni].in_flight[READ], 0);
+		atomic_set(&s->stat_shared[ni].in_flight[WRITE], 0);
+	}
+
+	for_each_possible_cpu(cpu) {
+		p = dm_kvzalloc(percpu_alloc_size, cpu_to_node(cpu));
+		if (!p) {
+			r = -ENOMEM;
+			goto out;
+		}
+		s->stat_percpu[cpu] = p;
+	}
+
+	/*
+	 * Suspend/resume to make sure there is no i/o in flight,
+	 * so that newly created statistics will be exact.
+	 *
+	 * (note: we couldn't suspend earlier because we must not
+	 * allocate memory while suspended)
+	 */
+	suspend_callback(md);
+
+	mutex_lock(&stats->mutex);
+	s->id = 0;
+	list_for_each(l, &stats->list) {
+		tmp_s = container_of(l, struct dm_stat, list_entry);
+		if (WARN_ON(tmp_s->id < s->id)) {
+			r = -EINVAL;
+			goto out_unlock_resume;
+		}
+		if (tmp_s->id > s->id)
+			break;
+		if (unlikely(s->id == INT_MAX)) {
+			r = -ENFILE;
+			goto out_unlock_resume;
+		}
+		s->id++;
+	}
+	ret_id = s->id;
+	list_add_tail_rcu(&s->list_entry, l);
+	mutex_unlock(&stats->mutex);
+
+	resume_callback(md);
+
+	return ret_id;
+
+out_unlock_resume:
+	mutex_unlock(&stats->mutex);
+	resume_callback(md);
+out:
+	dm_stat_free(&s->rcu_head);
+	return r;
+}
+
+static struct dm_stat *__dm_stats_find(struct dm_stats *stats, int id)
+{
+	struct dm_stat *s;
+
+	list_for_each_entry(s, &stats->list, list_entry) {
+		if (s->id > id)
+			break;
+		if (s->id == id)
+			return s;
+	}
+
+	return NULL;
+}
+
+static int dm_stats_delete(struct dm_stats *stats, int id)
+{
+	struct dm_stat *s;
+	int cpu;
+
+	mutex_lock(&stats->mutex);
+
+	s = __dm_stats_find(stats, id);
+	if (!s) {
+		mutex_unlock(&stats->mutex);
+		return -ENOENT;
+	}
+
+	list_del_rcu(&s->list_entry);
+	mutex_unlock(&stats->mutex);
+
+	/*
+	 * vfree can't be called from RCU callback
+	 */
+	for_each_possible_cpu(cpu)
+		if (is_vmalloc_addr(s->stat_percpu))
+			goto do_sync_free;
+	if (is_vmalloc_addr(s)) {
+do_sync_free:
+		synchronize_rcu_expedited();
+		dm_stat_free(&s->rcu_head);
+	} else {
+		ACCESS_ONCE(dm_stat_need_rcu_barrier) = 1;
+		call_rcu(&s->rcu_head, dm_stat_free);
+	}
+	return 0;
+}
+
+static int dm_stats_list(struct dm_stats *stats, const char *program,
+			 char *result, unsigned maxlen)
+{
+	struct dm_stat *s;
+	unsigned sz = 0;
+
+	mutex_lock(&stats->mutex);
+	list_for_each_entry(s, &stats->list, list_entry) {
+		if (!program || !strcmp(program, s->program_id))
+			DMEMIT("%d: %llu-%llu %llu %s %s\n", s->id,
+				(unsigned long long)s->start,
+				(unsigned long long)s->end,
+				(unsigned long long)s->step,
+				s->program_id,
+				s->aux_data);
+	}
+	mutex_unlock(&stats->mutex);
+
+	return 1;
+}
+
+static void dm_stat_round(struct dm_stat_shared *shared, struct dm_stat_percpu *p)
+{
+	/*
+	 * This is racy, but so is part_round_stats_single.
+	 */
+	unsigned long now = jiffies;
+	unsigned in_flight_read;
+	unsigned in_flight_write;
+	unsigned long difference = now - shared->stamp;
+
+	if (!difference)
+		return;
+	in_flight_read = atomic_read(&shared->in_flight[READ]);
+	in_flight_write = atomic_read(&shared->in_flight[WRITE]);
+	if (in_flight_read)
+		p->io_ticks[READ] += difference;
+	if (in_flight_write)
+		p->io_ticks[WRITE] += difference;
+	if (in_flight_read + in_flight_write) {
+		p->io_ticks_total += difference;
+		p->time_in_queue += (in_flight_read + in_flight_write) * difference;
+	}
+	shared->stamp = now;
+}
+
+static void dm_stat_for_entry(struct dm_stat *s, size_t entry,
+			      unsigned long bi_rw, unsigned len, bool merged,
+			      bool end, unsigned long duration)
+{
+	unsigned long idx = bi_rw & REQ_WRITE;
+	struct dm_stat_shared *shared = &s->stat_shared[entry];
+	struct dm_stat_percpu *p;
+
+	/*
+	 * For strict correctness we should use local_irq_disable/enable
+	 * instead of preempt_disable/enable.
+	 *
+	 * This is racy if the driver finishes bios from non-interrupt
+	 * context as well as from interrupt context or from more different
+	 * interrupts.
+	 *
+	 * However, the race only results in not counting some events,
+	 * so it is acceptable.
+	 *
+	 * part_stat_lock()/part_stat_unlock() have this race too.
+	 */
+	preempt_disable();
+	p = &s->stat_percpu[smp_processor_id()][entry];
+
+	if (!end) {
+		dm_stat_round(shared, p);
+		atomic_inc(&shared->in_flight[idx]);
+	} else {
+		dm_stat_round(shared, p);
+		atomic_dec(&shared->in_flight[idx]);
+		p->sectors[idx] += len;
+		p->ios[idx] += 1;
+		p->merges[idx] += merged;
+		p->ticks[idx] += duration;
+	}
+
+	preempt_enable();
+}
+
+static void __dm_stat_bio(struct dm_stat *s, unsigned long bi_rw,
+			  sector_t bi_sector, sector_t end_sector,
+			  bool end, unsigned long duration,
+			  struct dm_stats_aux *stats_aux)
+{
+	sector_t rel_sector, offset;
+	unsigned todo;
+	size_t entry;
+	unsigned fragment_len;
+
+	if (end_sector <= s->start || bi_sector >= s->end)
+		return;
+	if (unlikely(bi_sector < s->start)) {
+		rel_sector = 0;
+		todo = end_sector - s->start;
+	} else {
+		rel_sector = bi_sector - s->start;
+		todo = end_sector - bi_sector;
+	}
+	if (unlikely(end_sector > s->end))
+		todo -= end_sector - s->end;
+
+	offset = dm_sector_div64(rel_sector, s->step);
+	entry = rel_sector;
+	do {
+		if (WARN_ON_ONCE(entry >= s->n_entries)) {
+			DMCRIT("Invalid area access in region id %d", s->id);
+			return;
+		}
+		fragment_len = todo;
+		if (fragment_len > s->step - offset)
+			fragment_len = s->step - offset;
+		dm_stat_for_entry(s, entry, bi_rw, fragment_len,
+				  stats_aux->merged, end, duration);
+		todo -= fragment_len;
+		entry++;
+		offset = 0;
+	} while (unlikely(todo));
+}
+
+void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
+			 sector_t bi_sector, unsigned bi_sectors, bool end,
+			 unsigned long duration, struct dm_stats_aux *stats_aux)
+{
+	struct dm_stat *s;
+	sector_t end_sector;
+	struct dm_stats_last_position *last;
+
+	if (unlikely(!bi_sectors))
+		return;
+
+	end_sector = bi_sector + bi_sectors;
+
+	if (!end) {
+		/*
+		 * A race condition can at worst result in the merged flag being
+		 * misrepresented, so we don't have to disable preemption here.
+		 */
+		last = __this_cpu_ptr(stats->last);
+		stats_aux->merged =
+			(bi_sector == (ACCESS_ONCE(last->last_sector) &&
+				       ((bi_rw & (REQ_WRITE | REQ_DISCARD)) ==
+					(ACCESS_ONCE(last->last_rw) & (REQ_WRITE | REQ_DISCARD)))
+				       ));
+		ACCESS_ONCE(last->last_sector) = end_sector;
+		ACCESS_ONCE(last->last_rw) = bi_rw;
+	}
+
+	rcu_read_lock();
+
+	list_for_each_entry_rcu(s, &stats->list, list_entry)
+		__dm_stat_bio(s, bi_rw, bi_sector, end_sector, end, duration, stats_aux);
+
+	rcu_read_unlock();
+}
+
+static void __dm_stat_init_temporary_percpu_totals(struct dm_stat_shared *shared,
+						   struct dm_stat *s, size_t x)
+{
+	int cpu;
+	struct dm_stat_percpu *p;
+
+	local_irq_disable();
+	p = &s->stat_percpu[smp_processor_id()][x];
+	dm_stat_round(shared, p);
+	local_irq_enable();
+
+	memset(&shared->tmp, 0, sizeof(shared->tmp));
+	for_each_possible_cpu(cpu) {
+		p = &s->stat_percpu[cpu][x];
+		shared->tmp.sectors[READ] += ACCESS_ONCE(p->sectors[READ]);
+		shared->tmp.sectors[WRITE] += ACCESS_ONCE(p->sectors[WRITE]);
+		shared->tmp.ios[READ] += ACCESS_ONCE(p->ios[READ]);
+		shared->tmp.ios[WRITE] += ACCESS_ONCE(p->ios[WRITE]);
+		shared->tmp.merges[READ] += ACCESS_ONCE(p->merges[READ]);
+		shared->tmp.merges[WRITE] += ACCESS_ONCE(p->merges[WRITE]);
+		shared->tmp.ticks[READ] += ACCESS_ONCE(p->ticks[READ]);
+		shared->tmp.ticks[WRITE] += ACCESS_ONCE(p->ticks[WRITE]);
+		shared->tmp.io_ticks[READ] += ACCESS_ONCE(p->io_ticks[READ]);
+		shared->tmp.io_ticks[WRITE] += ACCESS_ONCE(p->io_ticks[WRITE]);
+		shared->tmp.io_ticks_total += ACCESS_ONCE(p->io_ticks_total);
+		shared->tmp.time_in_queue += ACCESS_ONCE(p->time_in_queue);
+	}
+}
+
+static void __dm_stat_clear(struct dm_stat *s, size_t idx_start, size_t idx_end,
+			    bool init_tmp_percpu_totals)
+{
+	size_t x;
+	struct dm_stat_shared *shared;
+	struct dm_stat_percpu *p;
+
+	for (x = idx_start; x < idx_end; x++) {
+		shared = &s->stat_shared[x];
+		if (init_tmp_percpu_totals)
+			__dm_stat_init_temporary_percpu_totals(shared, s, x);
+		local_irq_disable();
+		p = &s->stat_percpu[smp_processor_id()][x];
+		p->sectors[READ] -= shared->tmp.sectors[READ];
+		p->sectors[WRITE] -= shared->tmp.sectors[WRITE];
+		p->ios[READ] -= shared->tmp.ios[READ];
+		p->ios[WRITE] -= shared->tmp.ios[WRITE];
+		p->merges[READ] -= shared->tmp.merges[READ];
+		p->merges[WRITE] -= shared->tmp.merges[WRITE];
+		p->ticks[READ] -= shared->tmp.ticks[READ];
+		p->ticks[WRITE] -= shared->tmp.ticks[WRITE];
+		p->io_ticks[READ] -= shared->tmp.io_ticks[READ];
+		p->io_ticks[WRITE] -= shared->tmp.io_ticks[WRITE];
+		p->io_ticks_total -= shared->tmp.io_ticks_total;
+		p->time_in_queue -= shared->tmp.time_in_queue;
+		local_irq_enable();
+	}
+}
+
+static int dm_stats_clear(struct dm_stats *stats, int id)
+{
+	struct dm_stat *s;
+
+	mutex_lock(&stats->mutex);
+
+	s = __dm_stats_find(stats, id);
+	if (!s) {
+		mutex_unlock(&stats->mutex);
+		return -ENOENT;
+	}
+
+	__dm_stat_clear(s, 0, s->n_entries, true);
+
+	mutex_unlock(&stats->mutex);
+
+	return 1;
+}
+
+/*
+ * This is like jiffies_to_msec, but works for 64-bit values.
+ */
+static unsigned long long dm_jiffies_to_msec64(unsigned long long j)
+{
+	unsigned long long result = 0;
+	unsigned mult;
+
+	if (j)
+		result = jiffies_to_msecs(j & 0x3fffff);
+	if (j >= 1 << 22) {
+		mult = jiffies_to_msecs(1 << 22);
+		result += (unsigned long long)mult * (unsigned long long)jiffies_to_msecs((j >> 22) & 0x3fffff);
+	}
+	if (j >= 1ULL << 44)
+		result += (unsigned long long)mult * (unsigned long long)mult * (unsigned long long)jiffies_to_msecs(j >> 44);
+
+	return result;
+}
+
+static int dm_stats_print(struct dm_stats *stats, int id,
+			  size_t idx_start, size_t idx_len,
+			  bool clear, char *result, unsigned maxlen)
+{
+	unsigned sz = 0;
+	struct dm_stat *s;
+	size_t x;
+	sector_t start, end;
+	size_t idx_end;
+	struct dm_stat_shared *shared;
+
+	mutex_lock(&stats->mutex);
+
+	s = __dm_stats_find(stats, id);
+	if (!s) {
+		mutex_unlock(&stats->mutex);
+		return -ENOENT;
+	}
+
+	idx_end = idx_start + idx_len;
+	if (idx_end < idx_start ||
+	    idx_end > s->n_entries)
+		idx_end = s->n_entries;
+
+	if (idx_start > idx_end)
+		idx_start = idx_end;
+
+	start = s->start + s->step * idx_start;
+
+	for (x = idx_start; x < idx_end; x++, start = end) {
+		shared = &s->stat_shared[x];
+		end = start + s->step;
+		if (unlikely(end > s->end))
+			end = s->end;
+
+		__dm_stat_init_temporary_percpu_totals(shared, s, x);
+
+		DMEMIT("%llu-%llu %llu %llu %llu %llu %llu %llu %llu %llu %d %llu %llu %llu %llu\n",
+		       (unsigned long long)start,
+		       (unsigned long long)end,
+		       shared->tmp.ios[READ],
+		       shared->tmp.merges[READ],
+		       shared->tmp.sectors[READ],
+		       dm_jiffies_to_msec64(shared->tmp.ticks[READ]),
+		       shared->tmp.ios[WRITE],
+		       shared->tmp.merges[WRITE],
+		       shared->tmp.sectors[WRITE],
+		       dm_jiffies_to_msec64(shared->tmp.ticks[WRITE]),
+		       dm_stat_in_flight(shared),
+		       dm_jiffies_to_msec64(shared->tmp.io_ticks_total),
+		       dm_jiffies_to_msec64(shared->tmp.time_in_queue),
+		       dm_jiffies_to_msec64(shared->tmp.io_ticks[READ]),
+		       dm_jiffies_to_msec64(shared->tmp.io_ticks[WRITE]));
+
+		if (unlikely(sz + 1 >= maxlen))
+			goto buffer_overflow;
+	}
+
+	if (clear)
+		__dm_stat_clear(s, idx_start, idx_end, false);
+
+buffer_overflow:
+	mutex_unlock(&stats->mutex);
+
+	return 1;
+}
+
+static int dm_stats_set_aux(struct dm_stats *stats, int id, const char *aux_data)
+{
+	struct dm_stat *s;
+	const char *new_aux_data;
+
+	mutex_lock(&stats->mutex);
+
+	s = __dm_stats_find(stats, id);
+	if (!s) {
+		mutex_unlock(&stats->mutex);
+		return -ENOENT;
+	}
+
+	new_aux_data = kstrdup(aux_data, GFP_KERNEL);
+	if (!new_aux_data) {
+		mutex_unlock(&stats->mutex);
+		return -ENOMEM;
+	}
+
+	kfree(s->aux_data);
+	s->aux_data = new_aux_data;
+
+	mutex_unlock(&stats->mutex);
+
+	return 0;
+}
+
+static int message_stats_create(struct mapped_device *md,
+				unsigned argc, char **argv,
+				char *result, unsigned maxlen)
+{
+	int id;
+	char dummy;
+	unsigned long long start, end, step;
+	unsigned divisor;
+	const char *program_id, *aux_data;
+
+	if (argc < 3 || argc > 5)
+		return -EINVAL;
+
+	if (!strcmp(argv[1], "-")) {
+		start = 0;
+		end = dm_get_size(md);
+		if (!end)
+			end = 1;
+	} else if (sscanf(argv[1], "%llu-%llu%c", &start, &end, &dummy) != 2 ||
+		   start != (sector_t)start || end != (sector_t)end)
+		return -EINVAL;
+
+	if (start >= end)
+		return -EINVAL;
+
+	if (sscanf(argv[2], "/%u%c", &divisor, &dummy) == 1) {
+		step = end - start;
+		if (do_div(step, divisor))
+			step++;
+		if (!step)
+			step = 1;
+	} else if (sscanf(argv[2], "%llu%c", &step, &dummy) != 1 ||
+		   step != (sector_t)step || !step)
+		return -EINVAL;
+
+	program_id = "-";
+	aux_data = "-";
+
+	if (argc > 3)
+		program_id = argv[3];
+
+	if (argc > 4)
+		aux_data = argv[4];
+
+	/*
+	 * If a buffer overflow happens after we created the region,
+	 * it's too late (the userspace would retry with a larger
+	 * buffer, but the region id that caused the overflow is already
+	 * leaked).  So we must detect buffer overflow in advance.
+	 */
+	snprintf(result, maxlen, "%d", INT_MAX);
+	if (dm_message_test_buffer_overflow(result, maxlen))
+		return 1;
+
+	id = dm_stats_create(dm_get_stats(md), start, end, step, program_id, aux_data,
+			     dm_internal_suspend, dm_internal_resume, md);
+	if (id < 0)
+		return id;
+
+	snprintf(result, maxlen, "%d", id);
+
+	return 1;
+}
+
+static int message_stats_delete(struct mapped_device *md,
+				unsigned argc, char **argv)
+{
+	int id;
+	char dummy;
+
+	if (argc != 2)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	return dm_stats_delete(dm_get_stats(md), id);
+}
+
+static int message_stats_clear(struct mapped_device *md,
+			       unsigned argc, char **argv)
+{
+	int id;
+	char dummy;
+
+	if (argc != 2)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	return dm_stats_clear(dm_get_stats(md), id);
+}
+
+static int message_stats_list(struct mapped_device *md,
+			      unsigned argc, char **argv,
+			      char *result, unsigned maxlen)
+{
+	int r;
+	const char *program = NULL;
+
+	if (argc < 1 || argc > 2)
+		return -EINVAL;
+
+	if (argc > 1) {
+		program = kstrdup(argv[1], GFP_KERNEL);
+		if (!program)
+			return -ENOMEM;
+	}
+
+	r = dm_stats_list(dm_get_stats(md), program, result, maxlen);
+
+	kfree(program);
+
+	return r;
+}
+
+static int message_stats_print(struct mapped_device *md,
+			       unsigned argc, char **argv, bool clear,
+			       char *result, unsigned maxlen)
+{
+	int id;
+	char dummy;
+	unsigned long idx_start = 0, idx_len = -1;
+
+	if (argc != 2 && argc != 4)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	if (argc > 3) {
+		if (strcmp(argv[2], "-") &&
+		    sscanf(argv[2], "%lu%c", &idx_start, &dummy) != 1)
+			return -EINVAL;
+		if (strcmp(argv[3], "-") &&
+		    sscanf(argv[3], "%lu%c", &idx_len, &dummy) != 1)
+			return -EINVAL;
+	}
+
+	return dm_stats_print(dm_get_stats(md), id, idx_start, idx_len, clear,
+			      result, maxlen);
+}
+
+static int message_stats_set_aux(struct mapped_device *md,
+				 unsigned argc, char **argv)
+{
+	int id;
+	char dummy;
+
+	if (argc != 3)
+		return -EINVAL;
+
+	if (sscanf(argv[1], "%d%c", &id, &dummy) != 1 || id < 0)
+		return -EINVAL;
+
+	return dm_stats_set_aux(dm_get_stats(md), id, argv[2]);
+}
+
+int dm_stats_message(struct mapped_device *md, unsigned argc, char **argv,
+		     char *result, unsigned maxlen)
+{
+	int r;
+
+	if (dm_request_based(md)) {
+		DMWARN("Statistics are only supported for bio-based devices");
+		return -EOPNOTSUPP;
+	}
+
+	/* All messages here must start with '@' */
+	if (!strcasecmp(argv[0], "@stats_create"))
+		r = message_stats_create(md, argc, argv, result, maxlen);
+	else if (!strcasecmp(argv[0], "@stats_delete"))
+		r = message_stats_delete(md, argc, argv);
+	else if (!strcasecmp(argv[0], "@stats_clear"))
+		r = message_stats_clear(md, argc, argv);
+	else if (!strcasecmp(argv[0], "@stats_list"))
+		r = message_stats_list(md, argc, argv, result, maxlen);
+	else if (!strcasecmp(argv[0], "@stats_print"))
+		r = message_stats_print(md, argc, argv, false, result, maxlen);
+	else if (!strcasecmp(argv[0], "@stats_print_clear"))
+		r = message_stats_print(md, argc, argv, true, result, maxlen);
+	else if (!strcasecmp(argv[0], "@stats_set_aux"))
+		r = message_stats_set_aux(md, argc, argv);
+	else
+		return 2; /* this wasn't a stats message */
+
+	if (r == -EINVAL)
+		DMWARN("Invalid parameters for message %s", argv[0]);
+
+	return r;
+}
+
+int __init dm_statistics_init(void)
+{
+	dm_stat_need_rcu_barrier = 0;
+	return 0;
+}
+
+void dm_statistics_exit(void)
+{
+	if (dm_stat_need_rcu_barrier)
+		rcu_barrier();
+	if (WARN_ON(shared_memory_amount))
+		DMCRIT("shared_memory_amount leaked: %lu", shared_memory_amount);
+}
+
+module_param_named(stats_current_allocated_bytes, shared_memory_amount, ulong, S_IRUGO);
+MODULE_PARM_DESC(stats_current_allocated_bytes, "Memory currently used by statistics");
diff --git a/drivers/md/dm-stats.h b/drivers/md/dm-stats.h
new file mode 100644
index 0000000..e7c4984
--- /dev/null
+++ b/drivers/md/dm-stats.h
@@ -0,0 +1,40 @@
+#ifndef DM_STATS_H
+#define DM_STATS_H
+
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+
+int dm_statistics_init(void);
+void dm_statistics_exit(void);
+
+struct dm_stats {
+	struct mutex mutex;
+	struct list_head list;	/* list of struct dm_stat */
+	struct dm_stats_last_position __percpu *last;
+	sector_t last_sector;
+	unsigned last_rw;
+};
+
+struct dm_stats_aux {
+	bool merged;
+};
+
+void dm_stats_init(struct dm_stats *st);
+void dm_stats_cleanup(struct dm_stats *st);
+
+struct mapped_device;
+
+int dm_stats_message(struct mapped_device *md, unsigned argc, char **argv,
+		     char *result, unsigned maxlen);
+
+void dm_stats_account_io(struct dm_stats *stats, unsigned long bi_rw,
+			 sector_t bi_sector, unsigned bi_sectors, bool end,
+			 unsigned long duration, struct dm_stats_aux *aux);
+
+static inline bool dm_stats_used(struct dm_stats *st)
+{
+	return !list_empty(&st->list);
+}
+
+#endif
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e39d2b..2044f91 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -60,6 +60,7 @@ struct dm_io {
 	struct bio *bio;
 	unsigned long start_time;
 	spinlock_t endio_lock;
+	struct dm_stats_aux stats_aux;
 };
 
 /*
@@ -198,6 +199,8 @@ struct mapped_device {
 
 	/* zero-length flush that will be cloned and submitted to targets */
 	struct bio flush_bio;
+
+	struct dm_stats stats;
 };
 
 /*
@@ -269,6 +272,7 @@ static int (*_inits[])(void) __initdata = {
 	dm_io_init,
 	dm_kcopyd_init,
 	dm_interface_init,
+	dm_statistics_init,
 };
 
 static void (*_exits[])(void) = {
@@ -279,6 +283,7 @@ static void (*_exits[])(void) = {
 	dm_io_exit,
 	dm_kcopyd_exit,
 	dm_interface_exit,
+	dm_statistics_exit,
 };
 
 static int __init dm_init(void)
@@ -384,6 +389,16 @@ int dm_lock_for_deletion(struct mapped_device *md)
 	return r;
 }
 
+sector_t dm_get_size(struct mapped_device *md)
+{
+	return get_capacity(md->disk);
+}
+
+struct dm_stats *dm_get_stats(struct mapped_device *md)
+{
+	return &md->stats;
+}
+
 static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
@@ -466,8 +481,9 @@ static int md_in_flight(struct mapped_device *md)
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
+	struct bio *bio = io->bio;
 	int cpu;
-	int rw = bio_data_dir(io->bio);
+	int rw = bio_data_dir(bio);
 
 	io->start_time = jiffies;
 
@@ -476,6 +492,10 @@ static void start_io_acct(struct dm_io *io)
 	part_stat_unlock();
 	atomic_set(&dm_disk(md)->part0.in_flight[rw],
 		atomic_inc_return(&md->pending[rw]));
+
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_sector,
+				    bio_sectors(bio), false, 0, &io->stats_aux);
 }
 
 static void end_io_acct(struct dm_io *io)
@@ -491,6 +511,10 @@ static void end_io_acct(struct dm_io *io)
 	part_stat_add(cpu, &dm_disk(md)->part0, ticks[rw], duration);
 	part_stat_unlock();
 
+	if (unlikely(dm_stats_used(&md->stats)))
+		dm_stats_account_io(&md->stats, bio->bi_rw, bio->bi_sector,
+				    bio_sectors(bio), true, duration, &io->stats_aux);
+
 	/*
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
@@ -1519,7 +1543,7 @@ static void _dm_request(struct request_queue *q, struct bio *bio)
 	return;
 }
 
-static int dm_request_based(struct mapped_device *md)
+int dm_request_based(struct mapped_device *md)
 {
 	return blk_queue_stackable(md->queue);
 }
@@ -1959,6 +1983,8 @@ static struct mapped_device *alloc_dev(int minor)
 	md->flush_bio.bi_bdev = md->bdev;
 	md->flush_bio.bi_rw = WRITE_FLUSH;
 
+	dm_stats_init(&md->stats);
+
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
 	old_md = idr_replace(&_minor_idr, md, minor);
@@ -2010,6 +2036,7 @@ static void free_dev(struct mapped_device *md)
 
 	put_disk(md->disk);
 	blk_cleanup_queue(md->queue);
+	dm_stats_cleanup(&md->stats);
 	module_put(THIS_MODULE);
 	kfree(md);
 }
@@ -2695,6 +2722,38 @@ out:
 	return r;
 }
 
+/*
+ * Internal suspend/resume works like userspace-driven suspend. It waits
+ * until all bios finish and prevents issuing new bios to the target drivers.
+ * It may be used only from the kernel.
+ *
+ * Internal suspend holds md->suspend_lock, which prevents interaction with
+ * userspace-driven suspend.
+ */
+
+void dm_internal_suspend(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	if (dm_suspended_md(md))
+		return;
+
+	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
+	synchronize_srcu(&md->io_barrier);
+	flush_workqueue(md->wq);
+	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
+}
+
+void dm_internal_resume(struct mapped_device *md)
+{
+	if (dm_suspended_md(md))
+		goto done;
+
+	dm_queue_flush(md);
+
+done:
+	mutex_unlock(&md->suspend_lock);
+}
+
 /*-----------------------------------------------------------------
  * Event notification.
  *---------------------------------------------------------------*/
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 45b97da..9236e7c 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -16,6 +16,8 @@
 #include <linux/blkdev.h>
 #include <linux/hdreg.h>
 
+#include "dm-stats.h"
+
 /*
  * Suspend feature flags
  */
@@ -146,10 +148,16 @@ void dm_destroy(struct mapped_device *md);
 void dm_destroy_immediate(struct mapped_device *md);
 int dm_open_count(struct mapped_device *md);
 int dm_lock_for_deletion(struct mapped_device *md);
+int dm_request_based(struct mapped_device *md);
+sector_t dm_get_size(struct mapped_device *md);
+struct dm_stats *dm_get_stats(struct mapped_device *md);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 		      unsigned cookie);
 
+void dm_internal_suspend(struct mapped_device *md);
+void dm_internal_resume(struct mapped_device *md);
+
 int dm_io_init(void);
 void dm_io_exit(void);
 
@@ -162,4 +170,13 @@ void dm_kcopyd_exit(void);
 struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_bio_data_size);
 void dm_free_md_mempools(struct dm_md_mempools *pools);
 
+
+/*
+ * Helpers that are used by DM core
+ */
+static inline bool dm_message_test_buffer_overflow(char *result, unsigned maxlen)
+{
+	return !maxlen || strlen(result) + 1 >= maxlen;
+}
+
 #endif
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e151d4c..a903e9b 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -550,6 +550,19 @@ extern struct ratelimit_state dm_ratelimit_state;
 #define DM_MAPIO_REMAPPED	1
 #define DM_MAPIO_REQUEUE	DM_ENDIO_REQUEUE
 
+#if BITS_PER_LONG == 32 && defined(CONFIG_LBDAF)
+#include <linux/math64.h>
+#define dm_sector_div64(x, y)( \
+{ \
+	u64 _res; \
+	(x) = div64_u64_rem(x, y, &_res); \
+	_res; \
+} \
+)
+#else
+#define dm_sector_div64(x, y) sector_div(x, y)
+#endif
+
 /*
  * Ceiling(n / sz)
  */
