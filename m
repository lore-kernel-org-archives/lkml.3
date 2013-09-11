Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab3IKJ4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:56:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28834 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260Ab3IKJ4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:56:45 -0400
X-Authority-Analysis: v=2.0 cv=R/aB6KtX c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=j3-r3loCb8EA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=YmFrBUDmc8QA:10 a=uP1ucDPQAAAA:8 a=KKAkSRfTAAAA:8 a=drOt6m5kAAAA:8 a=T2h1Z_K7z-JURIdn7sYA:9 a=zaWHSuwd-w0A:10 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=nFlfukreqcYSQcj2:21 a=FTDgeUEVp1OVyZ1Q:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042905.646357940@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Nicolas Pitre <nico@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [080/251] ARM: 7722/1: zImage: Convert 32bits memory size and address from
 ATAG to 64bits DTB
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0080-ARM-7722-1-zImage-Convert-32bits-memory-size-and-add.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

[ Upstream commit faefd550c45d8d314e8f260f21565320355c947f ]

When CONFIG_ARM_APPENDED_DTB is selected, if the bootloader provides
an ATAG_MEM it replaces the memory size and the memory address in the
memory node of the device tree. In the case of a system which can
handle more than 4GB, the memory node cell size is 4: each data
(memory size and memory address) are 64 bits and then use 2 cells.

The current code in atags_to_fdt.c made the assumption of a cell size
of 2 (one cell for the memory size and one cell for the memory
address), this leads to an improper write of the data and ends with a
boot hang.

This patch writes the memory size and the memory address on the memory
node in the device tree depending of the size of the memory node (32
bits or 64 bits).

It has been tested in the 2 cases:
- with a dtb using skeleton.dtsi
- and with a dtb using skeleton64.dtsi

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/boot/compressed/atags_to_fdt.c |   44 ++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/compressed/atags_to_fdt.c b/arch/arm/boot/compressed/atags_to_fdt.c
index aabc02a..d1153c8 100644
--- a/arch/arm/boot/compressed/atags_to_fdt.c
+++ b/arch/arm/boot/compressed/atags_to_fdt.c
@@ -53,6 +53,17 @@ static const void *getprop(const void *fdt, const char *node_path,
 	return fdt_getprop(fdt, offset, property, len);
 }
 
+static uint32_t get_cell_size(const void *fdt)
+{
+	int len;
+	uint32_t cell_size = 1;
+	const uint32_t *size_len =  getprop(fdt, "/", "#size-cells", &len);
+
+	if (size_len)
+		cell_size = fdt32_to_cpu(*size_len);
+	return cell_size;
+}
+
 static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
 {
 	char cmdline[COMMAND_LINE_SIZE];
@@ -95,9 +106,11 @@ static void merge_fdt_bootargs(void *fdt, const char *fdt_cmdline)
 int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 {
 	struct tag *atag = atag_list;
-	uint32_t mem_reg_property[2 * NR_BANKS];
+	/* In the case of 64 bits memory size, need to reserve 2 cells for
+	 * address and size for each bank */
+	uint32_t mem_reg_property[2 * 2 * NR_BANKS];
 	int memcount = 0;
-	int ret;
+	int ret, memsize;
 
 	/* make sure we've got an aligned pointer */
 	if ((u32)atag_list & 0x3)
@@ -137,8 +150,25 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 				continue;
 			if (!atag->u.mem.size)
 				continue;
-			mem_reg_property[memcount++] = cpu_to_fdt32(atag->u.mem.start);
-			mem_reg_property[memcount++] = cpu_to_fdt32(atag->u.mem.size);
+			memsize = get_cell_size(fdt);
+
+			if (memsize == 2) {
+				/* if memsize is 2, that means that
+				 * each data needs 2 cells of 32 bits,
+				 * so the data are 64 bits */
+				uint64_t *mem_reg_prop64 =
+					(uint64_t *)mem_reg_property;
+				mem_reg_prop64[memcount++] =
+					cpu_to_fdt64(atag->u.mem.start);
+				mem_reg_prop64[memcount++] =
+					cpu_to_fdt64(atag->u.mem.size);
+			} else {
+				mem_reg_property[memcount++] =
+					cpu_to_fdt32(atag->u.mem.start);
+				mem_reg_property[memcount++] =
+					cpu_to_fdt32(atag->u.mem.size);
+			}
+
 		} else if (atag->hdr.tag == ATAG_INITRD2) {
 			uint32_t initrd_start, initrd_size;
 			initrd_start = atag->u.initrd.start;
@@ -150,8 +180,10 @@ int atags_to_fdt(void *atag_list, void *fdt, int total_space)
 		}
 	}
 
-	if (memcount)
-		setprop(fdt, "/memory", "reg", mem_reg_property, 4*memcount);
+	if (memcount) {
+		setprop(fdt, "/memory", "reg", mem_reg_property,
+			4 * memcount * memsize);
+	}
 
 	return fdt_pack(fdt);
 }
-- 
1.7.10.4


