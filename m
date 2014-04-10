Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934845AbaDJJQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:16:27 -0400
Received: from mail-db3lp0083.outbound.protection.outlook.com ([213.199.154.83]:39302
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933057AbaDJJQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:16:23 -0400
From: "Nekludov, Max" <Max.Nekludov@elster.com>
To: David Miller <davem@davemloft.net>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "mjr@cs.wisc.edu" <mjr@cs.wisc.edu>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@rustcorp.com.au" <trivial@rustcorp.com.au>
Subject: RE: ks8851: reset on RX failure and TX timeout
Thread-Topic: ks8851: reset on RX failure and TX timeout
Thread-Index: AQHPTj0g4r3kb9B8SEScXkvKt8zPXZsAKMaAgApu+k8=
Date: Thu, 10 Apr 2014 09:16:20 +0000
Message-ID: <28499d90be6a410f9a24d64b76a5c262@DB3PR02MB202.eurprd02.prod.outlook.com>
References: <b703c70840da4780bc93beed79a8503b@DB3PR02MB202.eurprd02.prod.outlook.com>
	<20140401.181355.1375673242692769955.davem@davemloft.net>
	<e095559e0b69441eb44fecc7e8639a71@DB3PR02MB202.eurprd02.prod.outlook.com>,<20140403.133203.1056561986987869608.davem@davemloft.net>
In-Reply-To: <20140403.133203.1056561986987869608.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [78.24.157.30]
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(377454003)(189002)(199002)(51704005)(19580395003)(74662001)(74502001)(31966008)(19580405001)(83322001)(83072002)(85852003)(80976001)(92566001)(2656002)(80022001)(81542001)(66066001)(81342001)(20776003)(76576001)(79102001)(86362001)(74316001)(76482001)(33646001)(77982001)(4396001)(99396002)(46102001)(87936001)(54356999)(50986999)(76176999)(77096999)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB3PR02MB204;H:DB3PR02MB202.eurprd02.prod.outlook.com;FPR:E530F113.34DE68A9.70FC57B0.C0922848.2024E;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: elster.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've tried to use ndo_tx_timeout. Actually it works. But it takes too long time after TX failure and before watchdog fires.

As I understand ndo_tx_timeout will be called only if tx queue is stopped. But ks8851 driver stops queue only after it's full.
So one have to  send a lot of data to reset device (~6KiB).

But I need to recover as fast as possible. Could you suggest how to achieve that?
________________________________________
From: David Miller <davem@davemloft.net>
Sent: Thursday, April 3, 2014 9:32 PM
To: Nekludov, Max
Cc: torvalds@linux-foundation.org; netdev@vger.kernel.org; sboyd@codeaurora.org; mjr@cs.wisc.edu; jiri@resnulli.us; linux-kernel@vger.kernel.org; trivial@rustcorp.com.au
Subject: Re: ks8851: reset on RX failure and TX timeout

From: "Nekludov, Max" <Max.Nekludov@elster.com>
Date: Wed, 2 Apr 2014 06:31:23 +0000

> Electromagnetic noise can make device to not send TX interrupts.
> As result outgoing queue will be suspended forever.
> Also EMI can raise RX interrupt with zero value in KS_RXFC register.
>
> Signed-off-by: Max Nekludov <Max.Nekludov@elster.com>

We have a watchdog facility for TX timeouts, don't reinvent the wheel.

Implement ->ndo_tx_timeout() and set dev->watchdog_timeo appropriately.
