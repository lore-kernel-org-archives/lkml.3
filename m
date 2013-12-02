Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3LBTqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:46:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39550 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab3LBTSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.12 153/212] s390/uaccess: add missing page table walk range check
Date: Mon,  2 Dec 2013 11:15:44 -0800
Message-Id: <20131202191304.535673023@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/lib/uaccess_pt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -78,11 +78,14 @@ static size_t copy_in_kernel(size_t coun
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


