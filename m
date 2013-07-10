Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab3GJKgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 06:36:01 -0400
Received: from eu1sys200aog123.obsmtp.com ([207.126.144.155]:32960 "EHLO
	eu1sys200aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753545Ab3GJKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 06:35:57 -0400
Message-ID: <51DD370C.20902@st.com>
Date: Wed, 10 Jul 2013 11:27:24 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com> <201307090956.03191.arnd@arndb.de> <51DBE718.2080007@st.com> <201307092315.06131.arnd@arndb.de>
In-Reply-To: <201307092315.06131.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
On 09/07/13 22:15, Arnd Bergmann wrote:
>> For DT case, At the moment I think callbacks at MACH level is one
>> > possible solution. But am open for any discussions.
> Ok, so a PHY driver might not be the best place to put this, but it's
> one option, since the PHY driver already has to know about the
> interface speed you are setting.
> 
> Having a global "*_setup_ethernet" callback is definitely not the
> right way to go. Please describe what the function actually does
> so we can come up with the right subsystem to move that functionality
> to. If you are setting clocks, you should use the clock subsystem,
> for taking the device out of reset, you should use the reset controller
> subsystem and for setting up the phy, you should use the phy subsystem,
> etc.

The purpose of this callback is to do three things.

	1> Configuring the MAC signals to select particular PHY interface mode.
MAC signals(wires) are wired up to this Ethernet Configuration register.

	2> Select synchronisation clock for data lines retiming. On High speed
interfaces track length/layouts on the boards can directly influence the
signal quality and introduce bit shifts or other errors. So SoC has
additional logic to retime these signals and improve the data
reliability. As there is possibility of multiple clock sources (MAC,
PHY) a correct choice of synchronization clock is made in Ethernet
configuration register. For 125 Mhz clock in Gbit mode, reference clock
is provided by the PHY in other case like 100bit and 10bit, 50MHz, 25MHz
clocks is provide by the MAC.
So this bits depend/driven based on the PHYMODEs and Link Speed.

	3> Ethernet Soft reset in Ethernet control register.
		Which can probably go into via reset controller driver.


For point 1 and 2, there is no subsystem in the kernel which can
accommodate these kind of SOC specific bits setup. Am not sure if other
platforms have similar SoC setup use cases?

For point 3, I can go for reset controller API.

Just for your reference (Sorry and Please ignore if Its too detailed),
Ethernet configuration register looks like:
Bit to configure signals connected to MAC.
	[5] ENMII1: when 1, MII mode
		when 0, Reverse MII mode
	[4:2] MII1_PHY_SEL:
		000: GMII/MII (default)
		001: RGMII
		010: SGMII
		100: RMII

Bit to configure retiming clock for retiming data lines:
	[8] ETH1_SEL_TX_RETIMING_CLK: Selection of the clock used to retime TX data
		0: clock selected by ETH1_SEL_TXCLK_NOT_CLK125 bit
		1: clock fed to or provided by MII_PHYCLK depending
		on eth1_sel_internal_notext_phyclk setting
	[7] ETH1_SEL_INTERNAL_NOTEXT_PHYCLK: Selection of internal clock or
external clock from MII_PHYCLK for retiming in RMII mode
		0: external clock (Beware that eth1_sel_tx_retiming_clk
		bit must also be programmed).
		1: internal clock (from clockgenA)
	[6] ETH1_SEL_TXCLK_NOT_CLK125: Selection of the clock used to
	retime TX data
		0: MII1_CLK_125 (beware that eth1_sel_tx_retiming_clk bit must also be
programmed)
		1: MII1_TXCLK

Thanks,
srini
