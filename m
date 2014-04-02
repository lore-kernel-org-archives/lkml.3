Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbaDBI5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:57:42 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:35931 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbaDBI5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:57:40 -0400
Message-ID: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: nfont@linux.vnet.ibm.com, gregkh@linuxfoundation.org
Date: Wed, 02 Apr 2014 16:56:58 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040208-3568-0000-0000-00000531A74D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed the phys_index and end_phys_index under 
/sys/devices/system/memory/memoryXXX/ have the same value, e.g.
(for the test machine, one memory block has 8 sections, that is 
 sections_per_block equals 8)

# cd /sys/devices/system/memory/memory100/
# cat phys_index end_phys_index 
00000064
00000064

Seems they should reflect the start/end section number respectively, which 
also matches what is said in Documentation/memory-hotplug.txt

This patch tries to modify that so the two files could show the start/end
section number of the memory block.

After this change, output of the above example looks like:

# cat phys_index end_phys_index 
00000320
00000327

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 drivers/base/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index bece691..b10f2fa 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -114,7 +114,7 @@ static ssize_t show_mem_start_phys_index(struct device *dev,
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
-	phys_index = mem->start_section_nr / sections_per_block;
+	phys_index = mem->start_section_nr;
 	return sprintf(buf, "%08lx\n", phys_index);
 }
 
@@ -124,7 +124,7 @@ static ssize_t show_mem_end_phys_index(struct device *dev,
 	struct memory_block *mem = to_memory_block(dev);
 	unsigned long phys_index;
 
-	phys_index = mem->end_section_nr / sections_per_block;
+	phys_index = mem->end_section_nr;
 	return sprintf(buf, "%08lx\n", phys_index);
 }
 


