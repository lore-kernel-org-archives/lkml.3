Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaLALtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:49:25 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:50510 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaLALtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:49:22 -0500
Date: Mon, 1 Dec 2014 12:49:13 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 last minute patch for 3.18
Message-ID: <20141201124913.351d8590@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120111-0025-0000-0000-000002AABF31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

A single but important fix for the machine check handling. The big
per-cpu cleanup from Christoph causes the code to do nothing after
receiving a machine check condition.

Sebastian Ott (1):
      s390: fix machine check handling

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

