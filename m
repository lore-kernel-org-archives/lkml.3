Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3EQCof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 22:44:35 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6124 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab3EQCod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 22:44:33 -0400
From: "Narasimhan, Sriram" <sriram.narasimhan@hp.com>
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "mst@redhat.com" <mst@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] virtio-net: Reporting traffic queue distribution
 statistics through ethtool
Thread-Topic: [PATCH] virtio-net: Reporting traffic queue distribution
 statistics through ethtool
Thread-Index: AQHOUnRROqlWPQC0RUqZ2SjO0KuUmJkIWQqAgABPt/A=
Date: Fri, 17 May 2013 02:42:40 +0000
Message-ID: <228BD1969E90E94D8805535E22CE8EFF063CE9E9@G9W0717.americas.hpqcorp.net>
References: <1368735869-31076-1-git-send-email-sriram.narasimhan@hp.com>
 <1368740855.2655.57.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1368740855.2655.57.camel@bwh-desktop.uk.solarflarecom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.17]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4H2j52Q026550

Thanks for the pointer to the earlier discussion thread.
I am open to any consensus format.  I would also like to
get feedback from Michael on maintaining the stats in the
per-queue data structure.

Sriram

-----Original Message-----
From: Ben Hutchings [mailto:bhutchings@solarflare.com] 
Sent: Thursday, May 16, 2013 2:48 PM
To: Narasimhan, Sriram
Cc: mst@redhat.com; rusty@rustcorp.com.au; virtualization@lists.linux-foundation.org; kvm@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: Reporting traffic queue distribution statistics through ethtool

On Thu, 2013-05-16 at 13:24 -0700, Sriram Narasimhan wrote:
> This patch allows virtio-net driver to report traffic distribution
> to inbound/outbound queues through ethtool -S.  The per_cpu
> virtnet_stats is split into receive and transmit stats and are
> maintained on a per receive_queue and send_queue basis.
> virtnet_stats() is modified to aggregate interface level statistics
> from per-queue statistics.  Sample output below:
> 
> NIC statistics:
>      rxq0: rx_packets: 4357802
>      rxq0: rx_bytes: 292642052
>      txq0: tx_packets: 824540
>      txq0: tx_bytes: 55256404
>      rxq1: rx_packets: 0
>      rxq1: rx_bytes: 0
>      txq1: tx_packets: 1094268
>      txq1: tx_bytes: 73328316
>      rxq2: rx_packets: 0
>      rxq2: rx_bytes: 0
>      txq2: tx_packets: 1091466
>      txq2: tx_bytes: 73140566
>      rxq3: rx_packets: 0
>      rxq3: rx_bytes: 0
>      txq3: tx_packets: 1093043
>      txq3: tx_bytes: 73246142
> 
> Signed-off-by: Sriram Narasimhan <sriram.narasimhan@hp.com>
[...]

That ordering is totally unreadable.  I want to see patches for ethtool
to let the user order and aggregate the queue statistics in a sensible
way:

$ ethtool -S eth0                   # default would show aggregated statistics
NIC statistics:
	rx_packets: 4357802
	rx_bytes: 292642052
	tx_packets: 4103317
	tx_bytes: 274971428

$ ethtool -S eth0 full group queue  # full statistics, grouped by queue name
NIC statistics:
rxq0:
	rx_packets: 4357802
	rx_bytes: 292642052
rxq1:
	rx_packets: 0
	rx_bytes: 0
[...]
txq0:
	tx_packets: 824540
	tx_bytes: 55256404
txq1:
	tx_packets: 1094268
	tx_bytes: 73328316
[...]

$ ethtool -S eth0 full group statistic  # full statistics, grouped by statistic name
NIC statistics:
rx_packets:
	rxq0: 4357802
	rxq1: 0
	rxq2: 0
	rxq3: 0
rx_bytes:
	rxq0: 292642052
	rxq1: 0
	rxq2: 0
	rxq3: 0
[...]

Maybe even:

$ ethtool -S eth0 full table
NIC statistics:
	rx_packets   rx_bytes
rxq0:      4357802  292642052
rxq1:            0          0
rxq2:            0          0
rxq3:            0          0
	tx_packets   tx_bytes
txq0:       824540   55256404
txq1:      1094268   73328316
txq2:      1091466   73140566
txq3:      1093043   73246142

(Difficult to do, but probably very useful!)

The queue names should be rx-<index> and tx-<index> like in sysfs.

We'll need to reach a consensus on the naming scheme for per-queue and
otherwise disaggregated statistics (see previous discussions in
<http://thread.gmane.org/gmane.linux.kernel.virtualization/15572/focus=15608>).  I don't much care what they look like as long as there's an implementation for the ethtool side and they don't look too awful in older versions of ethtool.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
