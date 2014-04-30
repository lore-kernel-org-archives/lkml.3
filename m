Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbaD3Jhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 05:37:31 -0400
Received: from mx0.aculab.com ([213.249.233.131]:35779 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758507AbaD3Jh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 05:37:26 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Alexey Charkov'" <alchark@gmail.com>
CC: Jan Moskyto Matejka <mq@suse.cz>, Roger Luethi <rl@hellgate.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: via-rhine: fix compiler warning
Thread-Topic: [PATCH] net: via-rhine: fix compiler warning
Thread-Index: AQHPY9FWWp1qfKJ7c0OzzdAVAe6qrZsp2FVQ///6yYCAABN1cA==
Date: Wed, 30 Apr 2014 09:35:28 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F702D00@AcuExch.aculab.com>
References: <1398792971-10379-1-git-send-email-mq@suse.cz>
	<063D6719AE5E284EB5DD2968C1650D6D0F702C5F@AcuExch.aculab.com>
 <CABjd4YzRTPcy1nbhywuNLb0pz4gPVjhzegZJTc_g+_SVc1XJvw@mail.gmail.com>
In-Reply-To: <CABjd4YzRTPcy1nbhywuNLb0pz4gPVjhzegZJTc_g+_SVc1XJvw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3U9bgcH006303

From: Alexey Charkov [mailto:alchark@gmail.com]
 
> 2014-04-30 12:49 GMT+04:00 David Laight <David.Laight@aculab.com>:
> > From: Jan Moskyto Matejka
> >> Fixed different size cast warning:
> >>
> >>       drivers/net/ethernet/via/via-rhine.c: In function rhine_init_one_platform:
> >>       drivers/net/ethernet/via/via-rhine.c:1132:13: warning: cast from pointer to integer of different
> >> size [-Wpointer-to-int-cast]
> >>         revision = (u32)match->data;
> >>                    ^
> >>
> >> That code was added in commit 2d283862dc62daead9db0dc89cd0d0351e91f765
> >> ("net: via-rhine: add OF bus binding").
> > ...
> >> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
> >> index 4fa9201..76d18e0 100644
> >> --- a/drivers/net/ethernet/via/via-rhine.c
> >> +++ b/drivers/net/ethernet/via/via-rhine.c
> >> @@ -288,7 +288,7 @@ MODULE_DEVICE_TABLE(pci, rhine_pci_tbl);
> >>   * (for quirks etc.)
> >>   */
> >>  static struct of_device_id rhine_of_tbl[] = {
> >> -     { .compatible = "via,vt8500-rhine", .data = (void *)0x84 },
> >> +     { .compatible = "via,vt8500-rhine", .data = (u32 []) { 0x84 } },
> >>       { }     /* terminate list */
> >>  };
> >>  MODULE_DEVICE_TABLE(of, rhine_of_tbl);
> >> @@ -1129,7 +1129,7 @@ static int rhine_init_one_platform(struct platform_device *pdev)
> >>       if (!irq)
> >>               return -EINVAL;
> >>
> >> -     revision = (u32)match->data;
> >> +     revision = *((u32 *) match->data);
> >>       if (!revision)
> >>               return -EINVAL;
> >
> > Both those casts look horrid.
> > I'm not entirely convinced that the first is valid C - It would have to be
> > something specific to C99 initialisers.
> > Casts like *(u32 *)foo are also likely to be bugs (esp. on BE systems)
> > so themselves start ringing alarm bells.
> >
> > So why not just:
> >         revision = (unsigned long)match->data;
> > and add a comment that the 0x84 is the revision - #define ??
> 
> There is no particular reason why it should be u32 now - this is a
> leftover from the previous iteration of code where revision was a
> separate property in DT (sized u32). It actually mirrors the
> respective field in struct pci_dev, which is u8 - don't see any issue
> defining it as unsigned long (and also changing the definition in
> struct rhine_private).

I'd guess that the field in 'struct rhine_private' only needs to
be large enough for the domain of the values that are actually
saved in it.
If these are versions (of something) then a fixed size type
(or just int) is probably more appropriate.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
