Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423349Ab3FUQ0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:26:33 -0400
Received: from relay2.sgi.com ([192.48.179.30]:33934 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423203Ab3FUQZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:25:58 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
Cc: holt@sgi.com, travis@sgi.com, nzimmer@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 2/2] x86_64, mm: Reinsert the absent memory
Date: Fri, 21 Jun 2013 11:25:34 -0500
Message-Id: <1371831934-156971-3-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory we set aside in the previous patch needs to be reinserted.
We start this process via late_initcall so we will have multiple cpus to do
the work.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org> 
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c | 129 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/base/memory.c  |  83 +++++++++++++++++++++++++++++++
 include/linux/memory.h |   5 ++
 3 files changed, 217 insertions(+)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 3752dc5..d31039d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -23,6 +23,7 @@
 
 #ifdef CONFIG_DELAY_MEM_INIT
 #include <linux/memory.h>
+#include <linux/delay.h>
 #endif
 
 #include <asm/e820.h>
@@ -397,6 +398,22 @@ static u64 min_region_size;	/* min size of region to slice from */
 static u64 pre_region_size;	/* multiply bsize for node low memory */
 static u64 post_region_size;	/* multiply bsize for node high memory */
 
+static unsigned long add_absent_work_start_time;
+static unsigned long add_absent_work_stop_time;
+static unsigned int add_absent_job_count;
+static atomic_t add_absent_work_count;
+
+struct absent_work {
+	struct work_struct	work;
+	struct absent_work	*next;
+	atomic_t		busy;
+	int			cpu;
+	int			node;
+	int			index;
+};
+static DEFINE_PER_CPU(struct absent_work, absent_work);
+static struct absent_work *first_absent_work;
+
 static int __init setup_delay_mem_init(char *str)
 {
 	int bbits, mpnbits, minmult, premult, postmult;
@@ -527,6 +544,118 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	}
 	return ret;
 }
+
+/* Assign a cpu for this memory chunk and get the per_cpu absent_work struct */
+static struct absent_work *get_absent_work(int node)
+{
+	int cpu;
+
+	for_each_cpu(cpu, cpumask_of_node(node)) {
+		struct absent_work *aws = &per_cpu(absent_work, cpu);
+		if (aws->node)
+			continue;
+		aws->cpu = cpu;
+		aws->node = node;
+		return aws;
+	}
+
+	/* (if this becomes a problem, we can use a cpu on another node) */
+	pr_crit("e820: No CPU on Node %d to schedule absent_work\n", node);
+	return NULL;
+}
+
+/* Count of 'not done' processes */
+static int count_absent_work_notdone(void)
+{
+	struct absent_work *aws;
+	int notdone = 0;
+
+	for (aws = first_absent_work; aws; aws = aws->next)
+		if (atomic_read(&aws->busy) < 2)
+			notdone++;
+
+	return notdone;
+}
+
+/* The absent_work thread */
+static void add_absent_memory_work(struct work_struct *work)
+{
+	struct absent_work *aws;
+	u64 phys_addr, size;
+	int ret;
+
+	aws = container_of(work, struct absent_work, work);
+
+	phys_addr = e820_absent.map[aws->index].addr;
+	size = e820_absent.map[aws->index].size;
+	ret = memory_add_absent(aws->node, phys_addr, size);
+	if (ret)
+		pr_crit("e820: Error %d adding absent memory %llx %llx (%d)\n",
+			ret, phys_addr, size, aws->node);
+
+	atomic_set(&aws->busy, 2);
+	atomic_dec(&add_absent_work_count);
+
+	/* if no one is waiting, then snap stop time */
+	if (!count_absent_work_notdone())
+		add_absent_work_stop_time = get_seconds();
+}
+
+/* Initialize absent_work threads */
+static int add_absent_memory(void)
+{
+	struct absent_work *aws = NULL;
+	int cpu, i;
+
+	add_absent_work_start_time = get_seconds();
+	add_absent_work_stop_time = 0;
+	atomic_set(&add_absent_work_count, 0);
+
+	for_each_online_cpu(cpu) {
+		struct absent_work *aws = &per_cpu(absent_work, cpu);
+		aws->node = 0;
+	}
+
+	/* setup each work thread */
+	for (i = 0; i < e820_absent.nr_map; i++) {
+		u64 phys_addr = e820_absent.map[i].addr;
+		int node = memory_add_physaddr_to_nid(phys_addr);
+
+		if (!node_online(node))
+			continue;
+
+		if (!aws) {
+			aws = get_absent_work(node);
+			first_absent_work = aws;
+		} else {
+			aws->next = get_absent_work(node);
+			aws = aws->next;
+		}
+
+		if (!aws)
+			continue;
+
+		INIT_WORK(&aws->work, add_absent_memory_work);
+		atomic_set(&aws->busy, 0);
+		aws->index = i;
+
+		/* schedule absent_work thread */
+		if (!schedule_work_on(aws->cpu, &aws->work))
+			BUG();
+	}
+
+
+	pr_info("e820: Add absent memory started\n");
+
+	return 0;
+}
+
+/* Called during bootup to start adding absent_mem early */
+static int absent_memory_init(void)
+{
+	return add_absent_memory();
+}
+late_initcall(absent_memory_init);
 #endif /* CONFIG_DELAY_MEM_INIT */
 
 static int __init __append_e820_map(struct e820entry *biosmap, int nr_map)
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 14f8a69..5b4245a 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -442,6 +442,89 @@ static inline int memory_probe_init(void)
 }
 #endif
 
+#ifdef CONFIG_DELAY_MEM_INIT
+static struct memory_block *memory_get_block(u64 phys_addr,
+					struct memory_block *last_mem_blk)
+{
+	unsigned long pfn = phys_addr >> PAGE_SHIFT;
+	struct memory_block *mem_blk = NULL;
+	struct mem_section *mem_sect;
+	unsigned long section_nr = pfn_to_section_nr(pfn);
+
+	if (!present_section_nr(section_nr))
+		return NULL;
+
+	mem_sect = __nr_to_section(section_nr);
+	mem_blk = find_memory_block_hinted(mem_sect, last_mem_blk);
+	return mem_blk;
+}
+
+/* addr and size must be aligned on memory_block_size boundaries */
+int memory_add_absent(int nid, u64 phys_addr, u64 size)
+{
+	struct memory_block *mem = NULL;
+	struct page *first_page;
+	unsigned long block_sz;
+	unsigned long nr_pages;
+	unsigned long start_pfn;
+	int ret;
+
+	block_sz = get_memory_block_size();
+	if (phys_addr & (block_sz - 1) || size & (block_sz - 1))
+		return -EINVAL;
+
+	/* memory already present? */
+	if (memory_get_block(phys_addr, NULL))
+		return -EBUSY;
+
+	ret = add_memory(nid, phys_addr, size);
+	if (ret)
+		return ret;
+
+	/* grab first block to use for onlining process */
+	mem = memory_get_block(phys_addr, NULL);
+	if (!mem)
+		return -ENOMEM;
+
+	first_page = pfn_to_page(mem->start_section_nr << PFN_SECTION_SHIFT);
+	start_pfn = page_to_pfn(first_page);
+	nr_pages = size >> PAGE_SHIFT;
+
+	ret = online_pages(start_pfn, nr_pages, ONLINE_KEEP);
+	if (ret)
+		return ret;
+
+	for (;;) {
+		/* we already have first block from above */
+		mutex_lock(&mem->state_mutex);
+		if (mem->state == MEM_OFFLINE) {
+			mem->state = MEM_ONLINE;
+			kobject_uevent(&mem->dev.kobj, KOBJ_ONLINE);
+		}
+		mutex_unlock(&mem->state_mutex);
+
+		phys_addr += block_sz;
+		size -= block_sz;
+		if (!size)
+			break;
+
+		mem = memory_get_block(phys_addr, mem);
+		if (mem)
+			continue;
+
+		pr_err("memory_get_block failed at %llx\n", phys_addr);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+#else
+static inline int start_add_absent_init(void)
+{
+	return 0;
+}
+#endif /* CONFIG_DELAY_MEM_INIT */
+
 #ifdef CONFIG_MEMORY_FAILURE
 /*
  * Support for offlining pages of memory
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 85c31a8..a000c54 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -128,6 +128,11 @@ extern struct memory_block *find_memory_block(struct mem_section *);
 enum mem_add_context { BOOT, HOTPLUG };
 #endif /* CONFIG_MEMORY_HOTPLUG_SPARSE */
 
+#ifdef CONFIG_DELAY_MEM_INIT
+extern int memory_add_absent(int nid, u64 phys_addr, u64 size);
+#endif
+
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 #define hotplug_memory_notifier(fn, pri) ({		\
 	static __meminitdata struct notifier_block fn##_mem_nb =\
-- 
1.8.2.1

