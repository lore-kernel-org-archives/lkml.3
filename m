Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757870Ab3GYSGY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:06:24 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33954 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3GYSGC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:06:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: James Hogan <james.hogan@imgtec.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51F1202D.9060403@imgtec.com>
Cc: <linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Doug Anderson <dianders@chromium.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        =?utf-8?q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
References: <1371139562-305-1-git-send-email-james.hogan@imgtec.com>
 <1371139562-305-5-git-send-email-james.hogan@imgtec.com>
 <51F11B46.7010900@samsung.com> <51F1202D.9060403@imgtec.com>
Message-ID: <20130725180557.7598.20285@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v5 4/5] clk: add CLK_SET_RATE_NO_REPARENT flag
Date: Thu, 25 Jul 2013 11:05:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Hogan (2013-07-25 05:55:09)
> Hi Sylwester
> 
> On 25/07/13 13:34, Sylwester Nawrocki wrote:
> > On 06/13/2013 06:06 PM, James Hogan wrote:
> >> Add a CLK_SET_RATE_NO_REPARENT clock flag, which will prevent muxes
> >> being reparented during clk_set_rate.
> >>
> >> To avoid breaking existing platforms, all callers of clk_register_mux()
> >> are adjusted to pass the new flag. Platform maintainers are encouraged
> >> to remove the flag if they wish to allow mux reparenting on set_rate.
> > [..]
> >> Changes in v3:
> >>
> >> * rename/invert CLK_SET_RATE_REMUX to CLK_SET_RATE_NO_REPARENT and move
> >>   to this new patch.
> >> * patch 3: add CLK_SET_RATE_NO_REPARENT flag to all callers of
> >>   clk_register_mux. If you don't mind your clocks being reparented in
> >>   response to set_rate please let me know and I'll drop the relevant
> >>   portion of the patch.
> > 
> > Why is this better to change current behaviour of the clock core
> > and modify all drivers instead of having, e.g. CLK_SET_RATE_REPARENT
> > set in drivers of hardware that supports clock re-parenting while
> > setting clock rate ?
> 
> See this message from Mike Turquette which first suggested it:
> 
> http://marc.info/?l=linux-kernel&m=136847508109344&w=2
> 
> > Is there intention to just have the automatic clock re-parenting
> > as a default feature in the common clock API ?
> 
> Yes, that would be the result (except where explicitly disallowed).
> Unfortunately where such policy should ideally be defined is still up in
> the air.
> 
> It's not a property of the hardware, but then it is arguably a property
> of the environment the bootloader has configured (like the stuff in the
> /chosen device tree node).

I'm happy to get feedback on this decision. Looking back on
CLK_SET_RATE_PARENT flag I wish I had made that behavior the default.
Instead there would only be a flag for the case where you explicitly do
not wish to propagate the rate change request up the tree.

Another thing to consider here is that only users of .determine_rate are
affected. If your mux clock implements .set_parent and .round_rate, but
not .determine_rate then you are not affected by this change.

The whole thing gets messy because we're pushing policy into the clock
framework, but there is no way to avoid that if we're going to achieve
the goal of having drivers know only about the leaf clocks they consume
and not requiring those drivers to understand the greater clock tree
topology.

Regards,
Mike

> 
> Presuming that the usual reason not to reparent a mux is because other
> important clocks depend on it, the kernel might know enough to work out
> whether it's safe (unless of course there are other cores/threads in the
> SoC using the clock that Linux isn't aware of, which brings us back to
> it being a bootloader environment thing).
> 
> > My apologies if this has already been answered, I haven't been
> > following this thread.
> 
> No problem :)
> 
> Cheers
> James
