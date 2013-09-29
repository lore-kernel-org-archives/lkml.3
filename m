Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3I2Tdv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:33:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab3I2T3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simo Sorce <simo@redhat.com>, "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 68/71] rpc: let xdr layer allocate gssproxy receieve pages
Date: Sun, 29 Sep 2013 12:28:20 -0700
Message-Id: <20130929192648.171814779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit d4a516560fc96a9d486a9939bcb567e3fdce8f49 upstream.

In theory the linux cred in a gssproxy reply can include up to
NGROUPS_MAX data, 256K of data.  In the common case we expect it to be
shorter.  So do as the nfsv3 ACL code does and let the xdr code allocate
the pages as they come in, instead of allocating a lot of pages that
won't typically be used.

Tested-by: Simo Sorce <simo@redhat.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_upcall.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -223,18 +223,14 @@ static void gssp_free_receive_pages(stru
 
 static int gssp_alloc_receive_pages(struct gssx_arg_accept_sec_context *arg)
 {
-	int i;
-
 	arg->npages = DIV_ROUND_UP(NGROUPS_MAX * 4, PAGE_SIZE);
 	arg->pages = kzalloc(arg->npages * sizeof(struct page *), GFP_KERNEL);
-
-	for (i=0; i < arg->npages; i++) {
-		arg->pages[i] = alloc_page(GFP_KERNEL);
-		if (arg->pages[i] == NULL) {
-			gssp_free_receive_pages(arg);
-			return -ENOMEM;
-		}
-	}
+	/*
+	 * XXX: actual pages are allocated by xdr layer in
+	 * xdr_partial_copy_from_skb.
+	 */
+	if (!arg->pages)
+		return -ENOMEM;
 	return 0;
 }
 


