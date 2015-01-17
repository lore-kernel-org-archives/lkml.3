Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbbAQB1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:27:20 -0500
Received: from mail-bn1on0113.outbound.protection.outlook.com ([157.56.110.113]:44096
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752735AbbAQB1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:27:19 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: RE: [PATCH] Drivers: hv: vmbus: serialize Offer and Rescind offer
 processing
Thread-Topic: [PATCH] Drivers: hv: vmbus: serialize Offer and Rescind offer
 processing
Thread-Index: AQHQMZLJKQ9LfE6z90moxAURaxgT/5zDe0Pw
Date: Sat, 17 Jan 2015 01:27:17 +0000
Message-ID: <BY2PR0301MB0711FD36DA9AB5E1BA2B8B2FA04C0@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1421415958-19015-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421415958-19015-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [167.220.67.234]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kys@microsoft.com; 
x-dmarcaction-test: None
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY2PR0301MB0775;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0775;
x-forefront-prvs: 04599F3534
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(377454003)(13464003)(189002)(199003)(164054003)(51704005)(40100003)(122556002)(77156002)(62966003)(74316001)(102836002)(68736005)(2950100001)(2900100001)(101416001)(76576001)(86612001)(2501002)(86362001)(33656002)(19580395003)(46102003)(64706001)(97736003)(105586002)(87936001)(66066001)(2656002)(92566002)(54206007)(54356999)(19580405001)(54606007)(106356001)(50986999)(76176999)(99286002)(106116001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0775;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2015 01:27:17.2500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0775
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0H1RPAj026350



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, January 16, 2015 5:46 AM
> To: KY Srinivasan; devel@linuxdriverproject.org
> Cc: Haiyang Zhang; linux-kernel@vger.kernel.org; Dexuan Cui; Jason Wang;
> Radim KrÄmÃ¡Å™
> Subject: [PATCH] Drivers: hv: vmbus: serialize Offer and Rescind offer
> processing
> 
> Commit 4b2f9abea52a ("staging: hv: convert channel_mgmt.c to not call
> osd_schedule_callback")' was written under an assumption that we never
> receive Rescind offer while we're still processing the initial Offer request.
> However, the issue we fixed in 04a258c162a8 could be caused by this
> assumption not always being true.
> 
> In particular, we need to protect against the following:
> 1) Receiving a Rescind offer after we do queue_work() for processing an
> Offer
>    request and before we actually enter vmbus_process_offer(). work.func
> points
>    to vmbus_process_offer() at this moment and in vmbus_onoffer_rescind()
> we do
>    another queue_work() without a check so we'll enter
> vmbus_process_offer()
>    twice.
> 2) Receiving a Rescind offer after we enter vmbus_process_offer() and
>    especially after we set >state = CHANNEL_OPEN_STATE. Many things can
> go
>    wrong in that case, e.g. we can call free_channel() while we're still using
>    it.
> 
> Implement the required protection by changing work->func at the very end
> of
> vmbus_process_offer() and checking work->func in
> vmbus_onoffer_rescind().
> pr_warn here serves only one purpose, it shows us the collision between
> Offer and Rescind offer actually happened. In case the assumption in
> 4b2f9abea52af3 was right and such collision is impossible this commit changes
> nothing.

It is clear that an offer that has not been made cannot be rescinded. So if a rescind were to come while 
we are in the process of handling the offer, we should deal with the rescind as well after the processing of the offer is done.
Your patch does not do this; essentially we could miss handling a rescind message. We could tweak your patch to
deal with this case. If a rescind message comes in while we are still processing the offer, we should process the
rescind message in the same context. We can add this check at the end of the function that processes the offer.
If the offer is processed fully when the rescind message comes in then we can process the rescind request in its own
work context.

> 
> I also fix one additional issue with this patch: vmbus_device_create() result is
> not being checked in vmbus_process_offer() and it can fail if kzalloc() fails.

Please have this fix in a separate patch.

Thanks,

K. Y
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
