Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbaCTMAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:00:40 -0400
Received: from mx0.aculab.com ([213.249.233.131]:60008 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757754AbaCTMAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:00:39 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Kevin Hao'" <haokexin@gmail.com>, Scott Wood <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "Chenhui Zhao" <chenhui.zhao@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Thread-Topic: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
Thread-Index: AQHPRDIhfWL8RcQP30utVc0r+VRreZrp3JdQ
Date: Thu, 20 Mar 2014 11:59:14 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6E33AE@AcuExch.aculab.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-9-git-send-email-chenhui.zhao@freescale.com>
 <1394586624.13761.132.camel@snotra.buserror.net>
 <20140312055755.GA17203@pek-khao-d1.corp.ad.wrs.com>
 <1394646185.13761.145.camel@snotra.buserror.net>
 <20140313074613.GD26692@pek-khao-d1.corp.ad.wrs.com>
 <1394835987.12479.119.camel@snotra.buserror.net>
 <20140316045801.GA32188@pek-khao-d1.corp.ad.wrs.com>
 <1395184734.12479.250.camel@snotra.buserror.net>
 <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
In-Reply-To: <20140320114735.GD10182@pek-khao-d1.corp.ad.wrs.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2KC0jbB021958

From: Kevin Hao
> Sent: 20 March 2014 11:48
> To: Scott Wood
> Cc: linuxppc-dev@lists.ozlabs.org; Chenhui Zhao; Jason.Jin@freescale.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 9/9] powerpc/pm: support deep sleep feature on T1040
> 
> On Tue, Mar 18, 2014 at 06:18:54PM -0500, Scott Wood wrote:
> > >  The sequence "write, readback, sync" will guarantee this according to the manual.
> >
> > If you're referring to the section you quoted above, the manual does not
> > say that.  It only talks about when accesses "to memory regions affected
> > by the configuration register write" can be safely made.
> 
>   To guarantee that the results of any sequence of writes to configuration
>   registers are in effect, the final configuration register write should be
>   immediately followed by a read of the same register, and that should be
>   followed by a SYNC instruction. Then accesses can safely be made to memory
>   regions affected by the configuration register write.

That sort of sequence is need to force the operations through any
external bus - after the cpu itself has issued the bus cycles.
Mostly required because writes are often 'posted' (ie address and data
latched, and then performed synchronously).

> According to the above description in t4240 RM manual (2.6.1 Accessing CCSR
> Memory from the Local Processor), that the writing to configuration register
> takes effect is a prerequisite for the memory access to the affected regions.
...
> OK, so the intention of 'twi, isync' following the load is not to order the
> following storage access, but order the following delay loop instructions,
> right

I tried to work out what the 'twi, isync' instructions were for (in in_le32()).
The best I could come up with was to ensure a synchronous bus-fault.
But bus faults are probably only expected during device probing - not
normal operation, and the instructions will have a significant cost.

Additionally in_le32() and out_le32() both start with a 'sync' instruction.
In many cases that isn't needed either - an explicit iosync() can be
used after groups of instructions.

	David


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
