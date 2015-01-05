Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbbAEXFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:05:03 -0500
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:33184
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753350AbbAEXFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:05:00 -0500
X-Greylist: delayed 871 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 18:05:00 EST
From: Matthew Garrett <matthew.garrett@nebula.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Subject: Re: [PATCH] RTC: Restore alarm after resume
Thread-Topic: [PATCH] RTC: Restore alarm after resume
Thread-Index: AQHQHhxHEMdkAaDerUSHINT8n1zQxpyyNVYAgAACboA=
Date: Mon, 5 Jan 2015 22:50:26 +0000
Message-ID: <1420498225.18006.6.camel@nebula.com>
References: <1419275979-24307-1-git-send-email-matthew.garrett@nebula.com>
	 <20150105144144.46a4792e90e5800b1d865cdd@linux-foundation.org>
In-Reply-To: <20150105144144.46a4792e90e5800b1d865cdd@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2602:243:200f:a924:6267:20ff:fec3:2318]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.garrett@nebula.com; 
x-dmarcaction: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN1PR05MB421;
x-forefront-prvs: 0447DB1C71
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(51704005)(24454002)(199003)(377424004)(68736005)(2950100001)(2900100001)(64706001)(110136001)(102836002)(20776003)(99396003)(86362001)(36756003)(120916001)(92566001)(106116001)(4396001)(33646002)(107046002)(2351001)(19580395003)(106356001)(19580405001)(99286002)(54356999)(50986999)(105586002)(87936001)(76176999)(2656002)(46102003)(101416001)(77156002)(62966003)(31966008)(97736003)(40100003)(122556002)(21056001)(103116003)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR05MB421;H:BN1PR05MB423.namprd05.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CD8C8F520AFF74FADA90C7675A40B1A@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2015 22:50:26.4543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9cc6df8-58db-46f5-bf3e-083732d8ac63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR05MB421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t05N5BvO009478

On Mon, 2015-01-05 at 14:41 -0800, Andrew Morton wrote:
> On Mon, 22 Dec 2014 19:19:39 +0000 Matthew Garrett <matthew.garrett@nebula.com> wrote:
> 
> > Some platform firmware may interfere with the RTC alarm over suspend,
> > resulting in the kernel and hardware having different ideas about system state
> > but also potentially causing problems with firmware that assumes the OS will
> > clean this case up. This patch saves the RTC alarm state on suspend and will
> > restore it on resume if the alarm has not yet fired - if it has, it will clear
> > the RTC alarm.
> 
> There's not really enough info here for me to decide which kernel
> version(s) need the patch.  Can we please expand on "some"?  Any
> suggestions regarding the importance/timing of the fix?

The case we've seen is Intel Rapid Start, which is a firmware-mediated
feature that automatically transitions systems from suspend-to-RAM to
suspend-to-disk without OS involvement. It does this by setting the RTC
alarm and a flag that indicates that on wake it should perform the
transition rather than re-starting the OS. However, if the OS has set a
wakeup alarm that would wake the machine earlier, it refuses to
overwrite it and allows the system to wake instead.

This fails in the following situation:

1) User configures Intel Rapid Start to transition after (say) 15
minutes
2) User suspends to RAM. Firmware sets the wakeup alarm for 15 minutes
in the future
3) User resumes after 5 minutes. Firmware does not reset the alarm, and
as such it is still set for 10 minutes in the future
4) User suspends after 5 minutes. Firmware notices that the alarm is set
for 5 minutes in the future, which is less than the 15 minute transition
threshold. It therefore assumes that the user wants the machine to wake
in 5 minutes
5) System resumes after 5 minutes

The worst case scenario here is that the user may have put the system in
a bag between (4) and (5), resulting in it running in a confined space
and potentially overheating. This seems reasonably important. The Rapid
Start support code got added in 3.11, but it can be configured in the
firmware regardless of kernel support.

I'd like to hear some feedback from the RTC maintainers regarding
whether this is the preferred fix. Doing it in the Rapid Start driver
doesn't seem correct, since as mentioned the feature doesn't require any
kernel support - the kernel code just provides a means for runtime
configuration.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
