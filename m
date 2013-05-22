Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3EVN1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:27:38 -0400
Received: from mx0.aculab.com ([213.249.233.131]:44825 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752792Ab3EVN1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:27:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Date: Wed, 22 May 2013 14:27:12 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7246@saturn3.aculab.com>
In-Reply-To: <1369225837.3301.324.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Thread-Index: Ac5W6DQN85yJV0YASzyghJ7mgM8jQwABus9A
References: <519B38EC.90401@yandex-team.ru>  <20130521120906.GD3578@linux.vnet.ibm.com>  <1369143885.3301.221.camel@edumazet-glaptop>  <519B8908.9080007@yandex-team.ru>  <1369150693.3301.233.camel@edumazet-glaptop>  <519BB90B.6080706@yandex-team.ru>  <1369188080.3301.268.camel@edumazet-glaptop> <1369201765.3301.299.camel@edumazet-glaptop> <519CB2D8.103@yandex-team.ru> <1369225837.3301.324.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Roman Gushchin" <klamm@yandex-team.ru>
Cc: <paulmck@linux.vnet.ibm.com>, "Dipankar Sarma" <dipankar@in.ibm.com>,
        <zhmurov@yandex-team.ru>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        "James Morris" <jmorris@namei.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "Patrick McHardy" <kaber@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4MDRkoW028522

> So yes, the patch appears to fix the bug, but it sounds not logical to
> me.

I was confused because the copy of the code I found was different
(it has some checks for reusaddr - which force a function call in the
loop).

The code being compiled is:

begin:
	result = NULL;
	badness = -1;
	udp_portaddr_for_each_entry_rcu(sk, node, &hslot2->head) {
		score = compute_score2(sk, net, saddr, sport,
				      daddr, hnum, dif);
		if (score > badness) {
			result = sk;
			badness = score;
			if (score == SCORE2_MAX)
				goto exact_match;
		}
	}
	/*
	 * if the nulls value we got at the end of this lookup is
	 * not the expected one, we must restart lookup.
	 * We probably met an item that was moved to another chain.
	 */
	if (get_nulls_value(node) != slot2)
		goto begin;

Which is entirely inlined - so the compiler is allowed to assume
that no other code modifies any of the data.
Hence it is allowed to cache the list head value.
Indeed it could convert the last line to "for (;;);".

A asm volatile ("":::"memory") somewhere would fix it.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
