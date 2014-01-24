Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaAXSbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:31:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaAXSbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:31:24 -0500
Date: Fri, 24 Jan 2014 13:31:14 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: konrad.wilk@oracle.com
Subject: Fix misplaced kfree from xlated_setup_gnttab_pages
Message-ID: <20140124183114.GA31844@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	konrad.wilk@oracle.com
References: <20140123064242.09E68660D05@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123064242.09E68660D05@gitolite.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing a freed 'pages' to free_xenballooned_pages will end badly
on kernels with slub debug enabled.

This looks out of place between the rc assign and the check, and
was likely a cut-and-paste error.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 103c93f874b2..28990cc97304 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -161,12 +161,11 @@ static int __init xlated_setup_gnttab_pages(void)
 
 	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
 				    &xen_auto_xlat_grant_frames.vaddr);
-
-	kfree(pages);
 	if (rc) {
 		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
 			nr_grant_frames, rc);
 		free_xenballooned_pages(nr_grant_frames, pages);
+		kfree(pages);
 		kfree(pfns);
 		return rc;
 	}
