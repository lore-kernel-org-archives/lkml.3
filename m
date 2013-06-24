Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3FXLew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 07:34:52 -0400
Received: from mail.us.es ([193.147.175.20]:59700 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab3FXLev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 07:34:51 -0400
X-Qmail-Scanner-Diagnostics: from 127.0.0.1 by antivirus2 (envelope-from <pneira@us.es>, uid 501) with qmail-scanner-2.10 
 (clamdscan: 0.97.8/17405. spamassassin: 3.3.2.  
 Clear:RC:1(127.0.0.1):SA:0(-97.8/7.5):. 
 Processed in 1.829385 secs); 24 Jun 2013 11:34:49 -0000
X-Envelope-From: pneira@us.es
Date: Mon, 24 Jun 2013 13:34:41 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: George Spelvin <linux@horizon.com>, bp@alien8.de, kaber@trash.net,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: v3.10-rc7 oops soon after boot
Message-ID: <20130624113441.GA2583@localhost>
References: <20130624094145.2576.qmail@science.horizon.com>
 <51C816C8.4080709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <51C816C8.4080709@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 05:52:08PM +0800, Gao feng wrote:
> On 06/24/2013 05:41 PM, George Spelvin wrote:
> >> Please try the patch below,
> >> I think this bug is introduced by me :(
> >>
> >> Thanks!
> > 
> > Well, you changed it, but it still crashes.
> > 
> > It's now at del_timer+0x9/0x58, with the code being:
> 
> This one should work.
> 
> Thanks for your quickly reply.

I managed to crash it using a group != 1 (default) and enabling
batching:

iptables -I INPUT -j ULOG --ulog-nlgroup 2 --ulog-qthresh 50

It seems ulog->nlgroup[i] is always left unset.

I have mangled your patch, find it attached.

--mP3DRpeJDSE+ciuQ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-ipt_ULOG-fix-incorrect-setting-of-ulog-tim.patch"

>From 79da8ea854c06ca9320decbb2f9d2e8d25b2f7e5 Mon Sep 17 00:00:00 2001
From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Mon, 24 Jun 2013 17:04:02 +0800
Subject: [PATCH] netfilter: ipt_ULOG: fix incorrect setting of ulog timer

The parameter of setup_timer should be &ulog->nlgroup[i].
the incorrect parameter will cause kernel panic in
ulog_timer.

Bug introducted in commit 355430671ad93546b34b4e91bdf720f3a704efa4
"netfilter: ipt_ULOG: add net namespace support for ipt_ULOG"

ebt_ULOG doesn't have this problem.

Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/ipt_ULOG.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index ff4b781..32b0e97 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -125,15 +125,16 @@ static void ulog_send(struct ulog_net *ulog, unsigned int nlgroupnum)
 /* timer function to flush queue in flushtimeout time */
 static void ulog_timer(unsigned long data)
 {
+	unsigned int groupnum = *((unsigned int *)data);
 	struct ulog_net *ulog = container_of((void *)data,
 					     struct ulog_net,
-					     nlgroup[*(unsigned int *)data]);
+					     nlgroup[groupnum]);
 	pr_debug("timer function called, calling ulog_send\n");
 
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
 	spin_lock_bh(&ulog->lock);
-	ulog_send(ulog, data);
+	ulog_send(ulog, groupnum);
 	spin_unlock_bh(&ulog->lock);
 }
 
@@ -407,8 +408,11 @@ static int __net_init ulog_tg_net_init(struct net *net)
 
 	spin_lock_init(&ulog->lock);
 	/* initialize ulog_buffers */
-	for (i = 0; i < ULOG_MAXNLGROUPS; i++)
-		setup_timer(&ulog->ulog_buffers[i].timer, ulog_timer, i);
+	for (i = 0; i < ULOG_MAXNLGROUPS; i++) {
+		ulog->nlgroup[i] = i;
+		setup_timer(&ulog->ulog_buffers[i].timer, ulog_timer,
+			    (unsigned long)&ulog->nlgroup[i]);
+	}
 
 	ulog->nflognl = netlink_kernel_create(net, NETLINK_NFLOG, &cfg);
 	if (!ulog->nflognl)
-- 
1.7.10.4


--mP3DRpeJDSE+ciuQ--
