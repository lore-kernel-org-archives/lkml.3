Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab3FRQSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:18:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933220Ab3FRQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:04 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 35/48] libceph: fix authorizer invalidation
Date: Tue, 18 Jun 2013 09:18:01 -0700
Message-Id: <20130618161730.999702312@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 4b8e8b5d78b8322351d44487c1b76f7e9d3412bc upstream.

We were invalidating the authorizer by removing the ticket handler
entirely.  This was effective in inducing us to request a new authorizer,
but in the meantime it mean that any authorizer we generated would get a
new and initialized handler with secret_id=0, which would always be
rejected by the server side with a confusing error message:

 auth: could not find secret_id=0
 cephx: verify_authorizer could not get service secret for service osd secret_id=0

Instead, simply clear the validity field.  This will still induce the auth
code to request a new secret, but will let us continue to use the old
ticket in the meantime.  The messenger code will probably continue to fail,
but the exponential backoff will kick in, and eventually the we will get a
new (hopefully more valid) ticket from the mon and be able to continue.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ceph/auth_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -630,7 +630,7 @@ static void ceph_x_invalidate_authorizer
 
 	th = get_ticket_handler(ac, peer_type);
 	if (!IS_ERR(th))
-		remove_ticket_handler(ac, th);
+		memset(&th->validity, 0, sizeof(th->validity));
 }
 
 


