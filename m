Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbbAFSgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:36:06 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:38725 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbbAFSgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAL_JsqJwauxNNojhAaYEr7oQTm6fwYwtByv_s6-tHiXYA214AQ@mail.gmail.com>
References: <1420562732-4353-1-git-send-email-mathieu.poirier@linaro.org>
	<CAL_JsqJwauxNNojhAaYEr7oQTm6fwYwtByv_s6-tHiXYA214AQ@mail.gmail.com>
Date: Tue, 6 Jan 2015 11:36:03 -0700
Message-ID: <CANLsYkz_tx0MAnssO1JmgGzeaj12oU64FJjiKKyEOyXuUKk8jQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: vexpress: bindings: Add generic PD awareness to the
 spc controller
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2015 at 10:02, Rob Herring <robherring2@gmail.com> wrote:
> On Tue, Jan 6, 2015 at 10:45 AM,  <mathieu.poirier@linaro.org> wrote:
>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
>>
>> Among other things, the serial power controller (SPC) controls power to
>> the A7 and A15 clusters.  Theses clusters also happen to contains the
>> coresight tracers used for HW assisted tracing.
>>
>> By modellling these to power domains in a way that is comprehensible to
>> the generic power domain sub-system and using the runtime PM API in the
>> coresight drivers, we can prevent power to the domains from being
>> turned off while tracing related operations are still pending.
>>
>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
>> ---
>>  .../bindings/arm/vexpress-power-controller.txt     | 54 ++++++++++++++++++++++
>>  1 file changed, 54 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
>> new file mode 100644
>> index 000000000000..3af5624dc5cb
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
>> @@ -0,0 +1,54 @@
>> +ARM Versatile Express Power Controller
>> +--------------------------------------
>> +
>> +This binding models the serial power controller (SPC) in a way that is
>> +intelligible to the generic power domain subsystem and in accordance
>> +with the guidelines from:
>> +
>> +Documentation/devicetree/bindings/power/power_domain.txt
>> +
>> +The binding doesn't have a '<reg>' property as the base address for HW
>> +access is provided by the vexpress-scc sub-system.
>> +
>> +Required node properties:
>> +- compatible value : = "arm,vexpress-power-controller";
>> +- #power-domain-cells : = Number of cells in a PM domain specifier, as
>> +  specified in "power_domain.txt" referenced above.
>> +
>> +Example:
>> +       A7_A15_cluster_pd: A7-A15-cluster-pd {
>
> This is more a description of the power domain than the power
> controller IP block.

This one is a little tricky - the controller itself (SPC) is accessed
via registers mapped by another driver (SCC) and have two completely
separate files.  The SPC driver itself is not DT'ed, simply because it
doesn't have too,  hence writing things the way I did.

I will ask the vexpress maintainers where they want to see this code
going.  Would you accept this binding as part of the existing
"arm,vexpress-sysreg" [1] or even "arm,vexpress-scc" [2]?

[1]. Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
[2]. Documentation/devicetree/bindings/arm/vexpress-scc.txt

>
>> +               compatible = "arm,vexpress-power-controller";
>> +               #power-domain-cells = <1>;
>
> You need to define what goes in the cell. That is specific to the
> power controller. It could be generic in that N corresponds to power
> domain N in the controller if the controller is generic in that way
> (i.e. all the register accesses are just indexed).

That is exactly how things are - one controller and two power domains.
Based on what the generic power domain code does #power-domain-cells
is the argument indicating what domain a device should be added to.
>From what I read this is also how things are (sparsely) explained in
"power_domain.txt".  As such I'm not exactly sure of what you'd like
to see modified - enlightenment would be appreciated.

>
>> +        };
>> +
>> +       ....
>> +
>> +       ptm@0,2201d000 {
>
> Drop the comma.
>
>> +               compatible = "arm,coresight-etm3x", "arm,primecell";
>> +               reg = <0 0x2201d000 0 0x1000>;
>> +
>> +               cpu = <&cpu1>;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               power-domains = <&A7_A15_cluster_pd 0>;
>> +               port {
>> +                       ptm1_out_port: endpoint {
>> +                               remote-endpoint = <&funnel_in_port1>;
>> +                       };
>> +               };
>> +       };
>> +
>> +       etm@0,2203c000 {
>
> ditto
>
>> +               compatible = "arm,coresight-etm3x", "arm,primecell";
>> +               reg = <0 0x2203c000 0 0x1000>;
>> +
>> +               cpu = <&cpu2>;
>> +               clocks = <&oscclk6a>;
>> +               clock-names = "apb_pclk";
>> +               power-domains = <&A7_A15_cluster_pd 1>;
>> +               port {
>> +                       etm0_out_port: endpoint {
>> +                               remote-endpoint = <&funnel_in_port2>;
>> +                       };
>> +               };
>> +       };
>> --
>> 1.9.1
>>
