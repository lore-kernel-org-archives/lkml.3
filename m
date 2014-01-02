Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaABRfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:35:13 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:3199 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaABRfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:35:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 02 Jan 2014 09:35:36 -0800
Message-ID: <52C5A344.2060908@nvidia.com>
Date: Thu, 2 Jan 2014 09:35:00 -0800
From: Matthew Longnecker <mlongnecker@nvidia.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.power-management.general,gmane.linux.drivers.devicetree,gmane.linux.drivers.sensors,gmane.linux.kernel
To: Eduardo Valentin <eduardo.valentin@ti.com>, <swarren@wwwdotorg.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>
CC: <wni@nvidia.com>, <grant.likely@linaro.org>, <durgadoss.r@intel.com>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv9 02/20] thermal: introduce device tree parser
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com> <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1384285582-16933-3-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduardo,

For the most part, this binding is really well thought out. It makes a 
lot of sense to me (as someone who has been working with thermal 
management in Linux/Android-based mobile devices for a few years).

However, I have one substantive criticism.

On 11/12/2013 11:46 AM, Eduardo Valentin wrote:
> +* Thermal zone nodes
> +
> +The thermal zone node is the node containing all the required info
> +for describing a thermal zone, including its cooling device bindings. The
> +thermal zone node must contain, apart from its own properties, one sub-node
> +containing trip nodes and one sub-node containing all the zone cooling maps.
> +
> +Required properties:
...
> +- thermal-sensors:	A list of thermal sensor phandles and sensor specifier
> +  Type: list of 	used while monitoring the thermal zone.
> +  phandles + sensor
> +  specifier
...
> +Optional property:
> +- coefficients:		An array of integers (one signed cell) containing
> +  Type: array		coefficients to compose a linear relation between
> +  Elem size: one cell	the sensors listed in the thermal-sensors property.
> +  Elem type: signed	Coefficients defaults to 1, in case this property
> +			is not specified. A simple linear polynomial is used:
> +			Z = c0 * x0 + c1 + x1 + ... + c(n-1) * x(n-1) + cn.
> +
> +			The coefficients are ordered and they match with sensors
> +			by means of sensor ID. Additional coefficients are
> +			interpreted as constant offset.


"coefficients" is a problematic way of describing the relationship 
between temperatures at various sensors and temperature at some other 
location. It would make sense if heat flowed infinitely quickly. 
However, in practice thermal capacitance means that we need to take into 
account the _history_ of temperature at sensors in order to predict heat 
coupled into a distant point.

For example, assuming that handset enclosure starts at ~25C, the CPU 
could burst to 100C for many minutes before the handset enclosure 
reaches ~40C. However, at steady-state, the CPU might only be able to 
sustain 65C without pushing the enclosure above 40C.

I wouldn't be complaining except that you're proposing this as a DT 
definition. In this case, the binding you've proposed is poor 
abstraction of the hardware.

thanks,
Matt Longnecker

p.s. I apologize for chiming in without having read the entire history 
of the patch set. Engineers on my team will be trying this out for Tegra 
within the next few weeks.
