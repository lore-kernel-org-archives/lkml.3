Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaGaPTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:19:36 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55444 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaGaPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:19:34 -0400
Message-ID: <53DA5E7E.9010607@gmail.com>
Date: Thu, 31 Jul 2014 17:19:26 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Naves <hsnaves@gmail.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Thomas Abraham <ta.omasab@gmail.com>,
        Andreas Farber <afaerber@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: Re: [PATCHv2 5/5] clk: samsung: exynos5410: Added clocks DPLL, EPLL,
 IPLL, and VPLL
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com> <1406805732-17372-6-git-send-email-hsnaves@gmail.com> <53DA3F86.3020506@gmail.com> <CAEe5pB9Rj9rdzk-fjyNcdWyhQCfLtwxt+nAZdb4xuKDO9OpzUA@mail.gmail.com>
In-Reply-To: <CAEe5pB9Rj9rdzk-fjyNcdWyhQCfLtwxt+nAZdb4xuKDO9OpzUA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31.07.2014 15:37, Humberto Naves wrote:
> Hi Tomasz,
> 
> I remember checking these rates on my calculator. You might notice the
> odd frequency of 45158401Hz (no pun intended) in the EPLL clock. This
> particular clock frequency was giving me a big headache in a previous
> project, since it was wrongly listed as 45158400. At first it seems
> innocuous, but whenever I would ask for one of the child clocks to
> change the rate, the driver would miscalculate the correct frequencies
> and errors would propagate up and down the clock tree.
> 
> Anyway, I would double check these tables. And if you want, I can
> write a separate patch for the rate table validation. I presume that
> you would like to add a new field, such as default_base_freq, to the
> structure samsung_pll_clock, and if that field is non-zero, you
> perform the validation of the table in _samsung_clk_register_pll?

I'm not sure I get the idea of the field you're suggesting. If I
understand correctly, your intention would be to provide a default
frequency if there is no table provided. I don't think there is a need
for it, because current code can read back current settings from
registers and calculate current rate.

As for the validation itself, one more thing that needs to be considered
is that the rate table must be sorted.

We once decided to rely on the fact that tables in SoC drivers have
rates explicitly specified and are correctly sorted, but now I'm
inclined to reconsider this, based on the fact that those rates often
are already incorrectly calculated in vendor code or even datasheets,
which are main information sources for patch authors.

Before mainlining PLL drivers (which was quite some time ago), we had a
bit different implementation in our internal tree, which did not use
explicitly specified rates at all (they could have been considered just
comments to improve table readability) and the _register_pll() function
simply calculated rates for all entries creating new table for internal
use of the PLL driver that was in addition explicitly sorted to make
sure that the order is correct. This kind of implementation is what I
would lean toward today.

Best regards,
Tomasz
