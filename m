Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab3HUAUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:20:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:56826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3HUAUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573802"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 2/8] turbostat: Don't attempt to printf an off_t with %zx
Date: Tue, 20 Aug 2013 17:20:13 -0700
Message-Id: <1377044419-15045-3-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
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
1.8.4.rc3

