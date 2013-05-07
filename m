Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3EGORf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:17:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42140 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab3EGNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:40:48 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/118] s390/memory hotplug: prevent offline of active memory increments
Date: Tue,  7 May 2013 14:37:51 +0100
Message-Id: <1367933964-1564-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 94c163663fc1dcfc067a5fb3cc1446b9469975ce upstream.

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
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/s390/char/sclp_cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 766cb7b..1845ab5 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -529,6 +529,8 @@ static void __init sclp_add_standby_memory(void)
 	add_memory_merged(0);
 }
 
+#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
+
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -541,7 +543,7 @@ static void __init insert_increment(u16 rn, int standby, int assigned)
 	new_incr->rn = rn;
 	new_incr->standby = standby;
 	if (!standby)
-		new_incr->usecount = 1;
+		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {
-- 
1.8.1.2

