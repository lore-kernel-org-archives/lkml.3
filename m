Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab3HJXz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 19:55:29 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:49072 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3HJXz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 19:55:28 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 10 Aug 2013 16:55:19 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH] turbostat: Don't attempt to printf an off_t with %zx
Message-ID: <20130810235518.GA9342@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

turbostat uses the format %zx to print an off_t.  However, %zx wants a
size_t, not an off_t.  On 32-bit targets, those refer to different
types, potentially even with different sizes.  Use %llx and a cast
instead, since printf does not have a length modifier for off_t.

Without this patch, when compiling for a 32-bit target:

turbostat.c: In function 'get_msr':
turbostat.c:231:3: warning: format '%zx' expects argument of type 'size_t', but argument 4 has type 'off_t' [-Wformat]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 5bf4a67..b10b8d2 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -230,7 +230,7 @@ int get_msr(int cpu, off_t offset, unsigned long long *msr)
 	close(fd);
 
 	if (retval != sizeof *msr) {
-		fprintf(stderr, "%s offset 0x%zx read failed\n", pathname, offset);
+		fprintf(stderr, "%s offset 0x%llx read failed\n", pathname, (unsigned long long)offset);
 		return -1;
 	}
 
-- 
1.8.4.rc1

