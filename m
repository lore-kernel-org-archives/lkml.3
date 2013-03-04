Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3CDEAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:00:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32960 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660Ab3CDDoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:03 -0500
Message-Id: <20130304033715.075678690@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:23 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Wangyuan Zhang <Wangyuan.Zhang@netapp.com>
Subject: [ 076/153] NLM: Ensure that we resend all pending blocking locks after a
 reclaim
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/lockd/clntproc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/lockd/clntproc.c
+++ b/fs/lockd/clntproc.c
@@ -551,6 +551,9 @@ again:
 		status = nlmclnt_block(block, req, NLMCLNT_POLL_TIMEOUT);
 		if (status < 0)
 			break;
+		/* Resend the blocking lock request after a server reboot */
+		if (resp->status ==  nlm_lck_denied_grace_period)
+			continue;
 		if (resp->status != nlm_lck_blocked)
 			break;
 	}


