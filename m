Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab3LFOMh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:12:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43747 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161243Ab3LFNAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 049/272] s390/uaccess: add missing page table walk range check
Date: Fri,  6 Dec 2013 12:55:38 +0000
Message-Id: <1386334761-25517-50-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 71a86ef055f569b93bc6901f007bdf447dbf515f upstream.

When translating a user space address, the address must be checked against
the ASCE limit of the process. If the address is larger than the maximum
address that is reachable with the ASCE, an ASCE type exception must be
generated.

The current code simply ignored the higher order bits. This resulted in an
address wrap around in user space instead of an exception in user space.

Reviewed-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/lib/uaccess_pt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index 50ea137..1bf40ef 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -78,11 +78,14 @@ static size_t copy_in_kernel(size_t count, void __user *to,
  * contains the (negative) exception code.
  */
 #ifdef CONFIG_64BIT
+
 static unsigned long follow_table(struct mm_struct *mm,
 				  unsigned long address, int write)
 {
 	unsigned long *table = (unsigned long *)__pa(mm->pgd);
 
+	if (unlikely(address > mm->context.asce_limit - 1))
+		return -0x38UL;
 	switch (mm->context.asce_bits & _ASCE_TYPE_MASK) {
 	case _ASCE_TYPE_REGION1:
 		table = table + ((address >> 53) & 0x7ff);
-- 
1.8.3.2

