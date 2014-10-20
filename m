Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaJTVbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:31:24 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:65098 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaJTVbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:31:21 -0400
From: Kevin Hilman <khilman@kernel.org>
To: "jinkun.hong" <jinkun.hong@rock-chips.com>
Cc: linus.walleij@linaro.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org, dianders@chromium.org,
        Heiko Stuebner <heiko@sntech.de>, linux-rockchip@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Jack Dai <jack.dai@rock-chips.com>
Subject: Re: [PATCH v4 1/3] power-domain: add power domain drivers for Rockchip platform
References: <1413795824-3453-1-git-send-email-jinkun.hong@rock-chips.com>
	<1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com>
Date: Mon, 20 Oct 2014 14:31:17 -0700
In-Reply-To: <1413795824-3453-2-git-send-email-jinkun.hong@rock-chips.com>
	(jinkun hong's message of "Mon, 20 Oct 2014 02:03:41 -0700")
Message-ID: <7hppdme8d6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"jinkun.hong" <jinkun.hong@rock-chips.com> writes:

> From: "jinkun.hong" <jinkun.hong@rock-chips.com>
>
> Add power domain drivers based on generic power domain for Rockchip platform,
> and support RK3288.
>
> Signed-off-by: Jack Dai <jack.dai@rock-chips.com>
> Signed-off-by: jinkun.hong <jinkun.hong@rock-chips.com>

[...]

> +static int rockchip_pmu_set_idle_request(struct rockchip_domain *pd,
> +					 bool idle)
> +{
> +	u32 idle_mask = BIT(pd->idle_shift);
> +	u32 idle_target = idle << (pd->idle_shift);
> +	u32 ack_mask = BIT(pd->ack_shift);
> +	u32 ack_target = idle << (pd->ack_shift);
> +	unsigned int mask = BIT(pd->req_shift);
> +	unsigned int val;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pd->idle_lock, flags);
> +	val = (idle) ? mask : 0;
> +	regmap_update_bits(pd->regmap_pmu, REQ_OFFSET, mask, val);
> +	dsb();

A summary of the locking and barriers here (or in changelog) would be
helpful for reviewers to verify you're protecting what you need to
protect.

> +	do {
> +		regmap_read(pd->regmap_pmu, ACK_OFFSET, &val);
> +	} while ((val & ack_mask) != ack_target);
> +
> +	do {
> +		regmap_read(pd->regmap_pmu, IDLE_OFFSET, &val);
> +	} while ((val & idle_mask) != idle_target);
> +
> +	spin_unlock_irqrestore(&pd->idle_lock, flags);

These IRQ-disabled while loops look like opportunities to lockup the
system.  Maybe add a timeout or a maximum number of tries?

> +	return 0;
> +}

Kevin
