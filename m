Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210AbaLKV6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:58:25 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:42804 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934012AbaLKV6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:58:21 -0500
MIME-Version: 1.0
In-Reply-To: <1418325511-16648-1-git-send-email-dianders@chromium.org>
References: <1418325511-16648-1-git-send-email-dianders@chromium.org>
Date: Thu, 11 Dec 2014 13:58:20 -0800
X-Google-Sender-Auth: usdnUbWS4JmUV3qbp2QApoDp6r0
Message-ID: <CAD=FV=VT_vzn_7EPfokA50B42ObDuXdtWEu72Dq6DHXt0QXFzA@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: Account for repeated start time requirement
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Addy Ke <addy.ke@rock-chips.com>, Lin Huang <hl@rock-chips.com>,
        yiwei cai <cyw@rock-chips.com>, Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 11, 2014 at 11:18 AM, Doug Anderson <dianders@chromium.org> wrote:
> -       min_low_ns = spec_min_low_ns + fall_ns;
> -       min_high_ns = spec_min_high_ns + rise_ns;
> +       /*
> +        * For repeated start we need at least (spec_setup_start * 2) to meet
> +        * (tSU;SDA) requirements. The controller drops data low at half the
> +        * high time). Also need to meet normal specification requirements.
> +        */
> +       if (for_start)
> +               min_high_ns = max(spec_setup_start * 2,
> +                                 spec_setup_start + sda_fall_ns +
> +                                 spec_min_high_ns);
> +       else
> +               min_high_ns = spec_min_high_ns;
> +       min_high_ns += scl_rise_ns;
> +
> +       min_low_ns = spec_min_low_ns + scl_fall_ns;

Sorry I didn't think about this before, but I think the above has a
slight bug.  I need to account for the scl_rise_ns rise time twice in
the repeated start case, I believe.  I'll send out a new version
shortly.
