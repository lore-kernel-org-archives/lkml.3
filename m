Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932410Ab3LDOv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:51:26 -0500
Received: from mx0.aculab.com ([213.249.233.131]:58089 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932257Ab3LDOvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:51:24 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: Supporting 4 way connections in LKSCTP
Date: Wed, 4 Dec 2013 14:50:46 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B745D@saturn3.aculab.com>
In-Reply-To: <529F395B.9040308@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Supporting 4 way connections in LKSCTP
Thread-Index: Ac7w+4yzdrRKKswbQ7CvVC5OYkDJSQAAgdgw
References: <CAFXGft+CXk3W8=3w=AuYzqYtYnR8nH4Of9=668tUeT+tugD9-A@mail.gmail.com>	<5294BC01.7090605@gmail.com>	<CAFXGftLsKm9a5bmXX4Fe+rnSvYVdBDOyYGwisRP7XMu+ky=DGw@mail.gmail.com>	<CAFXGftLt1p6XpR2eGsMYKjEbbOHvch-LgcFw1sAXThcA2Rtjyw@mail.gmail.com>	<20131127124530.GA23369@hmsreliant.think-freely.org>	<CAFXGftJQV=5Pqs3bhfiS3T1VO1q8jfaMjAUiqm2tDbtSyBCM3A@mail.gmail.com>	<529C9B50.50002@gmail.com>	<CAGugRbXFirQ5P3ek9zN86h4vvO6qsy3eNEooJOApotA+dL+C_g@mail.gmail.com>	<529CB859.9090904@gmail.com>	<CAFXGft+F52p+oaa59=5e5pGfON44N36NA-XMYi5PorzWeybnKw@mail.gmail.com>	<CAFXGft+4o6fT4SYbu3musC+-BEi=xOEGUbZSavF1-0_V1mg6zg@mail.gmail.com>	<529D3BF9.3070208@gmail.com>	<CAFXGftJtCCJ=pVxg_DH-+n2bKmoKXavog0y8mfX+h-1z3hP49Q@mail.gmail.com>	<529DCF42.1070800@gmail.com>	<CAFXGftK5tz90OzObiV7Hi+g080j3zWCNdo217CKdNkOY4JWQUg@mail.gmail.com>	<529DF73E.7060604@gmail.com> <CAFXGftKZD0zN1S=UTa_bYr71-v=7mzU=_CewTNkjPv9CGGB_Fg@mail.gmail.com> <529F395B.9040308@gmail.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Vlad Yasevich" <vyasevich@gmail.com>, "Sun Paul" <paulrbk@gmail.com>
Cc: <netdev@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        "Karl Heiss" <kheiss@gmail.com>, "Neil Horman" <nhorman@tuxdriver.com>,
        <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB4EpsrY001528

> > In normal operation, IP-A sends INIT to IP-X, IP-X returns INIT_ACK to
> > IP-A. IP-A then sends HB to IP-X, IP-X then returns HB_ACK to IP-A. In
> > the meantime, IP-B sends HB to IP-Y and IPY returns HB_ACK.
> >
> > In case of the path between IP-A and IP-X is broken, IP-B sends INIT
> > to IP-X, NODE-B uses IP-Y to return INIT_ACK to IP-B. Then IP-B sends
> > HB to IP-X, and IP-Y returns HB_ACK to IP-B. In the meantime, the HB
> > communication between IP-B and IP-Y follows the normal flow.
> >
> > Can I confirm, is it really valid?
> 
> As long as NODE-B knows about both IP-A and IP-B, and NODE-A knows about
> both IP-X and IP-Y (meaning all the addresses were exchanged inside INIT
> and INIT-ACK), then this situation is perfectly valid.  In fact, this
> has been tested an multiple interops.

There are some network configurations that do cause problems.
Consider 4 systems with 3 LAN segments:
A) 10.10.10.1 on LAN X and 192.168.1.1 on LAN Y.
B) 10.10.10.2 on LAN X and 192.168.1.2 on LAN Y.
C) 10.10.10.3 on LAN X.
D) 10.10.10.4 on LAN X and 192.168.1.2 on LAN Z.
There are no routers between the networks (and none of the systems
are running IP forwarding).

If A connects to B everything is fine - traffic can use either LAN.

Connections from A to C are problematic if C tries to send anything
(except a HB) to 192.168.1.1 before receiving a HB response.
One of the SCTP stacks we've used did send messages to an
inappropriate address, but I've forgotten which one.

Connections between A and D fail unless the HB errors A receives
for 192.168.1.2 are ignored.

Of course the application could explicitly bind to only the 10.x address
but that requires the application know the exact network topology
and may be difficult for incoming calls.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
