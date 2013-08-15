Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3HOLUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:20:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:49799 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3HOLUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:20:35 -0400
From: Caizhiyong <caizhiyong@huawei.com>
To: Brian Norris <computersforpeace@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wanglin (Albert)" <albert.wanglin@huawei.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Caizhiyong <caizhiyong@huawei.com>
Subject: [PATCH] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Topic: [PATCH] mtd: cmdlinepart: use cmdline partition parser lib
Thread-Index: Ac6ZqUjFrSVLBN9iSseRnW4m4SICWw==
Date: Thu, 15 Aug 2013 11:19:36 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: BgMM KA1T VNoB Y8TL bCmU srCC ur+B 49Lz AAjmsQ== AAzMgQ==
 ABFZog== ABdy1Q== ADlP4w== AEaatw== AGVywg==
 AHiaFw==;7;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGMAbwBtAHAAdQB0AGUAcgBzAGYAbwByAHAAZQBhAGMAZQBAAGcAbQBhAGkAbAAuAGMAbwBtADsAZABlAGQAZQBrAGkAbgBkADEAQABnAG0AYQBpAGwALgBjAG8AbQA7AGsAegBhAGsAQAByAGUAZABoAGEAdAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG0AdABkAEAAbABpAHMAdABzAC4AaQBuAGYAcgBhAGQAZQBhAGQALgBvAHIAZwA7AHMAaABtAHUAbABpAGsALgBsAGEAZABrAGEAbgBpAEAAZwBtAGEAaQBsAC4AYwBvAG0A;Sosha1_v1;7;{16B0FD4B-B867-484F-B1AD-66669F5DB668};YwBhAGkAegBoAGkAeQBvAG4AZwBAAGgAdQBhAHcAZQBpAC4AYwBvAG0A;Thu,
 15 Aug 2013 11:19:19
 GMT;WwBQAEEAVABDAEgAXQAgAG0AdABkADoAIABjAG0AZABsAGkAbgBlAHAAYQByAHQAOgAgAHUAcwBlACAAYwBtAGQAbABpAG4AZQAgAHAAYQByAHQAaQB0AGkAbwBuACAAcABhAHIAcwBlAHIAIABsAGkAYgA=
x-cr-puzzleid: {16B0FD4B-B867-484F-B1AD-66669F5DB668}
x-originating-ip: [10.67.223.18]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cai Zhiyong <caizhiyong@huawei.com>

MTD cmdline partition use cmdline partition parser lib

reference: https://lkml.org/lkml/2013/8/6/550

Signed-off-by: Cai ZhiYong <caizhiyong@huawei.com>
---
 Documentation/block/cmdline-partition.txt |  93 +++++---
 block/cmdline-parser.c                    |  16 +-
 drivers/mtd/Kconfig                       |   1 +
 drivers/mtd/cmdlinepart.c                 | 361 ++++--------------------------
 include/linux/cmdline-parser.h            |   8 +-
 5 files changed, 111 insertions(+), 368 deletions(-)

diff --git a/Documentation/block/cmdline-partition.txt b/Documentation/block/cmdline-partition.txt
index 651863d..adc5f7a 100644
--- a/Documentation/block/cmdline-partition.txt
+++ b/Documentation/block/cmdline-partition.txt
@@ -1,40 +1,59 @@
 Embedded device command line partition
-=====================================================================
-
-Read block device partition table from command line.
-The partition used for fixed block device (eMMC) embedded device.
-It is no MBR, save storage space. Bootloader can be easily accessed
-by absolute address of data on the block device.
-Users can easily change the partition.
-
-The format for the command line is just like mtdparts:
-
-blkdevparts=<blkdev-def>[;<blkdev-def>]
+Authors: Cai Zhiyong <caizhiyong@huawei.com>
+
+The format for the command line is as follows,
+it is used by MTD device (reference drivers/mtd/cmdlinepart.c) and
+block device (reference block/partitions/cmdline.c)
+
+================================================================================
+For MTD device:
+  mtdparts=<mtddef>[;<mtddef]
+  <mtddef>  := <mtd-id>:<partdef>[,<partdef>]
+  <partdef> := <size>[@<offset>][<name>][ro][lk]
+  <mtd-id>  := unique name used in mapping driver/device (mtd->name)
+  <size>    := standard linux memsize OR "-" to denote all remaining space
+               size is automatically truncated at end of device
+               if specified or trucated size is 0 the part is skipped
+  <offset>  := standard linux memsize
+               if omitted the part will immediately follow the previous part
+               or 0 if the first part
+  <name>    := '(' NAME ')'
+               NAME will appear in /proc/mtd
+
+  <size> and <offset> can be specified such that the parts are out of order
+  in physical memory and may even overlap.
+
+  The parts are assigned MTD numbers in the order they are specified in the
+  command line regardless of their order in physical memory.
+
+  Examples:
+
+  1 NOR Flash, with 1 single writable partition:
+  edb7312-nor:-
+
+  1 NOR Flash with 2 partitions, 1 NAND with one
+  edb7312-nor:256k(ARMboot)ro,-(root);edb7312-nand:-(home)
+
+================================================================================
+For block device:
+  blkdevparts=<blkdev-def>[;<blkdev-def>]
   <blkdev-def> := <blkdev-id>:<partdef>[,<partdef>]
-    <partdef> := <size>[@<offset>](part-name)
-
-<blkdev-id>
-    block device disk name, embedded device used fixed block device,
-    it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.
-
-<size>
-    partition size, in bytes, such as: 512, 1m, 1G.
-
-<offset>
-    partition start address, in bytes.
-
-(part-name)
-    partition name, kernel send uevent with "PARTNAME". application can create
-    a link to block device partition with the name "PARTNAME".
-    user space application can access partition by partition name.
-
-Example:
-    eMMC disk name is "mmcblk0" and "mmcblk0boot0"
-
-  bootargs:
+  <partdef> := <size>[@<offset>][<name>]
+  <blkdev-id>
+       block device disk name, embedded device used fixed block device,
+       it's disk name also fixed. such as: mmcblk0, mmcblk1, mmcblk0boot0.
+  <size>    := standard linux memsize OR "-" to denote all remaining space
+               size is automatically truncated at end of device
+               if specified or trucated size is 0 the part is skipped
+  <offset>  := standard linux memsize
+               if omitted the part will immediately follow the previous part
+               or 0 if the first part
+  <name>    := '(' NAME ')'
+        partition name, kernel send uevent with "PARTNAME". application could
+        create a link to block device partition with the name "PARTNAME".
+        user space application can access partition by partition name.
+
+  Example:
+
+    eMMC disk name is "mmcblk0" and "mmcblk0boot0", bootargs:
     'blkdevparts=mmcblk0:1G(data0),1G(data1),-;mmcblk0boot0:1m(boot),-(kernel)'
-
-  dmesg:
-    mmcblk0: p1(data0) p2(data1) p3()
-    mmcblk0boot0: p1(boot) p2(kernel)
-
diff --git a/block/cmdline-parser.c b/block/cmdline-parser.c
index 18fb435..8c09db3 100644
--- a/block/cmdline-parser.c
+++ b/block/cmdline-parser.c
@@ -4,8 +4,6 @@
  * Written by Cai Zhiyong <caizhiyong@huawei.com>
  *
  */
-#include <linux/buffer_head.h>
-#include <linux/module.h>
 #include <linux/cmdline-parser.h>
 
 static int parse_subpart(struct cmdline_subpart **subpart, char *partdef)
@@ -158,6 +156,7 @@ void cmdline_parts_free(struct cmdline_parts **parts)
 		*parts = next_parts;
 	}
 }
+EXPORT_SYMBOL(cmdline_parts_free);
 
 int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline)
 {
@@ -205,6 +204,7 @@ fail:
 	cmdline_parts_free(parts);
 	goto done;
 }
+EXPORT_SYMBOL(cmdline_parts_parse);
 
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev)
@@ -213,16 +213,17 @@ struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 		parts = parts->next_parts;
 	return parts;
 }
+EXPORT_SYMBOL(cmdline_parts_find);
 
 /*
  *  add_part()
  *    0 success.
  *    1 can not add so many partitions.
  */
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param)
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param)
 
 {
 	sector_t from = 0;
@@ -246,4 +247,7 @@ void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
 		if (add_part(slot, subpart, param))
 			break;
 	}
+
+	return slot;
 }
+EXPORT_SYMBOL(cmdline_parts_set);
diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 5fab4e6e..6f7f9ca 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -75,6 +75,7 @@ endif # MTD_REDBOOT_PARTS
 
 config MTD_CMDLINE_PARTS
 	tristate "Command line partition table parsing"
+	select CMDLINE_PARSER
 	depends on MTD
 	---help---
 	  Allow generic configuration of the MTD partition tables via the kernel
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 721caeb..79bd584 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -18,34 +18,8 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  *
- * The format for the command line is as follows:
+ * Verbose please reference "Documentation/block/cmdline-partition.txt"
  *
- * mtdparts=<mtddef>[;<mtddef]
- * <mtddef>  := <mtd-id>:<partdef>[,<partdef>]
- * <partdef> := <size>[@<offset>][<name>][ro][lk]
- * <mtd-id>  := unique name used in mapping driver/device (mtd->name)
- * <size>    := standard linux memsize OR "-" to denote all remaining space
- *              size is automatically truncated at end of device
- *              if specified or trucated size is 0 the part is skipped
- * <offset>  := standard linux memsize
- *              if omitted the part will immediately follow the previous part
- *              or 0 if the first part
- * <name>    := '(' NAME ')'
- *              NAME will appear in /proc/mtd
- *
- * <size> and <offset> can be specified such that the parts are out of order
- * in physical memory and may even overlap.
- *
- * The parts are assigned MTD numbers in the order they are specified in the
- * command line regardless of their order in physical memory.
- *
- * Examples:
- *
- * 1 NOR Flash, with 1 single writable partition:
- * edb7312-nor:-
- *
- * 1 NOR Flash with 2 partitions, 1 NAND with one
- * edb7312-nor:256k(ARMboot)ro,-(root);edb7312-nand:-(home)
  */
 
 #include <linux/kernel.h>
@@ -54,249 +28,43 @@
 #include <linux/mtd/partitions.h>
 #include <linux/module.h>
 #include <linux/err.h>
+#include <linux/cmdline-parser.h>
 
-/* error message prefix */
-#define ERRP "mtd: "
-
-/* debug macro */
-#if 0
-#define dbg(x) do { printk("DEBUG-CMDLINE-PART: "); printk x; } while(0)
-#else
-#define dbg(x)
-#endif
-
-
-/* special size referring to all the remaining space in a partition */
-#define SIZE_REMAINING ULLONG_MAX
-#define OFFSET_CONTINUOUS ULLONG_MAX
-
-struct cmdline_mtd_partition {
-	struct cmdline_mtd_partition *next;
-	char *mtd_id;
-	int num_parts;
-	struct mtd_partition *parts;
-};
-
-/* mtdpart_setup() parses into here */
-static struct cmdline_mtd_partition *partitions;
-
-/* the command line passed to mtdpart_setup() */
 static char *mtdparts;
-static char *cmdline;
-static int cmdline_parsed;
+static struct cmdline_parts *mtd_cmdline_parts;
 
-/*
- * Parse one partition definition for an MTD. Since there can be many
- * comma separated partition definitions, this function calls itself
- * recursively until no more partition definitions are found. Nice side
- * effect: the memory to keep the mtd_partition structs and the names
- * is allocated upon the last definition being found. At that point the
- * syntax has been verified ok.
- */
-static struct mtd_partition * newpart(char *s,
-				      char **retptr,
-				      int *num_parts,
-				      int this_part,
-				      unsigned char **extra_mem_ptr,
-				      int extra_mem_size)
+static int add_part(int slot, struct cmdline_subpart *subpart, void *param)
 {
-	struct mtd_partition *parts;
-	unsigned long long size, offset = OFFSET_CONTINUOUS;
-	char *name;
-	int name_len;
-	unsigned char *extra_mem;
-	char delim;
-	unsigned int mask_flags;
-
-	/* fetch the partition size */
-	if (*s == '-') {
-		/* assign all remaining space to this partition */
-		size = SIZE_REMAINING;
-		s++;
-	} else {
-		size = memparse(s, &s);
-		if (size < PAGE_SIZE) {
-			printk(KERN_ERR ERRP "partition size too small (%llx)\n",
-			       size);
-			return ERR_PTR(-EINVAL);
-		}
-	}
+	struct mtd_partition *mtdpart = &((struct mtd_partition *)param)[slot];
 
-	/* fetch partition name and flags */
-	mask_flags = 0; /* this is going to be a regular partition */
-	delim = 0;
+	mtdpart->offset = subpart->from;
+	mtdpart->size = subpart->size;
+	mtdpart->name = subpart->name;
+	mtdpart->mask_flags = 0;
 
-	/* check for offset */
-	if (*s == '@') {
-		s++;
-		offset = memparse(s, &s);
-	}
-
-	/* now look for name */
-	if (*s == '(')
-		delim = ')';
-
-	if (delim) {
-		char *p;
-
-		name = ++s;
-		p = strchr(name, delim);
-		if (!p) {
-			printk(KERN_ERR ERRP "no closing %c found in partition name\n", delim);
-			return ERR_PTR(-EINVAL);
-		}
-		name_len = p - name;
-		s = p + 1;
-	} else {
-		name = NULL;
-		name_len = 13; /* Partition_000 */
-	}
-
-	/* record name length for memory allocation later */
-	extra_mem_size += name_len + 1;
-
-	/* test for options */
-	if (strncmp(s, "ro", 2) == 0) {
-		mask_flags |= MTD_WRITEABLE;
-		s += 2;
-	}
+	if (subpart->flags & PF_RDONLY)
+		mtdpart->mask_flags |= MTD_WRITEABLE;
 
 	/* if lk is found do NOT unlock the MTD partition*/
-	if (strncmp(s, "lk", 2) == 0) {
-		mask_flags |= MTD_POWERUP_LOCK;
-		s += 2;
-	}
-
-	/* test if more partitions are following */
-	if (*s == ',') {
-		if (size == SIZE_REMAINING) {
-			printk(KERN_ERR ERRP "no partitions allowed after a fill-up partition\n");
-			return ERR_PTR(-EINVAL);
-		}
-		/* more partitions follow, parse them */
-		parts = newpart(s + 1, &s, num_parts, this_part + 1,
-				&extra_mem, extra_mem_size);
-		if (IS_ERR(parts))
-			return parts;
-	} else {
-		/* this is the last partition: allocate space for all */
-		int alloc_size;
-
-		*num_parts = this_part + 1;
-		alloc_size = *num_parts * sizeof(struct mtd_partition) +
-			     extra_mem_size;
-
-		parts = kzalloc(alloc_size, GFP_KERNEL);
-		if (!parts)
-			return ERR_PTR(-ENOMEM);
-		extra_mem = (unsigned char *)(parts + *num_parts);
-	}
-
-	/* enter this partition (offset will be calculated later if it is zero at this point) */
-	parts[this_part].size = size;
-	parts[this_part].offset = offset;
-	parts[this_part].mask_flags = mask_flags;
-	if (name)
-		strlcpy(extra_mem, name, name_len + 1);
-	else
-		sprintf(extra_mem, "Partition_%03d", this_part);
-	parts[this_part].name = extra_mem;
-	extra_mem += name_len + 1;
-
-	dbg(("partition %d: name <%s>, offset %llx, size %llx, mask flags %x\n",
-	     this_part, parts[this_part].name, parts[this_part].offset,
-	     parts[this_part].size, parts[this_part].mask_flags));
+	if (subpart->flags & PF_POWERUP_LOCK)
+		mtdpart->mask_flags |= MTD_POWERUP_LOCK;
 
-	/* return (updated) pointer to extra_mem memory */
-	if (extra_mem_ptr)
-		*extra_mem_ptr = extra_mem;
-
-	/* return (updated) pointer command line string */
-	*retptr = s;
-
-	/* return partition table */
-	return parts;
+	return 0;
 }
 
 /*
- * Parse the command line.
+ * This is the handler for our kernel parameter, called from
+ * main.c::checksetup(). Note that we can not yet kmalloc() anything,
+ * so we only save the commandline for later processing.
+ *
+ * This function needs to be visible for bootloaders.
  */
-static int mtdpart_setup_real(char *s)
+static int __init mtdpart_setup(char *s)
 {
-	cmdline_parsed = 1;
-
-	for( ; s != NULL; )
-	{
-		struct cmdline_mtd_partition *this_mtd;
-		struct mtd_partition *parts;
-		int mtd_id_len, num_parts;
-		char *p, *mtd_id;
-
-		mtd_id = s;
-
-		/* fetch <mtd-id> */
-		p = strchr(s, ':');
-		if (!p) {
-			printk(KERN_ERR ERRP "no mtd-id\n");
-			return -EINVAL;
-		}
-		mtd_id_len = p - mtd_id;
-
-		dbg(("parsing <%s>\n", p+1));
-
-		/*
-		 * parse one mtd. have it reserve memory for the
-		 * struct cmdline_mtd_partition and the mtd-id string.
-		 */
-		parts = newpart(p + 1,		/* cmdline */
-				&s,		/* out: updated cmdline ptr */
-				&num_parts,	/* out: number of parts */
-				0,		/* first partition */
-				(unsigned char**)&this_mtd, /* out: extra mem */
-				mtd_id_len + 1 + sizeof(*this_mtd) +
-				sizeof(void*)-1 /*alignment*/);
-		if (IS_ERR(parts)) {
-			/*
-			 * An error occurred. We're either:
-			 * a) out of memory, or
-			 * b) in the middle of the partition spec
-			 * Either way, this mtd is hosed and we're
-			 * unlikely to succeed in parsing any more
-			 */
-			 return PTR_ERR(parts);
-		 }
-
-		/* align this_mtd */
-		this_mtd = (struct cmdline_mtd_partition *)
-				ALIGN((unsigned long)this_mtd, sizeof(void *));
-		/* enter results */
-		this_mtd->parts = parts;
-		this_mtd->num_parts = num_parts;
-		this_mtd->mtd_id = (char*)(this_mtd + 1);
-		strlcpy(this_mtd->mtd_id, mtd_id, mtd_id_len + 1);
-
-		/* link into chain */
-		this_mtd->next = partitions;
-		partitions = this_mtd;
-
-		dbg(("mtdid=<%s> num_parts=<%d>\n",
-		     this_mtd->mtd_id, this_mtd->num_parts));
-
-
-		/* EOS - we're done */
-		if (*s == 0)
-			break;
-
-		/* does another spec follow? */
-		if (*s != ';') {
-			printk(KERN_ERR ERRP "bad character after partition (%c)\n", *s);
-			return -EINVAL;
-		}
-		s++;
-	}
-
-	return 0;
+	mtdparts = s;
+	return 1;
 }
+__setup("mtdparts=", mtdpart_setup);
 
 /*
  * Main function to be called from the MTD mapping driver/device to
@@ -309,82 +77,35 @@ static int parse_cmdline_partitions(struct mtd_info *master,
 				    struct mtd_partition **pparts,
 				    struct mtd_part_parser_data *data)
 {
-	unsigned long long offset;
-	int i, err;
-	struct cmdline_mtd_partition *part;
-	const char *mtd_id = master->name;
+	struct cmdline_parts *parts;
 
-	/* parse command line */
-	if (!cmdline_parsed) {
-		err = mtdpart_setup_real(cmdline);
-		if (err)
-			return err;
-	}
+	if (mtdparts) {
+		if (mtd_cmdline_parts)
+			cmdline_parts_free(&mtd_cmdline_parts);
+
+		if (cmdline_parts_parse(&mtd_cmdline_parts, mtdparts)) {
+			mtdparts = NULL;
+			return -EINVAL;
+		}
 
-	/*
-	 * Search for the partition definition matching master->name.
-	 * If master->name is not set, stop at first partition definition.
-	 */
-	for (part = partitions; part; part = part->next) {
-		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
-			break;
+		mtdparts = NULL;
 	}
 
-	if (!part)
+	if (!mtd_cmdline_parts)
 		return 0;
 
-	for (i = 0, offset = 0; i < part->num_parts; i++) {
-		if (part->parts[i].offset == OFFSET_CONTINUOUS)
-			part->parts[i].offset = offset;
-		else
-			offset = part->parts[i].offset;
-
-		if (part->parts[i].size == SIZE_REMAINING)
-			part->parts[i].size = master->size - offset;
-
-		if (offset + part->parts[i].size > master->size) {
-			printk(KERN_WARNING ERRP
-			       "%s: partitioning exceeds flash size, truncating\n",
-			       part->mtd_id);
-			part->parts[i].size = master->size - offset;
-		}
-		offset += part->parts[i].size;
-
-		if (part->parts[i].size == 0) {
-			printk(KERN_WARNING ERRP
-			       "%s: skipping zero sized partition\n",
-			       part->mtd_id);
-			part->num_parts--;
-			memmove(&part->parts[i], &part->parts[i + 1],
-				sizeof(*part->parts) * (part->num_parts - i));
-			i--;
-		}
-	}
+	parts = cmdline_parts_find(mtd_cmdline_parts, master->name);
+	if (!parts)
+		return 0;
 
-	*pparts = kmemdup(part->parts, sizeof(*part->parts) * part->num_parts,
-			  GFP_KERNEL);
+	*pparts = kzalloc(sizeof(**pparts) * parts->nr_subparts, GFP_KERNEL);
 	if (!*pparts)
 		return -ENOMEM;
 
-	return part->num_parts;
-}
-
-
-/*
- * This is the handler for our kernel parameter, called from
- * main.c::checksetup(). Note that we can not yet kmalloc() anything,
- * so we only save the commandline for later processing.
- *
- * This function needs to be visible for bootloaders.
- */
-static int __init mtdpart_setup(char *s)
-{
-	cmdline = s;
-	return 1;
+	return cmdline_parts_set(parts, master->size, 0, add_part,
+				 (void *)*pparts);
 }
 
-__setup("mtdparts=", mtdpart_setup);
-
 static struct mtd_part_parser cmdline_parser = {
 	.owner = THIS_MODULE,
 	.parse_fn = parse_cmdline_partitions,
@@ -393,8 +114,6 @@ static struct mtd_part_parser cmdline_parser = {
 
 static int __init cmdline_parser_init(void)
 {
-	if (mtdparts)
-		mtdpart_setup(mtdparts);
 	return register_mtd_parser(&cmdline_parser);
 }
 
diff --git a/include/linux/cmdline-parser.h b/include/linux/cmdline-parser.h
index 98e892e..43b65a9 100644
--- a/include/linux/cmdline-parser.h
+++ b/include/linux/cmdline-parser.h
@@ -35,9 +35,9 @@ int cmdline_parts_parse(struct cmdline_parts **parts, const char *cmdline);
 struct cmdline_parts *cmdline_parts_find(struct cmdline_parts *parts,
 					 const char *bdev);
 
-void cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
-		       int slot,
-		       int (*add_part)(int, struct cmdline_subpart *, void *),
-		       void *param);
+int cmdline_parts_set(struct cmdline_parts *parts, sector_t disk_size,
+		      int slot,
+		      int (*add_part)(int, struct cmdline_subpart *, void *),
+		      void *param);
 
 #endif /* CMDLINEPARSEH */
-- 
1.8.1.5

