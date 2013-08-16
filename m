Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3HPIsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 04:48:35 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43053 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab3HPIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 04:48:24 -0400
Date: Fri, 16 Aug 2013 09:48:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, sameo@linux.intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: 88pm800: add device tree support
Message-ID: <20130816084816.GA3916@lee--X1>
References: <1376468930-9794-1-git-send-email-chao.xie@marvell.com>
 <1376468930-9794-4-git-send-email-chao.xie@marvell.com>
 <20130814174227.GI4046@lee--X1>
 <CADApbejPaRRX5OM5Ho8-bV2vaKLODOjhOh2Abzb8Auniwdukkw@mail.gmail.com>
 <20130815100719.GB25875@lee--X1>
 <CADApbegsSEaHhTBoy+STf2EDE3t8NR-K0GMWr1ObRPZkmPsYxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADApbegsSEaHhTBoy+STf2EDE3t8NR-K0GMWr1ObRPZkmPsYxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Aug 2013, Chao Xie wrote:

> On Thu, Aug 15, 2013 at 6:07 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >> >> +Optional parent device properties:
> >> >> +- marvell,88pm800-irq-write-clear: inicates whether interrupt status is cleared by write
> >> >> +- marvell,88pm800-battery-detection: indicats whether need 88pm800 to support battery
> >> >> +                             detection or not.
> >> >
> >> > Not sure what these are. This is why you need to CC the Device Tree
> >> > guys.
> >> >
> >> It is the 88pm805's own configuration.
> >> 88pm800-irq-write-clear: when irq happens, the status register is
> >> write clear or read clear.
> >> 88pm800-battery-detection: whether the battery is connected to chip.
> >> It means that whether
> >> the chip be aware of battery or not.
> >
> > As you are adding vendor specific bindings, you need to Cc the Device
> > Tree mailing list.
> >
> >> >> +     if (IS_ENABLED(CONFIG_OF)) {
> >> >> +             if (!pdata) {
> >> >> +                     pdata = devm_kzalloc(&client->dev,
> >> >> +                                          sizeof(*pdata), GFP_KERNEL);
> >> >> +                     if (!pdata)
> >> >> +                             return -ENOMEM;
> >> >> +             }
> >> >> +             ret = pm800_dt_init(node, &client->dev, pdata);
> >> >> +             if (ret)
> >> >> +                     return ret;
> >> >> +     } else if (!pdata) {
> >> >> +             return -EINVAL;
> >> >> +     }
> >> >
> >> > Replace with:
> >> >
> >> >         if (!pdata) {
> >> >                 if (node)
> >> >                         /* <blah> populate pdata with DT </blah> */
> >> >                 else
> >> >                         return -EINVAL;
> >> >         }
> >> >
> >> The orignial code will cover the following situation.
> >> 1. DT enabled, and user pass pdata
> >> 2. DT enabled, but user do not pass pdata
> >> 3. DT disabled, user pass pdata
> >> 4. DT disabled, user do not pass pdata.
> >>
> >> 88pm805 has a callback for config the it based on platform requirment.
> >> I do not want to remove this callback now, because it includes so many
> >> configurations.
> >> So i allow user can pass pdata with callback if the platform needs to
> >> configure the chip.
> >
> > Mixing DT with pdata is a bad idea. If you need to pass a call-back
> > pointer, then _only_ use pdata i.e. get all of your platform specific
> > information from pdata, rather than just over-writing sections of it
> > with information retrieved from Device Tree.
> >
> > So:
> >
> > If pdata  - use pdata and ignore DT completely
> > If !pdata:
> >    If DT  - use DT
> >    If !DT - return -EINVAL
> >
> > Out of interest, what does your call-back do?
> >
> Without the callback, the soc still can work.
> The callback does job relates to power saving and CP's requirment.
> 1. LPM configure for the chip based on AP/CP's requriment.
> 2. 88pm800 OSC configuration
> 3. Some output pin configuration of 88pm800, for example reset_out_n pin
> 
> I want to abstract the callback step by step, so the first step are the patches
> that enable DT first.

I think the first step is to fix the call-back. I can't say for sure
as I haven't seen it, but the chances are that it can be implemented
in a different way and eradicated. I'm keen not to accept the code
above, as I believe it's fundamentally broken.

> For the patch 0001 and 0002 are fixes, so if these two patches are all
> right, can you
> merge them? Then i will submit the 2 DT related patches again with cc
> to device tree maillist.

I don't think you sent patches 1 and 2 to me? Can you resend them as a
separate patch-set please?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
