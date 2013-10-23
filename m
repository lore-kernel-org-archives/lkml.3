Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab3JWT7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:59:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49786 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab3JWT7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:59:05 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: Christoph Paasch <christoph.paasch@uclouvain.be>, fengguang.wu@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1382533364.7572.15.camel@edumazet-glaptop.roam.corp.google.com>
	(Eric Dumazet's message of "Wed, 23 Oct 2013 06:02:44 -0700")
References: <20131022214129.GB2715@localhost>
	<20131022.180023.1141845387743361648.davem@davemloft.net>
	<87k3h461ql.fsf@tw-ebiederman.twitter.com>
	<20131023122543.GH5132@cpaasch-mac>
	<1382533364.7572.15.camel@edumazet-glaptop.roam.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Wed, 23 Oct 2013 12:58:52 -0700
Message-ID: <87ppqviwsj.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+A9XqPrEzkhH/laFLErhGwJr2L+fj/0Dc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0046]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
Subject: [PATCH] Fix: Dereference pointer-value of sk_prot->memory_pressure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Paasch <christoph.paasch@uclouvain.be>
Date: Wed, 23 Oct 2013 12:49:21 -0700

2e685cad57 (tcp_memcontrol: Kill struct tcp_memcontrol) falsly modified
the access to memory_pressure of sk->sk_prot->memory_pressure. The patch
did modify the memory_pressure-field of struct cg_proto, but not the one
of struct proto.

So, the access to sk_prot->memory_pressure should not be changed.

Acked-by: Eric Dumazet <edumazet@google.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Christoph Paasch <christoph.paasch@uclouvain.be>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---

Resent because I fat fingered and deleted Dave by accident.

 include/net/sock.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c93542f92420..e3a18ff0c38b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1137,7 +1137,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	if (mem_cgroup_sockets_enabled && sk->sk_cgrp)
 		return !!sk->sk_cgrp->memory_pressure;
 
-	return !!sk->sk_prot->memory_pressure;
+	return !!*sk->sk_prot->memory_pressure;
 }
 
 static inline void sk_leave_memory_pressure(struct sock *sk)
-- 
1.7.5.4

