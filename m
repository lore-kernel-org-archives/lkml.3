Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3KHAET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:04:19 -0500
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:46401 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116Ab3KHAEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:04 -0500
X-AuditID: 12074423-b7fac8e00000539e-00-527c2946bd2d
Date: Thu, 7 Nov 2013 18:58:59 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 07/11] random: simplify accounting code slightly
Message-ID: <20131107235859.GJ16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixCmqrOumWRNksPaDusXuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Ms5c/8le0MZdcXLSd/YGxnccXYycHBICJhK/
	325ng7DFJC7cWw9kc3EICcxmkjjScI0FwtnAKHHg0zYo5yejxL6LV1lBWlgEVCSmPZwG1s4m
	oCDxY/46ZhBbREBZYtXMTUwgNrOAvcTvqZPZQWxhAQeJKwdmAg3i4OAVMJO40RsIEhYSMJD4
	Of0tC4jNKyAocXLmExaIVi2JG/9eMoGUMwtISyz/B3Y0p4ChRHvzFbALRIEumHJyG9sERsFZ
	SLpnIemehdC9gJF5FaNsSm6Vbm5iZk5xarJucXJiXl5qka6ZXm5miV5qSukmRlDosrso72D8
	c1DpEKMAB6MSD++JS9VBQqyJZcWVuYcYJTmYlER5J6rXBAnxJeWnVGYkFmfEF5XmpBYfYpTg
	YFYS4X2mCJTjTUmsrEotyodJSXOwKInz3uKwDxISSE8sSc1OTS1ILYLJynBwKEnwfgAZKliU
	mp5akZaZU4KQZuLgBBnOAzT8CUgNb3FBYm5xZjpE/hSjopQ47xyQhABIIqM0D64XllpeMYoD
	vSLM+wKkigeYluC6XwENZgIaHPKrEmRwSSJCSqqBUZPvj7z5jSj5B7rL67QndTjNZV4Tln52
	VpTRodNHJwgvf/+A+5jODE+ZJEtNjcqYVbb//nb2XAnrKAiwrk7/McH1Rep/H0Nzv5bm/PJ9
	D0K/irrtlSxysxD8p3d64mr+91cW720K4lxmLy8ly3W95fyE5X2r9cLsrNdIHbmk9Or+fJk5
	v5JMlViKMxINtZiLihMB0ePwdQgDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit makes the very boring simplifications so that the next
commit, which is a little trickier, is isolated and easy to review.
No change in behavior here at all.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8ec4a9a..8824e8d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -858,18 +858,16 @@ static size_t account(struct entropy_store *r, size_t nbytes, int min,
 retry:
 		entropy_count = orig = ACCESS_ONCE(r->entropy_count);
 		/* If limited, never pull more than available */
-		if (r->limit && nbytes + reserved >= entropy_count / 8)
-			nbytes = entropy_count/8 - reserved;
+		if (r->limit)
+			nbytes = min_t(size_t, nbytes, entropy_count/8 - reserved);
 
 		if (entropy_count / 8 >= nbytes + reserved) {
 			entropy_count -= nbytes*8;
-			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-				goto retry;
 		} else {
 			entropy_count = reserved;
-			if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
-				goto retry;
 		}
+		if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
+			goto retry;
 
 		if (entropy_count < random_write_wakeup_thresh)
 			wakeup_write = 1;
-- 
1.8.3.2

