Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaGKPZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:25:39 -0400
Received: from na01-by1-obe.ptr.o365filtering.com ([64.4.22.94]:46906 "EHLO
	na01-by1-obe.outbound.o365filtering.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751459AbaGKPZh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:25:37 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
CC: KY Srinivasan <kys@microsoft.com>, "David S. Miller" <davem@davemloft.net>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy
 in 3.14+ on Hyper-V 2012 R2
Thread-Topic: [BISECTED][REGRESSION] Loading Hyper-V network drivers is racy
 in 3.14+ on Hyper-V 2012 R2
Thread-Index: AQHPmVd2lonpWupwu0Spl7Lqc9fFbZuU0/7ggACNCICABXpggIAAJvuQ
Date: Fri, 11 Jul 2014 15:25:11 +0000
Message-ID: <52afbe119b1a481aa1c80f909c3a2432@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
References: <20140706201800.GA10587@sucs.org>
 <941b0055b1a94c66b3a608ae67764d11@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
 <20140707181341.GA2646@sucs.org> <20140711055259.GA10317@sucs.org>
In-Reply-To: <20140711055259.GA10317@sucs.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.51.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.159.99;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(51914003)(377454003)(13464003)(164054003)(189002)(199002)(15975445006)(47776003)(68736004)(50466002)(20776003)(77982001)(64706001)(4396001)(93886003)(87936001)(79102001)(85852003)(83072002)(84676001)(66066001)(2656002)(21056001)(33646001)(97736001)(44976005)(23726002)(19580405001)(2009001)(83322001)(19580395003)(97756001)(74502001)(80022001)(6806004)(110136001)(85326001)(86612001)(46102001)(31966008)(1411001)(99396002)(46406003)(106116001)(74662001)(81342001)(107046002)(106466001)(76482001)(54356999)(81542001)(92566001)(76176999)(50986999)(77096999)(108616002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2SR01MB592;H:hybrid.exchange.microsoft.com;FPR:;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02698DF457
X-OriginatorOrg: msft.ccsctp.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Friday, July 11, 2014 1:53 AM
> To: Haiyang Zhang
> Cc: KY Srinivasan; David S. Miller; devel@linuxdriverproject.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [BISECTED][REGRESSION] Loading Hyper-V network drivers is
> racy in 3.14+ on Hyper-V 2012 R2

> Oops that should have been
> https://bugzilla.kernel.org/attachment.cgi?id=142351 (either way it's
> information linked off
> https://bugzilla.kernel.org/show_bug.cgi?id=78771 ).

Thanks for the dmesg. By looking at it, seems the netvsc driver was loaded properly, and 2 NICs are up, one NIC is down (probably not set to connected in HyperV manager?). Or, this dmesg wasn't the one when bug happens?

[    8.514493] hv_netvsc: hv_netvsc channel opened successfully
[    9.343318] hv_netvsc vmbus_0_14: Send section size: 6144, Section count:170
[    9.345831] hv_netvsc vmbus_0_14: Device MAC 00:15:5d:6f:02:8f link state up

[    9.347101] hv_netvsc: hv_netvsc channel opened successfully
[   10.170308] hv_netvsc vmbus_0_15: Send section size: 6144, Section count:170
[   10.170702] hv_netvsc vmbus_0_15: Device MAC 00:15:5d:6f:02:a5 link state up

[   10.172826] hv_netvsc: hv_netvsc channel opened successfully
[   10.988146] hv_netvsc vmbus_0_16: Send section size: 6144, Section count:170
[   10.989069] hv_netvsc vmbus_0_16: Device MAC 00:15:5d:6f:02:a6 link state down

Since you found the commit b679ef73edc is related to this problem, could you do a simple test:
  Reduce the receive buffer size back to 2MB, like below, then re-test it, see if the problem goes away?
	drivers/net/hyperv/hyperv_net.h
	#define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*2)	/* 2MB */

Thanks,
- Haiyang

