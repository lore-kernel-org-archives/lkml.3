Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040Ab3DBXRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 19:17:48 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:42276 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab3DBXRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 19:17:46 -0400
Message-ID: <515B6717.1060602@wwwdotorg.org>
Date: Tue, 02 Apr 2013 17:17:43 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 RESEND 0/6] arm: vt8500: Add support for pinctrl/gpio
 module
References: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1364877661-26086-1-git-send-email-linux@prisktech.co.nz>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 10:40 PM, Tony Prisk wrote:
> Sorry - got Linus W's email address wrong in first send.
> 
> v4 changes:
> Changed as requested by Stephen Warren:
> Corrected the range checking in of_property_read_u32_index().
> Fix configs[0] assignment in wmt_pctl_dt_node_to_map_pull().
> Move the platform memory mapping from per-soc to common init.
> Drop the custom .of_xlate function and use the default of_gpio_simple_xlate.

Those changes all look fine.

> Remove the kfree(maps) call, and use devm_kzalloc to simplify the fail path.

I'm not sure that's a good idea.

The issue is that dt_node_to_maps() is called every time a pinctrl
consumer is probed, whereas the devm_kzalloc() call in dt_node_to_maps()
uses the pinctrl device itself, not the pinctrl consumer device.. Each
client's probe() could be deferred a few times. Hence, you may end up
accumulating all those map entries from the deferred probes, until the
pinctrl driver itself is remove()d. Similarly, if you unload/load a
(pinctrl client) driver module over and over, the same thing will happen.

Oh, and you left the following in there too:

> +static void wmt_pctl_dt_free_map(struct pinctrl_dev *pctldev,

> +	kfree(maps);

