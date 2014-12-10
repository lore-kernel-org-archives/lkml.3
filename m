Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbaLJHW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:22:26 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:13466 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752764AbaLJHWZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:22:25 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Kirill A. Shutemov'" <kirill@shutemov.name>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Konstantin Khlebnikov'" <koct9i@gmail.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'n-horiguchi@ah.jp.nec.com'" <n-horiguchi@ah.jp.nec.com>,
        "'oleg@redhat.com'" <oleg@redhat.com>,
        "'gorcunov@openvz.org'" <gorcunov@openvz.org>,
        "'pfeiner@google.com'" <pfeiner@google.com>
Date: Wed, 10 Dec 2014 15:22:21 +0800
Subject: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
Thread-Topic: [RFC] mm:fix zero_page huge_zero_page rss/pss statistic
Thread-Index: AdAS3POBh48LiUfmSOiU07RH13dqIwAgkhXwADqmExA=
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B31403@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103E688B313EE@CNBJMBX05.corpusers.net>
 <CALYGNiOuBKz8shHSrFCp0BT5AV6XkNOCHj+LJedQQ-2YdZtM7w@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E688B313F2@CNBJMBX05.corpusers.net>
 <20141205143134.37139da2208c654a0d3cd942@linux-foundation.org>
 <35FD53F367049845BC99AC72306C23D103E688B313F4@CNBJMBX05.corpusers.net>
 <20141208114601.GA28846@node.dhcp.inet.fi>
 <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E688B313FB@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smaps_pte_entry() doesn't ignore zero_huge_page,
but it ignore zero_page, because vm_normal_page() will
ignore it. We remove vm_normal_page() call, because walk_page_range()
have ignore VM_PFNMAP vma maps, it's safe to just use pfn_valid(),
so that we can also consider zero_page to be a valid page.

Another change is that we only add map_count >= 2 or mapcount == 1
pages into pss, because zero_page and huge_zero_page's _mapcount is
zero, this means pss will consider evey zero page as a PAGE_SIZE for
every process, this is not correct for pss statistic. We ignore
zero page for pss, just add zero page into rss statistic.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 fs/proc/task_mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0388c..ce503d3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -458,7 +458,9 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 	int mapcount;
 
 	if (pte_present(ptent)) {
-		page = vm_normal_page(vma, addr, ptent);
+		if (!pte_special(ptent) && pfn_valid(pte_pfn(ptent)))
+			page = pfn_to_page(pte_pfn(ptent));
+
 	} else if (is_swap_pte(ptent)) {
 		swp_entry_t swpent = pte_to_swp_entry(ptent);
 
@@ -491,7 +493,7 @@ static void smaps_pte_entry(pte_t ptent, unsigned long addr,
 		else
 			mss->shared_clean += ptent_size;
 		mss->pss += (ptent_size << PSS_SHIFT) / mapcount;
-	} else {
+	} else if (mapcount == 1){
 		if (pte_dirty(ptent) || PageDirty(page))
 			mss->private_dirty += ptent_size;
 		else
-- 
2.1.3
