Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3EUO0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:26:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:16523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753114Ab3EUO0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:26:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,714,1363158000"; 
   d="scan'208";a="341118674"
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Subject: [PATCH v4 net-next 0/4] net: low latency Ethernet device polling
To: Dave Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 17:26:41 +0300
Message-ID: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave,

I believe that I addressed the issues that were raised.
Please look and see if you have more comments.

Thank you all for your input.

To prevent the use of a stale napi pointer, I implemented a global id
that should be incremented whenever a napi is freed.
I used the free space in skb's second bitfield (7 bits) since I did not
want to increase the size of the structure. In an earlier attempt to do
this I chopped the global id to seven bits but in testing, this would
crash on the wrap-around. 
Now if the seven bits that are in the skb match the global id, 
we save the un-chopped id in the socket.
(This removes the module parameter and the limit on unloading.)


is this how you prefer the change log?

change log
v4
- removed separate config option for TCP busy-polling as suggested Eric Dumazet.
- added linux mib counter for packets received through the low latency path.
- re-allow module unloading, remove module param, use a global generation id
  instead to prevent the use of a stale napi pointer, as suggested
  by Eric Dumazet
- updated Documentation/networking/ip-sysctl.txt text

v3
- coding style changes suggested by Dave Miller

v2
- the sysctl knob is now in microseconds. The default value is now 0 (off).
- for now the code depends at configure time on CONFIG_I86_TSC 
- the napi reference in struct skb is now a union with the dma cookie
  since the former is only used on RX and the latter on TX,
  as suggested by Eric Dumazet.
- we do a better job at honoring non-blocking operations.
- removed busy-polling support for tcp_read_sock()
- remove dynamic disabling of GRO
- coding style fixes
- disallow unloading the device module after the feature has been used

Thanks,
Eliezer
