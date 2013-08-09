Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967677Ab3HIB7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030196Ab3HIB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 053/102] svcrpc: fix gss-proxy xdr decoding oops
Date: Thu,  8 Aug 2013 18:57:29 -0700
Message-Id: <20130809015022.578978396@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit dc43376c26cef74226174a2394f37f2a3f8a8639 upstream.

Uninitialized stack data was being used as the destination for memcpy's.

Longer term we'll just delete some of this code; all we're doing is
skipping over xdr that we don't care about.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/gss_rpc_xdr.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/sunrpc/auth_gss/gss_rpc_xdr.c
+++ b/net/sunrpc/auth_gss/gss_rpc_xdr.c
@@ -430,7 +430,7 @@ static int dummy_enc_nameattr_array(stru
 static int dummy_dec_nameattr_array(struct xdr_stream *xdr,
 				    struct gssx_name_attr_array *naa)
 {
-	struct gssx_name_attr dummy;
+	struct gssx_name_attr dummy = { .attr = {.len = 0} };
 	u32 count, i;
 	__be32 *p;
 
@@ -493,12 +493,13 @@ static int gssx_enc_name(struct xdr_stre
 	return err;
 }
 
+
 static int gssx_dec_name(struct xdr_stream *xdr,
 			 struct gssx_name *name)
 {
-	struct xdr_netobj dummy_netobj;
-	struct gssx_name_attr_array dummy_name_attr_array;
-	struct gssx_option_array dummy_option_array;
+	struct xdr_netobj dummy_netobj = { .len = 0 };
+	struct gssx_name_attr_array dummy_name_attr_array = { .count = 0 };
+	struct gssx_option_array dummy_option_array = { .count = 0 };
 	int err;
 
 	/* name->display_name */


