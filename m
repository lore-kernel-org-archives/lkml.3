Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbaKSNOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:14:44 -0500
Received: from mail-bn1on0142.outbound.protection.outlook.com ([157.56.110.142]:62089
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750960AbaKSNOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:14:43 -0500
X-Greylist: delayed 982 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Nov 2014 08:14:43 EST
From: Dexuan Cui <decui@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
Thread-Topic: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
Thread-Index: AQHQA/lzzMovMMzE0U6mTiCuakubnJxn69tQ
Date: Wed, 19 Nov 2014 13:13:49 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E4F44B@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1416394245-31717-1-git-send-email-decui@microsoft.com>
	<87lhn7forv.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E4F2FA@SIXPRD3002MB028.064d.mgd.msft.net>
	<87egszfjn6.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E4F3AA@SIXPRD3002MB028.064d.mgd.msft.net>
 <87a93nfiif.fsf@vitty.brq.redhat.com>
In-Reply-To: <87a93nfiif.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(199003)(13464003)(51704005)(41574002)(164054003)(189002)(46406003)(84676001)(2656002)(86362001)(86612001)(86146001)(87936001)(110136001)(92566001)(26826002)(21056001)(68736004)(33656002)(93886004)(20776003)(69596002)(92726001)(44976005)(6806004)(95666004)(120916001)(47776003)(4396001)(64706001)(106116001)(99396003)(31966008)(54356999)(76176999)(46102003)(50986999)(97756001)(62966003)(77096003)(16796002)(66066001)(50466002)(55846006)(97736003)(77156002)(81156004)(107046002)(23726002)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB1211;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-Forefront-PRVS: 04004D94E2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1211;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov 
> >> --
> >>   Vitaly
> >
> > OK, I can add this new check:
> > (I'll send out the v2 tomorrow in case  people have new comments)
> >
> 
> Thanks!
> 
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -1770,8 +1770,15 @@ kvp_done:
> >
> >                 len = netlink_send(fd, incoming_cn_msg);
> >                 if (len < 0) {
> > +                       int saved_errno = errno;
> >                         syslog(LOG_ERR, "net_link send failed; error: %d %s", errno,
> >                                         strerror(errno));
> > +
> > +                       if (saved_errno == ENOMEM || saved_errno ==  EAGAIN) {
> 
> Sorry for being pushy, but it seems ENOBUFS is also possible here (at
> least man sendmsg mentions it).
OK, I'll add this too. :-)

BTW, I realized sendmsg() can't return EAGAIN here as that's for non-blocking
socket.

Here I simply ignore the error, hoping the other end will re-try.

> 
> > +                               syslog(LOG_ERR, "send error: ignored");
> > +                               continue;
> > +                       }
> > +
> >                         exit(EXIT_FAILURE);
> >                 }
> >         }
> >
> > Thanks,
> > -- Dexuan
> 
>   Vitaly

-- Dexuan
