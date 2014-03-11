Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaCKGR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:17:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:1739 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbaCKGR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:17:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,629,1389772800"; 
   d="scan'208";a="497472069"
Date: Tue, 11 Mar 2014 14:17:43 +0800
From: Liu ShuoX <shuox.liu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, yanmin_zhang@linux.intel.com
Subject: [PATCH 2/2] pstore: correct the max_dump_cnt clearing of ramoops
Message-ID: <20140311061742.GB11552@lskakaxi-intel>
References: <20140311061519.GA11552@lskakaxi-intel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20140311061519.GA11552@lskakaxi-intel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu ShuoX <shuox.liu@intel.com>

In case that ramoops_init_przs failed, max_dump_cnt won't be reset to
zero in error handle path.

Signed-off-by: Liu ShuoX <shuox.liu@intel.com>
---
  fs/pstore/ram.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 6f96d8c..522e530 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -326,6 +326,7 @@ static void ramoops_free_przs(struct ramoops_context *cxt)
  	for (i = 0; !IS_ERR_OR_NULL(cxt->przs[i]); i++)
  		persistent_ram_free(cxt->przs[i]);
  	kfree(cxt->przs);
+	cxt->max_dump_cnt = 0;
  }
  
  static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
@@ -350,7 +351,7 @@ static int ramoops_init_przs(struct device *dev, struct ramoops_context *cxt,
  			     GFP_KERNEL);
  	if (!cxt->przs) {
  		dev_err(dev, "failed to initialize a prz array for dumps\n");
-		return -ENOMEM;
+		goto fail_prz;
  	}
  
  	for (i = 0; i < cxt->max_dump_cnt; i++) {
@@ -508,7 +509,6 @@ fail_buf:
  	kfree(cxt->pstore.buf);
  fail_clear:
  	cxt->pstore.bufsize = 0;
-	cxt->max_dump_cnt = 0;
  fail_cnt:
  	kfree(cxt->fprz);
  fail_init_fprz:
-- 
1.8.3.2

