Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934400AbaE2Rrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:47:33 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:32947 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbaE2Rrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:47:32 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alex Elder <elder@linaro.org>, mporter@linaro.org, bcm@fixthebug.org,
        devicetree@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5387661E.7060106@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1400590362-11177-1-git-send-email-elder@linaro.org>
 <1400590362-11177-3-git-send-email-elder@linaro.org>
 <20140524005358.23136.8918@quantum> <53873577.8000502@linaro.org>
 <20140529163552.10062.50409@quantum> <5387661E.7060106@linaro.org>
Message-ID: <20140529174728.10062.42854@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 2/5] clk: bcm281xx: implement prerequisite clocks
Date: Thu, 29 May 2014 10:47:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alex Elder (2014-05-29 09:53:50)
> On 05/29/2014 11:35 AM, Mike Turquette wrote:
> > Quoting Alex Elder (2014-05-29 06:26:15)
> >> On 05/23/2014 07:53 PM, Mike Turquette wrote:
> >>> The above seems like a lot effort to go to. Why not skip all of this and
> >>> just implement the prerequisite logic in the .enable & .disable
> >>> callbacks? E.g. your kona clk .enable callback would look like:
> >>
> >> I think the problem is that it means the clock consumers
> >> would have to know that prerequisite relationship.  And
> >> that is dependent on the clock tree.  The need for it in
> >> this case was because the boot loader didn't initialize
> >> all the clocks that were needed.  If we could count on
> >> the boot loader setting things up initially we might not
> >> need to do this.
> 
> I think you've convinced me that if the prerequisite is
> set up at initialization time, the consumers don't need
> to know about the the clock tree.
> 
> >>>
> >>> diff --git a/drivers/clk/bcm/clk-kona.c b/drivers/clk/bcm/clk-kona.c
> >>> index d603c4e..51f35b4 100644
> >>> --- a/drivers/clk/bcm/clk-kona.c
> >>> +++ b/drivers/clk/bcm/clk-kona.c
> >>> @@ -987,6 +987,12 @@ static int kona_peri_clk_enable(struct clk_hw *hw)
> >>>  {
> >>>       struct kona_clk *bcm_clk = to_kona_clk(hw);
> >>>       struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
> >>> +     int ret;
> >>> +
> >>> +     hw->prereq_bus_clk = clk_get(hw->ccu, hw->prereq);
> >>> +     ret = clk_enable(prereq_bus_clk);
> >>> +     if (ret)
> >>> +             return ret;
> >>>  
> >>>       return clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, true);
> >>>  }
> >>> @@ -997,6 +1003,9 @@ static void kona_peri_clk_disable(struct clk_hw *hw)
> >>>       struct bcm_clk_gate *gate = &bcm_clk->u.peri->gate;
> >>>  
> >>>       (void)clk_gate(bcm_clk->ccu, bcm_clk->init_data.name, gate, false);
> >>> +
> >>> +     clk_disable(hw->prereq_bus_clk);
> >>> +     clk_put(hw->prereq_bus_clk);
> >>>  }
> >>>  
> >>>  static int kona_peri_clk_is_enabled(struct clk_hw *hw)
> >>>
> >>>
> >>> I guess it might take some trickery to get clk_get to work like that.
> >>> Let me know if I've completely lost the plot.
> >>
> >> I don't think so, but I think there's a lot of stuff
> >> here to try to understand, and you're trying to extract
> >> it from the code without the benefit of some background
> >> of how and why it's done this way.
> >>
> >> Hopefully all this verbiage is moving you closer to
> >> understanding...  I appreciate your patience.
> > 
> > Hi Alex,
> > 
> > Can you comment on my diff above? I basically tossed up some pseudo-code
> > to show how clk_enable calls can be nested inside of each other. I'd
> > like to know if that approach makes sense for your prereq clocks case.
> 
> Yes, I should have looked more closely before.
> 
> Are you suggesting this prerequisite notion get elevated into the
> common framework?

Nope.

> Or is "hw" here just representative of the
> Kona-specific clock structure?

Yup. It's just good old struct clk_hw. There is one instance of this
struct for every struct clk object.

> 
> In any case, you're suggesting the prerequisite be handled in the
> enable path (as opposed to the one-time initialization path),
> which during the course of this discussion I've been thinking may
> be the right way to do it.

Right, and don't forget that you have both the prepare path AND the
enable path. It is common for drivers to call clk_prepare once at probe
time and then aggressively call clk_enable/clk_disable for fine-grained
PM. Likewise some drivers always use clk_prepare_enable and
clk_disable_unprepare.

The point is that you have two callbacks that you might split some of
this stuff across. Your "initializiation" stuff might go into .prepare()
and simply enabling the clock might go into .enable().

> 
> Let me see if I can rework it that way and I'll let you know
> what I discover as a result.  I hope to have something to
> talk about later today.

Sounds good.

Regards,
Mike

> 
> Thanks a lot Mike.
> 
>                                         -Alex
> 
> > Note that Linux device drivers that consume leaf clocks do NOT need to
> > know about the prereq clocks. All of that prereq clock knowledge is
> > stored in the .enable callback for the leaf clock (see above).
> > 
> > Regards,
> > Mike
> > 
> >>
> >>                                         -Alex
> >>
> 
