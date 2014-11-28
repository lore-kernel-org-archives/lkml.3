Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaK1PD1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:03:27 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:38050 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaK1PD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:03:26 -0500
Date: Fri, 28 Nov 2014 16:03:14 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Tejun Heo <tj@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: PATCH] s390: fix machine check handling
Message-ID: <alpine.LFD.2.11.1411281544190.1648@denkbrett>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112815-0005-0000-0000-00000244B305
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

would it be possible to have this one for 3.18 (if not, please add
Cc: stable@vger.kernel.org # v3.18)

Regards,
Sebastian

>8-----

>From ca198a6ff5766f19645104b7f8d621774524c4b4 Mon Sep 17 00:00:00 2001
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
Date: Fri, 28 Nov 2014 15:40:57 +0100
Subject: [PATCH] s390: fix machine check handling

Commit eb7e7d76 "s390: Replace __get_cpu_var uses" broke machine check
handling.

We copy machine check information from per-cpu to a stack variable for
local processing. Next we should zap the per-cpu variable, not the
stack variable.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Reviewed-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 arch/s390/kernel/nmi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
index dd1c24c..3f51cf4 100644
--- a/arch/s390/kernel/nmi.c
+++ b/arch/s390/kernel/nmi.c
@@ -54,12 +54,8 @@ void s390_handle_mcck(void)
 	 */
 	local_irq_save(flags);
 	local_mcck_disable();
-	/*
-	 * Ummm... Does this make sense at all? Copying the percpu struct
-	 * and then zapping it one statement later?
-	 */
-	memcpy(&mcck, this_cpu_ptr(&cpu_mcck), sizeof(mcck));
-	memset(&mcck, 0, sizeof(struct mcck_struct));
+	mcck = *this_cpu_ptr(&cpu_mcck);
+	memset(this_cpu_ptr(&cpu_mcck), 0, sizeof(mcck));
 	clear_cpu_flag(CIF_MCCK_PENDING);
 	local_mcck_enable();
 	local_irq_restore(flags);
-- 
1.8.4.2

