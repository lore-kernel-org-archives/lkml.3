Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3FMPTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:19:05 -0400
Received: from multi.imgtec.com ([194.200.65.239]:59165 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FMPTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:19:02 -0400
Message-ID: <51B9E2E1.9020203@imgtec.com>
Date: Thu, 13 Jun 2013 16:18:57 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Saravana Kannan <skannan@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com> <1369056507-32521-6-git-send-email-james.hogan@imgtec.com> <519AFBB6.90700@codeaurora.org> <CAD=FV=VFqTzqLc3+UOHD21NiTqtu84DzwYD1Qag-RxiD0qcFDA@mail.gmail.com>
In-Reply-To: <CAD=FV=VFqTzqLc3+UOHD21NiTqtu84DzwYD1Qag-RxiD0qcFDA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_06_13_16_19_00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/13 02:01, Doug Anderson wrote:
> Hi,
> 
> Mike pointed me at this series since I'm running into parenting
> problems at the moment as well...
> 
> On Mon, May 20, 2013 at 9:44 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>> While writing a similar code for our internal tree, I quickly came to the
>> realization that, "all parents are equal, but some are more equal than
>> others". The simplest example is a clock tree like this:
>>
>> Source -> Divider -> Mux
>> Source -> Mux
>>
>> A rate of Y can be achieved for Mux by either running Source at Y and
>> picking that input or running Source at Y * 2 and Divider set to div-2 and
>> picking the Divider input.
>>
>> The solution seems to be a priority list of parents. I'm sure there would be
>> other reason (jitter, clock quality, etc) for a mux to pick one parent vs.
>> another when both of them can provide the required rate.
>>
>> I think this loop should loop over parents based on their priority order.
>> So, parents should become a struct of { clk, index } and have the parents
>> listed in the order of priority. Well, at least in that long run that would
>> be better to avoid messing up parent/index values. But for now, you could
>> just have a priority array of index or parents.
>>
>> It might not fit 100% of the cases where two parents can provide the same
>> rate, but it should fit most use cases.
> 
> I'm slightly worried about similar problems, but I don't have a really
> great solution.
> 
> In my case I'm working on exynos5 hardware which has a bunch of PLLs
> and a crazy number of muxing options.  Many of the muxing options are
> not really meant to be used but seem to have been added to the SoC as
> a "backup plan" of some sort.  :-/  Most of the PLLs are intended to
> be used for one purpose and one purpose only though muxing options
> allow them to be used all over the place.
> 
> For instance if I look at my current bootup of exynos5250-snow, I see:
> 
> fout_apll/clk_rate:1700000000
> fout_bpll/clk_rate:800000000
> fout_cpll/clk_rate:333000000
> fout_epll/clk_rate:45158401
> fout_gpll/clk_rate:533000000
> fout_mpll/clk_rate:1600000000
> 
> * APLL is intended to be the parent of the 2 ARM cores and changes due
> to cpu load
> * EPLL is intended to be the parent for audio and changes dpending on
> audio playback rates.
> * GPLL is intended to be the parent of the GPU and changes due to gpu load
> * VPLL is intended to be the parent for video related things and could
> change depending on the LCD.
> * MPLL doesn't change a lot and is intended to be the parent for most things.
> * In some systems BPLL can be used for memory or GPU
> 
> My main concern here is the CCF will end up deciding at some point
> that it should reparent some clock onto a PLL that is going to change
> a whole lot.  Maybe the user will plug in an SD card that requests a
> frequency of 52MHz and at the moment we'll be running EPLL at 104 MHz
> so it will be a perfect match!  ...but then the user wants to play
> audio at a different rate.  The audio code assumes that it can mess
> with its clock and we've got code setup to call CLK_SET_RATE_PARENT
> all the way up to EPLL.  That will really mess with the SD card.
> Really we'd rather just have the SD card clock always parented on the
> stable MPLL and it's OK if 52MHz gets rounded down to 50MHz.

One possible approach to handling this is by making drivers register
clock rate change notifications, which can reject a clock rate change,
however I believe at the moment this would simply make the clock rate
change fail rather than finding an alternative change which isn't
rejected, so it may have limited use at the moment.

> Of course, on another board maybe they don't have an audio codec and
> aren't using epll for audio and have realized that EPLL would be a
> perfect way to get their SD card to run 4% faster.  It ought to work.
> 
> 
> I guess to summarize the above:
> 
> * It seems like much of the muxing on exynos5250 is just too
> complicated to leave it to an simple automated algorithm.
> * It seems like we can't make muxing decisions on the SoC level.
> * Your automatic muxing patches don't hurt me and could be useful for
> _some_ of the muxing options, just not the top PLL ones.
> 
> ...but the only place that leaves me for my muxing needs is the device
> tree.  ...and as Mike pointed out on IRC the device tree should
> describe hardware, not policy.  Ick.

Yes, we have a similar situation with the TZ1090, except it may be worse
as some of the clocks/devices may be driven by different non-Linux cores
or hardware threads (e.g. the WiFi/DAB firmware drives the I2C/SPI bus
the tuner chip is connected to, and related clocks), in which case Linux
literally has no knowledge of whether the hardware is already in use
aside from some form of application-specific configuration (currently
munged into device tree due to the lack of an alternative).

Cheers
James

