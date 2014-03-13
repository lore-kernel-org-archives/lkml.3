Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbaCMP7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:59:31 -0400
Received: from mail-bn1blp0189.outbound.protection.outlook.com ([207.46.163.189]:24325
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753560AbaCMP71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:59:27 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "jmorris@namei.org" <jmorris@namei.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Thread-Topic: Trusted kernel patchset for Secure Boot lockdown
Thread-Index: AQHPPoSmgdFEpLbAD0ahQ2OJgthmsZrewXAAgABr7YA=
Date: Thu, 13 Mar 2014 15:59:24 +0000
Message-ID: <1394726363.25122.16.camel@x230>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	 <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	 <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	 <1394686919.25122.2.camel@x230>
	 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	 <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:470:1f07:1371:6267:20ff:fec3:2318]
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377424004)(24454002)(199002)(189002)(74876001)(81686001)(85852003)(19580405001)(33646001)(83072002)(65816001)(80022001)(79102001)(33716001)(80976001)(76786001)(81816001)(74502001)(97336001)(63696002)(69226001)(83322001)(19580395003)(46102001)(51856001)(31966008)(81342001)(85306002)(59766001)(77982001)(90146001)(4396001)(92726001)(95416001)(93516002)(54316002)(74366001)(93136001)(56776001)(92566001)(47976001)(86362001)(76482001)(77096001)(56816005)(87266001)(76796001)(50986001)(53806001)(54356001)(95666003)(74706001)(94316002)(97186001)(87936001)(2656002)(81542001)(94946001)(47736001)(49866001)(74662001)(3826001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR05MB456;H:BN1PR05MB423.namprd05.prod.outlook.com;CLIP:2001:470:1f07:1371:6267:20ff:fec3:2318;FPR:E1FD7905.8FFA5F0C.71D1997E.4AE5DB71.202C9;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E8F15796680394FA0096755D042D658@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s2DFxcZt010440

On Thu, 2014-03-13 at 20:33 +1100, James Morris wrote:

> I'll take it, but there's unanswered review feedback (your response to the 
> first question), and Alan raised some doubts about the patches which I'm 
> not sure have been resolved.

The remaining opens seem to be CAP_SYS_RAWIO and firmware signing?
Ironically, disabling CAP_SYS_RAWIO disables firmware loadingâ€¦

The problem with CAP_SYS_RAWIO is that its semantics were never
sufficiently well documented, and as a result it's a mixture of "This is
incredibly dangerous" and "We replaced a check for uid 0 with whichever
capability seemed to have the most appropriate name". I've gone through
all the uses of CAP_SYS_RAWIO and added additional checks to the generic
ones that seem appropriate. There's a couple of old drivers that use it
to gate access to features that potentially allow arbitrary DMA and it
might be worth cleaning those up, but the only general case I haven't
modified is the ability to send arbitrary SCSI commands from userspace.
My understanding is that endpoints aren't going to be able to DMA to
arbitrary addresses, so that doesn't seem like a problem.

On the other hand, disabling CAP_SYS_RAWIO *definitely* breaks expected
functionality - firmware loading and the fibmap ioctl are probably the
most obvious. And changing the use of CAP_SYS_RAWIO potentially breaks
userspace expectations, so we're kind of stuck there.

As for signed firmware, I'm looking forward to Kees' work on that.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
