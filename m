Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838AbaFTPtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:49:25 -0400
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:1853 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbaFTPtV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:49:21 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Topic: [PATCH net-next] hyperv: Add handler for
 RNDIS_STATUS_NETWORK_CHANGE event
Thread-Index: AQHPjB+WQKkwvkUXekGWoyJ+QmEz5Zt6JBcA////dcA=
Date: Fri, 20 Jun 2014 15:48:56 +0000
Message-ID: <5174e5cab2b84decaa903dcf3215bce9@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1403228076-7596-1-git-send-email-haiyangz@microsoft.com>
 <20140620084158.GR5500@mwanda>
In-Reply-To: <20140620084158.GR5500@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51704005)(13464003)(199002)(189002)(377454003)(24454002)(164054003)(21056001)(50466002)(2656002)(81542001)(85326001)(87936001)(33646001)(74662001)(31966008)(46406003)(64706001)(68736004)(20776003)(47776003)(74502001)(106116001)(6806004)(19580395003)(80022001)(83322001)(19580405001)(81342001)(77096999)(79102001)(4396001)(99396002)(76176999)(84676001)(23726002)(50986999)(54356999)(92566001)(46102001)(97736001)(66066001)(44976005)(97756001)(2009001)(86612001)(85852003)(77982001)(83072002)(76482001)(24736002)(106276001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUSR01MB590;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 024847EE92
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Friday, June 20, 2014 4:42 AM
> To: Haiyang Zhang
> Cc: davem@davemloft.net; netdev@vger.kernel.org; olaf@aepfle.de;
> jasowang@redhat.com; driverdev-devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next] hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event
> 
> On Thu, Jun 19, 2014 at 06:34:36PM -0700, Haiyang Zhang wrote:
> > @@ -589,7 +590,19 @@ void netvsc_linkstatus_callback(struct hv_device
> *device_obj,
> >  	net_device = hv_get_drvdata(device_obj);
> >  	rdev = net_device->extension;
> >
> > -	rdev->link_state = status != 1;
> > +	switch (indicate->status) {
> > +	case RNDIS_STATUS_MEDIA_CONNECT:
> > +		rdev->link_state = false;
> 
> link_state false means that we want to connect?
Yes

> 
> > +		break;
> > +	case RNDIS_STATUS_MEDIA_DISCONNECT:
> > +		rdev->link_state = true;
> 
> link_state true means that we are disconnecting.
Yes.

> > @@ -782,10 +797,17 @@ static void netvsc_link_change(struct
> work_struct *w)
> >  	} else {
> >  		netif_carrier_on(net);
> >  		notify = true;
> > +		if (rdev->link_change) {
> > +			rdev->link_change = false;
> > +			refresh = true;
> > +		}
> 
> How do we know that we received a RNDIS_STATUS_MEDIA_CONNECT before we
> received the RNDIS_STATUS_NETWORK_CHANGE?  In other words, why does
> RNDIS_STATUS_NETWORK_CHANGE imply that the link_state is false?

After host sleep, both RNDIS_STATUS_MEDIA_CONNECT and 
RNDIS_STATUS_NETWORK_CHANGE events are received, but not necessarily in
this order. If RNDIS_STATUS_MEDIA_CONNECT arrives later, the flag saved
in rdev->link_change previously will trigger the refresh, not in the
RNDIS_STATUS_NETWORK_CHANGE event, but in the latter RNDIS_STATUS_MEDIA_CONNECT
event.

> 
> >  	}
> >
> >  	rtnl_unlock();
> >
> > +	if (refresh)
> > +		call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> 
> You may as well use UMH_NO_WAIT since there is no error handling if
> /etc/init.d/network is not found.

I previously tried UMH_NO_WAIT, but not working. We need to wait for the 
exec (not process completion) in this case. Since it's in the work queue,
a bit of waiting is OK.

Thanks,
- Haiyang


