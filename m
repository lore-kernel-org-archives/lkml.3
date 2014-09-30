Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaI3Hxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 03:53:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:5397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbaI3Hxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 03:53:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="393434289"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: "richard@nod.at" <richard@nod.at>
CC: "dedekind1@gmail.com" <dedekind1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
Thread-Topic: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
Thread-Index: AQHP3IOmvAnUBLHqWU+r04e0E2w41g==
Date: Tue, 30 Sep 2014 07:53:40 +0000
Message-ID: <1412063620.2379.12.camel@sauron.fi.intel.com>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
		 <1412029248-22454-2-git-send-email-richard@nod.at>
	 <1412058366.23429.77.camel@sauron.fi.intel.com> <542A548A.7040308@nod.at>
In-Reply-To: <542A548A.7040308@nod.at>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.54]
Content-Type: text/plain; charset="utf-8"
Content-ID: <05B235C330B34B47BE87DEF9256E872A@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8U7rnUl020118

On Tue, 2014-09-30 at 08:58 +0200, Richard Weinberger wrote:
> Am 30.09.2014 08:26, schrieb Artem Bityutskiy:
> > On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
> >> ...otherwise the deferred work might run after datastructures
> >> got freed and corrupt memory.
> > 
> > How can this happend? The background thread is stopped by this time
> > already, so what are the other possibilities? And why is this
> > fastmap-only?
> 
> This has nothing do to with the background thread.
> Fastmap has a work queue. If one fastmap work has been
> scheuled we have to wait for it.

I expected a bit more explanation. But OK, here is what I think.

UBI consists of subsystems. Subsystems try to be more or less
independent, whenever possible. They expose interface functions for
other subsystems. Of course the split is not ideal, but we do our best.

* wl.c does wear-levelling.
* wl.c does not do fastmap.
* fastmap.c does fastmap.
* I am unhappy seeing yet another ifdef to wl.c
* I am unhappy seeing wl.c calling 'flush_work(&ubi->fm_work)', because
fastmap.c should deal with 'fm_work'. Or said differently, wl.c is not a
fastmap queue baby-sitter. fastmap.c is.

Most UB subsystems have the init and close function. May be adding one
for fastmap would help? Then you could flush whatever from
'ubi_wl_close()' ?

Historically the work queue was implemented in wl.c because wl.c was the
only user of it.

If this layout is not good enough, we should probably extend it, may be
separate work queue management out of wl.c.

But populating wl.c with macros and little "take care of this fatmap
bit" stuff is a not going to lead to better code structure.

-- 
Best Regards,
Artem Bityutskiy
---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki 
Business Identity Code: 0357606 - 4 
Domiciled in Helsinki 

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
