Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201Ab3BLEVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 23:21:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45802 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757768Ab3BLEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 23:21:49 -0500
Date: Mon, 11 Feb 2013 20:21:36 -0800
From: tip-bot for Mike Travis <travis@sgi.com>
Message-ID: <tip-0af6352045a3bf359a2d5f55965266d67d262b47@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        travis@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        travis@sgi.com, sivanich@sgi.com, rja@sgi.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20130211194508.893907185@gulag1.americas.sgi.com>
References: <20130211194508.893907185@gulag1.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, uv, uv3: Update Time Support for SGI UV3
Git-Commit-ID: 0af6352045a3bf359a2d5f55965266d67d262b47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 20:21:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0af6352045a3bf359a2d5f55965266d67d262b47
Gitweb:     http://git.kernel.org/tip/0af6352045a3bf359a2d5f55965266d67d262b47
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Mon, 11 Feb 2013 13:45:13 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Feb 2013 17:18:12 -0800

x86, uv, uv3: Update Time Support for SGI UV3

This patch updates time support for the SGI UV3 hub.  Since the UV2
and UV3 time support is identical, "is_uvx_hub" is used instead of
having both "is_uv2_hub" and "is_uv3_hub".

Signed-off-by: Mike Travis <travis@sgi.com>
Link: http://lkml.kernel.org/r/20130211194508.893907185@gulag1.americas.sgi.com
Acked-by: Russ Anderson <rja@sgi.com>
Reviewed-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/uv/uv_time.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/uv/uv_time.c b/arch/x86/platform/uv/uv_time.c
index 5032e0d..98718f6 100644
--- a/arch/x86/platform/uv/uv_time.c
+++ b/arch/x86/platform/uv/uv_time.c
@@ -15,7 +15,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  *
- *  Copyright (c) 2009 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2009-2013 Silicon Graphics, Inc.  All Rights Reserved.
  *  Copyright (c) Dimitri Sivanich
  */
 #include <linux/clockchips.h>
@@ -102,9 +102,10 @@ static int uv_intr_pending(int pnode)
 	if (is_uv1_hub())
 		return uv_read_global_mmr64(pnode, UVH_EVENT_OCCURRED0) &
 			UV1H_EVENT_OCCURRED0_RTC1_MASK;
-	else
-		return uv_read_global_mmr64(pnode, UV2H_EVENT_OCCURRED2) &
-			UV2H_EVENT_OCCURRED2_RTC_1_MASK;
+	else if (is_uvx_hub())
+		return uv_read_global_mmr64(pnode, UVXH_EVENT_OCCURRED2) &
+			UVXH_EVENT_OCCURRED2_RTC_1_MASK;
+	return 0;
 }
 
 /* Setup interrupt and return non-zero if early expiration occurred. */
@@ -122,8 +123,8 @@ static int uv_setup_intr(int cpu, u64 expires)
 		uv_write_global_mmr64(pnode, UVH_EVENT_OCCURRED0_ALIAS,
 				UV1H_EVENT_OCCURRED0_RTC1_MASK);
 	else
-		uv_write_global_mmr64(pnode, UV2H_EVENT_OCCURRED2_ALIAS,
-				UV2H_EVENT_OCCURRED2_RTC_1_MASK);
+		uv_write_global_mmr64(pnode, UVXH_EVENT_OCCURRED2_ALIAS,
+				UVXH_EVENT_OCCURRED2_RTC_1_MASK);
 
 	val = (X86_PLATFORM_IPI_VECTOR << UVH_RTC1_INT_CONFIG_VECTOR_SHFT) |
 		((u64)apicid << UVH_RTC1_INT_CONFIG_APIC_ID_SHFT);
