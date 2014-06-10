Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628AbaFJA0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:26:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934637AbaFJAWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3.4 85/88] xen/balloon: Subtract from xen_released_pages the count that is populated.
Date: Mon,  9 Jun 2014 17:25:35 -0700
Message-Id: <20140610002427.299412134@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 58b7b53a36b0be8081fbfc91aeea24b83c20ca1b upstream.

We did not take into account that xen_released_pages would be
used outside the initial E820 parsing code. As such we would
did not subtract from xen_released_pages the count of pages
that we had populated back (instead we just did a simple
extra_pages = released - populated).

The balloon driver uses xen_released_pages to set the initial
current_pages count.  If this is wrong (too low) then when a new
(higher) target is set, the balloon driver will request too many pages
from Xen."

This fixes errors such as:

(XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (51 of 512)
during bootup and
free_memory            : 0

where the free_memory should be 128.

Acked-by: David Vrabel <david.vrabel@citrix.com>
[v1: Per David's review made the git commit better]
Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/setup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -399,7 +399,8 @@ char * __init xen_memory_setup(void)
 	populated = xen_populate_chunk(map, memmap.nr_entries,
 			max_pfn, &last_pfn, xen_released_pages);
 
-	extra_pages += (xen_released_pages - populated);
+	xen_released_pages -= populated;
+	extra_pages += xen_released_pages;
 
 	if (last_pfn > max_pfn) {
 		max_pfn = min(MAX_DOMAIN_PAGES, last_pfn);


