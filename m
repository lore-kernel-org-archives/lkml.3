Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaIXQAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:00:44 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33964 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbaIXQAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:00:42 -0400
Message-ID: <1411574442.18580.95.camel@iivanov-dev>
Subject: Re: [PATCH v2] iio: iadc: Qualcomm SPMI PMIC current ADC driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>, Hartmut Knaack <knaack.h@gmx.de>,
        Lee Jones <lee.jones@linaro.org>, Philippe Reynes <tremyfr@yahoo.fr>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Date: Wed, 24 Sep 2014 19:00:42 +0300
In-Reply-To: <20140924145527.GI5729@leverpostej>
References: <1411567103-2380-1-git-send-email-iivanov@mm-sol.com>
	 <20140924145527.GI5729@leverpostej>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-24 at 15:55 +0100, Mark Rutland wrote:
> On Wed, Sep 24, 2014 at 02:58:23PM +0100, Ivan T. Ivanov wrote:
> > The current ADC is peripheral of Qualcomm SPMI PMIC chips. It has
> > 16 bits resolution and register space inside PMIC accessible across
> > SPMI bus.
> > 
> > The driver registers itself through IIO interface.
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> > Changes:
> > - Fix Kconfig dependencies
> > - Reword Kconfig help text
> > - Replace IIO_CHAN_INFO_PROCESSED with IIO_CHAN_INFO_RAW and IIO_CHAN_INFO_SCALE,
> >   This enable client drivers to use microampers precission, instead miliamps.
> > - Use const array for iio_schan_spec-fiers.
> > - Fix spelling errors and adress review comments.
> > 
> > Previous version:
> > https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg728360.html
> > 
> >  .../devicetree/bindings/iio/adc/qcom,spmi-iadc.txt |  61 ++
> >  drivers/iio/adc/Kconfig                            |  11 +
> >  drivers/iio/adc/Makefile                           |   1 +
> >  drivers/iio/adc/qcom-spmi-iadc.c                   | 691 +++++++++++++++++++++
> >  4 files changed, 764 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
> >  create mode 100644 drivers/iio/adc/qcom-spmi-iadc.c
> > 
> > diff --git a/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
> > new file mode 100644
> > index 0000000..06e58b6
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/iio/adc/qcom,spmi-iadc.txt
> > @@ -0,0 +1,61 @@
> > +Qualcomm's SPMI PMIC current ADC
> > +
> > +QPNP PMIC current ADC (IADC) provides interface to clients to read current.
> > +A 16 bit ADC is used for current measurements.
> > +
> > +IADC node:
> > +
> > +- compatible:
> > +    Usage: required
> > +    Value type: <string>
> > +    Definition: Should contain "qcom,spmi-iadc".
> > +
> > +- reg:
> > +    Usage: required
> > +    Value type: <prop-encoded-array>
> > +    Definition: IADC base address and length in the SPMI PMIC register map.
> > +                TRIM_CNST_RDS register address and length(1)
> 
> Are these two register regions? Please make the order explicit somehow
> (either say first/second/third/etc, or use reg-names).

Will make order explicit. 

> 
> Are they both part of the IADC, or is one part of an external/shared
> component?

I think that this is shared component.

> 
> > +
> > +- interrupts:
> > +    Usage: optional
> > +    Value type: <prop-encoded-array>
> > +    Definition: End of conversion interrupt number. If property is
> > +            missing driver will use polling to detect end of conversion
> > +            completion.
> 
> Driver details shouldn't be in the binding. If the driver can poll,
> that's good, but it should be dropped form this description.
> 

Will remove driver details.

> Is this the only interrupt?
> 

Yes.

> What do you mean be "End of conversion interrupt number"? Just describe
> what the interrupt logically is from the PoV of the device -- interrupts
> is a standard property so we don't need to be too explicit about the
> type.

Badly worded. Just, "End of conversion interrupt"?

> 
> > +
> > +- qcom,rsense:
> > +    Usage: optional
> > +    Value type: <u32>
> > +    Definition: External sense register value in Ohm. Defining this
> > +            propery will instruct ADC to use external ADC sense channel.
> > +            If property is not defined ADC will use internal sense channel.
> 
> The latter two sentences sound like a driver description.
> 
> What exactly is the difference between the internal and external
> channels, and what exactly is the value in the sense register used for?

Internal - when using chip build-in resistor
External - when using off-chip resistor

> 
> The binding should describe the logical properties of the device rather
> than the specific programming model details.
> 
> > +
> > +- qcom,rds-trim:
> > +    Usage: optional
> > +    Value type: <u32>
> > +    Definition: Calculate internal sense resistor value based TRIM_CNST_RDS,
> > +            IADC RDS and manufacturer.
> > +            0: Read the IADC and SMBB trim register and apply the default
> > +               RSENSE if conditions are met.
> > +            1: Read the IADC, SMBB trim register and manufacturer type and
> > +               apply the default RSENSE if conditions are met.
> > +            2: Read the IADC, SMBB trim register and apply the default RSENSE
> > +               if conditions are met.
> > +            If property is not defined driver will use qcom,rsense value if
> > +            defined or internal sense resistor value trimmed into register.
> 
> Having read this a few times, I still don't understand which I would use
> and when.
> 
> Which conditions need to be met in each of these cases?
> 
> When does the manufacturer need to be taken into account and what does
> it even mean for that to be the case? That sounds very much like a
> driver detail rather than a HW property.
> 
> Cases 0 and 2 seem to be the same, just with s/, / and /. I cannot
> figure out the intended difference between the two.
> 
> The last sentence is very much a driver description.

Sorry. I have tried to make it better. Now looking again DT files
in codeaurora tree I see that 0 is used in pm8941, 1 is used in
pm8110 and 2 is used for pm8226. So I will remove this property
and handle this inside driver based on chip version.

> 
> > +
> > +Example:
> > +       /* IADC node */
> > +       pmic_iadc: iadc@3600 {
> > +               compatible = "qcom,spmi-iadc";
> > +               reg = <0x3600 0x100>,
> > +                         <0x12f1 0x1>;
> > +               interrupts = <0x0 0x36 0x0 IRQ_TYPE_EDGE_RISING>;
> > +               qcom,rds-trim = <0>;
> > +       };
> > +
> > +       /* IIO client node */
> > +       bat {
> > +               io-channels = <&pmic_iadc 0>;
> > +               io-channel-names = "iadc";
> > +       };
> 
> Surely you need #iio-cells on the IADC node?

Yes, I need to add it.

> 
> Given the client seems to pass a specifier value, does this have
> multiple channels, or only a single channel?

Driver register only one IIO channel, so #io-channel-cells 
should be <0>.

Thank you for the comments.

Regards,
Ivan

