Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbaCDQ5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:57:22 -0500
Received: from na01-sn2-obe.ptr.o365filtering.com ([157.55.158.25]:21869 "EHLO
	na01-sn2-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbaCDQ5U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:57:20 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: RE: [PATCH net-next] hyperv: Move state setting for link query
Thread-Topic: [PATCH net-next] hyperv: Move state setting for link query
Thread-Index: AQHPNzS1MjMVTcnutkixH59RjUyzbprQxhqAgABZCqA=
Date: Tue, 4 Mar 2014 16:57:00 +0000
Message-ID: <856c5dedc14a458b8100dcb2d3a2f9e6@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <1393890875-1420-1-git-send-email-haiyangz@microsoft.com>
 <531543FD.7090907@redhat.com>
In-Reply-To: <531543FD.7090907@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.147.100;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(24454002)(164054003)(377454003)(51704005)(479174003)(13464003)(199002)(189002)(53806001)(56776001)(77982001)(59766001)(47976001)(47736001)(80022001)(85852003)(54316002)(4396001)(20776003)(47776003)(54356001)(46102001)(63696002)(76482001)(83072002)(66066001)(93516002)(87266001)(49866001)(74662001)(51856001)(50986001)(74366001)(80976001)(81686001)(76796001)(90146001)(33646001)(2201001)(81816001)(56816005)(76786001)(74876001)(84676001)(44976005)(47446002)(74502001)(83322001)(19580395003)(95416001)(87936001)(94946001)(81342001)(19580405001)(94316002)(86612001)(31966008)(74706001)(93136001)(79102001)(65816001)(92566001)(46406003)(95666003)(23726002)(81542001)(50466002)(6806004)(69226001)(2656002)(85306002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB594;H:hybrid.exchange.microsoft.com;FPR:260D781E.3C639DEA.41FABF17.40E3E92B.202AD;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 01401330D1
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jason Wang [mailto:jasowang@redhat.com]
> Sent: Monday, March 3, 2014 10:10 PM
> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org
> Subject: Re: [PATCH net-next] hyperv: Move state setting for link query
> 
> On 03/04/2014 07:54 AM, Haiyang Zhang wrote:
> > It moves the state setting for query into rndis_filter_receive_response().
> > All callbacks including query-complete and status-callback are
> > synchronized by channel->inbound_lock. This prevents pentential race
> between them.
> 
> This still looks racy to me. The problem is workqueue is not synchronized with
> those here.
> 
> Consider the following case in netvsc_link_change():
> 
>     if (rdev->link_state) {
>     ... receive interrupt ...
>     rndis_filter_receice_response() which changes rdev->link_state
>     ...
>         netif_carrier_off()
>     }
> 
> And also it need to schedule a work otherwise the link status is out of sync.

The rndis_filter_query_device_link_status() makes the query and wait for the
complete message, including set state, before returning.

The rndis_filter_query_device_link_status() is called from rndis_filter_device_add(),
which is called from either netvsc_change_mtu() or netvsc_probe().

The change_mtu() and netvsc_link_change() are synchronized by rtnl_lock().
In netvsc_probe(), the status query & complete happens before register_netdev(), and
the netvsc_linkstatus_callback() schedules the work only after netdevice is registered.
So, there are no race in either case.

The carrier_on/off work will be scheduled when netvsc_open() is called. Then,
the status will be updated based on the latest link_state.

Thanks,
- Haiyang

