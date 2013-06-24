Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081Ab3FXJud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 05:50:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31247 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3FXJuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 05:50:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,927,1363104000"; 
   d="scan'208,223";a="7660181"
Message-ID: <51C816C8.4080709@cn.fujitsu.com>
Date: Mon, 24 Jun 2013 17:52:08 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: bp@alien8.de, kaber@trash.net, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, pablo@netfilter.org
Subject: Re: v3.10-rc7 oops soon after boot
References: <20130624094145.2576.qmail@science.horizon.com>
In-Reply-To: <20130624094145.2576.qmail@science.horizon.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/24 17:49:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/24 17:49:18,
	Serialize complete at 2013/06/24 17:49:18
Content-Type: multipart/mixed;
 boundary="------------090500020500050904030007"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090500020500050904030007
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8

On 06/24/2013 05:41 PM, George Spelvin wrote:
>> Please try the patch below,
>> I think this bug is introduced by me :(
>>
>> Thanks!
> 
> Well, you changed it, but it still crashes.
> 
> It's now at del_timer+0x9/0x58, with the code being:

This one should work.

Thanks for your quickly reply.

> 
> 3f 00 55 53 48 89 fb 48 83 ec 10 <48> 83 3f 00 48 c7 47
> 
> The backtrace is
>  <IRQ>
>  ? ulog_send+0x21/0x76
>  ? ulog_timer+0x2d/0x39
>  ? ulog_send+0x76/0x76
>  ? call_timer_fn.isra
>  ? run_timer_softirq
>  ? __do_softirq
>  ? irq_exit
>  ? do_IRQ
>  ? common_interrupt
>  <EOI>
> 
> (To give a faster response, I just transcribed a few key
> sections.  Is that enough of a clue, or do you need more?)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


--------------090500020500050904030007
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0001-netfilter-ipt_ULOG-fix-incorrect-setting-of-ulog-tim.patch"
Content-Disposition: attachment;
 filename*0="0001-netfilter-ipt_ULOG-fix-incorrect-setting-of-ulog-tim.pa";
 filename*1="tch"

>From f22cb6a9a52497364605c25930ba470ee180ca58 Mon Sep 17 00:00:00 2001
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
---
 net/ipv4/netfilter/ipt_ULOG.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index ff4b781..1345c20 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -133,7 +133,7 @@ static void ulog_timer(unsigned long data)
 	/* lock to protect against somebody modifying our structure
 	 * from ipt_ulog_target at the same time */
 	spin_lock_bh(&ulog->lock);
-	ulog_send(ulog, data);
+	ulog_send(ulog, *(unsigned int *)data);
 	spin_unlock_bh(&ulog->lock);
 }
 
@@ -408,7 +408,8 @@ static int __net_init ulog_tg_net_init(struct net *net)
 	spin_lock_init(&ulog->lock);
 	/* initialize ulog_buffers */
 	for (i = 0; i < ULOG_MAXNLGROUPS; i++)
-		setup_timer(&ulog->ulog_buffers[i].timer, ulog_timer, i);
+		setup_timer(&ulog->ulog_buffers[i].timer, ulog_timer,
+			    (unsigned long)&ulog->nlgroup[i]);
 
 	ulog->nflognl = netlink_kernel_create(net, NETLINK_NFLOG, &cfg);
 	if (!ulog->nflognl)
-- 
1.8.1.4


--------------090500020500050904030007--
