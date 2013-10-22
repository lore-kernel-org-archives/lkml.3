Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3JVNPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 09:15:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26448 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab3JVNPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 09:15:37 -0400
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Brian Norris <computersforpeace@gmail.com>
CC: Brian Norris <computersforpeace@gmail.com>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Thread-Topic: [PATCH 2/2]  mtd: cmdlinepart: use cmdline partition parser lib
Thread-Index: AQHOzyiczXccMKf72E2y9hcK5+vClg==
Date: Tue, 22 Oct 2013 13:14:17 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F1C084C81@szxeml512-mbs.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F1C0643B8@szxeml512-mbx.china.huawei.com>
 <20131020120603.GA18678@localhost>
In-Reply-To: <20131020120603.GA18678@localhost>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.21]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r9MDFlZT006122

From: CaiZhiyong <caizhiyong@huawei.com>
Subject: mtd: cmdlinepart: use cmdline partition parser lib

In the previous version, adjust the cmdline parser code to library-style
code, and move it to a separate file "block/cmdline-parser.c", we can use
it in some client code. there is no any functionality change in the adjusting.

this patch use cmdline parser lib.

For further information, see "https://lkml.org/lkml/2013/8/6/550"

Signed-off-by: CaiZhiyong <caizhiyong@huawei.com>
---
 drivers/mtd/Kconfig       |   1 +
 drivers/mtd/cmdlinepart.c | 343 +++++-----------------------------------------
 2 files changed, 39 insertions(+), 305 deletions(-)

diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
index 5fab4e6e..daf544a 100644
--- a/drivers/mtd/Kconfig
+++ b/drivers/mtd/Kconfig
@@ -75,6 +75,7 @@ endif # MTD_REDBOOT_PARTS
 
 config MTD_CMDLINE_PARTS
 	tristate "Command line partition table parsing"
+	select BLK_CMDLINE_PARSER
 	depends on MTD
 	---help---
 	  Allow generic configuration of the MTD partition tables via the kernel
diff --git a/drivers/mtd/cmdlinepart.c b/drivers/mtd/cmdlinepart.c
index 721caeb..ba934a4 100644
--- a/drivers/mtd/cmdlinepart.c
+++ b/drivers/mtd/cmdlinepart.c
@@ -47,344 +47,79 @@
  * 1 NOR Flash with 2 partitions, 1 NAND with one
  * edb7312-nor:256k(ARMboot)ro,-(root);edb7312-nand:-(home)
  */
+ /*
+  * Copyright Â© 2013 Cai Zhiyong <caizhiyong@huawei.com>
+  * Rewrite the cmdline parser code, adjust it to a library-style code.
+  * this module only use the cmdline parser lib.
+  */
 
 #include <linux/kernel.h>
-#include <linux/slab.h>
 #include <linux/mtd/mtd.h>
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
-
-	/* fetch partition name and flags */
-	mask_flags = 0; /* this is going to be a regular partition */
-	delim = 0;
-
-	/* check for offset */
-	if (*s == '@') {
-		s++;
-		offset = memparse(s, &s);
-	}
+	struct mtd_partition *mtdpart = &((struct mtd_partition *)param)[slot];
 
-	/* now look for name */
-	if (*s == '(')
-		delim = ')';
+	mtdpart->offset = subpart->from;
+	mtdpart->size = subpart->size;
+	mtdpart->name = subpart->name;
+	mtdpart->mask_flags = 0;
 
-	if (delim) {
-		char *p;
+	if (subpart->flags & PF_RDONLY)
+		mtdpart->mask_flags |= MTD_WRITEABLE;
 
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
+	if (subpart->flags & PF_POWERUP_LOCK)
+		mtdpart->mask_flags |= MTD_POWERUP_LOCK;
 
-	/* if lk is found do NOT unlock the MTD partition*/
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
-
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
 
-/*
- * Parse the command line.
- */
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
 
-/*
- * Main function to be called from the MTD mapping driver/device to
- * obtain the partitioning information. At this point the command line
- * arguments will actually be parsed and turned to struct mtd_partition
- * information. It returns partitions for the requested mtd device, or
- * the first one in the chain if a NULL mtd_id is passed in.
- */
 static int parse_cmdline_partitions(struct mtd_info *master,
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
 
-	/*
-	 * Search for the partition definition matching master->name.
-	 * If master->name is not set, stop at first partition definition.
-	 */
-	for (part = partitions; part; part = part->next) {
-		if ((!mtd_id) || (!strcmp(part->mtd_id, mtd_id)))
-			break;
+		if (cmdline_parts_parse(&mtd_cmdline_parts, mtdparts)) {
+			mtdparts = NULL;
+			return -EINVAL;
+		}
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
+	return cmdline_parts_set(parts, master->size, 0, add_part,
+				 (void *)*pparts);
 }
 
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
-}
-
-__setup("mtdparts=", mtdpart_setup);
-
 static struct mtd_part_parser cmdline_parser = {
 	.owner = THIS_MODULE,
 	.parse_fn = parse_cmdline_partitions,
@@ -393,8 +128,6 @@ static struct mtd_part_parser cmdline_parser = {
 
 static int __init cmdline_parser_init(void)
 {
-	if (mtdparts)
-		mtdpart_setup(mtdparts);
 	return register_mtd_parser(&cmdline_parser);
 }
 
-- 
1.8.1.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
