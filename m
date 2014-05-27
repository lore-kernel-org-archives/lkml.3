Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaE0NGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:06:52 -0400
Received: from gloria.sntech.de ([95.129.55.99]:59619 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbaE0NGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:06:50 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        James Hogan <james.hogan@imgtec.com>,
        Stephen Warren <swarren@nvidia.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: Enable "power-source" to be extracted from DT files
Date: Tue, 27 May 2014 15:09:20 +0200
Message-ID: <2480893.UEqfxe8meR@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1401172056-25743-1-git-send-email-iivanov@mm-sol.com>
References: <CACRpkdZyLxMTSygRP6pD-mxghQ_D6tQ821tvn8GYw0Rnh9hZoQ@mail.gmail.com> <1401172056-25743-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 27. Mai 2014, 09:27:36 schrieb Ivan T. Ivanov:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Add "power-source" property to generic options used for DT parsing files.
> This  enables drivers, which use generic pin configurations, to get the
> value passed to this property.

I think the main problem here is, that pinconf-generic.h defines the power-
source as having a "custom format". With DT as a hardware description, 
implementaton specific values do not work well - instead it should have a 
regular unit-value.

For the power-source I think volts could work well - as this is the main use-
case for pinctrl I know. The regulator-binding uses microvolts, maybe it would 
be good use a similar unit.

So something along

--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
@@ -156,6 +156,7 @@ input-disable		- disable input on pin (no effect on
output) input-schmitt-enable	- enable schmitt-trigger mode
 input-schmitt-disable	- disable schmitt-trigger mode
 input-debounce		- debounce mode with debound time X
+power-source		- set power supply to X microvolts
 low-power-enable	- enable low power mode
 low-power-disable	- disable low power mode
 output-low		- set the pin to output mode with low level

and in the dt itself:

	pcfg_1v8 {
		power-source = <1800000>;
	};

And then the pinctrl driver being responsible to select an appropriate source 
for this voltage.

But I guess Linus knows more pinctrl corner-cases than me, so this may be 
entire rubbish :-) .


Heiko

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt | 1 +
>  drivers/pinctrl/pinconf-generic.c                              | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt index
> 4414163..fa40a17 100644
> --- a/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
> @@ -156,6 +156,7 @@ input-disable		- disable input on pin (no effect on
> output) input-schmitt-enable	- enable schmitt-trigger mode
>  input-schmitt-disable	- disable schmitt-trigger mode
>  input-debounce		- debounce mode with debound time X
> +power-source		- select between different power supplies
>  low-power-enable	- enable low power mode
>  low-power-disable	- disable low power mode
>  output-low		- set the pin to output mode with low level
> diff --git a/drivers/pinctrl/pinconf-generic.c
> b/drivers/pinctrl/pinconf-generic.c index 3d9a999..c7ead91 100644
> --- a/drivers/pinctrl/pinconf-generic.c
> +++ b/drivers/pinctrl/pinconf-generic.c
> @@ -166,6 +166,7 @@ static struct pinconf_generic_dt_params dt_params[] = {
>  	{ "input-schmitt-enable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 1 },
>  	{ "input-schmitt-disable", PIN_CONFIG_INPUT_SCHMITT_ENABLE, 0 },
>  	{ "input-debounce", PIN_CONFIG_INPUT_DEBOUNCE, 0 },
> +	{ "power-source", PIN_CONFIG_POWER_SOURCE, 0 },
>  	{ "low-power-enable", PIN_CONFIG_LOW_POWER_MODE, 1 },
>  	{ "low-power-disable", PIN_CONFIG_LOW_POWER_MODE, 0 },
>  	{ "output-low", PIN_CONFIG_OUTPUT, 0, },
> --
> 1.8.3.2

