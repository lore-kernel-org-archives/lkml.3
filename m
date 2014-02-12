Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaBLQiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:38:54 -0500
Received: from mx0.aculab.com ([213.249.233.131]:45571 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753155AbaBLQiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:38:52 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Michal Simek'" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Srikanth Thokala <sthokal@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Michal Simek <monstr@monstr.eu>,
        "Anirudha Sarangi" <anirudh@xilinx.com>,
        John Linn <John.Linn@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/14] net: axienet: Service completion interrupts ASAP
Thread-Topic: [PATCH 05/14] net: axienet: Service completion interrupts ASAP
Thread-Index: AQHPKAyNveH31gmZlkKmADz9sJ5s6JqxzqpA
Date: Wed, 12 Feb 2014 16:38:36 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6BDFEE@AcuExch.aculab.com>
References: <cover.1392220536.git.michal.simek@xilinx.com>
 <cafb13f2ebe4bb996bafb91e405d8609454bb920.1392220536.git.michal.simek@xilinx.com>
In-Reply-To: <cafb13f2ebe4bb996bafb91e405d8609454bb920.1392220536.git.michal.simek@xilinx.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek
> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> 
> The packet completion interrupts for TX and RX should be serviced before
> the packets are consumed. This ensures against the degenerate case when a
> new completion interrupt is raised after the handler has exited but before
> the interrupts are cleared. In this case its possible for the ISR to clear
> an unhandled interrupt (leading to potential deadlock).

I would clear the IRQ after processing the last packet, and then do a final
check for another packet.

That reduces the number of interrupts you take and then find there is
no work (because it was done on the previous interrupt).

There is a slight 'gotcha' in that the write to clear the IRQ can easily
get delayed enough the that cpu exits the ISR before the IRQ line
actually drops - leading the unwanted and unclaimed interrupts.
A posted write over PCIe could easily take long enough.

Maybe a hybrid scheme where the IRQ is cleared when the next entry
is still owned by the device would work.

	David



