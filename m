Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaGJTyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:54:45 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43098 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaGJTyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:54:43 -0400
Date: Thu, 10 Jul 2014 12:54:42 -0700 (PDT)
Message-Id: <20140710.125442.1730351591773172988.davem@davemloft.net>
To: jim.epost@gmail.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org
Subject: Re: randconfig build error with next-20140710, in
 net/ipv4/ipconfig.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+r1ZhhJxs_EL3UbtL8qAK4_JAqo3sJ3fF3KJ_3=NcRhnJiYjg@mail.gmail.com>
References: <CA+r1ZhhJxs_EL3UbtL8qAK4_JAqo3sJ3fF3KJ_3=NcRhnJiYjg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 10 Jul 2014 12:54:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6AJsrVE012389

From: Jim Davis <jim.epost@gmail.com>
Date: Thu, 10 Jul 2014 10:07:50 -0700

> Building with the attached random configuration file,
> 
> net/ipv4/ipconfig.c: In function ¡ic_dynamic¢:
> net/ipv4/ipconfig.c:1221:3: error: ¡ic_dev_xid¢ undeclared (first use
> in this function)
>    ic_dev_xid = d->xid;
>    ^
> net/ipv4/ipconfig.c:1221:3: note: each undeclared identifier is
> reported only once for each function it appears in
> make[2]: *** [net/ipv4/ipconfig.o] Error 1

Should be fixed by:

>From 405fd707196d596f59a510d176dedc979c1ae34b Mon Sep 17 00:00:00 2001
From: "David S. Miller" <davem@davemloft.net>
Date: Wed, 9 Jul 2014 22:25:18 -0700
Subject: [PATCH] ipconfig: Only bootp paths should reference ic_dev_xid.

It is only tested, and declared, in the bootp code.

So, in ic_dynamic() guard it's setting with IPCONFIG_BOOTP.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ipconfig.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index f02f594..5bbef4f 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -1217,10 +1217,10 @@ static int __init ic_dynamic(void)
 	get_random_bytes(&timeout, sizeof(timeout));
 	timeout = CONF_BASE_TIMEOUT + (timeout % (unsigned int) CONF_TIMEOUT_RANDOM);
 	for (;;) {
+#ifdef IPCONFIG_BOOTP
 		/* Track the device we are configuring */
 		ic_dev_xid = d->xid;
 
-#ifdef IPCONFIG_BOOTP
 		if (do_bootp && (d->able & IC_BOOTP))
 			ic_bootp_send_if(d, jiffies - start_jiffies);
 #endif
-- 
1.7.11.7

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
