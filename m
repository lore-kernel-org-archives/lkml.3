Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3FDWmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:42:15 -0400
Received: from 1wt.eu ([62.212.114.60]:35384 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab3FDWmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:10 -0400
Message-Id: <20130604172131.885884951@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:08 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>,
        Aaditya Kumar <aaditya.kumar@ap.sony.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 038/184] mm: bugfix: set current->reclaim_state to NULL while
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 returning from kswapd()

From: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>

commit b0a8cc58e6b9aaae3045752059e5e6260c0b94bc upstream.

In kswapd(), set current->reclaim_state to NULL before returning, as
current->reclaim_state holds reference to variable on kswapd()'s stack.

In rare cases, while returning from kswapd() during memory offlining,
__free_slab() and freepages() can access the dangling pointer of
current->reclaim_state.

Signed-off-by: Takamori Yamaguchi <takamori.yamaguchi@jp.sony.com>
Signed-off-by: Aaditya Kumar <aaditya.kumar@ap.sony.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 mm/vmscan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4649929..738db2b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2241,6 +2241,8 @@ static int kswapd(void *p)
 			balance_pgdat(pgdat, order);
 		}
 	}
+
+	current->reclaim_state = NULL;
 	return 0;
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



