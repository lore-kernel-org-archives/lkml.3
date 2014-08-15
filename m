Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaHOAER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 20:04:17 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12934 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaHOAEP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 20:04:15 -0400
Date: Thu, 14 Aug 2014 17:04:05 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>
CC: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT
 binding
Message-ID: <20140815000403.GA7070@sonymobile.com>
References: <1407796988-25872-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1407796988-25872-2-git-send-email-bjorn.andersson@sonymobile.com>
 <AF6050C7-EF40-4865-9E41-B730FEF59D6C@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AF6050C7-EF40-4865-9E41-B730FEF59D6C@codeaurora.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 12 Aug 10:43 PDT 2014, Kumar Gala wrote:

> 
> On Aug 11, 2014, at 5:43 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:
> 
[...]
> > diff --git a/Documentation/devicetree/bindings/mfd/qcom,rpm.txt b/Documentation/devicetree/bindings/mfd/qcom,rpm.txt
[...]
> > +- reg:
> > +     Usage: required
> > +     Value type: <prop-encoded-array>
> > +     Definition: two entries specifying the physical address and size of the
> > +                 RPM's message ram
> 
> I’m a little confused here, by ‘two entries’ do you mean two values or really two regions? < A B > or < A B C D >?
> 

Hmm, I agree with you, but I'm not sure what the definition of an entry is in
this context and looking around at other bindings makes me wonder even more.

How about we reduce the confusion by dropping the beginning and letting it be
"the physical address and size of..."?

> > +
[...]
> > +
> > +- qcom,ipc:
> > +     Usage: required
> > +     Value type: <prop-encoded-array>
> > +     Definition: three entries specifying:
> > +                 - phandle to a syscon node representing the apcs registers
> > +                 - u32 representing offset to the register within the syscon
> > +                 - u32 representing the ipc bit within the register
> 
> Can we clarify that this is ipc from Apps (or ARM processors to RPM)
> 

Makes sense

> > +
> > +
> > += SUBDEVICES
> 
> These should not be children of RPM, but in an RPM container outside of the SoC node with some phandle reference (if needed) to the RPM.  The reason is there isn’t really a technical means to translate from the SoC / MMIO bus address space to the RPM address space that these nodes live in.
> 

I don't agree with this; the regulators, clocks and bus-scalers aren't
components on their own but just parts of the RPM. Your argument indicates that
every pmic, i2c, spi... block got this wrong, I think we should better follow
the pattern defined by the rest of these.

One thing that I think should be fixed though is to rename "SUBDEVICES" to
"SUBNODES" as "devices" is an implementation detail in my solution.

> Also, the binding specs should be split out into their own files.
> 

Not according to Rob Herring:
https://lkml.org/lkml/2014/3/10/567

> > +
> > +The RPM exposes resources to its subnodes. The below bindings specify the set
> > +of valid subnodes that can operate on these resources.
> > +
> > +== Switch-mode Power Supply regulator
> > +
[...]
> > +- reg:
> > +     Usage: required
> > +     Value type: <u32>
> > +     Definition: resource as defined in <dt-bindings/mfd/qcom,rpm.h>
> > +
> 
> Can we spec what subset of values in qcom,rpm.h are actually valid?
> 

Yes, sorry about not improving this part.

[...]
> > +- qcom,switch-mode-frequency:
> > +     Usage: required
> > +     Value type: <u32>
> > +     Definition: Frequency (Hz) of the switch-mode power supply;
> > +                 must be one of:
> > +                 19200000, 9600000, 6400000, 4800000, 3840000, 3200000,
> > +                 2740000, 2400000, 2130000, 1920000, 1750000, 1600000,
> > +                 1480000, 1370000, 1280000, 1200000
> > +
> > +- qcom,force-mode-none:
> 
> I think I asked this last time I took a look at this, but can we have multiple force-mode’s set?  If no, maybe this should be an enum instead.
> 

No, they are mutually exclusive. I just like the boolean representation
instead, but I can change it to an enum and provide some constants in the
header file.

Looking through msm-3.4 almost everything seems to be using force mode "none",
with a few uses of "auto". So if we turn it into an enum then we could specify
"none" in the platform dtsi (or don't specifying anything?) and only have to
override it in the very few places it needs to be anything else.

> > +     Usage: optional (default if no other qcom,force-mode is specified)
> > +     Value type: <empty>
> > +     Defintion: indicates that the regulator should not be forced to any
> > +                particular mode
> > +
> > +- qcom,force-mode-lpm:
> > +     Usage: optional
> > +     Value type: <empty>
> > +     Definition: indicates that the regulator should be forced to operate in
> > +                 low-power-mode
> > +
> > +- qcom,force-mode-auto:
> > +     Usage: optional (only available for 8960/8064)
> 
> can we say only available for "qcom,rpm-msm8960”, "qcom,rpm-apq8064"
> 

Indeed.

> > +     Value type: <empty>
> > +     Definition: indicates that the regulator should be automatically pick
> > +                 operating mode
> > +
> > +- qcom,force-mode-hpm:
> > +     Usage: optional (only available for 8960/8064)
> 
> can we say only available for "qcom,rpm-msm8960”, "qcom,rpm-apq8064"
> 

Indeed.

> > +     Value type: <empty>
> > +     Definition: indicates that the regulator should be forced to operate in
> > +                 high-power-mode
> > +
> > +- qcom,force-mode-bypass: (only for 8960/8064)
> > +     Usage: optional (only available for 8960/8064)
> 
> can we say only available for "qcom,rpm-msm8960”, "qcom,rpm-apq8064"
> 

Indeed.

> 
> > +     Value type: <empty>
> > +     Definition: indicates that the regulator should be forced to operate in
> > +                 bypass mode
> > +
> > +- qcom,power-mode-hysteretic:
> > +     Usage: optional
> > +     Value type: <empty>
> > +     Definition: indicates that the power supply should operate in hysteretic
> > +                 mode (defaults to qcom,power-mode-pwm if not specified)
> > +
> > +- qcom,power-mode-pwm:
> > +     Usage: optional
> > +     Value type: <empty>
> > +     Definition: indicates that the power supply should operate in pwm mode
> 
> If we default to pwm mode w/o any property why do we need 2 things here.  Seems like existence of (or lack there of) qcom,power-mode-hysteretic says how to set the power-mode
> 

You're right, that's cleaner.

> > +
> > +Standard regulator bindings are used inside switch mode power supply subnodes.
> > +Check Documentation/devicetree/bindings/regulator/regulator.txt for more
> > +details.
> > +

Same answers goes for the other subnodes.


Thanks for the feedback!

Regards,
Bjorn

