Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaAMRCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:02:48 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47784 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaAMRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:02:42 -0500
Message-ID: <52D41C2F.3050308@wwwdotorg.org>
Date: Mon, 13 Jan 2014 10:02:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: tegra1x4: initialize at arch_initcall time
References: <1389401416-29892-1-git-send-email-abrestic@chromium.org>
In-Reply-To: <1389401416-29892-1-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 05:50 PM, Andrew Bresticker wrote:
> Many devices rely on pinctrl/pinmux settings being applied
> before probing and some of these may probe before device_initcall
> time (e.g. i2c at subsys_initcall).  Move Tegra1x4 pinctrl driver
> registration to arch_initcall time so that proper pin settings
> can be applied earlier.

NAK. We shouldn't play games with initcall levels to achieve probe
ordering. It's not scalable and there's no actual guarantee it'll
produce the desired result.

Instead, if one device depends on another, it should do so explicitly.
In other words, the device that relies on a particular pinctrl setting
should have a pinctrl state defined, that references the pin controller,
which then triggers deferred probe until the pin controller is initialized.

Since we initialize the whole pinctrl setup in one go in a state
associated with the pin controller, rather than as separate states
associated with each device, you'll need to have the leaf devices
reference an empty pinctrl state defined in the desired pin controller.
