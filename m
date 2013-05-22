Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab3EVOZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:25:51 -0400
Received: from mx0.aculab.com ([213.249.233.131]:46004 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754106Ab3EVOZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:25:50 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Date: Wed, 22 May 2013 15:23:19 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7247@saturn3.aculab.com>
In-Reply-To: <1369229800.3301.332.camel@edumazet-glaptop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v2] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Thread-Index: Ac5W8WiDxPADMNb8QdKdNB6bBsdiSwABNHEw
References: <519B38EC.90401@yandex-team.ru>  <20130521120906.GD3578@linux.vnet.ibm.com>  <1369143885.3301.221.camel@edumazet-glaptop>  <519B8908.9080007@yandex-team.ru>  <1369150693.3301.233.camel@edumazet-glaptop>  <519BB90B.6080706@yandex-team.ru>  <1369188080.3301.268.camel@edumazet-glaptop> <1369201765.3301.299.camel@edumazet-glaptop> <519CB2D8.103@yandex-team.ru> <1369225837.3301.324.camel@edumazet-glaptop> <AE90C24D6B3A694183C094C60CF0A2F6026B7246@saturn3.aculab.com> <1369229800.3301.332.camel@edumazet-glaptop>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Eric Dumazet" <eric.dumazet@gmail.com>
Cc: "Roman Gushchin" <klamm@yandex-team.ru>, <paulmck@linux.vnet.ibm.com>,
        "Dipankar Sarma" <dipankar@in.ibm.com>, <zhmurov@yandex-team.ru>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        "James Morris" <jmorris@namei.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "Patrick McHardy" <kaber@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4MEPwwR028915

> Here this loops begin by
> 
>  someptr = rcu_dereference(somelocation);
> 
> May claim is rcu_dereference() should force the compiler to read again
> somelocation. Its done thanks to ACCESS_ONCE(). But apparently in the
> specific case of &hslot->head, it doesnt work.

Hmmm....
#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
That might be doomed to fail for much the same reason as:
void x(struct foo *unaligned_ptr)
{
    char *p = (void *)unaligned_ptr;
    memcpy(tgt, p, sizeof *p);
}
generates alignment faults.
And that casts to a union type don't get around 'strict aliasing'.

Basically the compiler makes use of the fact that you should
cast addresses back to their original type before dereferencing them.

So I'm not sure you can use a cast to add a type qualifier.
The front-end lets you remove 'const', but I suspect the optimiser
is using the original types.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
