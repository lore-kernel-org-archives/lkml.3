Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbaD2TUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 15:20:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaD2TT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 15:19:59 -0400
Date: Tue, 29 Apr 2014 15:19:10 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, sandeen@redhat.com, akpm@linux-foundation.org,
        jweiner@redhat.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz,
        fengguang.wu@intel.com, mpatlasov@parallels.com
Subject: [PATCH] mm,writeback: fix divide by zero in pos_ratio_polynom
Message-ID: <20140429151910.53f740ef@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for "limit - setpoint + 1" to equal zero, leading to a
divide by zero error. Blindly adding 1 to "limit - setpoint" is not
working, so we need to actually test the divisor before calling div64.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: stable@vger.kernel.org
---
 mm/page-writeback.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index ef41349..2682516 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -597,11 +597,16 @@ static inline long long pos_ratio_polynom(unsigned long setpoint,
 					  unsigned long dirty,
 					  unsigned long limit)
 {
+	unsigned int divisor;
 	long long pos_ratio;
 	long x;
 
+	divisor = limit - setpoint;
+	if (!divisor)
+		divisor = 1;
+
 	x = div_s64(((s64)setpoint - (s64)dirty) << RATELIMIT_CALC_SHIFT,
-		    limit - setpoint + 1);
+		    divisor);
 	pos_ratio = x;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
 	pos_ratio = pos_ratio * x >> RATELIMIT_CALC_SHIFT;
