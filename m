Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab3BACo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 21:44:57 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3BACoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 21:44:55 -0500
Date: Thu, 31 Jan 2013 18:44:46 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH] PVH linux: Use ballooning to allocate grant
 table pages
Message-ID: <20130131184446.654a2289@mantra.us.oracle.com>
In-Reply-To: <20130131183015.13bc2bff@mantra.us.oracle.com>
References: <20130131183015.13bc2bff@mantra.us.oracle.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2013 18:30:15 -0800
Mukesh Rathor <mukesh.rathor@oracle.com> wrote:

> This patch fixes a fixme in Linux to use alloc_xenballooned_pages() to
> allocate pfns for grant table pages instead of kmalloc. This also
> simplifies add to physmap on the xen side a bit.

Looking at it again, I realized rc should be signed in gnttab_resume().
Below again. Thanks.

Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>

diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
index 9c0019d..7a630bb 100644
--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -47,6 +47,7 @@
 #include <xen/grant_table.h>
 #include <xen/interface/memory.h>
 #include <xen/hvc-console.h>
+#include <xen/balloon.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/interface.h>
 
@@ -1138,27 +1139,42 @@ static void gnttab_request_version(void)
 		grant_table_version);
 }
 
+static int xlated_setup_gnttab_pages(int numpages, void **addr)
+{
+	int i, rc;
+	unsigned long pfns[numpages];
+	struct page *pages[numpages];
+
+	rc = alloc_xenballooned_pages(numpages, pages, 0);
+	if (rc != 0) {
+		pr_warn("%s Could not balloon alloc %d pfns rc:%d\n", __func__,
+			numpages, rc);
+		return -ENOMEM;
+	}
+	for (i = 0; i < numpages; i++)
+		pfns[i] = page_to_pfn(pages[i]);
+
+	rc = arch_gnttab_map_shared(pfns, numpages, numpages, addr);
+	return rc;
+}
+
 int gnttab_resume(void)
 {
+	int rc;
 	unsigned int max_nr_gframes;
-	char *kmsg = "Failed to kmalloc pages for pv in hvm grant frames\n";
 
 	gnttab_request_version();
 	max_nr_gframes = gnttab_max_grant_frames();
 	if (max_nr_gframes < nr_grant_frames)
 		return -ENOSYS;
 
-	/* PVH note: xen will free existing kmalloc'd mfn in
-	 * XENMEM_add_to_physmap. TBD/FIXME: use xen ballooning instead of
-	 * kmalloc(). */
 	if (xen_pv_domain() && xen_feature(XENFEAT_auto_translated_physmap) &&
 	    !gnttab_shared.addr) {
-		gnttab_shared.addr =
-			kmalloc(max_nr_gframes * PAGE_SIZE, GFP_KERNEL);
-		if (!gnttab_shared.addr) {
-			pr_warn("%s", kmsg);
-			return -ENOMEM;
-		}
+
+		rc = xlated_setup_gnttab_pages(max_nr_gframes,
+					       &gnttab_shared.addr);
+		if (rc != 0)
+			return rc;
 	}
 	if (xen_pv_domain())
 		return gnttab_map(0, nr_grant_frames - 1);



