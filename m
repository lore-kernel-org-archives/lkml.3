Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbaKSMbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 07:31:41 -0500
Received: from mail-by2on0145.outbound.protection.outlook.com ([207.46.100.145]:61153
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751226AbaKSMbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 07:31:40 -0500
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
Thread-Index: AQHQA+agzMovMMzE0U6mTiCuakubnJxn2pZQ
Date: Wed, 19 Nov 2014 12:15:21 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C613E4F2FA@SIXPRD3002MB028.064d.mgd.msft.net>
References: <1416394245-31717-1-git-send-email-decui@microsoft.com>
 <87lhn7forv.fsf@vitty.brq.redhat.com>
In-Reply-To: <87lhn7forv.fsf@vitty.brq.redhat.com>
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
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(51704005)(13464003)(199003)(377454003)(189002)(26826002)(86362001)(110136001)(97756001)(107046002)(46406003)(55846006)(21056001)(62966003)(77096003)(2656002)(77156002)(95666004)(86146001)(87936001)(66066001)(86612001)(47776003)(64706001)(33656002)(20776003)(106466001)(99396003)(4396001)(81156004)(97736003)(106116001)(76176999)(50466002)(50986999)(84676001)(92726001)(92566001)(54356999)(16796002)(31966008)(46102003)(44976005)(6806004)(23726002)(19580405001)(120916001)(19580395003)(68736004)(69596002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1205;H:mail.microsoft.com;FPR:;SPF:Pass;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-Forefront-PRVS: 04004D94E2
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1205;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Vitaly Kuznetsov
> Sent: Wednesday, November 19, 2014 18:50 PM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; Haiyang Zhang
> Subject: Re: [PATCH] tools: hv: ignore ENOBUFS in the KVP daemon
> 
> Dexuan Cui  writes:
> 
> > Under high memory pressure and very high KVP R/W test pressure, the
> netlink
> > recvfrom() may transiently return ENOBUFS to the daemon -- we found
> this
> > during a 2-week stress test.
> >
> > We'd better not terminate the daemon on this failure, because a typical
> KVP
> > user can re-try the R/W and hopefully it will succeed next time.
> >
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> > index 22b0764..9f4b303 100644
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -1559,8 +1559,15 @@ int main(int argc, char *argv[])
> >  				addr_p, &addr_l);
> >
> >  		if (len < 0) {
> > +			int saved_errno = errno;
> >  			syslog(LOG_ERR, "recvfrom failed; pid:%u
> error:%d %s",
> >  					addr.nl_pid, errno, strerror(errno));
> > +
> > +			if (saved_errno == ENOBUFS) {
> 
> is it possible to meet EAGAIN (or EWOULDBLOCK) here as well? I'd suggest
> we ignore these as well in such case. Ignoring ENOMEM here is doubtful,
> I think. But possible.
> 
>   Vitaly

I don't think EAGAIN is possible  because "man recvfrom" says
   "If  no messages are available at the socket, the receive calls wait for a
     message to arrive, unless the socket is nonblocking (see fcntl(2)), in which
     case the value -1 is returned and  the  external variable  errno is set to
    EAGAIN or EWOULDBLOCK".

The same man page mention ENOMEM for recvmsg(), but not recvfrom().

-- Dexuan
