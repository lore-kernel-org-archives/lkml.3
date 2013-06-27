Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab3F0Xo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:44:56 -0400
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:34182 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab3F0Xoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:44:55 -0400
From: Sven-Thorsten Dietrich <sven@vyatta.com>
To: LKML <linux-kernel@vger.kernel.org>
CC: Stephen Hemminger <shemminger@vyatta.com>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mike Davison <Mike.Davison@vyatta.com>
Date: Thu, 27 Jun 2013 16:44:47 -0700
Subject: [PATCH] Set the correct RTNL family for multicast netconf messages
Thread-Topic: [PATCH] Set the correct RTNL family for multicast netconf
 messages
Thread-Index: Ac5zkE+0NDP4gxTfTsG8Cs8NF9bRPA==
Message-ID: <1372376687.21767.10.camel@imac-linux.luckyscavenger.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-27_09:2013-06-27,2013-06-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1306270208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5RNj5dt017591

There may be other cases that require a special case, so I chose the switch approach.

Please note, that all other messages from ipmr[6].c correctly set the family, while these do not.

Thanks

Sven



Subject: Set correct RTNL family for multicast netconf messages
From: Sven-Thorsten Dietrich sven@vyatta.com Thu Jun 27 16:40:17 2013 -0700
Date: Thu Jun 27 16:40:17 2013 -0700:


diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index dfc39d4..695858b 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1705,7 +1705,16 @@ static int inet_netconf_fill_devconf(struct sk_buff *skb, int ifindex,
 		return -EMSGSIZE;
 
 	ncm = nlmsg_data(nlh);
-	ncm->ncm_family = AF_INET;
+
+	switch (type) {
+		case NETCONFA_MC_FORWARDING:
+			ncm->ncm_family = RTNL_FAMILY_IPMR;
+			break;
+
+		default:
+			ncm->ncm_family = AF_INET;
+			break;
+	}
 
 	if (nla_put_s32(skb, NETCONFA_IFINDEX, ifindex) < 0)
 		goto nla_put_failure;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4ab4c38..a177da4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -492,7 +492,16 @@ static int inet6_netconf_fill_devconf(struct sk_buff *skb, int ifindex,
 		return -EMSGSIZE;
 
 	ncm = nlmsg_data(nlh);
-	ncm->ncm_family = AF_INET6;
+
+	switch (type) {
+		case NETCONFA_MC_FORWARDING:
+			ncm->ncm_family = RTNL_FAMILY_IP6MR;
+			break;
+
+		default:
+			ncm->ncm_family = AF_INET6;
+			break;
+	}
 
 	if (nla_put_s32(skb, NETCONFA_IFINDEX, ifindex) < 0)
 		goto nla_put_failure;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
