Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbbA1Ucv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:32:51 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:60938 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389AbbA1Ucs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:32:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] Smack: fix netfilter Makefile entry
Date: Wed, 28 Jan 2015 17:12 +0100
Message-ID: <2504358.ZeqdfUXKpJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:J7nQYd0ssT5hP+I1BfgT3grF1Bhz/DZLk2Hs0PQCxg7TUzM/sjt
 rC6cmdUC5u84LoyBymkaccisIvlnlTKPtSxAY7j9tuXLdPjuX/1vhENYZOn+B+bAipCRKAq
 jiAUeGSducl9Y/kQMlGNPPBQW0x1L2coKtb1tZCTVy87KrK5B0vgRph/MxkoVDBHh7jLD2o
 v/nrs2Fv2LzFEPhM/akyw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added Smack support for netfilter secmark has its own
Kconfig symbol, but the actual implementation is conditionally
built on another symbol.

It is possible for CONFIG_NETFILTER and SECURITY_SMACK to both
be enabled, but NETWORK_SECMARK to be disabled, in which case
we get a build error:

../security/smack/smack_netfilter.c: In function 'smack_ipv6_output':
../security/smack/smack_netfilter.c:36:6: error: 'struct sk_buff' has no member named 'secmark'
   skb->secmark = skp->smk_secid;
      ^
../security/smack/smack_netfilter.c: In function 'smack_ipv4_output':
../security/smack/smack_netfilter.c:55:6: error: 'struct sk_buff' has no member named 'secmark'
   skb->secmark = skp->smk_secid;
      ^

This changes the Makefile to use the correct Kconfig symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 69f287ae6fc83 ("Smack: secmark support for netfilter")

diff --git a/security/smack/Makefile b/security/smack/Makefile
index 616cf93b368e..d4a376c84050 100644
--- a/security/smack/Makefile
+++ b/security/smack/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_SECURITY_SMACK) := smack.o
 
 smack-y := smack_lsm.o smack_access.o smackfs.o
-smack-$(CONFIG_NETFILTER) += smack_netfilter.o
+smack-$(SECURITY_SMACK_NETFILTER) += smack_netfilter.o

