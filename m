Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3FMWCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 18:02:06 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36991 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798Ab3FMWCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 18:02:05 -0400
Message-ID: <51BA4158.906@wwwdotorg.org>
Date: Thu, 13 Jun 2013 16:02:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH 1/3] drivers: pinctrl sleep and idle states in the core
References: <1370439873-30053-1-git-send-email-linus.walleij@stericsson.com> <51AF73E9.90506@wwwdotorg.org> <CACRpkdY_s_RkErKLqVOWdE-A80CZOq7+VZSE8jcYSUbYkvsYYQ@mail.gmail.com>
In-Reply-To: <CACRpkdY_s_RkErKLqVOWdE-A80CZOq7+VZSE8jcYSUbYkvsYYQ@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 02:28 AM, Linus Walleij wrote:
> On Wed, Jun 5, 2013 at 7:22 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>>> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
>>
>>> +int pinctrl_pm_select_default_state(struct device *dev)
>>
>>> +int pinctrl_pm_select_sleep_state(struct device *dev)
>>
>>> +int pinctrl_pm_select_idle_state(struct device *dev)
>>
>> The implementation of those 3 functions is basically identical. I'd be
>> inclined to move it to a helper function, and just pass (dev,
>> pins->xxx_state) to it.
> 
> Just to follow up on this now that I'm adding one more state.
> 
> I tried to create a refactoring patch for this but couldn't come
> up with anything apropriate along the lines above. For example
> this function:
...

Don't you just want something very roughly like:

int pinctrl_pm_select_xxx_state(struct device *dev,
		unsigned long offset, char *name)
{
	struct dev_pin_info *pins = dev->pins;
	struct pinctrl_state **s = (void *)(((char *)pins) + offset)
	int ret;

	if (!pins)
		return 0;
	if (IS_ERR(*s))
		return 0; /* No default state */
	ret = pinctrl_select_state(pins->p, *s);
	if (ret)
		dev_err(dev, "failed to activate %s pinctrl state\n",
			name);
	return ret;
}

int pinctrl_pm_select_default_state(struct device *dev)
{
    return pinctrl_pm_select_xxx_state(dev,
		offsetof(struct dev_pin_info, default_state),
		"default");
}

