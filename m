Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705AbaJ3JKa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 05:10:30 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58258 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaJ3JKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 05:10:25 -0400
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v2] ipv4: Do not cache routing failures due to disabled forwarding.
Date: Thu, 30 Oct 2014 10:09:53 +0100
Message-Id: <1414660193-4177-1-git-send-email-nicolas.cavallari@green-communications.fr>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <20141029.150328.530876391340346443.davem@davemloft.net>
References: <20141029.150328.530876391340346443.davem@davemloft.net>
X-Provags-ID: V02:K0:QFCeTREVYENky/+VlH0vx1dxkEQy0OgjljqJS1pKUGO
 kaHCKY3KoW8Mx3KI5c+by6KAkZ1OmGMfslmfS6iRrgpYhntWOZ
 HcqVoyUo1PgEnl+s4qOyeJ3OIMoXVVrnIqT3L+DhEx3P+lVIR4
 Nmq+zqApfuBrBQPXdXn/GO2AgxAepnPAKRNpoNNjpdnye4vrhk
 ZBb1t1YMFn0dDLdYtnR7p+UYMS8hV+m59ZRsuZHR4dm28LHx0J
 FwPk7vpHLs3/UuFUmMs8iznqYNyfkuC0lwvPZTiyo7cuBI6eZz
 fJVCDjCD4OT6EN13xhH7MtXKM/TdfHtNWEYnAVASs3HSJUBh0u
 3WuQCGMK8vlsVU+pAdlISftwvTli79RCUs/QG7OJ0iIC1DELot
 znTlj+3wKBainSt4K7AFX1fdAeltdYce3bhPUmKPxqgKHwzjGV
 rkBvtMtfbQ8ZGPs2B1My32lMmC4gUEgW9xT7NQFpfFTzT+rKM2
 xiXSltn5/Jyw0UCF1Rf
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we cache them, the kernel will reuse them, independently of
whether forwarding is enabled or not.  Which means that if forwarding is
disabled on the input interface where the first routing request comes
from, then that unreachable result will be cached and reused for
other interfaces, even if forwarding is enabled on them.  The opposite
is also true.

This can be verified with two interfaces A and B and an output interface
C, where B has forwarding enabled, but not A and trying
ip route get $dst iif A from $src && ip route get $dst iif B from $src

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Reviewed-by: Julian Anastasov <ja@ssi.bg>
---
> Sorry Nicolas, this seems to have fallen on the floor.  Could you please
> resubmit your most uptodate version of this patch so I can apply it?

Here you are.

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2d4ae46..6a2155b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1798,6 +1798,7 @@ local_input:
 no_route:
 	RT_CACHE_STAT_INC(in_no_route);
 	res.type = RTN_UNREACHABLE;
+	res.fi = NULL;
 	goto local_input;
 
 	/*
-- 
2.1.1

