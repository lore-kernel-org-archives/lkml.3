Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaIBRqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:46:25 -0400
Received: from mail-db3lrp0082.outbound.protection.outlook.com ([213.199.154.82]:12595
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754631AbaIBRqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:46:24 -0400
From: Itzcak Pechtalt <itzcak@flashnetworks.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
Thread-Topic: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
Thread-Index: Ac/GxJS2CAsOsHuZTuKoM+hFYbOusAAA5kEAAAJegjA=
Date: Tue, 2 Sep 2014 17:46:19 +0000
Message-ID: <65c9175dc6cc4c1799e50873a29a0abb@AM3PR06MB388.eurprd06.prod.outlook.com>
References: <5dfbace37c434be58ed26ea524aa0675@AM3PR06MB388.eurprd06.prod.outlook.com>
 <CA+55aFw9HL4E=3eofs4=hzY=LvWEcKzzJZOTDDTGkeF1_vDcog@mail.gmail.com>
In-Reply-To: <CA+55aFw9HL4E=3eofs4=hzY=LvWEcKzzJZOTDDTGkeF1_vDcog@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [212.143.111.82]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0322B4EDE1
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(189002)(199003)(24454002)(377424004)(51704005)(377454003)(13464003)(74502001)(74662001)(31966008)(108616004)(85306004)(50986999)(33646002)(99396002)(19580405001)(19580395003)(83322001)(76176999)(54356999)(46102001)(110136001)(81542001)(21056001)(64706001)(85852003)(101416001)(83072002)(90102001)(79102001)(80022001)(15975445006)(66066001)(2656002)(86362001)(77982001)(76482001)(105586002)(87936001)(4396001)(92566001)(76576001)(107046002)(95666004)(74316001)(81342001)(106356001)(20776003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:AM3PR06MB385;H:AM3PR06MB388.eurprd06.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: flashnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s82HkUEZ015122

Indeed,  my crash dump occurred on kernel 2.6.30 (RH 6.5 distribution) and in this version function remove_hrtimer  doesn't preserve "HRTIMER_STATE_CALLBACK" flag and triggers hard lockup.
So this bug was already fixed in version 2.6.35 to set the flag by remove_hrtimer function.

Seems that  migrate_hrtimer_list case isn't a problem because it is called when old CPU is already dead.

I'll fix the bug report to resolved.

Thanks

Itzcak Pechtalt



-----Original Message-----
From: linus971@gmail.com [mailto:linus971@gmail.com] On Behalf Of Linus Torvalds
Sent: Tuesday, September 02, 2014 7:09 PM
To: Itzcak Pechtalt; Thomas Gleixner
Cc: linux-kernel@vger.kernel.org
Subject: Re: Race condition in HR timers that cause double insertion and hard lockup -- all latest versions

On Tue, Sep 2, 2014 at 8:45 AM, Itzcak Pechtalt <itzcak@flashnetworks.com> wrote:
>
> I opened a bug in https://bugzilla.kernel.org/show_bug.cgi?id=83601  for this subject with full description.
> There is also a short fix patch for kernel/hrtimer.c file.
> Even if this bug occurs rary, however it resolves system hard lockup option.

The patch is whitespace-damaged, but with a small oneliner like this that doesn't much matter (the timer files moved to kernel/time/ during this merge window, so the patch wouldn't apply as-is anyway).

It needs a sign-off (see Documentation/SubmittingPatches), but even more importantly it needs to go to the right people for double-checking.

But the patch is more broken than whitespace and even lack of sign-off. It cannot even have compiled. I'm assuming "timer_state" was intended to be "timer->state". Also, every caller but one already has "HRTIMER_STATE_CALLBACK" set unconditionally or to the old state in "newstate", so I suspect if this patch is the real fix (which I'll leave for Thomas to comment more on), afaik the actual problem can only happen through migrate_hrtimer_list() which uconditionally sets the whole state to HRTIMER_STATE_MIGRATE.

Thomas? Leaving damaged patch quoted below.

           Linus

> I suspect that it was targeted by mistake to not active list (timers_realtime-clock@kernel-bugs.osdl.org).
> Following is the fix patch based on kernel 3.16.1 (just simple):
> diff -uNr a/kernel/hrtimer.c b/kernel/hrtimer.c
> --- a/kernel/hrtimer.c 2014-08-31 20:59:52.177452123 +0300
> +++ b/kernel/hrtimer.c 2014-08-31 21:02:14.972166540 +0300
> @@ -941,7 +941,7 @@
> if (!timerqueue_getnext(&base->active))
> base->cpu_base->active_bases &= ~(1 << base->index);
> out:
> - timer->state = newstate;
> + timer->state = (newstate | (timer_state & HRTIMER_STATE_CALLBACK));
> }
>
> /*
>
> Is there a chance for this patch fix to insert into next kernel release?
>
> Thanks
>
> Itzcak Pechtalt
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
