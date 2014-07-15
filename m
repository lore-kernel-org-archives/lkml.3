Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886AbaGOL67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:58:59 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29482 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbaGOL65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:58:57 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-04-53c517693f12
Subject: [PATCH] mm: do not call do_fault_around for non-linear fault
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Korb <ingo.korb@tu-dortmund.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ning Qu <quning@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Date: Tue, 15 Jul 2014 15:58:32 +0400
Message-id: <20140715115832.18997.90349.stgit@buzz>
In-reply-to: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
References: <CALYGNiM9Fu9-i7hXMQNTUP69RfydN+2NqO29wZYd+4Gn25GbCQ@mail.gmail.com>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7qZ4keDDZauE7aYs34Nm8WW601M
	Fk8/9bFYtPzpZLP4sbOX1eLm8zksFis7H7BaXN41h83i3pr/rBbXN81jsVh85DazA7fHzll3
	2T0WbCr12PRpErvHiRm/WTzmnQz0+Pj0FovH+31X2Tz6tqxi9Gg818vs8XmTXABXFJdNSmpO
	Zllqkb5dAlfGht3TGQtOslfsnLyetYFxDlsXIyeHhICJxOIFp5khbDGJC/fWg8WFBJYySly6
	I9vFyAVkNzJJnH69DijBwSEs4Cpx62A2SA2bgJnEtn23GUFsEYFaiZ4HBxlB6pkFvjNKfPzx
	iQUkwSKgKnHnwVGwIl4BY4npG/+ALeAUCJb4fqGLCWJZgETHzQYwW1RATmLl5RZWiHpBiR+T
	77GA7GUWUJeYMiUXJMwsIC+xec1b5gmMArOQVM1CqJqFpGoBI/MqRtHU0uSC4qT0XEO94sTc
	4tK8dL3k/NxNjJC4+bKDcfExq0OMAhyMSjy8FWKHg4VYE8uKK3MPMUpwMCuJ8Nb/OxIsxJuS
	WFmVWpQfX1Sak1p8iJGJg1OqgbGprfKi1vEba7g/yEzynhHOfnT6u7ZX0RfzT+W3v3+ylTHv
	wtFVFRfXZsq9z7slx6PP1Bu0/8SzwMRF8YWH/yza+UVL13KbZzJzs7+YiGpRWuVLtTVxtqc+
	/dO+xHx/+nOTxmWP76etPsyy9MtO55WcK5WmSoZzBWoFaLb4f965i+WQ55qd1sJKLMUZiYZa
	zEXFiQBxJ/qreQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <koct9i@gmail.com>

Faulting around non-linear page-fault has no sense and
breaks logic in do_fault_around because pgoff is shifted.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: "Ingo Korb" <ingo.korb@tu-dortmund.de>
---
 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index d67fd9f..7e8d820 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2882,7 +2882,8 @@ static int do_read_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * if page by the offset is not ready to be mapped (cold cache or
 	 * something).
 	 */
-	if (vma->vm_ops->map_pages && fault_around_pages() > 1) {
+	if (vma->vm_ops->map_pages && !(flags & FAULT_FLAG_NONLINEAR) &&
+	    fault_around_pages() > 1) {
 		pte = pte_offset_map_lock(mm, pmd, address, &ptl);
 		do_fault_around(vma, address, pte, pgoff, flags);
 		if (!pte_same(*pte, orig_pte))

