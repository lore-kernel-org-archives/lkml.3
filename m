Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaGZTk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:40:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbaGZTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Marek Marczykowski <marmarek@invisiblethingslab.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 3.15 019/109] xen/balloon: set ballooned out pages as invalid in p2m
Date: Sat, 26 Jul 2014 12:01:41 -0700
Message-Id: <20140726190224.418308635@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit fb9a0c443691ceaab3daba966bbbd9f5ff3aa26f upstream.

Since cd9151e26d31048b2b5e00fd02e110e07d2200c9 (xen/balloon: set a
mapping for ballooned out pages), a ballooned out page had its entry
in the p2m set to the MFN of one of the scratch pages.  This means
that the p2m will contain many entries pointing to the same MFN.

During a domain save, these many-to-one entries are not identified as
such and the scratch page is saved multiple times. On restore the
ballooned pages are populated with new frames and the domain may use
up its allocation before all pages can be restored.

Since the original fix only needed to keep a mapping for the ballooned
page it is safe to set ballooned out pages as INVALID_P2M_ENTRY in the
p2m (as they were before). Thus preventing them from being saved and
re-populated on restore.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reported-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
Tested-by: Marek Marczykowski <marmarek@invisiblethingslab.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/balloon.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -426,20 +426,18 @@ static enum bp_state decrease_reservatio
 		 * p2m are consistent.
 		 */
 		if (!xen_feature(XENFEAT_auto_translated_physmap)) {
-			unsigned long p;
-			struct page   *scratch_page = get_balloon_scratch_page();
-
 			if (!PageHighMem(page)) {
+				struct page *scratch_page = get_balloon_scratch_page();
+
 				ret = HYPERVISOR_update_va_mapping(
 						(unsigned long)__va(pfn << PAGE_SHIFT),
 						pfn_pte(page_to_pfn(scratch_page),
 							PAGE_KERNEL_RO), 0);
 				BUG_ON(ret);
-			}
-			p = page_to_pfn(scratch_page);
-			__set_phys_to_machine(pfn, pfn_to_mfn(p));
 
-			put_balloon_scratch_page();
+				put_balloon_scratch_page();
+			}
+			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 		}
 #endif
 


