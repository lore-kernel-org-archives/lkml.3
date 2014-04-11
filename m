Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbaDKJBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 05:01:50 -0400
Received: from mx0.aculab.com ([213.249.233.131]:56070 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755998AbaDKJBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 05:01:48 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>
CC: Florian Fainelli <f.fainelli@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Patrick McHardy <kaber@trash.net>
Subject: RE: [PATCH] tcp: fix compiler array bounds warning on
 selective_acks[]
Thread-Topic: [PATCH] tcp: fix compiler array bounds warning on
 selective_acks[]
Thread-Index: AQHPVQPliB8UXR9wYkmZkIsKPbQpM5sMG3zQ
Date: Fri, 11 Apr 2014 08:59:57 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6F5DFA@AcuExch.aculab.com>
References: <20140410213029.24916.93892.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140410213029.24916.93892.stgit@bhelgaas-glaptop.roam.corp.google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3B9226O001679

Bjorn Helgaas 
> With -Werror=array-bounds, gcc v4.8.x warns that in tcp_sack_remove(), a
> selective_acks[] "array subscript is above array bounds".
> 
> I don't understand how gcc figures this out, or why we don't see similar
> problems many other places, but this is the only fix I can figure out.
...
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 65cf90e063d5..65133b108236 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -4047,7 +4047,8 @@ static void tcp_sack_remove(struct tcp_sock *tp)
> 
>  			/* Zap this SACK, by moving forward any other SACKS. */
>  			for (i = this_sack+1; i < num_sacks; i++)
> -				tp->selective_acks[i-1] = tp->selective_acks[i];
> +				if (i < ARRAY_SIZE(tp->selective_acks))
> +					tp->selective_acks[i-1] = tp->selective_acks[i];
>  			num_sacks--;
>  			continue;
>  		}

You really shouldn't add that test every time around the loop.

Try changing the loop so the assignment is:
   tp->selective_acks[i] = tp->selective_acks[i + 1];

or the loop test to:
	i <= num_sacks - 1;

Or beat up the gcc developers :-)

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
