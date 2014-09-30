Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaI3TAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:00:18 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:18375 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaI3TAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:00:15 -0400
Date: Tue, 30 Sep 2014 12:00:24 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH 1/4] ARM: DT: apq8064: add rpm support
Message-ID: <20140930190023.GS28481@sonymobile.com>
References: <1411982044-7873-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1411982092-7922-1-git-send-email-srinivas.kandagatla@linaro.org>
 <5429DA95.80505@codeaurora.org>
 <20140930050203.GG28481@sonymobile.com>
 <542AF5FE.1000006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <542AF5FE.1000006@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 30 Sep 11:27 PDT 2014, Stephen Boyd wrote:

> On 09/29/14 22:02, Bjorn Andersson wrote:
> > On Mon 29 Sep 15:17 PDT 2014, Stephen Boyd wrote:
> >
> >> On 09/29/14 02:14, Srinivas Kandagatla wrote:
> >>> @@ -246,6 +247,24 @@
> >>>  			#reset-cells = <1>;
> >>>  		};
> >>>  
> >>> +		apcs: syscon@2011000 {
> >>> +			compatible = "syscon";
> >>> +			reg = <0x2011000 0x1000>;
> >>> +		};
> >> This is actually a clock controller block that hw designers decided was
> >> good place to shove the ipc bits (because there's room!). Can we call it
> >>
> >>                 l2cc: clock-controller@2011000 {
> >>                         compatible = "syscon";
> >>                         reg = <0x2011000 0x1000>;
> >>                 };
> >>
> >> Eventually I'll add the specific krait compatible when we merge krait
> >> clock support:
> >>
> >>                 l2cc: clock-controller@2011000 {
> >>                         compatible = "qcom,kpss-gcc", "syscon";
> >>                         reg = <0x2011000 0x1000>;
> >>                         clock-output-names = "acpu_l2_aux";
> >>                 };
> >>
> > As long as we can get hold of the regmap that would be fine. I pressume the
> > idea is to have the kpss-gcc using syscon, just like the rpm. But hopefully the
> > syscon patches that are floating around (merged?) will allow any driver to
> > expose a "syscon regmap".
> 
> Agreed. I'm not sure if kpss-gcc will use syscon. With the floating
> patches I don't see a reason why we need to use it.
> 


All we need is a regmap for the kpss-gcc, but the restriction that it has to be 
a syscon is more of a implementation detail. But you probably don't want to 
implement the phandle->regmap lookup code in kpss-gcc (and all the other
places) and if I understand the syscon improvements being suggested they are
supposed to help with exactly that (help any device expose regmaps).

Need to look into that again though.

> >
> >>> +
> >>> +		rpm@108000 {
> >>> +			compatible	= "qcom,rpm-apq8064";
> >>> +			reg		= <0x108000 0x1000>;
> >>> +			qcom,ipc = <&apcs 0x8 2>;
> >> There are actually 3 ipc bits. I guess if we ever have to use the other
> >> two we'll extend this binding to have the other bits specified some
> >> other way?
> > I haven't seen any indications of us using more than this bit. If we want to do
> > that, we could simply make it <&apcs 8 2 &apcs 8 3 &apcs 8 4> (or whatever
> > those indices are). That way this should be easy it keep compatible.
> >
> 
> Good to hear we're not forced to use a new property. The indices have
> always been 2, 1, and 0 as far as I know.
> 
> We use bit 1 to ack the RPM if it ever crashes. We know that it crashes
> because we receive the error interrupt. Instead of calling panic like we
> do downstream we can gracefully fail any new rpm requests. There really
> isn't any way to recover from this scenario though besides rebooting.
> Looking at the code I see this is all wrong and we use bit 2 to ack the
> error.
> 

Hmm, seems I got that wrong, sorry about that.

But do you mean "all wrong" as in that I use the wrong bit or to some greater
extent? Currently all following requests should timeout, but maybe we should
have a faster fail-path when we've hit this point?


>From a practical pov I guess that once the rpm starts returning errors on
updates to regulators, root clocks and bus scaling then most of the system is
becoming useless.

Regards,
Bjorn
