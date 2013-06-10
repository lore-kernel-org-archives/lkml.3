Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab3FJNwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:52:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56214 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3FJNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:52:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux@arm.linux.org.uk,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <rob.herring@calxeda.com>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Prisk <linux@prisktech.co.nz>
Subject: Re: [PATCH v2 07/11] ARM:stixxxx: Add STiH416 SOC support
Date: Mon, 10 Jun 2013 15:52:07 +0200
Message-ID: <3733079.FxbR14kFrs@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370856425-7135-1-git-send-email-srinivas.kandagatla@st.com>
References: <1370855828-5318-1-git-send-email-srinivas.kandagatla@st.com> <1370856425-7135-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Obu4nClBoz8p23BWbc03FBxojBcMFHr0FNADEJHrvvX
 x5+WseMB13T/tkhqO6Bm3AuuOSnBzH2827xgUIYYsYhcnqwApT
 OYhnFkiSztMK0J6nUTkqv8LptWu7J7srSo3eHD08wmWa1+PEht
 THg4zxeN5WLCzNYJ840XmmTHsYfMQbZbvj0S0XRx8AAIRDyZo+
 uAYEAuC8yCq0Uj6mcJdbZYMzNPJWm5YfvZXBUfye16ehC3XUPu
 YnRTmbgez+MCdF9EKhpBuqaTBtJU9vJB4D2oCHKKHkuZJtBMAe
 m/jHdtHkpOIgupsRUwe5gT94NPfHCt67Kl3qg3zqzbXfIsls5A
 CklWUDZYeQ6abiCV/dWw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 June 2013 10:27:05 Srinivas KANDAGATLA wrote:

> +	soc {
> +		pin-controller-sbc {
> +			#address-cells	= <1>;
> +			#size-cells	= <1>;
> +			compatible	= "st,stih416-pinctrl", "simple-bus";

Why is this both its own device with a compatible string and a
"simple-bus" at the same time? Wouldn't it be simpler to just
scan the child device nodes from the "st,stih416-pinctrl"
driver instead of having a separate platform_driver for them?

> +			st,retime-in-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
> +			st,retime-out-delay	= <0 300 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250>;
> +			st,syscfg		= <&syscfg_sbc>;
> +			st,syscfg-offsets	= <0 40 50 60 100>;
> +			ranges;
> +			PIO0: pinctrl@fe610000 {
> +				#gpio-cells = <1>;
> +				compatible = "st,stixxxx-gpio";
> +				gpio-controller;
> +				reg = <0xfe610000 0x100>;
> +				st,bank-name  = "PIO0";
> +				st,retime-pin-mask = <0xff>;
> +			};
> +			PIO1: pinctrl@fe611000 {
> +				#gpio-cells	= <1>;
> +				compatible	= "st,stixxxx-gpio";
> +				gpio-controller;
> +				reg = <0xfe611000 0x100>;
> +				st,bank-name  = "PIO1";
> +				st,retime-pin-mask = <0xff>;
> +			};

What is in the ranges between these registers? It seems you have
256 bytes for each pinctrl node, with 4kb spacing. I wonder if
it would make sense to declare the entire range to belong to a single
pinctrl device. At least since all of the registers are in a single
range, you could add a property like

	ranges = <0 0xfe610000 0x10000>;

and use relative addresses in the sub-nodes.

Please don't use identifiers with 'xxx' in them. Instead use numbers
of actual chips, ideally using the first one that this is compatible
with.

> +		syscfg_sbc:syscfg@fe600000{
> +			compatible	= "st,stih416-syscfg";
> +			reg		= <0xfe600000 0x1000>;
> +			syscfg-range	= <0 999>;
> +			syscfg-name	= "SYSCFG_SBC";
> +		};
> +		syscfg_front:syscfg@fee10000{
> +			compatible	= "st,stih416-syscfg";
> +			reg		= <0xfee10000 0x1000>;
> +			syscfg-range	= <1000 999>;
> +			syscfg-name	= "SYSCFG_FRONT";
> +		};

Did you mean to declare ranges excluding 1000 and 2000 here?
Normally I would expect inclusive ranges like syscfg-range=<0 1000>;

What is the idea of the 'syscfg-name'? If the nodes are all different,
I would expect them to have distinct "compatible" values and not
need them.

	Arnd
