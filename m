Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbaJXQjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 12:39:10 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43972 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756792AbaJXQjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 12:39:06 -0400
Date: Fri, 24 Oct 2014 09:39:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Santosh Shilimkar <santosh.shilimkar@gmail.com>, ssantosh@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: keystone: pm: switch to use generic pm
 domains
Message-ID: <20141024163901.GD19933@dtor-ws>
References: <1413809764-21995-3-git-send-email-grygorii.strashko@ti.com>
 <5446A065.9050308@gmail.com>
 <544793B5.6080601@ti.com>
 <CAPDyKFo97D3XbwDQrDzHw+qr4b24Fsq9EwDbdOMhy_L-RoYsLw@mail.gmail.com>
 <CAMuHMdVsqsSHxirzoWspGz7y+2qBk42p-VUBNkys3_rr6Th_9Q@mail.gmail.com>
 <CAPDyKFp6T1a1XXHdxiubP2RaS26uSqkUS3rbBgsNV_y+dSFfvw@mail.gmail.com>
 <CAMuHMdVO4nMoeYdzLf6wdKW876gYVyML3C2+QKoteGPtisD4sA@mail.gmail.com>
 <CAPDyKFrVCczc+fSy1ax4XinhB4SMfZZWP=d4QdY5Lv4zjOrHPA@mail.gmail.com>
 <544912AB.3050801@ti.com>
 <CAPDyKFpwguzd_iy46mpPcwDs98bh1k_3fVNfe4UAjYYwNoBJPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFpwguzd_iy46mpPcwDs98bh1k_3fVNfe4UAjYYwNoBJPQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:53:05AM +0200, Ulf Hansson wrote:
> On 23 October 2014 16:37, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
> > Hi Ulf,
> >
> > On 10/23/2014 11:11 AM, Ulf Hansson wrote:
> >> On 22 October 2014 17:44, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>> On Wed, Oct 22, 2014 at 5:28 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >>>> On 22 October 2014 17:09, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >>>>> On Wed, Oct 22, 2014 at 5:01 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> >>>>>>>>> +void keystone_pm_domain_attach_dev(struct device *dev)
> >>>>>>>>>    {
> >>>>>>>>> +    struct clk *clk;
> >>>>>>>>>        int ret;
> >>>>>>>>> +    int i = 0;
> >>>>>>>>>
> >>>>>>>>>        dev_dbg(dev, "%s\n", __func__);
> >>>>>>>>>
> >>>>>>>>> -    ret = pm_generic_runtime_suspend(dev);
> >>>>>>>>> -    if (ret)
> >>>>>>>>> -        return ret;
> >>>>>>>>> -
> >>>>>>>>> -    ret = pm_clk_suspend(dev);
> >>>>>>>>> +    ret = pm_clk_create(dev);
> >>>>>>>>>        if (ret) {
> >>>>>>>>> -        pm_generic_runtime_resume(dev);
> >>>>>>>>> -        return ret;
> >>>>>>>>> +        dev_err(dev, "pm_clk_create failed %d\n", ret);
> >>>>>>>>> +        return;
> >>>>>>>>> +    };
> >>>>>>>>> +
> >>>>>>>>> +    while ((clk = of_clk_get(dev->of_node, i++)) && !IS_ERR(clk)) {
> >>>>>>>>> +        ret = pm_clk_add_clk(dev, clk);
> >>>>>>>>> +        if (ret) {
> >>>>>>>>> +            dev_err(dev, "pm_clk_add_clk failed %d\n", ret);
> >>>>>>>>> +            goto clk_err;
> >>>>>>>>> +        };
> >>>>>>>>>        }
> >>>>>>>>>
> >>>>>>>>> -    return 0;
> >>>>>>>>> +    if (!IS_ENABLED(CONFIG_PM_RUNTIME)) {
> >>>>>>>> Can we not okkup two seperate callbacks instead of above check ?
> >>>>>>>> I don't like this CONFIG check here. Its slightly better version of
> >>>>>>>> ifdef in middle of the code.
> >>>>>>>
> >>>>>>> I've found more-less similar comment on patch
> >>>>>>> "Re: [PATCH v3 1/3] power-domain: add power domain drivers for Rockchip platform"
> >>>>>>> https://lkml.org/lkml/2014/10/17/257
> >>>>>>>
> >>>>>>> So, Would you like me to create patch which will enable clocks in pm_clk_add/_clk()
> >>>>>>> in case !IS_ENABLED(CONFIG_PM_RUNTIME)
> >>>>>>
> >>>>>> I am wondering whether we actually should/could do this, no matter of
> >>>>>> CONFIG_PM_RUNTIME.
> >>>>>>
> >>>>>> Typically, for configurations that uses CONFIG_PM_RUNTIME, the PM
> >>>>>> clocks through pm_clk_suspend(), will be gated once the device becomes
> >>>>>> runtime PM suspended. Right?
> >>>>>
> >>>>> Doing it unconditionally means we'll have lots of unneeded clocks running
> >>>>> for a short while.
> >>>
> >>>> As long as the pm_clk_add() is being invoked from the ->attach_dev()
> >>>> callback, we are in the probe path. Certainly we would like to have
> >>>> clocks enabled while probing, don't you think?
> >>>>
> >>>> If we wouldn't enable the clocks for CONFIG_PM_RUNTIME, when will
> >>>> those be enabled?
> >>>
> >>> They will be enabled when the driver does
> >>>
> >>>          pm_runtime_enable(dev);
> >>>          pm_runtime_get_sync(dev);
> >>>
> >>> in its .probe() method.
> >>
> >> No! This doesn't work for drivers which have used
> >> pm_runtime_set_active() prior pm_runtime_enable().
> >
> > Sorry, but some misunderstanding is here:
> > 1) If some code call pm_runtime_set_active() it has to ensure
> > that all PM resources switched to ON state. All! So, it will
> > be ok to call enable & get after that - these functions will only
> > adjust counters.
> 
> Correct.
> 
> This is also the key problem with your approach. You requires a
> pm_runtime_get_sync() to trigger the runtime PM resume callbacks to be
> invoked. That's a fragile design.

Why is this fragile design? Having pm_runtime_get_sync() result in
resuming the device (and in turn the PM domain it is in) if device is
suspended is the proper behavior, no?

Thanks.

-- 
Dmitry
