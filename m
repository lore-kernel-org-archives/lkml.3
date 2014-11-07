Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaKGPiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 10:38:14 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44416 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaKGPiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 10:38:10 -0500
Message-ID: <545CE75C.8000408@collabora.co.uk>
Date: Fri, 07 Nov 2014 16:38:04 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/5] regulator: Document binding for initial and suspend
 modes
References: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk> <1415365205-27630-2-git-send-email-javier.martinez@collabora.co.uk> <20141107145806.GQ8509@sirena.org.uk>
In-Reply-To: <20141107145806.GQ8509@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

Thanks a lot for your feedback.

On 11/07/2014 03:58 PM, Mark Brown wrote:
> On Fri, Nov 07, 2014 at 02:00:01PM +0100, Javier Martinez Canillas wrote:
> 
>> +	  The "regulator-mode" property only takes effect if the regulator is
>> +	  enabled for the given suspend state using "regulator-on-in-suspend".
> 
> Why?
> 

I saw that the regulator core only call the .set_suspend_mode callback if
the regulator is either enabled or disabled explicitly...

static int suspend_set_state(struct regulator_dev *rdev,
	struct regulator_state *rstate)
{
	....
	/* If we have no suspend mode configration don't set anything;
	 * only warn if the driver implements set_suspend_voltage or
	 * set_suspend_mode callback.
	 */
	if (!rstate->enabled && !rstate->disabled) {
		if (rdev->desc->ops->set_suspend_voltage ||
		    rdev->desc->ops->set_suspend_mode)
			rdev_warn(rdev, "No configuration\n");
		return 0;
	}
	...
	
};

>> +	  If the regulator has not been explicitly disabled for the given state
>> +	  with "regulator-off-in-suspend", then setting the operating mode
>> +	  will also have no effect.
> 
> This seems surprising, I'd expect mode setting to be paid attention to
> even if the regulator is off - we may add other ways to control the
> enable state in suspend for example.
> 

...and I thought that setting a mode if the regulator was disabled in suspend
was not a possible configuration, that's why I documented that.

I know that there is both a .set_suspend_disable and .set_suspend_mode but
at least in the hardware that I'm interested in (max77802), the same hw
register is used for setting a suspend mode and disable on suspend.

So if this is allowed and a user specifies both a disable on suspend and a
suspend mode, the later will overwrite the configuration of the former.

But now that I think about it, this is only a constraint of the max77802
and probably needs to be specified in the max77802 DT binding and not in
the regulator generic one since otherwise limits what other devices can
do.

>> +- regulator-initial-mode: initial operating mode. The set of possible operating
>> +  modes is the same used for the regulator-mode property and the device binding
>> +  documentation explains which property each regulator supports.
>> +If no mode is defined, then the OS will not manage the modes and the hardware
>> +default values will be used instead.
> 
> Again that seems surprising, it precludes any future changes and isn't
> going to be true for devices where we can't read the current state.
> 

I saw that you asked Chanwoo on an early version of his suspend states
series, to point out that in the absence of a initial state, the state is
the hardware default [0] so I thought that it should be the case for the
regulator suspend mode too.

So should I just explain what each property is about without trying to make
assumptions about the limitations that different devices could have and let
each device DT binding to specify those?

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/4/652 
