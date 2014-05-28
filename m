Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaE1A0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:26:39 -0400
Received: from mail-yh0-f43.google.com ([209.85.213.43]:40048 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaE1A0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:26:36 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Cody P Schafer <dev@codyps.com>, Michael Ellerman <mpe@ellerman.id.au>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 02/16] powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack allocations
Date: Tue, 27 May 2014 17:21:57 -0700
Message-Id: <1401236684-10579-3-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian pointed out the use of __aligned(4096) caused rather large stack
consumption in single_24x7_request(), so use the kmem_cache
hv_page_cache (which we've already got set up for other allocations)
insead of allocating locally.

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Reported-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 arch/powerpc/perf/hv-24x7.c | 52 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 37 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index e0766b8..9a7a830 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -294,7 +294,7 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
 					 u16 lpar, u64 *res,
 					 bool success_expected)
 {
-	unsigned long ret;
+	unsigned long ret = -ENOMEM;
 
 	/*
 	 * request_buffer and result_buffer are not required to be 4k aligned,
@@ -304,7 +304,27 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
 	struct reqb {
 		struct hv_24x7_request_buffer buf;
 		struct hv_24x7_request req;
-	} __packed __aligned(4096) request_buffer = {
+	} __packed *request_buffer;
+	struct resb {
+		struct hv_24x7_data_result_buffer buf;
+		struct hv_24x7_result res;
+		struct hv_24x7_result_element elem;
+		__be64 result;
+	} __packed *result_buffer;
+
+	BUILD_BUG_ON(sizeof(*request_buffer) > 4096);
+	BUILD_BUG_ON(sizeof(*result_buffer) > 4096);
+
+	request_buffer = kmem_cache_alloc(hv_page_cache, GFP_USER);
+
+	if (!request_buffer)
+		goto out_reqb;
+
+	result_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
+	if (!result_buffer)
+		goto out_resb;
+
+	*request_buffer = (struct reqb) {
 		.buf = {
 			.interface_version = HV_24X7_IF_VERSION_CURRENT,
 			.num_requests = 1,
@@ -320,28 +340,30 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
 		}
 	};
 
-	struct resb {
-		struct hv_24x7_data_result_buffer buf;
-		struct hv_24x7_result res;
-		struct hv_24x7_result_element elem;
-		__be64 result;
-	} __packed __aligned(4096) result_buffer = {};
-
 	ret = plpar_hcall_norets(H_GET_24X7_DATA,
-			virt_to_phys(&request_buffer), sizeof(request_buffer),
-			virt_to_phys(&result_buffer),  sizeof(result_buffer));
+			virt_to_phys(request_buffer), sizeof(*request_buffer),
+			virt_to_phys(result_buffer),  sizeof(*result_buffer));
 
 	if (ret) {
 		if (success_expected)
 			pr_err_ratelimited("hcall failed: %d %#x %#x %d => 0x%lx (%ld) detail=0x%x failing ix=%x\n",
 					domain, offset, ix, lpar,
 					ret, ret,
-					result_buffer.buf.detailed_rc,
-					result_buffer.buf.failing_request_ix);
-		return ret;
+					result_buffer->buf.detailed_rc,
+					result_buffer->buf.failing_request_ix);
+		goto out_hcall;
 	}
 
-	*res = be64_to_cpu(result_buffer.result);
+	*res = be64_to_cpu(result_buffer->result);
+	kfree(result_buffer);
+	kfree(request_buffer);
+	return ret;
+
+out_hcall:
+	kfree(result_buffer);
+out_resb:
+	kfree(request_buffer);
+out_reqb:
 	return ret;
 }
 
-- 
1.9.3

