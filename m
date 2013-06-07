Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3FGLtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 07:49:00 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:62379 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3FGLs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 07:48:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130607102326.GA3111@e102568-lin.cambridge.arm.com>
References: <1370538685-22386-1-git-send-email-james.king@linaro.org>
	<20130607102326.GA3111@e102568-lin.cambridge.arm.com>
Date: Fri, 7 Jun 2013 12:48:58 +0100
Message-ID: <CAFtq+0FuzNcoQpK7=7d_KetYYHoPC7rdkFWMrApey5dxiWZ9mg@mail.gmail.com>
Subject: Re: [PATCH] arm/dt: Don't add disabled CPUs to system topology
From: James King <james.king@linaro.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On 7 June 2013 11:23, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com> wrote:
> Hi James,
>
> On Thu, Jun 06, 2013 at 06:11:25PM +0100, James King wrote:
>> If CPUs are marked as disabled in the devicetree, make sure they do
>> not exist in the system CPU information and CPU topology information.
>> In this case these CPUs will not be able to be added to the system later
>> using hot-plug. This allows a single chip with many CPUs to be easily
>> used in a variety of hardware devices where they may have different
>> actual processing requirements (eg for thermal/cost reasons).
>>
>> - Change devicetree.c to ignore any cpu nodes marked as disabled,
>>   this effectively limits the number of active cpu cores so no need
>>   for the max_cpus=x in the chosen node.
>> - Change topology.c to ignore any cpu nodes marked as disabled, this
>>   is where the scheduler would learn about big/LITTLE cores so this
>>   effectively keeps the scheduler in sync.
>>
>
> I have two questions:
>
> 1) Since with this approach the DT should change anyway if on different
>    hardware devices based on the same chip you want to allow booting a
>    different number of CPUs, why do not we remove the cpu nodes instead of
>    disabling them ? Put it another way: cpu nodes define a cpu as
>    possible (currently), we can simply remove the node if we do not want
>    that cpu to be seen by the kernel.

The reason we want disabled status rather than just remove the nodes
is to use a common soc.dtsi file which is included in many board.dts
files - eg:

file soc.dtsi contains:

                cpus {
                                cpu0: cpu@0 {
                                                device_type = "cpu";
                                                compatible = "arm,cortex-a7";
                                                reg = <0>;
                                                cluster = <&cluster0>;
                                                core = <&core0>;
                                };

                                cpu1: cpu@1 {
                                                device_type = "cpu";
                                                compatible = "arm,cortex-a7";
                                                reg = <1>;
                                                cluster = <&cluster0>;
                                                core = <&core1>;
                                };

                                cpu2: cpu@2 {
                                                device_type = "cpu";
                                                compatible = "arm,cortex-a15";
                                                reg = <2>;
                                                cluster = <&cluster0>;
                                                core = <&core2>;
                                };
                };

file board1.dts where we want the A15 disabled contains:

/include/ "soc.dtsi"

                cpus {
                                cpu2: cpu@2 {
                                                status = "disabled";
                                };
                };

> 2) If we go for the "status" property, why do not we use it to set present
>    mask ? That way the cpu is possible but not present, you cannot
>    hotplug it in. It is a bit of a stretch, granted, the cpu _is_ present,
>    we just want to disable it, do not know how this is handled in x86
>    and other archs though.

I have been struggling to find any equivalent example for another
arch, so just tried to solve our problem. I guess in the x86 world it
is less likely to want to disable processors in a SoC for heat/battery
issues so this has just never arisen. In this case the cpu is
physically present but not possible, but I am not sure it should be in
a present mask (giving the impression it can be used). Perhaps you
could elaborate with an example what you are thinking about here?

Thanks,
James
>
> I am just asking, since it is something I thought about while writing
> code that parses the DT cpu map, basically we do not have a way to
> "disable" a cpu in the DT and that's what you are doing, I just would like
> to understand the best way to put it into DT bindings.
>
> Thanks,
> Lorenzo
>
