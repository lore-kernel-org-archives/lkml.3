Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaLKBRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:17:01 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:48188 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933315AbaLKBQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:16:58 -0500
MIME-Version: 1.0
In-Reply-To: <20141210235347.GT11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org> <20141210235347.GT11764@sirena.org.uk>
From: Alexandru Stan <amstan@chromium.org>
Date: Wed, 10 Dec 2014 17:08:37 -0800
Message-ID: <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
To: Mark Brown <broonie@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spec is from 1.7V to 1.95V, with 1.8V being ideal. It's not that
symmetric. But let's say that 0.1V is fine for tolerance(so 1.7-1.9V)

regulator_set_voltage_tol looks interesting, but i still think it's
not the appropriate thing to use in this case.

Imagine a board has a 1V-1.79 V regulator, we tell it to
regulator_set_voltage_tol(1800000,100000). It will try the 1.8V-1.9V
range, when it sees that it can't it'll fallback to 1.7V - 1.9V, and
it will just be lazy and pick the lowest of the range again:
1.7V(causing voltage drop issues because we're exactly at the minimum
of the spec). The correct voltage would be 1.79V

It's unfortunate that regulator_set_voltage was designed to always
pick the lowest voltage in that range. I understand that it's a power
efficiency thing, but it's not ideal in cases like this.

Alexandru Stan (amstan)


On Wed, Dec 10, 2014 at 3:53 PM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, Dec 10, 2014 at 12:58:02PM -0800, Doug Anderson wrote:
>> There are some cases where you'd like to set a voltage for a regulator
>> and a range of voltages are OK, but you'd really like to get as close
>> as you can to a specific voltage if at all possible.
>
> This looks like regulator_set_voltage_tol(), why not use that?  The spec
> probably even has a number for the tolerance, or you can make one up.
