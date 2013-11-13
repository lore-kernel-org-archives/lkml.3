Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828Ab3KMIIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:08:39 -0500
Received: from dmz-mailsec-scanner-2.mit.edu ([18.9.25.13]:63252 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808Ab3KMII0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:08:26 -0500
X-AuditID: 1209190d-b7ef66d000000c40-dc-528333786ef3
Date: Wed, 13 Nov 2013 03:08:21 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 6/9] random: simplify accounting logic
Message-ID: <20131113080821.GT16018@ringworld.MIT.EDU>
References: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384329436.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsUixG6nolth3BxksPaatMW0jeIWu+csZrG4
	vGsOmwOzx5kFR9g9Pm+S8zjR8oU1gDmKyyYlNSezLLVI3y6BK+P5ls2sBau5Kp4d3M3YwDif
	o4uRk0NCwETizqWLzBC2mMSFe+vZuhi5OIQEZjNJHN09kRnC2cgocfxOAyOE84tRom/tMyaQ
	FhYBVYk/LZNZQGw2AQWJH/PXgY0SEVCWWDVzE1gNs0CWxPa7s1hBbGEBM4mjT/vYQGxeIHvb
	NghbSMBAYuP+CcwQcUGJkzOfsED0aknc+PcSaA4HkC0tsfwf2NWcAoYSkzYcBRspKqAiMeXk
	NrYJjIKzkHTPQtI9C6F7ASPzKkbZlNwq3dzEzJzi1GTd4uTEvLzUIl0jvdzMEr3UlNJNjKBw
	5pTk3cH47qDSIUYBDkYlHl6LmKYgIdbEsuLK3EOMkhxMSqK8TjrNQUJ8SfkplRmJxRnxRaU5
	qcWHGCU4mJVEeA8IA+V4UxIrq1KL8mFS0hwsSuK8Nznsg4QE0hNLUrNTUwtSi2CyMhwcShK8
	FkZAjYJFqempFWmZOSUIaSYOTpDhPEDDRUBqeIsLEnOLM9Mh8qcYFaXEeWNAEgIgiYzSPLhe
	WLp5xSgO9IowryhIFQ8wVcF1vwIazAQ02KK4CWRwSSJCSqqBUWbFs+J3ic1s5z5xLelZcfls
	ahHDo3Vhbm/b/Rt7DS+bvjCa8vnkbuPinRtltf58Ur/yV+oL+6/zpvNWb67eY+hcG24WFzxL
	w/v0zytL2Y8GdzGKejz8eYchf8pH6YenJh9cddr1x2Ofab5NB1sWyp62LPrhmPvi4Lpbm7hX
	XNWs0vM9urOg/6QSS3FGoqEWc1FxIgACCgwKEgMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This logic is exactly equivalent to the old logic, but it should
be easier to see what it's doing.

The equivalence depends on one fact from outside this function:
when 'r->limit' is false, 'reserved' is zero.  (Well, two facts;
the other is that 'reserved' is never negative.)

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index fe7ecdd..5dffca8 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -988,14 +988,10 @@ retry:
 		ibytes = 0;
 	} else {
 		/* If limited, never pull more than available */
-		if (r->limit && ibytes + reserved >= have_bytes)
-			ibytes = have_bytes - reserved;
-
-		if (have_bytes >= ibytes + reserved)
-			entropy_count -= ibytes << (ENTROPY_SHIFT + 3);
-		else
-			entropy_count = reserved << (ENTROPY_SHIFT + 3);
-
+		if (r->limit)
+			ibytes = min_t(size_t, ibytes, have_bytes - reserved);
+		entropy_count = max_t(int, 0,
+			    entropy_count - (ibytes << (ENTROPY_SHIFT + 3)));
 		if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 			goto retry;
 
-- 
1.8.3.2

