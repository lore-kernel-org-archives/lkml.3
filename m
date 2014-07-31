Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaGaWv2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:51:28 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:53451 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGaWv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:51:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tomasz Figa <tomasz.figa@gmail.com>, "Humberto Naves" <hsnaves@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53DAC079.5040709@gmail.com>
Cc: "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Tomasz Figa" <t.figa@samsung.com>,
        "Thomas Abraham" <ta.omasab@gmail.com>,
        "Andreas Farber" <afaerber@suse.de>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>
References: <1406805732-17372-1-git-send-email-hsnaves@gmail.com>
 <1406805732-17372-6-git-send-email-hsnaves@gmail.com>
 <53DA3F86.3020506@gmail.com>
 <CAEe5pB9Rj9rdzk-fjyNcdWyhQCfLtwxt+nAZdb4xuKDO9OpzUA@mail.gmail.com>
 <53DA5E7E.9010607@gmail.com>
 <CAEe5pB9=0VWd+d2KAcHD=YZSqFQo_3hRfV9M2mzvq2mziZXMUg@mail.gmail.com>
 <53DAC079.5040709@gmail.com>
Message-ID: <20140731225122.4463.77416@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCHv2 5/5] clk: samsung: exynos5410: Added clocks DPLL, EPLL, IPLL,
 and VPLL
Date: Thu, 31 Jul 2014 15:51:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tomasz Figa (2014-07-31 15:17:29)
> Humberto,
> 
> [dropping few addresses from Cc as this topic is rather irrelevant for
> them and adding Mike and Sylwester]
> 
> On 31.07.2014 23:19, Humberto Naves wrote:
> > Hi,
> > 
> > On Thu, Jul 31, 2014 at 5:19 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> >>
> >> I'm not sure I get the idea of the field you're suggesting. If I
> >> understand correctly, your intention would be to provide a default
> >> frequency if there is no table provided. I don't think there is a need
> >> for it, because current code can read back current settings from
> >> registers and calculate current rate.
> >>
> > I think I was not clear enough. I am not trying to provide a default
> > frequency for the clock, but I do want to specify the base frequency
> > on which the rate table was based upon. Let me give you an example
> > that will hopefully clarify the matter. Suppose I want to register my
> > PLL, such as in the 5410. The *current* solution would be like this:
> > 
> > static struct samsung_pll_rate_table ipll_24mhz_tbl[] __initdata = {
> >        /* PLL_35XX_RATE(rate, m, p, s, k) */
> >        PLL_35XX_RATE(864000000, 288, 4, 1),
> >        { },
> > };
> > static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
> >        [ipll] = PLL(pll_35xx, CLK_FOUT_IPLL, "fout_ipll", "fin_pll", IPLL_LOCK,
> >                IPLL_CON0, NULL),
> > };
> > 
> > And in the driver initialization function, I would add the rate table
> > if the input clock source matches what I expected, in this case 24Mhz:
> > 
> > if (_get_rate("fin_pll") == 24 * MHZ) {
> >          exynos5410_plls[ipll].rate_table = ipll_24mhz_tbl;
> > }
> > 
> > An alternative approach would be as follows, we add a new field (say
> > "base_rate") to the structure samsung_pll_clock, and to the macro PLL,
> > and describe the pll table in a simpler way, such as follows:
> > 
> > static struct samsung_pll_clock exynos5410_plls[nr_plls] __initdata = {
> >        [ipll] = PLL(pll_35xx, CLK_FOUT_IPLL, "fout_ipll", "fin_pll", IPLL_LOCK,
> >                IPLL_CON0, &ipll_24mhz_tbl, 24 * MHZ),
> > };
> > 
> > and in the _samsung_clk_register_pll function, all the validation
> > would be performed. Here I am talking about checking if the parent
> > rate is what is specified on the samsung_pll_clock structure, and if
> > so, to check if the rates on the rate table actually match what the
> > coefficients are telling.
> 
> What if there are multiple sets of tables for different "base rates"?
> Certain PLLs can run with several reference clock frequencies, e.g. VPLL
> rates are often specified for 24 MHz and 27 MHz, depending on setting of
> mout_vpllsrc.
> 
> > 
> >> As for the validation itself, one more thing that needs to be considered
> >> is that the rate table must be sorted.
> > 
> > The _samsung_clk_register_pll could do that in theory.
> > 
> >>
> >> We once decided to rely on the fact that tables in SoC drivers have
> >> rates explicitly specified and are correctly sorted, but now I'm
> >> inclined to reconsider this, based on the fact that those rates often
> >> are already incorrectly calculated in vendor code or even datasheets,
> >> which are main information sources for patch authors.
> >>
> >> Before mainlining PLL drivers (which was quite some time ago), we had a
> >> bit different implementation in our internal tree, which did not use
> >> explicitly specified rates at all (they could have been considered just
> >> comments to improve table readability) and the _register_pll() function
> >> simply calculated rates for all entries creating new table for internal
> >> use of the PLL driver that was in addition explicitly sorted to make
> >> sure that the order is correct. This kind of implementation is what I
> >> would lean toward today.
> > 
> > I would strongly object to such as solution. I think that in the
> > table, the frequency *must* be specified. As you said previously, the
> > coefficients should be carefully chosen. We cannot know for sure that
> > the same coefficients that work for a base frequency of 24 Mhz will
> > also work for a different base frequency. So the driver cannot simply
> > compute the frequency from the coefficients, and it must also check
> > that the input rate is correct. This is another reason why I want to
> > add the base_frequency field to that structure.
> 
> Sorry, I don't understand your concern. Currently it's SoC driver's duty
> to check which rate table to use depending on input clock rate. If input
> rate matches any table the driver has, it assigns the table pointer.
> Otherwise no table is used and the PLL is working in read-only mode.
> 
> If we leave this as is, then PLL driver will have enough information to
> calculate PLL rate, because it can retrieve input clock rate by calling
> clk_get_rate() on its parent clock. No need to specify output_rate in
> rate table, as it is redundant. However...
> 
> > 
> > I believe that the the _samsung_clk_register_pll must double-check if
> > the frequencies match what the formula tells, and must drop the
> > entries (or the whole frequency table) that are faulty. And then
> > finally, it should sort the entries in descending order.
> 
> Based on your proposal, another idea came to my mind.
> 
> We can add input_rate to rate table instead, so that each entry will
> have its own input rate specified. Then register_pll() would do following:
>  - validate all the entries by checking if entry.rate ==
> calc_rate(entry.fin, entry.p, entry.m, ...),
>  - discard invalid entries and print a warning,
>  - sort the table.

This is how my "coordinated clock rates" approach works. A given
coordinated rate table must specify the parent(s) and input rate(s). An
assignee at Linaro was working on this but then got shuffled out so
unfortunately the work is stalled.

My secret plan is to replace the "cpu clocks" type stuff I've seen on
the list recently with an approach that is baked into the clock
framework core and is re-usable for everybody.

Back on topic, the approach of specifying input rate for these patches
is sane and helps a lot to sanity check.

Regards,
Mike

> 
> Resulting table would have entries for various input clock rates mixed
> together, but all sorted according to output rate.
> 
> Then set_rate() when going through rate table would not only check the
> output_rate, but also whether input_rate matches and skip entries
> unsuitable for current setup.
> 
> This would have the advantage of being able to work with input_rate
> which can dynamically change, e.g. when mout_vpllsrc setting changes,
> while no check for input_rate would have to be done in SoC driver at all.
> 
> However I'm still not sure whether specifying output_rate in rate table
> has really any benefits. It's something that can be calculated precisely
> by the driver, so it introduces redundancy and unnecessarily increases
> error possibility, because you need to precisely calculate those rates
> yourself according to equation from the datasheet or reverse engineered
> from the code, because you often get incorrectly rounded values from the
> vendor. Not even saying that it makes it harder to add more frequencies
> to the table.
> 
> I'd like to collect more opinions on this though and so altered Cc list
> as mentioned at the top.
> 
> Mike, Sylwester, what do you think?
> 
> Best regards,
> Tomasz
