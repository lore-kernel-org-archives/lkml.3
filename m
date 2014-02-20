Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaBTVDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:03:00 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50095 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbaBTVC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:02:59 -0500
Message-ID: <1392930177.15264.5.camel@x220>
Subject: [PATCH] drm/radeon: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Dave Airlie <airlied@linux.ie>
Cc: Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Feb 2014 22:02:57 +0100
In-Reply-To: <1391085212.5170.9.camel@x41>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	 <1391085212.5170.9.camel@x41>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 21:02:58.0189 (UTC) FILETIME=[21EC43D0:01CF2E7F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building radeon_ttm.o on 32 bit x86 triggers a warning:
    In file included from include/asm-generic/bug.h:13:0,
                     from [...]/arch/x86/include/asm/bug.h:38,
                     from include/linux/bug.h:4,
                     from include/drm/drm_mm.h:39,
                     from include/drm/drm_vma_manager.h:26,
                     from include/drm/ttm/ttm_bo_api.h:35,
                     from drivers/gpu/drm/radeon/radeon_ttm.c:32:
    drivers/gpu/drm/radeon/radeon_ttm.c: In function 'radeon_ttm_gtt_read':
    include/linux/kernel.h:712:17: warning: comparison of distinct pointer types lacks a cast [enabled by default]
      (void) (&_min1 == &_min2);  \
                     ^
    drivers/gpu/drm/radeon/radeon_ttm.c:938:22: note: in expansion of macro 'min'
       ssize_t cur_size = min(size, PAGE_SIZE - off);
                          ^

Silence this warning by casting "PAGE_SIZE - off" to size_t. Since
"PAGE_SIZE - off" is between 0 and PAGE_SIZE, and PAGE_SIZE is at most
21 bits wide while size_t is at least 32 bits wide, this should be safe.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only (on 32 and 64 bit x86).

 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 77f5b0c..5c87979 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
 	while (size) {
 		loff_t p = *pos / PAGE_SIZE;
 		unsigned off = *pos & ~PAGE_MASK;
-		ssize_t cur_size = min(size, PAGE_SIZE - off);
+		ssize_t cur_size = min(size, (size_t)(PAGE_SIZE - off));
 		struct page *page;
 		void *ptr;
 
-- 
1.8.5.3

