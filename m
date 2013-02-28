Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab3B1NCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 08:02:24 -0500
Received: from mail-bl2lp0206.outbound.protection.outlook.com ([207.46.163.206]:31341
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751332Ab3B1NCV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 08:02:21 -0500
X-Greylist: delayed 41717 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2013 08:02:21 EST
From: Tom Talpey <ttalpey@microsoft.com>
To: "Stefan (metze) Metzmacher" <metze@samba.org>,
        Jeff Layton <jlayton@samba.org>
CC: Steve French <sfrench@samba.org>, Dave Chiluk <chiluk@canonical.com>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH] CIFS: Decrease reconnection delay when switching nics
Thread-Topic: [PATCH] CIFS: Decrease reconnection delay when switching nics
Thread-Index: AQHOE6gELIco8AYO20mQ183wJfgE3JiNjZoAgABbqoCAAIDxgIAAyORg
Date: Thu, 28 Feb 2013 13:01:20 +0000
Message-ID: <614F550557B82C44AC27C492ADA391AA045A5B27@TK5EX14MBXC284.redmond.corp.microsoft.com>
References: <1361831310-24260-1-git-send-email-chiluk@canonical.com>
	<512DE8A6.9030000@samba.org>
	<20130227083419.0af9deaf@corrin.poochiereds.net> <512EA1B5.5010801@samba.org>
In-Reply-To: <512EA1B5.5010801@samba.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.36]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(51444002)(377454001)(189002)(51704002)(199002)(24454001)(13464002)(23726001)(79102001)(16406001)(47736001)(47976001)(49866001)(50466001)(76482001)(31966008)(66066001)(59766001)(50986001)(53806001)(46406002)(46102001)(56776001)(80022001)(55846006)(74502001)(47446002)(65816001)(51856001)(56816002)(63696002)(54356001)(20776003)(47776003)(33656001)(77982001)(4396001)(74662001)(5343655001)(44976002)(54316002);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB037;H:TK5EX14MLTC104.redmond.corp.microsoft.com;RD:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: microsoft.onmicrosoft.com
X-Forefront-PRVS: 0771670921
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: samba-technical-bounces@lists.samba.org [mailto:samba-technical-
> bounces@lists.samba.org] On Behalf Of Stefan (metze) Metzmacher
> Sent: Wednesday, February 27, 2013 7:16 PM
> To: Jeff Layton
> Cc: Steve French; Dave Chiluk; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-cifs@vger.kernel.org
> Subject: Re: [PATCH] CIFS: Decrease reconnection delay when switching nics
> 
> Am 27.02.2013 17:34, schrieb Jeff Layton:
> > On Wed, 27 Feb 2013 12:06:14 +0100
> > "Stefan (metze) Metzmacher" <metze@samba.org> wrote:
> >
> >> Hi Dave,
> >>
> >>> When messages are currently in queue awaiting a response, decrease
> >>> amount of time before attempting cifs_reconnect to SMB_MAX_RTT =
> 10
> >>> seconds. The current wait time before attempting to reconnect is
> >>> currently 2*SMB_ECHO_INTERVAL(120
> >>> seconds) since the last response was recieved.  This does not take
> >>> into account the fact that messages waiting for a response should be
> >>> serviced within a reasonable round trip time.
> >>
> >> Wouldn't that mean that the client will disconnect a good connection,
> >> if the server doesn't response within 10 seconds?
> >> Reads and Writes can take longer than 10 seconds...
> >>
> >
> > Where does this magic value of 10s come from? Note that a slow server
> > can take *minutes* to respond to writes that are long past the EOF.
> >
> >>> This fixes the issue where user moves from wired to wireless or vice
> >>> versa causing the mount to hang for 120 seconds, when it could
> >>> reconnect considerably faster.  After this fix it will take
> >>> SMB_MAX_RTT (10 seconds) from the last time the user attempted to
> >>> access the volume or SMB_MAX_RTT after the last echo.  The worst
> >>> case of the latter scenario being
> 2*SMB_ECHO_INTERVAL+SMB_MAX_RTT+small scheduling delay (about 130
> seconds).
> >>> Statistically speaking it would normally reconnect sooner.  However
> >>> in the best case where the user changes nics, and immediately tries
> >>> to access the cifs share it will take SMB_MAX_RTT=10 seconds.
> >>
> >> I think it would be better to detect the broken connection by using
> >> an AF_NETLINK socket listening for RTM_DELADDR messages?
> >>
> >> metze
> >>
> >
> > Ick -- that sounds horrid ;)
> 
> This is what winbindd uses to detect that a source ip of outgoing connections
> are gone. I don't know much of the kernel, there might be a better way from
> within the kernel to detect this. But this is exactly the correct thing to do to
> failover to another interface, as it just happens when the ip is removed
> without messing with a timeout value.
> 
> Another optimization would be to use tcp keepalives (I think there 10
> seconds would be ok), I think that's what Windows SMB3 clients are using.

Yes, they do. See MS-SMB2 behavior note 144 attached to section 3.2.5.14.9.

10 seconds seems a fairly rapid keepalive interval. The TCP stack probably
won't allow it to be less than the maximum retransmit, for instance.

Tom.
