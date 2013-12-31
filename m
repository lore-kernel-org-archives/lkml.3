Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab3LaTW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:22:58 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab3LaTW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:22:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: jjhiblot@traphandler.com, nicolas.ferre@atmel.com,
        jean-jacques hiblot <jean-jacques.hiblot@jdsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] at91: dt: sam9261: Added DM9000 in the device tree
Date: Tue, 31 Dec 2013 20:19:51 +0100
Message-ID: <4526077.qASk8HSHKP@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <1388507534-10570-7-git-send-email-jjhiblot@traphandler.com>
References: <1388507534-10570-1-git-send-email-jjhiblot@traphandler.com> <1388507534-10570-7-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:U+taZpBlugsCjnNg6SdlvZ5rsSiTqCZWun/Ww8jOUtk
 RCQT1AYn5Q6uxXqBmwGYR7GtTEjxEZpgLXsMuD48zU7/s5AjHx
 Mtuvj7pfTrhRYbCBH1BcHawMlEhRM7t03KsIZ9SLd+9tXGSS7K
 QlU8QLsQ9ot9GG7FJUyEpGbHSbz2jkhhX/fs8B3tiQQxfBiE7L
 H/pZy/30EmB9Jdq6efdebvFDF7ejk/7pd95FyW/3PxFu+sDXDc
 R05f82+NfZlmTUBo2wRoEOO0xUx+pgHhGWQ70xSrFNAtnbrUIc
 pJEVOauFPP1jNH7QimPfMN2Gjk4fx7qGqGE1Ry9w8/3Z13g/oj
 gMW9FDHk6Iht/5CIIT1A=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 December 2013 17:32:14 jjhiblot@traphandler.com wrote:
> 
> +                       ethernet@30000000 {
> +                               compatible = "davicom,dm9000";
> +                               reg = <0x30000000 0x2 0x30000004 0x2>;
> +                               interrupt-parent = <&pioC>;
> +                               interrupts = <11 IRQ_TYPE_EDGE_BOTH>;
> +                               local-mac-address = [00 00 de ad be ef];
> +                               davicom,no-eeprom;
> +
> +                               smc,cs = <2>;
> +                               smc,ncs_read_setup = <0>;
> +                               smc,nrd_setup = <2>;
> +                               smc,ncs_write_setup = <0>;
> +                               smc,nwe_setup = <2>;
> +                               smc,ncs_read_pulse = <8>;
> +                               smc,nrd_pulse = <4>;
> +                               smc,ncs_write_pulse = <8>;
> +                               smc,nwe_pulse = <4>;
> +                               smc,read_cycle = <16>;
> +                               smc,write_cycle = <16>;
> +                               smc,tdf_cycles = <1>;
> +                               smc,tdf_optimized = <0>;
> +                               smc,page_size = <0>;
> +                               smc,byte_access_type = <1>;
> +                               smc,bus_width = <1>;
> +                               smc,nwait_mode = <0>;
> +                               smc,read_mode = <1>;
> +                               smc,write_mode = <1>;
> +                       };

I don't like how this forces you to mix the properties
of the ethernet device with the properties of the smc
port. I would also like to see the address translation
reflected in the DT nodes. This should probably just work
out if you restructure the DT representation, and won't need
changes in the driver.

How about this:

	smc: smc@ffffec00 {
		#address-cells = <2>; /* cs, address */
		#size-cells = <1>;
		ranges = <2 0 0x30000000 0x10000000>
			 <3 0 0x40000000 0x10000000>;

		extbus@2.0 {
			compatible = "simple-bus";
			#address-cells = <1>;
			#size-cells = <1>;
			ranges = <0 2 0 0x10000000>;
			smc,ncs_read_setup = <0>;
			smc,nrd_setup = <2>;
			smc,...

			ethernet@0 {
				compatible = "davicom,dm9000";
				reg = <0x0 0x2> <0x4 0x2>;
			};
		};
	};

If each bus interface has a fixed range of registers, you can actually
collapse the upper two nodes again and just have one device per
chipselect.

	Arnd
