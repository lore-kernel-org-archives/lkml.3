Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaGZT4z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:56:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbaGZTKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Westphal <fwestpha@redhat.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 34/87] net: sctp: check proc_dointvec result in proc_sctp_do_auth
Date: Sat, 26 Jul 2014 12:02:08 -0700
Message-Id: <20140726190215.628164483@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 24599e61b7552673dd85971cf5a35369cd8c119e ]

When writing to the sysctl field net.sctp.auth_enable, it can well
be that the user buffer we handed over to proc_dointvec() via
proc_sctp_do_auth() handler contains something other than integers.

In that case, we would set an uninitialized 4-byte value from the
stack to net->sctp.auth_enable that can be leaked back when reading
the sysctl variable, and it can unintentionally turn auth_enable
on/off based on the stack content since auth_enable is interpreted
as a boolean.

Fix it up by making sure proc_dointvec() returned sucessfully.

Fixes: b14878ccb7fa ("net: sctp: cache auth_enable per endpoint")
Reported-by: Florian Westphal <fwestpha@redhat.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -423,8 +423,7 @@ static int proc_sctp_do_auth(struct ctl_
 		tbl.data = &net->sctp.auth_enable;
 
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
-
-	if (write) {
+	if (write && ret == 0) {
 		struct sock *sk = net->sctp.ctl_sock;
 
 		net->sctp.auth_enable = new_value;


