Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaGUKWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 06:22:06 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:16839
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754387AbaGUKWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 06:22:04 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: Tom Gundersen <teg@jklm.no>
CC: netdev <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPom6EfguQ5YHfv0qQpfdXjiDiFZuqS0WAgAAF43A=
Date: Mon, 21 Jul 2014 10:21:06 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B4476A6D1@SINEX14MBXC416.southpacific.corp.microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <CAG-2HqXFBUmpTAE8h13-DmP6Fq42viHzmuH9OfNoLgjW8XcQ3Q@mail.gmail.com>
In-Reply-To: <CAG-2HqXFBUmpTAE8h13-DmP6Fq42viHzmuH9OfNoLgjW8XcQ3Q@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(377454003)(51704005)(189002)(199002)(584604001)(86612001)(50986999)(68736004)(54356999)(85852003)(81342001)(46102001)(85306003)(107046002)(2656002)(33656002)(69596002)(81542001)(23676002)(76176999)(83072002)(97736001)(76482001)(47776003)(106116001)(80022001)(4396001)(31966008)(77982001)(20776003)(16796002)(110136001)(55846006)(64706001)(95666004)(74502001)(84676001)(6806004)(83322001)(86362001)(79102001)(81156004)(26826002)(19580395003)(19580405001)(50466002)(87936001)(92566001)(21056001)(77096002)(92726001)(106466001)(74662001)(44976005)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB619;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=yuezha@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6LAMCB1029247

> From: Tom Gundersen [mailto:teg@jklm.no]
> Sent: Monday, July 21, 2014 5:42 PM
> 
> On Fri, Jul 18, 2014 at 12:55 PM, Yue Zhang <yuezha@microsoft.com> wrote:
> > From: Yue Zhang <yuezha@microsoft.com>
> >
> > This patch addresses the comment from Olaf Hering and Greg KH
> > for a previous commit 3a494e710367 ("hyperv: Add handler for
> > RNDIS_STATUS_NETWORK_CHANGE event")
> >
> > In previous solution, the driver calls "network restart" to
> > force a DHCP renew when the host is back from hibernation.
> >
> > In this fix, the driver will keep network carrier offline for
> > 10 seconds and then bring it back. So that ifplugd daemon will
> > notice this change and refresh DHCP lease.
> >
> > Cc: Haiyang Zhang <haiyangz@microsoft.com>
> > Cc: K. Y. Srinivasan <kys@microsoft.com>
> >
> > Signed-off-by: Yue Zhang <yuezha@microsoft.com>
> > ---
> >  drivers/net/hyperv/netvsc_drv.c | 21 +++++++++++++++++----
> >  1 file changed, 17 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/hyperv/netvsc_drv.c
> b/drivers/net/hyperv/netvsc_drv.c
> > index a9c5eaa..559c97d 100644
> > --- a/drivers/net/hyperv/netvsc_drv.c
> > +++ b/drivers/net/hyperv/netvsc_drv.c
> > @@ -33,6 +33,7 @@
> >  #include <linux/if_vlan.h>
> >  #include <linux/in.h>
> >  #include <linux/slab.h>
> > +#include <linux/delay.h>
> >  #include <net/arp.h>
> >  #include <net/route.h>
> >  #include <net/sock.h>
> > @@ -792,8 +793,7 @@ static void netvsc_link_change(struct work_struct
> *w)
> >         struct netvsc_device *net_device;
> >         struct rndis_device *rdev;
> >         bool notify, refresh = false;
> > -       char *argv[] = { "/etc/init.d/network", "restart", NULL };
> > -       char *envp[] = { "HOME=/", "PATH=/sbin:/usr/sbin:/bin:/usr/bin",
> NULL };
> > +       int delay;
> >
> >         rtnl_lock();
> >
> > @@ -816,8 +816,21 @@ static void netvsc_link_change(struct work_struct
> *w)
> >
> >         rtnl_unlock();
> >
> > -       if (refresh)
> > -               call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> > +       if (refresh) {
> > +               /*
> > +                * Keep the carrier offline for 10 seconds
> > +                * to notify ifplugd daemon network change
> > +                */
> > +               for (delay = 0; delay < 10; delay++) {
> > +                       rtnl_lock();
> > +                       netif_carrier_off(net);
> > +                       rtnl_unlock();
> > +                       ssleep(1);
> > +               }
> > +               rtnl_lock();
> > +               netif_carrier_on(net);
> > +               rtnl_unlock();
> > +       }
> 
> Why is it necessary to wait for ten seconds? Why not just:
> 
> if (refresh) {
>         rtnl_lock();
>         netif_carrier_off(net);
>         netif_carrier_on(net);
>         rtnl_unlock();
> }
> 
> At least systemd-networkd will renew the dhcp lease as long as it gets
> NEWLINK messages indicating that the carrier was lost and regained,
> regardless of the time between events. Is there any reason not to do
> this?
> 
> Cheers,
> 
> Tom
> 

Hi, Tom

Some network monitoring daemon, like ifplugd has a deferring mechanism.
When it detects carriers is offline, it doesn't trigger DHCP renew immediately. 
Instead it will wait for another 5 seconds to check whether carrier is back to 
online status. In that case, it will avoid renew DHCP lease.

And also there is some optimization in Linux's network stack. If link state
flipped so quickly, like the code you proposed. It is very likely the event won't
be delivered to user space.

Thanks
---
Yue
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
