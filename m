Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab3IERf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 13:35:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:36711 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3IERf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 13:35:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,848,1371106800"; 
   d="scan'208";a="374020123"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] lockref: remove cpu_relax() again
Thread-Topic: [PATCH] lockref: remove cpu_relax() again
Thread-Index: AQHOqjponYZ6pHUzoUeo27Wv6BHm9pm3utOA//+oSZA=
Date: Thu, 5 Sep 2013 17:35:14 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F31CDC7F7@ORSMSX106.amr.corp.intel.com>
References: <20130905131814.GA24274@osiris>
 <CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
In-Reply-To: <CA+55aFyZ8xLWiPcP3jcnVApQOqAvpo_fshSvGpdpW42iRutPcQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r85HZWWu031751

> And there can't be any livelock, since by definition somebody else
> _did_ make progress. In fact, adding the cpu_relax() probably just
> makes things much less fair - once somebody else raced on you, the
> cpu_relax() now makes it more likely that _another_ cpu does so too.
>
> That said, let's see Tony's numbers are.

Data from 20 runs of "./t"

3.11 + Linus enabling patches, but ia64 not enabled (commit bc08b449ee14a from Linus tree).
mean 3469553.800000
min 3367709.000000
max 3494154.000000
stddev = 43613.722742

Now add ia64 enabling (including the cpu_relax())
mean 5509067.150000 // nice boost
min 3191639.000000 // worst case is worse than worst case before we made the change
max 6508629.000000
stddev = 793243.943875 // much more variation from run to run

Comment out the cpu_relax()
mean 2185864.400000 // this sucks
min 2141242.000000
max 2286505.000000
stddev = 40847.960152 // but it consistently sucks

So Linus is right that the cpu_relax() makes things less fair ... but without it performance sucks so
much that I don't want to use the clever cmpxchg at all - I'm much better off without it!

This may be caused by Itanium hyper-threading (SOEMT - switch on event multi-threading) where
the spinning thread means that its buddy retires no instructions until h/w times it out and forces
a switch.  But that's just a guess - losing the cacheline to whoever made the change that caused
the cmpxchg to fail should also force a thread switch.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
