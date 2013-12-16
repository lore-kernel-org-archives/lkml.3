Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977Ab3LPR4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:56:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3LPR4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:56:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Ianovich <ynvich@gmail.com>
Subject: Re: [PATCH v2 00/16] ARM: support for ICP DAS LP-8x4x (with dts)
Date: Mon, 16 Dec 2013 18:56:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Daniel Mack <zonque@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com> <201312150355.27755.arnd@arndb.de> <1387198885.13062.154.camel@host5.omatika.ru>
In-Reply-To: <1387198885.13062.154.camel@host5.omatika.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201312161856.11384.arnd@arndb.de>
X-Provags-ID: V02:K0:5aEJMp1kv8jXXfhS35tDlrxDmzw63bcKwimOlMTLwHd
 At5v8qukQ7A9Nf+gJJybJ5Y8GhUxi40Cr1y2Go89lRUFtjfl3E
 L5ixEjbxBYRZ3mHhzWHa2TwzrhnOdiUAvHyAcz+ybkrwuRV8+J
 i1uydNxc3AXxz4bdRPf68CYwJcM0yPDWL3QktY5mhM59709UYd
 3QUGq5/EfuAMBXIIYdImVF3CtzZTKc4DrTg9f2YDNlfus6N59y
 65aJuYiOxxmxy72ohF8dLu6TtMEDSjCxEq/OJQIfYu5xjL5Yx0
 P/Pzwq3xQVvtF/yZLwpbHaNw/+/NYWvw/yG/HXU8ESHHsGaXE3
 H+K4dUlOk1wv96s8hVS4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 December 2013, Sergei Ianovich wrote:
> PXA27x memory bus can have up to 10 devices: up to 6 slower
> flash/SRAM/variable-latency-IO selected by nCS<0> to <5>, and up to 4
> partions of SDRAM selected by nSDCS<0> to <3>.
> 
> It appears that the FPGA is directly connected to the memory bus and is
> selected by nCS<5>. According to MSC2 configuration (already in the
> mainstream U-Boot), the FPGA is configured as a synchronous SRAM with
> access cycle of 30x memory bus cycles. So I made it a top-level bus like
> pxabus.
> 
> Ethernet devices are also connected to the memory bus via some kind of
> gate array. This one is a bit faster -- 15x memory cycles, which is
> still a lot. It explains why network transfers are never faster than 15
> Mbit/s.

Ok, I see. This sounds like some of the other platforms we have with
external memory buses. If there is a chance that Linux ever has to
program the per-CS settings into the bus controller, I would suggest
to represent that as well as a separate node, like this

extbus {
	compatible = "simple-bus";

	#address-cells = <2>; /* first cell is nCS, second is address */
	#size-cells = <1>;

	ranges = <0 0 0 0x04000000>
		 <1 0 0x04000000 0x04000000>
		 <2 0 0x08000000 0x04000000>
		 <3 0 0x0c000000 0x04000000>
	  	 <4 0 0x10000000 0x04000000>
	  	 <5 0 0x14000000 0x04000000>;

	timings = ...;

	flash@0 {
		reg = <0 0x0 0x02000000>;
		...
	};

	flash@1 {
		reg = <1 0x0 0x02000000>;
		...
	};

	fpga@5 {
		#address-cells = <1>;
		#size-cells = <1>;
		ranges = <0 5 0x03000000 0x10000>;
		...
	};
};

In case there is a driver for the extbus node, I would not make it
"simple-bus" but instead add a separate compatible string to match
the driver, and let that driver call of_platform_populate
to probe the children after the bus is set up.

	Arnd
