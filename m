Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab3ANCu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 21:50:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32946 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207Ab3ANCu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 21:50:27 -0500
Date: Mon, 14 Jan 2013 02:50:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Axel Lin <axel.lin@ingics.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] regulator-core: update all enable GPIO state in
	_enable/disable
Message-ID: <20130114025025.GA30179@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E122AA@DQHE02.ent.ti.com> <20130113224220.GE5041@opensource.wolfsonmicro.com> <A874F61F95741C4A9BA573A70FE3998F69E12A0D@DQHE02.ent.ti.com> <20130114014239.GA29909@opensource.wolfsonmicro.com> <A874F61F95741C4A9BA573A70FE3998F69E12A43@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E12A43@DQHE02.ent.ti.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 02:44:08AM +0000, Kim, Milo wrote:

> > So, clearly that's going to be the behaviour at the system level but
> > the
> > consumers aren't going to know that.  If the consumer supports some of
> > the supplies being enabled and disabled separately then it will rely on
> > the regulator core reference counting to keep the supply enabled if
> > there are other reasons to do so.  This is how things would work if
> > both
> > supplies came from the same regulator so I'd expect us to preserve the
> > same behaviour.

> OK, the consumer just cares about the regulator(s) which is(are) obtained.
> However it doesn't show exact state of regulator in case that enable GPIOs are
> shared.

It would do if my suggestion that we use a shared state for the GPIO
were implemented!

> (6) CB tries to get the state of LDO3 before disabling it,
> regulator_is_enabled() returns 1, but real state is 0.

> 	if(!regulator_is_enabled(rdev))
> 		regulator_disable(rdev);

> 	Therefore CB never disables LDO3, use_count is always 1.

> This patch solves this unmatched situation.

This is just a buggy consumer - the consumer would also break if there
were a single regulator shared by two consumers.  There's almost no case
outside of bootstrapping where it makes sense to check if the regulator
is enabled for anything other than diagnostics.

> Regulator APIs may show unmatched value, but it can be handled in each consumer 
> driver *separately*.
> Therefore, we should not update 'ena_gpio_state' of other regulators.
> This patch should be ignored.
> Is that correct?

No, we need to reference count over all the regualtors sharing the
enable line.  Otherwise we won't pay attention to references held by
anything other than the regulator currently being enabled or disabled.
