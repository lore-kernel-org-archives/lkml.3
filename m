Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3KHAFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:05:24 -0500
Received: from dmz-mailsec-scanner-1.mit.edu ([18.9.25.12]:42622 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116Ab3KHAEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:04:25 -0500
X-AuditID: 1209190c-b7f058e000005fd9-ef-527c295bb891
Date: Thu, 7 Nov 2013 18:59:21 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 08/11] random: simplify accounting logic
Message-ID: <20131107235920.GK16018@ringworld.MIT.EDU>
References: <cover.1383868558.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1383868558.git.price@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsUixG6nrhutWRNksGWPgsXuOYtZLC7vmsPm
	wORxZsERdo/Pm+QCmKK4bFJSczLLUov07RK4Mu6fu85ecIerovXVatYGxgscXYycHBICJhKn
	dy5ghbDFJC7cW8/WxcjFISQwm0li+t7prBDOBkaJ3o6XzBDOT0aJiUePsXQxcnCwCKhIXHtl
	DNLNJqAg8WP+OmYQW0RAWWLVzE1MIDazgL3E76mT2UFsYQELiRld78HivAJmEtv2t7CA2EIC
	BhI/p79lgYgLSpyc+YQFoldL4sa/l0wgq5gFpCWW/wM7mlPAUKK9+QrY0aJAF0w5uY1tAqPg
	LCTds5B0z0LoXsDIvIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXUC83s0QvNaV0EyModDkleXYw
	vjmodIhRgINRiYe34EJ1kBBrYllxZe4hRkkOJiVR3onqNUFCfEn5KZUZicUZ8UWlOanFhxgl
	OJiVRHifKQLleFMSK6tSi/JhUtIcLErivDc57IOEBNITS1KzU1MLUotgsjIcHEoSvDM1gBoF
	i1LTUyvSMnNKENJMHJwgw3mAhj8BWcxbXJCYW5yZDpE/xagoJc5rBNIsAJLIKM2D64WllleM
	4kCvCPO+AGnnAaYluO5XQIOZgAaH/KoEGVySiJCSamBc5zc96ZjcBubJf0Szjmg6FijyBJ6O
	k37WeGv1l/Z5Z2YlXL1hIPAifx+jd8IFia7jDMfCLybqPnXp9w3bfzjxRGyXdcx2syV8ZlMV
	YvwWfWaudPdQZ26VPCEhxxmoy1bOI/LFtfTe6fB9TDeF++0aNyzqqpZZuyDt4+y2mCkbDlsu
	XvnmiasSS3FGoqEWc1FxIgAvwR5/CAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This logic is exactly equivalent to the old logic, but it should
be easier to see what it's doing.

The equivalence depends on one fact from outside this function:
when 'r->limit' is false, 'reserved' is zero.  (Well, two facts;
the other is that 'reserved' is never negative.)

Which is a good thing, too, because the "entropy_count = reserved"
line would have had a bug otherwise -- 'reserved' counts bytes and
'entropy_count' counts bits.  Fortunately that line could only be
reached if 'r->limit' was false, and zero bytes is zero bits.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Price <price@mit.edu>
---
 drivers/char/random.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 8824e8d..9e4645e 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -860,12 +860,7 @@ retry:
 		/* If limited, never pull more than available */
 		if (r->limit)
 			nbytes = min_t(size_t, nbytes, entropy_count/8 - reserved);
-
-		if (entropy_count / 8 >= nbytes + reserved) {
-			entropy_count -= nbytes*8;
-		} else {
-			entropy_count = reserved;
-		}
+		entropy_count = max_t(int, entropy_count - nbytes*8, 0);
 		if (cmpxchg(&r->entropy_count, orig, entropy_count) != orig)
 			goto retry;
 
-- 
1.8.3.2

