Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbaIOVOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:14:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54566 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878AbaIOT0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 028/158] mm: fix potential infinite loop in dissolve_free_huge_pages()
Date: Mon, 15 Sep 2014 12:24:27 -0700
Message-Id: <20140915192543.730250398@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

commit d0177639310d23c7739500df3c6ce6fdfe34acec upstream.

It is possible for some platforms, such as powerpc to set HPAGE_SHIFT to
0 to indicate huge pages not supported.

When this is the case, hugetlbfs could be disabled during boot time:
hugetlbfs: disabling because there are no supported hugepage sizes

Then in dissolve_free_huge_pages(), order is kept maximum (64 for
64bits), and the for loop below won't end: for (pfn = start_pfn; pfn <
end_pfn; pfn += 1 << order)

As suggested by Naoya, below fix checks hugepages_supported() before
calling dissolve_free_huge_pages().

[rientjes@google.com: no legitimate reason to call dissolve_free_huge_pages() when !hugepages_supported()]
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1089,6 +1089,9 @@ void dissolve_free_huge_pages(unsigned l
 	unsigned long pfn;
 	struct hstate *h;
 
+	if (!hugepages_supported())
+		return;
+
 	/* Set scan step to minimum hugepage size */
 	for_each_hstate(h)
 		if (order > huge_page_order(h))


