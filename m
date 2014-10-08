Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaJHIqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:46:35 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:52087 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495AbaJHIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:46:33 -0400
Message-ID: <5434F9E4.7020109@collabora.co.uk>
Date: Wed, 08 Oct 2014 10:46:28 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>, Chris Zhong <zyw@rock-chips.com>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH] regulator: rk808: Add support setting suspend voltage
References: <1412671438-25399-1-git-send-email-zyw@rock-chips.com> <CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
In-Reply-To: <CAD=FV=W_6_JSn5ZWEG7YBDw5xf+tGReSB-WCV798gBqXyhikgg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Doug,

On 10/07/2014 07:48 PM, Doug Anderson wrote:
> 
> I don't have all the right patches to test this right now.  Hopefully
> you can point me at what we're using right now.  I'd expect that this
> will need the patches that Chanwoo and Javier are working on, so I've
> added them to this.
>

Yes, you will need Chanwoo's series in order to use this. If also the
driver needs to set a default initial regulator operating mode, it will
need the series I'll post today but in that case also a .set_mode handler
is needed.
 
> One point of curiosity (maybe this is a question for Chanwoo and
> Javier): I'd expect that if someone didn't explicitly setup a "suspend
> voltage" that their voltage would just be left alone at suspend time.
> I believe that won't be the case for your driver.  The rk808 will (I
> think) automatically transition to the "suspend voltage" settings for
> ALL regulators at suspend time.  If you didn't explicitly set the
> suspend voltage then you'll move to whatever the default voltage is,
> right?
> 

On system suspend, the regulator core only calls the .set_suspend_voltage
handler if struct regulator_state *rstate->uV > 0 for the given suspend
state (mem,disk,standby) and only calls .set_suspend_{enable,disable} if
struct regulator_state *rstate->{enabled,disable} are set for that state.

Chanwoo's series have different DT properties that are used to set the
suspend state uV (regulator-volt) and disabled (regulator-off-in-suspend):

	ldoX_reg: LDOx {
		...
		regulator-state-mem {
			regulator-volt = <1200000>;
			regulator-off-in-suspend;
		};
		...
	};

So answering your question, the transition to the "suspend voltage" setting
will only happen if uV is set (regulator-volt), otherwise it will be left
alone at suspend time just like is left alone on disable.

However, Chanwoo said that he will drop the regulator-volt DT property from
v5 [0]. It seems that is a useful use case for others to set the regulator
voltage on suspend, so maybe Chanwoo can address the issues pointed out by
Mark about renaming it to regulator-uV [1] and revise the check for the
voltage range [2] but kept the DT property on v5?

> -Doug
> 

Thanks a lot and best regards,
Javier

[0]: https://lkml.org/lkml/2014/9/28/202
[1]: https://lkml.org/lkml/2014/9/4/652
[2]: https://lkml.org/lkml/2014/9/4/651
