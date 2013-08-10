Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab3HJPnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:43:42 -0400
Received: from fallback3.mail.ru ([94.100.176.58]:50384 "EHLO
	fallback3.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934440Ab3HJPnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:43:41 -0400
From: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
To: =?UTF-8?B?RXplcXVpZWwgR2FyY2lh?= 
	<ezequiel.garcia@free-electrons.com>
Cc: =?UTF-8?B?TGlvciBBbXNhbGVt?= <alior@marvell.com>,
        =?UTF-8?B?VGhvbWFzIFBldGF6em9uaQ==?= 
	<thomas.petazzoni@free-electrons.com>,
        =?UTF-8?B?UnVzc2VsbCBLaW5n?= <linux@arm.linux.org.uk>,
        =?UTF-8?B?SmFzb24gQ29vcGVy?= <jason@lakedaemon.net>,
        =?UTF-8?B?QW5kcmV3IEx1bm4=?= <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?B?R3JlZ29yeSBDbGVtZW50?= 
	<gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?U2ViYXN0aWFuIEhlc3NlbGJhcnRo?= 
	<sebastian.hesselbarth@gmail.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAxLzNdIEFSTTogSW50cm9kdWNlIGF0b21pYyBNTUlPIGNs?=
 =?UTF-8?B?ZWFyL3NldA==?=
Mime-Version: 1.0
X-Mailer: Mail.Ru Mailer 1.0
X-Originating-IP: [188.134.40.128]
Date: Sat, 10 Aug 2013 19:43:08 +0400
Reply-To: =?UTF-8?B?QWxleGFuZGVyIFNoaXlhbg==?= <shc_work@mail.ru>
X-Priority: 3 (Normal)
Message-ID: <1376149388.716003514@f150.i.mail.ru>
Content-Type: text/plain; charset=utf-8
X-Mras: Ok
In-Reply-To: <20130810140927.GC3080@localhost>
References: <1376138582-7550-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <20130810140237.GB3080@localhost>
 <20130810140927.GC3080@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7AFhltp015415

> On Sat, Aug 10, 2013 at 11:02:38AM -0300, Ezequiel Garcia wrote:
> > On Sat, Aug 10, 2013 at 04:49:28PM +0400, Alexander Shiyan wrote:
> > > > Some SoC have MMIO regions that are shared across orthogonal
> > > > subsystems. This commit implements a possible solution for the
> > > > thread-safe access of such regions through a spinlock-protected API
> > > > with clear-set semantics.
> > > > 
> > > > Concurrent access is protected with a single spinlock for the
> > > > entire MMIO address space. While this protects shared-registers,
> > > > it also serializes access to unrelated/unshared registers.
[...]
> > > > +void atomic_io_clear_set(void __iomem *reg, u32 clear, u32 set)
> > > > +{
> > > > +	spin_lock(&__io_lock);
> > > > +	writel((readl(reg) & ~clear) | set, reg);
> > > > +	spin_unlock(&__io_lock);
> > > > +}
> > > > +EXPORT_SYMBOL(atomic_io_clear_set);
> > > 
> > > So, one lock is used to all possible registers?
> > > Seems a regmap-mmio can be used for such access.
> > > 
> > 
> > Thanks for the hint! Quite frankly, I wasn't familiar with regmap-mmio.
> > 
> > However, after reading some code, I fail to see how that helps in this case.
> > 
> > Note that we need to access the *same* MMIO address from completely
> > different (and unrelated) drivers, such as watchdog and clocksource.
> > 
> > So I wonder who would "own" the regmap descriptor, and how does the other
> > one gets aware of that descriptor?
> > 
> > In addition given we can use orion_wdt (originally meant for mach-kirkwood)
> > to support mvebu SoC watchdog, we need to sort this out in a completely
> > multiplatform capable way.
> > 
> > Ideas?
> 
> Answering myself...
> 
> How about using drivers/mfd/syscon.c to create the regmap owner for the shared
> register (TIMER_CTRL in this case, but others might appear) ?
> 
> Or adding a new mfd implementation if syscon does not fit ?
> 
> Does this sound like an overkill ?

Yes, syscon is designed especially for such cases.

---
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
