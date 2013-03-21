Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934428Ab3CUQnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:43:00 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:2902
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934262Ab3CUQgV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:21 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dIc89bh936eI1432I1447Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dh8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah906i1155h)
Date: Thu, 21 Mar 2013 09:36:14 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: divider: Use DIV_ROUND_CLOSEST
References: <2e77dfe8-8d4f-4b77-bf1b-831ad1572c23@VA3EHSMHS046.ehs.local>
 <20130320001609.8663.21043@quantum>
 <f3ff0545-52cd-4b7b-967e-f81324ba0152@CH1EHSMHS040.ehs.local>
 <20130320185051.GA28349@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20130320185051.GA28349@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [172.19.74.49]
X-RCIS-Action: ALLOW
Message-ID: <d1e87771-73df-4afd-9a02-b294d2ca62a1@AM1EHSMHS002.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 07:50:51PM +0100, Sascha Hauer wrote:
> On Wed, Mar 20, 2013 at 09:32:51AM -0700, Sören Brinkmann wrote:
> > Hi Mike,
> >
> > On Tue, Mar 19, 2013 at 05:16:09PM -0700, Mike Turquette wrote:
> > > Quoting Soren Brinkmann (2013-01-29 17:25:44)
> > > > Use the DIV_ROUND_CLOSEST macro to calculate divider values and minimize
> > > > rounding errors.
> > > >
> > > > Cc: linux-arm-kernel@lists.infradead.org
> > > > Cc: linux-kernel@vger.kernel.org
> > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > ---
> > > > Hi,
> > > >
> > > > I just came across this behavior:
> > > > I'm using the clk-divider as cpuclock which can be scaled through cpufreq.
> > > > During boot I create an opp table which in this case holds the frequencies [MHz]
> > > > 666, 333 and 222. To make sure those are actually valid frequencies I call
> > > > clk_round_rate().
> > > > I added a debug line in clk-divider.c:clk_divider_bestdiv() before the return
> > > > in line 163 giving me:
> > > >         prate:1333333320, rate:333333330, div:4
> > > > for adding the 333 MHz operating point.
> > > >
> > > > In the running system this gives me:
> > > > zynq:/sys/devices/system/cpu/cpu0/cpufreq # cat scaling_available_frequencies
> > > > 222222 333333 666666
> > > > zynq:/sys/devices/system/cpu/cpu0/cpufreq # cat scaling_cur_freq
> > > >  666666
> > > >
> > > >  So far, so good. But now, let's scale the frequency:
> > > > zynq:/sys/devices/system/cpu/cpu0/cpufreq # echo 333333 > scaling_setspeed
> > > > zynq:/sys/devices/system/cpu/cpu0/cpufreq # cat scaling_cur_freq
> > > >  266666
> > > >
> > > > And the corresponding debug line:
> > > >         prate:1333333320, rate:333333000, div:5
> > > >
> > > > So, with DIV_ROUND_UP an actual divider of 4.00000396 becomes 5, resulting in a
> > > > huge error.
> > > >
> > >
> > > Soren,
> > >
> > > Thanks for the patch, and apologies for it getting lost for so long.  I
> > > think that your issue is more about policy.  E.g. should we round the
> > > divider up or round the divider down?  The correct answer will vary from
> > > platform to platform and the clk.h api doesn't specify how
> > > clk_round_rate should round, other than it must specify a rate that the
> > > clock can actually run at.
> > Sure, my problem seems to be caused by different subsystems using a different resolution for clock frequencies.
> >
> > >
> > > Unless everyone can agree that DIV_ROUND_CLOSEST gives them what they
> > > want I'm more inclined to make this behavior a flag specific to struct
> > > clk-divider.  E.g. CLK_DIVIDER_ROUND_CLOSEST.
> > My understanding would have been, that clk_round_rate() gives me a
> > frequency as close to the requested one as possible.
>
> clk_round_rate clk_set_rate are implemented to give the closest possible
> rate that *is not higher* than the desired clock. That was the
> understanding by the time the clk framework was implemented.
>
> > If the caller
> > doesn't like the returned frequency he can request a different one.
> > And he's eventually happy with the return value he calls
> > clk_set_rate() requesting the frequency clk_round_rate() returned.
> > Always rounding down seems a bit odd to me.
> >
> > Another issue with the current implmentation:
> > clk_divider_round_rate() calls clk_divider_bestdiv(), which uses the ROUND_UP macro, returning a rather low frequency.
>
> And that is correct. clk_divider_bestdiv is used to calculate the
> maximum parent frequency for which a given divider value does not
> exceed the desired rate.
That is not what I mean. I was pointing at, that passing the same
frequency to round_rate and set_rate can return different results, since
round_rate rounds up whereas set_rate rounds down. Though, it's probably
fine since you shouldn't call set_rate with a frequency which wasn't returned
from round_rate.

>
> That is, when you want to have a frequency of 100Hz and your divider is
> 2, then your parent input clock can be between 101Hz and 200Hz,
> corresponding to a call to DIV_ROUND_UP.
I was not (yet) looking at cases where CLK_SET_RATE_PARENT is set. Just
an isolated clk-divider.

        Sören


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


