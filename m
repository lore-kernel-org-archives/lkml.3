Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaGDKYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 06:24:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:32032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631AbaGDKYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 06:24:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,600,1400050800"; 
   d="scan'208";a="557424563"
Message-ID: <53B68068.2060102@intel.com>
Date: Fri, 04 Jul 2014 18:22:32 +0800
From: "xinhui.pan" <xinhuix.pan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, agk@redhat.com, snitzer@redhat.com,
        dm-devel@redhat.com
CC: yanmin_zhang@linux.intel.com, "Liu, ShuoX" <shuox.liu@intel.com>
Subject: [PATCH] md/dm-ioctl.c: optimize memory allocation in copy_params
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KMALLOC_MAX_SIZE is too big, it easily cause memory fragmented and low memory when param_kernel->data_size
is also big. That's not nice. So use vmalloc instead of kmalloc when size is larger than (PAGE_SIZE << 2).
There are other drivers using kmalloc to gain a big size memory. And that cause our devices to hit hang and
many worse issues. We don't benefit much when using kmalloc in such scenario.

Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
Signed-off-by: yanmin.zhang <yanmin_zhang@linux.intel.com>
---
 drivers/md/dm-ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5152142..31c3af9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1709,7 +1709,7 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl *param_kern
         * Use kmalloc() rather than vmalloc() when we can.
         */
        dmi = NULL;
-       if (param_kernel->data_size <= KMALLOC_MAX_SIZE) {
+       if (param_kernel->data_size <= (PAGE_SIZE << 2)) {
                dmi = kmalloc(param_kernel->data_size, GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN);
                if (dmi)
                        *param_flags |= DM_PARAMS_KMALLOC;
-- 
1.7.9.5
