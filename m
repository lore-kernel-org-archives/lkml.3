Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab3BZX7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:59:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442Ab3BZX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:59:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wangyuan Zhang <Wangyuan.Zhang@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 23/53] NLM: Ensure that we resend all pending blocking locks after a reclaim
Date: Tue, 26 Feb 2013 15:57:52 -0800
Message-Id: <20130226235622.231791477@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 666b3d803a511fbc9bc5e5ea8ce66010cf03ea13 upstream.

Currently, nlmclnt_lock will break out of the for(;;) loop when
the reclaimer wakes up the blocking lock thread by setting
nlm_lck_denied_grace_period. This causes the lock request to fail
with an ENOLCK error.
The intention was always to ensure that we resend the lock request
after the grace period has expired.

Reported-by: Wangyuan Zhang <Wangyuan.Zhang@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -550,6 +550,9 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
+		/* Resend the blocking lock request after a server reboot */
+		if (resp->status ==  nlm_lck_denied_grace_period)
+			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}


