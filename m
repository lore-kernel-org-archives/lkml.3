Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbaGGI5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:57:46 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:65220 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbaGGI5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:57:43 -0400
Message-ID: <1404723456.4501.14.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] appletalk: Set skb with destructor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        acme@ghostprotocols.net, netdev@vger.kernel.org, davem@davemloft.net
Date: Mon, 07 Jul 2014 10:57:36 +0200
In-Reply-To: <CANZNk81v7YHKpzjZ65KHdUi1BgBiV_ibZO24b8uauuCVZeUv2A@mail.gmail.com>
References: <20140705202821.GA25880@mwanda>
	 <1404647816-7564-1-git-send-email-andrey.krieger.utkin@gmail.com>
	 <1404682932.4501.6.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CANZNk81v7YHKpzjZ65KHdUi1BgBiV_ibZO24b8uauuCVZeUv2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 11:03 +0300, Andrey Utkin wrote:
> 2014-07-07 0:42 GMT+03:00 Eric Dumazet <eric.dumazet@gmail.com>:
> >>       /* Queue packet (standard) */
> >> +     sock_hold(sock);
> >> +     skb->destructor = atalk_skb_destructor;
> >>       skb->sk = sock;
> >
> > This part is not needed : sock_queue_rcv_skb() already does the right
> > thing : It calls skb_set_owner_r(skb, sk);
> >
> > You should therefore remove the "skb->sk = sock;" line
> 
> If it is so, i think this should be as another patch with its own reasoning.
> 

No it is not.

Its illegal to set skb->sk to a socket without taking proper reference.

But it is useless to do this before calling sock_queue_rcv_skb(), as I
explained to you.

This is adding two extra atomic operations for nothing: skb_orphan() is
called from sock_queue_rcv_skb(), so it is kind of stupid to set a
destructor that _will_ be immediately called.

We do not do defensive programming, we try to do logical things, and
only logical things.

Please re-spin your patch, by integrating my feedback.

Thanks !


