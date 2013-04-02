Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762154Ab3DBWVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:21:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933794Ab3DBWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 52/68] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
Date: Tue,  2 Apr 2013 15:13:41 -0700
Message-Id: <20130402221335.997754400@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: dingtianhong <dingtianhong@huawei.com>

[ Upstream commit 14134f6584212d585b310ce95428014b653dfaf6 ]

SCM_SCREDENTIALS should apply to write() syscalls only either source or destination
socket asserted SOCK_PASSCRED. The original implememtation in maybe_add_creds is wrong,
and breaks several LSB testcases ( i.e. /tset/LSB.os/netowkr/recvfrom/T.recvfrom).

Origionally-authored-by: Karel Srot <ksrot@redhat.com>
Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/unix/af_unix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1414,8 +1414,8 @@ static void maybe_add_creds(struct sk_bu
 	if (UNIXCB(skb).cred)
 		return;
 	if (test_bit(SOCK_PASSCRED, &sock->flags) ||
-	    !other->sk_socket ||
-	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags)) {
+	    (other->sk_socket &&
+	    test_bit(SOCK_PASSCRED, &other->sk_socket->flags))) {
 		UNIXCB(skb).pid  = get_pid(task_tgid(current));
 		UNIXCB(skb).cred = get_current_cred();
 	}


