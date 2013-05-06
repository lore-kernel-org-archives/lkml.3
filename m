Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab3EGADM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:03:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759448Ab3EFW44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:56:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 13/63] s390/memory hotplug: prevent offline of active memory increments
Date: Mon,  6 May 2013 15:55:51 -0700
Message-Id: <20130506225318.059865307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


