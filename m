Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaCDJe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:34:56 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:53862 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756410AbaCDJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:34:53 -0500
Message-ID: <1393925688.3038.22.camel@x220>
Subject: [PATCH v2] drm/radeon: silence GCC warning on 32 bit
From: Paul Bolle <pebolle@tiscali.nl>
To: Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Tue, 04 Mar 2014 10:34:48 +0100
In-Reply-To: <20140221082021.GG22574@ulmo.nvidia.com>
References: <alpine.DEB.2.00.1401300249130.13810@skynet.skynet.ie>
	 <1391085212.5170.9.camel@x41> <1392930177.15264.5.camel@x220>
	 <CAKb7Uvg=U+b0d2uBM3rrXzotdCM=VZsJ0ArPU82Nzy95S=WZRw@mail.gmail.com>
	 <1392931493.15264.17.camel@x220> <20140221082021.GG22574@ulmo.nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2014 09:34:50.0941 (UTC) FILETIME=[FDC32ED0:01CF378C]
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

Silence this warning by using min_t(). Since cur_size will never be
negative and its upper bound is PAGE_SIZE, we can change its type to
size_t and use min_t(size_t, [...]) here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v2: use min_t() as Ilia suggested, and convert cur_size to size_t, as
Thierry suggested.

Still compile tested only (on 32 and 64 bit x86).

 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 77f5b0c..1ce6ba6 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -935,7 +935,7 @@ static ssize_t radeon_ttm_gtt_read(struct file *f, char __user *buf,
 	while (size) {
 		loff_t p = *pos / PAGE_SIZE;
 		unsigned off = *pos & ~PAGE_MASK;
-		ssize_t cur_size = min(size, PAGE_SIZE - off);
+		size_t cur_size = min_t(size_t, size, PAGE_SIZE - off);
 		struct page *page;
 		void *ptr;
 
-- 
1.8.5.3

