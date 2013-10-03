Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3JCAwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:52:37 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:36946 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3JCAwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:52:32 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 14/14] vrange: Add vmstat counter about purged page
Date: Wed,  2 Oct 2013 17:51:43 -0700
Message-Id: <1380761503-14509-15-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380761503-14509-1-git-send-email-john.stultz@linaro.org>
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>

This patch adds the number of purged page in vmstat so admin can see
how many of volatile pages are discarded by VM until now.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Robert Love <rlove@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Andrea Righi <andrea@betterlinux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Jan Kara <jack@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org <linux-mm@kvack.org>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/vm_event_item.h |  2 ++
 mm/vmstat.c                   |  2 ++
 mm/vrange.c                   | 10 ++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index bd6cf61..c4aea92 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -25,6 +25,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(PGALLOC),
 		PGFREE, PGACTIVATE, PGDEACTIVATE,
 		PGFAULT, PGMAJFAULT,
+		PGDISCARD_DIRECT,
+		PGDISCARD_KSWAPD,
 		FOR_ALL_ZONES(PGREFILL),
 		FOR_ALL_ZONES(PGSTEAL_KSWAPD),
 		FOR_ALL_ZONES(PGSTEAL_DIRECT),
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 20c2ef4..4f35f46 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -756,6 +756,8 @@ const char * const vmstat_text[] = {
 
 	"pgfault",
 	"pgmajfault",
+	"pgdiscard_direct",
+	"pgdiscard_kswapd",
 
 	TEXTS_FOR_ZONES("pgrefill")
 	TEXTS_FOR_ZONES("pgsteal_kswapd")
diff --git a/mm/vrange.c b/mm/vrange.c
index c30e3dd..8931fab 100644
--- a/mm/vrange.c
+++ b/mm/vrange.c
@@ -894,6 +894,10 @@ int discard_vpage(struct page *page)
 
 		if (page_freeze_refs(page, 1)) {
 			unlock_page(page);
+			if (current_is_kswapd())
+				count_vm_event(PGDISCARD_KSWAPD);
+			else
+				count_vm_event(PGDISCARD_DIRECT);
 			return 0;
 		}
 	}
@@ -1144,6 +1148,12 @@ static int discard_vrange(struct vrange *vrange)
 		ret = __discard_vrange_file(mapping, vrange, &nr_discard);
 	}
 
+	if (!ret) {
+		if (current_is_kswapd())
+			count_vm_events(PGDISCARD_KSWAPD, nr_discard);
+		else
+			count_vm_events(PGDISCARD_DIRECT, nr_discard);
+	}
 out:
 	__vroot_put(vroot);
 	return nr_discard;
-- 
1.8.1.2

