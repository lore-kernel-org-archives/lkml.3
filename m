Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaHESOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:14:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbaHESOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 10/39] mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()
Date: Tue,  5 Aug 2014 11:13:47 -0700
Message-Id: <20140805181336.361063269@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxim Patlasov <MPatlasov@parallels.com>

commit f6789593d5cea42a4ecb1cbeab6a23ade5ebbba7 upstream.

Under memory pressure, it is possible for dirty_thresh, calculated by
global_dirty_limits() in balance_dirty_pages(), to equal zero.  Then, if
strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:

  bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh

by dividing by zero.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1324,9 +1324,9 @@ static inline void bdi_dirty_limits(stru
 	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
 
 	if (bdi_bg_thresh)
-		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
-					 background_thresh,
-					 dirty_thresh);
+		*bdi_bg_thresh = dirty_thresh ? div_u64((u64)*bdi_thresh *
+							background_thresh,
+							dirty_thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need


