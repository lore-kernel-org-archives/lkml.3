Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaJAGDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:03:55 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44870 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaJAGDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:03:52 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/5] powerpc/perf/hv-24x7: use kmem_cache instead of aligned stack allocations
Date: Tue, 30 Sep 2014 23:03:17 -0700
Message-Id: <1412143402-26061-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1412143402-26061-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100106-5806-0000-0000-000000A2977F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <dev@codyps.com>

Ian pointed out the use of __aligned(4096) caused rather large stack
consumption in single_24x7_request(), so use the kmem_cache
hv_page_cache (which we've already got set up for other allocations)
insead of allocating locally.

CC: Haren Myneni <hbabu@us.ibm.com>
Reported-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
Changelog [v3]:
	[Michael Ellerman] Cleanup code and use kmem..zalloc()

 arch/powerpc/perf/hv-24x7.c | 55 ++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 70d4f74..697759d 100644
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
+
+	struct {
+		struct hv_24x7_data_result_buffer buf;
+		struct hv_24x7_result res;
+		struct hv_24x7_result_element elem;
+		__be64 result;
+	} __packed *result_buffer;
+
+	BUILD_BUG_ON(sizeof(*request_buffer) > 4096);
+	BUILD_BUG_ON(sizeof(*result_buffer) > 4096);
+
+	request_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
+	if (!request_buffer)
+		goto out;
+
+	result_buffer = kmem_cache_zalloc(hv_page_cache, GFP_USER);
+	if (!result_buffer)
+		goto out_free_request_buffer;
+
+	*request_buffer = (struct reqb) {
 		.buf = {
 			.interface_version = HV_24X7_IF_VERSION_CURRENT,
 			.num_requests = 1,
@@ -320,28 +340,27 @@ static unsigned long single_24x7_request(u8 domain, u32 offset, u16 ix,
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
-			pr_err_ratelimited("hcall failed: %d %#x %#x %d => 0x%lx (%ld) detail=0x%x failing ix=%x\n",
-					domain, offset, ix, lpar,
-					ret, ret,
-					result_buffer.buf.detailed_rc,
-					result_buffer.buf.failing_request_ix);
-		return ret;
+			pr_err_ratelimited("hcall failed: %d %#x %#x %d => "
+				"0x%lx (%ld) detail=0x%x failing ix=%x\n",
+				domain, offset, ix, lpar, ret, ret,
+				result_buffer->buf.detailed_rc,
+				result_buffer->buf.failing_request_ix);
+		goto out_free_result_buffer;
 	}
 
-	*res = be64_to_cpu(result_buffer.result);
+	*res = be64_to_cpu(result_buffer->result);
+
+out_free_result_buffer:
+	kfree(result_buffer);
+out_free_request_buffer:
+	kfree(request_buffer);
+out:
 	return ret;
 }
 
-- 
1.8.3.1

