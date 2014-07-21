Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaGUCox (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 22:44:53 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:41571
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751069AbaGUCov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 22:44:51 -0400
From: "Yue Zhang (OSTC DEV)" <yuezha@microsoft.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>, Thomas Shao <huishao@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>
Subject: RE: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Topic: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
Thread-Index: AQHPom6EfguQ5YHfv0qQpfdXjiDiFZul1uyAgAP9BeA=
Date: Mon, 21 Jul 2014 02:44:35 +0000
Message-ID: <DC7803B42427924284F2D5252E076A3B44769DCA@SINEX14MBXC416.southpacific.corp.microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
 <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com>
In-Reply-To: <CAFLxGvxQU_z+mChHsNSu9VZEdXrU+RU75k6H18uKbdAj2TKD5g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.3.97]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(164054003)(24454002)(199002)(189002)(377454003)(76482001)(97736001)(85852003)(77982001)(79102001)(4396001)(55846006)(80022001)(69596002)(46102001)(19580395003)(83322001)(86362001)(74662001)(84676001)(87936001)(19580405001)(2656002)(50466002)(54356999)(26826002)(50986999)(76176999)(33656002)(68736004)(21056001)(83072002)(64706001)(85306003)(77096002)(47776003)(86612001)(584604001)(99396002)(92566001)(92726001)(20776003)(6806004)(106116001)(74502001)(16796002)(31966008)(106466001)(107046002)(81156004)(110136001)(44976005)(23676002)(95666004)(81542001)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB620;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6L2ixK9027151

> From: Richard Weinberger [mailto:richard.weinberger@gmail.com]
> Sent: Friday, July 18, 2014 9:41 PM
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
> 
> Why 10? Is this a random number which works by accident for ifplugd?
> What about other networking implementations, is 10 also ok for them?
> --
> Thanks,
> //richard

Hi, Richard

I checked ifplugd's code. The deferring time is 5 seconds. That's how  comes 
the "10s". I agree with you this is a magic number and should be avoid. However, 
this is the only feasible solution right now. If there is a better solution, I will be 
glad to switch to it.

I tested the fix in Redhat, Ubuntu and SUSE and it works in all of them.

Thanks
Yie
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
