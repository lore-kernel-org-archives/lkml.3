Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3IYATz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:19:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab3IYATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:19:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 009/117] UBI: Fix PEB leak in wear_leveling_worker()
Date: Tue, 24 Sep 2013 17:17:55 -0700
Message-Id: <20130925001741.881099298@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Weinberger <richard@nod.at>

commit 5ef4414f4bc26a19cfd5cd11aee9697a863e4d51 upstream.

get_peb_for_wl() removes the PEB from the free list.
If the WL subsystem detects that no wear leveling is needed
it cancels the operation and drops the gained PEB.
In this case we have to put the PEB back into the free list.

This issue was introduced with commit ed4b7021c
(UBI: remove PEB from free tree in get_peb_for_wl()).

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/wl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1069,6 +1069,9 @@ static int wear_leveling_worker(struct u
 		if (!(e2->ec - e1->ec >= UBI_WL_THRESHOLD)) {
 			dbg_wl("no WL needed: min used EC %d, max free EC %d",
 			       e1->ec, e2->ec);
+
+			/* Give the unused PEB back */
+			wl_tree_add(e2, &ubi->free);
 			goto out_cancel;
 		}
 		self_check_in_wl_tree(ubi, e1, &ubi->used);


