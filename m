Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab3KVP6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:58:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:32936 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634Ab3KVP6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:58:50 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19OWCktmyAs2XnJFljyO9cT
Date: Fri, 22 Nov 2013 07:58:45 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joel Fernandes <joelf@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org,
        santosh.shilimkar@ti.com, jgchunter@gmail.com, rnayak@ti.com,
        balbi@ti.com
Subject: Re: [PATCH 6/8] devicetree: doc: Document ti,timer-parent property
Message-ID: <20131122155838.GF10023@atomide.com>
References: <1385085414-9034-1-git-send-email-joelf@ti.com>
 <1385085414-9034-7-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385085414-9034-7-git-send-email-joelf@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joel Fernandes <joelf@ti.com> [131121 18:00]:
> +Required properties for system timers (clockevents/clocksource):
> +- ti,timer-parent:	System timer's parent mux clock needs to be setup.
> +			This is currently hardcoded in code, for DT boot we
> +			move this to DT.
> +

This can be replaced with just clk_set_rate, or clk_set_parent if needed.
Or by having a clocks = <&32k_clk> property in the dmtimer node in the
.dts file.

>  Optional properties:
>  - ti,timer-alwon:	Indicates the timer is in an alway-on power domain.

Hmm this we may not need, this can probably be deciphered from the compatible
flag already?

Then for the users of a specific dmtimer, they can select the right one using
the interrupt-parent property:

timer1: timer@0x4800abcd {
	compatible = "ti,omap5430-timer";
	#interrupt-cells = <1>;		/* needs irqchip implemented for dmtimer */
	interrupt-controller;
	#clock-cells = <1>;		/* needs clocksource implemented for dmtimer */
	clock-output-names = "32k", "sys_ck";
	...
};

counter32k: counter@4ae04000 {
	compatible = "ti,omap-counter32k";
	#clock-cells = <1>;		/* needs clocksource implemented for 32k counter */
	clock-output-names = "32k";
	...
};

timer {
	compatible = "ti,omap5-timer";
	interrupt-parent = <&timer1>;
	interrupts = <1>;
	clocks = <&timer1 0>,		/* use timer1 as clockevent, clock index 0 = 32k, 1 = sys_ck ... */
		 <&counter32k 0>;	/* use 32k counter as clocksource */
};

>  - ti,timer-dsp:		Indicates the timer can interrupt the on-chip DSP in

This can be probably also be mapped based on the compatible property?

Regards,

Tony
