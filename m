Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3ERCQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:16:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7265 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=foI7EGvVeSsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KVkRizAFnqsA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=mz2APyGfDvhza7jz6GAA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021645.104355369@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 021/136 ] s390/memory hotplug: prevent offline of active memory increments
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0021-s390-memory-hotplug-prevent-offline-of-active-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit 94c163663fc1dcfc067a5fb3cc1446b9469975ce ]

In case a machine supports memory hotplug all active memory increments
present at IPL time have been initialized with a "usecount" of 1.
This is wrong if the memory increment size is larger than the memory
section size of the memory hotplug code. If that is the case the
usecount must be initialized with the number of memory sections that
fit into one memory increment.
Otherwise it is possible to put a memory increment into standby state
even if there are still active sections.
Afterwards addressing exceptions might happen which cause the kernel
to panic.
However even worse, if a memory increment was put into standby state
and afterwards into active state again, it's contents would have been
zeroed, leading to memory corruption.

This was only an issue for machines that support standby memory and
have at least 256GB memory.

This is broken since commit fdb1bb15 "[S390] sclp/memory hotplug: fix
initial usecount of increments".

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: stable@vger.kernel.org # 2.6.39+
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/s390/char/sclp_cmd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 71ea923c..5cf9cc7 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -567,6 +567,8 @@ static void __init sclp_add_standby_memory(void)
 	add_memory_merged(0);
 }
 
+#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
+
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -579,7 +581,7 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 	new_incr->rn = rn;
 	new_incr->standby = standby;
 	if (!standby)
-		new_incr->usecount = 1;
+		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
-- 
1.7.10.4


