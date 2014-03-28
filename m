Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaC1RnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:43:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaC1RbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>
Subject: [PATCH 3.13 20/46] SUNRPC: Fix a pipe_version reference leak
Date: Fri, 28 Mar 2014 10:32:04 -0700
Message-Id: <20140328173137.402111439@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit e9776d0f4adee8877145672f6416b06b57f2dc27 upstream.

In gss_alloc_msg(), if the call to gss_encode_v1_msg() fails, we
want to release the reference to the pipe_version that was obtained
earlier in the function.

Fixes: 9d3a2260f0f4b (SUNRPC: Fix buffer overflow checking in...)
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/auth_gss/auth_gss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -500,10 +500,12 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 	default:
 		err = gss_encode_v1_msg(gss_msg, service_name, gss_auth->target_name);
 		if (err)
-			goto err_free_msg;
+			goto err_put_pipe_version;
 	};
 	kref_get(&gss_auth->kref);
 	return gss_msg;
+err_put_pipe_version:
+	put_pipe_version(gss_auth->net);
 err_free_msg:
 	kfree(gss_msg);
 err:


