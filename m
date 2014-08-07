Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaHGMw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:52:26 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:13031 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757245AbaHGMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:52:22 -0400
X-IronPort-AV: E=Sophos;i="5.01,818,1400018400"; 
   d="scan'208";a="88599295"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Eric Biederman <ebiederm@xmission.com>
Cc: kernel-janitors@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] kexec: fix error return code
Date: Thu,  7 Aug 2014 14:49:09 +0200
Message-Id: <1407415749-19978-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1407415749-19978-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Convert a zero return value on error to a negative one, as returned
elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 kernel/kexec.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 0b49a0a..dcd7a1f 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2212,8 +2212,10 @@ static int kexec_calculate_store_digests(struct kimage *image)
 
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions)
+	if (!sha_regions) {
+		ret = -ENOMEM;
 		goto out_free_desc;
+	}
 
 	desc->tfm   = tfm;
 	desc->flags = 0;

