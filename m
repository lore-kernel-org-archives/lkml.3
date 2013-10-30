Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab3J3Au3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:50:29 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:55401 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3J3Au2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:50:28 -0400
X-IronPort-AV: E=Sophos;i="4.93,597,1378857600"; 
   d="scan'208";a="66081823"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH net-next RFC 0/5] xen-netback: TX grant mapping instead of copy
Date: Wed, 30 Oct 2013 00:50:15 +0000
Message-ID: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A long known problem of the upstream netback implementation that on the TX
path (from guest to Dom0) it copies the whole packet from guest memory into
Dom0. That simply became a bottleneck with 10Gb NICs, and generally it's a
huge perfomance penalty. The classic kernel version of netback used grant
mapping, and to get notified when the page can be unmapped, it used page
destructors. Unfortunately that destructor is not an upstreamable solution.
Ian Campbell's skb fragment destructor patch series
(http://lwn.net/Articles/491522/) tried to solve this problem, however it
seems to be very invasive on the network stack's code, and therefore haven't
progressed very well.
This patch series use SKBTX_DEV_ZEROCOPY flags to tell the stack it needs to
know when the skb is freed up. That is the way KVM solved the same problem,
and based on my initial tests it can do the same for us. Avoiding the extra
copy boosted up TX throughput from 6.8 Gbps to 7.9 (I used a slower
Interlagos box, both Dom0 and guest on upstream kernel, on the same NUMA node,
running iperf 2.0.5, and the remote end was a bare metal box on the same 10Gb
switch)
Based on my investigations the packet get only copied if it is delivered to
Dom0 stack, which is due to this patch:
https://lkml.org/lkml/2012/7/20/363
That's a bit unfortunate, but as far as I know for the huge majority this use
case is not too important. There are a couple of things which need more
polishing, see the FIXME comments. I will run some more extensive tests, but
in the meantime I would like to hear comments about what I've done so far.
I've tried to broke it down to smaller patches, with mixed results, so I
welcome suggestions on that part as well:
1/5: Introduce TX grant map definitions
2/5: Change TX path from grant copy to mapping
3/5: Remove old TX grant copy definitons
4/5: Fix indentations
5/5: Change RX path for mapped SKB fragments

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

