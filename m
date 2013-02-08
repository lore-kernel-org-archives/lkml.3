Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3BHBos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:44:48 -0500
Received: from plane.gmane.org ([80.91.229.3]:39300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab3BHBoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 20:44:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: net: rcu warnings in ip6fl_get_first
Date: Fri, 8 Feb 2013 01:38:29 +0000 (UTC)
Message-ID: <kf1kul$699$2@ger.gmane.org>
References: <51140154.9040901@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 14.205.20.175
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2013 at 19:32 GMT, Sasha Levin <sasha.levin@oracle.com> wrote:
> Hi guys,
>
> I got the following while fuzzing with trinity inside a KVM tools guest:
>
> [   51.680236] ===============================
> [   51.681914] [ INFO: suspicious RCU usage. ]
> [   51.683610] 3.8.0-rc6-next-20130206-sasha-00028-g83214f7-dirty #276 Tainted: G        W
> [   51.686703] -------------------------------
> [   51.688281] net/ipv6/ip6_flowlabel.c:671 suspicious rcu_dereference_check() usage!
> [   51.691345]

It should use rcu_dereference_bh()...

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index ea42bf4..c50080f 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -65,13 +65,13 @@ static DEFINE_SPINLOCK(ip6_fl_lock);
 static DEFINE_SPINLOCK(ip6_sk_fl_lock);
 
 #define for_each_fl_rcu(hash, fl)				\
-	for (fl = rcu_dereference(fl_ht[(hash)]);		\
+	for (fl = rcu_dereference_bh(fl_ht[(hash)]);		\
 	     fl != NULL;					\
-	     fl = rcu_dereference(fl->next))
+	     fl = rcu_dereference_hb(fl->next))
 #define for_each_fl_continue_rcu(fl)				\
-	for (fl = rcu_dereference(fl->next);			\
+	for (fl = rcu_dereference_bh(fl->next);			\
 	     fl != NULL;					\
-	     fl = rcu_dereference(fl->next))
+	     fl = rcu_dereference_bh(fl->next))
 
 #define for_each_sk_fl_rcu(np, sfl)				\
 	for (sfl = rcu_dereference_bh(np->ipv6_fl_list);	\

