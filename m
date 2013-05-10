Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3EJOV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab3EJOVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
        "Gerald Schaefer" <gerald.schaefer@de.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.214700466@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [061/118] s390/memory hotplug: prevent offline of active memory
 increments
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/s390/char/sclp_cmd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -509,6 +509,8 @@ static void __init sclp_add_standby_memo
 	add_memory_merged(0);
 }
 
+#define MEM_SCT_SIZE (1UL << SECTION_SIZE_BITS)
+
 static void __init insert_increment(u16 rn, int standby, int assigned)
 {
 	struct memory_increment *incr, *new_incr;
@@ -521,7 +523,7 @@ static void __init insert_increment(u16
 	new_incr->rn = rn;
 	new_incr->standby = standby;
 	if (!standby)
-		new_incr->usecount = 1;
+		new_incr->usecount = rzm > MEM_SCT_SIZE ? rzm/MEM_SCT_SIZE : 1;
 	last_rn = 0;
 	prev = &sclp_mem_list;
 	list_for_each_entry(incr, &sclp_mem_list, list) {

