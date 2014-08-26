Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbaHZCRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 22:17:19 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39005 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855AbaHZCRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 22:17:17 -0400
Message-ID: <53FBEE2B.7020008@codeaurora.org>
Date: Mon, 25 Aug 2014 19:17:15 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lina Iyer <lina.iyer@linaro.org>
CC: daniel.lezcano@linaro.org, khilman@linaro.org, davidb@codeaurora.org,
        galak@codeaurora.org, linux-arm-msm@vger.kernel.org,
        lorenzo.pieralisi@arm.com, msivasub@codeaurora.org,
        Praveen Chidamabram <pchidamb@codeaurora.org>,
        Murali Nalajala <mnalajal@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 4/8] qcom: spm-devices: Add SPM device manager for
 the SoC
References: <1408486537-6358-1-git-send-email-lina.iyer@linaro.org> <1408486537-6358-5-git-send-email-lina.iyer@linaro.org> <53FBC971.1070102@codeaurora.org> <20140826003153.GA72292@ilina-mac.local>
In-Reply-To: <20140826003153.GA72292@ilina-mac.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/14 17:31, Lina Iyer wrote:
> On Mon, Aug 25, 2014 at 04:40:33PM -0700, Stephen Boyd wrote:
>> On 08/19/14 15:15, Lina Iyer wrote:
>>> diff --git a/Documentation/devicetree/bindings/arm/msm/spm.txt
>>> b/Documentation/devicetree/bindings/arm/msm/spm.txt
>>> new file mode 100644
>>> index 0000000..318e024
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/msm/spm.txt
>>
>> We already have a binding document for SAW. Please add stuff there
>> because SPM is just a component of SAW.
>>
> I agree that SPM is just a component of the SAW. But the document there
> seems to indicate regulator details, totally unrelated to the actual SAW
> hardware functionality.

Huh? The SAW binding should be extended with whatever properties are
necessary. Probably the only thing we need is the delays. Everything
else can be determined from the compatible?

SAW has a connection to the PMIC, does it not? If it isn't directly
connected we can come up with a different name for the node, but just
because the node name in the example is misleading doesn't mean we
should completely disregard what we already have.

>
>>> @@ -0,0 +1,47 @@
>>> +* Subsystem Power Manager (SAW2)
>>> +
>>> +S4 generation of MSMs have SPM hardware blocks to control the
>>> Application
>>> +Processor Sub-System power. These SPM blocks run individual state
>>> machine
>>> +to determine what the core (L2 or Krait/Scorpion) would do when the
>>> WFI
>>> +instruction is executed by the core.
>>> +
>>> +The devicetree representation of the SPM block should be:
>>> +
>>> +Required properties
>>> +
>>> +- compatible: Could be one of -
>>> +        "qcom,spm-v2.1"
>>> +        "qcom,spm-v3.0"
>>> +- reg: The physical address and the size of the SPM's memory mapped
>>> registers
>>> +- qcom,cpu: phandle for the CPU that the SPM block is attached to.
>>> +    This field is required on only for SPMs that control the CPU.
>>
>> We have a phandle from the CPU/L2 to the SAW, so this isn't necessary.
>>
> Sorry, I dont understand. Care to explain pls? Its necessary to know
> what SPM instance controls which CPU or L2, so as to pick the right SPM
> device to configure.

We have a phandle in the CPU nodes pointing to the SAW that is
associated with that CPU (qcom,saw). SPM is a part of a SAW. Thus there
is no need for this qcom,cpu property once the SAW node is used.
Instead, we can search the CPU and cache nodes for a qcom,saw that
matches the of_node for the platform device we're probing.

>
>>> +- qcom,saw2-cfg: SAW2 configuration register
>>
>> Why? Compatible should indicate where this register is.
>>
> There are multiple versions of saw handled by the same driver and
> distinguished by the version register. These SAW revisions differ in the
> register offset organization. The variable holds the value to be
> configured in the saw2-cfg register. I will update the documentation to
> be more clear.
>>> +- qcom,saw2-spm-ctl: The SPM control register
>>
>> Why? Compatible should indicate where this register is.
>>
> See above. 

Ah this is more register jam table in DT? cfg should probably be
described in desired clock rate and then the driver can figure out the
value by multiplying that the input clock rate. spm-ctl looks like it's
usually used to describe "enable", which seems rather obvious. Why isn't
the driver always writing the enable bit (bit 0)?

>
>>> +- qcom,saw2-spm-dly: Provides the values for the SPM delay command
>>> in the SPM
>>> +    sequence
>>
>> This is actually three values packed into one register for three
>> different selectable delays, right? We don't typically do register jam
>> tables in DT. Perhaps it should be split out into 3 different
>> properties. Or maybe it shouldn't be specified in DT at all and should
>> be determined algorithmically from the command sequences? From what I
>> can tell most of the sequences don't even use these delays.
>>
> Not at all sequences use the delays. These cannot be determined
> algorithmatically, They may be added to the sequence for changes in
> hardware. Let me revisit the sequences to see if they need to be set
> with the current sequence in use.
>

I was thinking perhaps these should be more structured binary blobs that
indicate the delays that would be necessary in the first 3 bytes or
something and then the command sequence after that.

        <delay1> <delay2> <delay3> <sequence>

Or perhaps

        <num delays=N> <delayN-1> <delayN> <sequence>

and then the code would parse these first few bytes and compress them
into 3 values that are written into the register.

BTW, I wonder if these sequences should be firmware blobs? Or at least,
different files that we then /incbin/ into the final DT blob (if DT
reviewers approve putting blobs like this into the kernel, Cc'ed the DT
list just in case).

>
>
>>> +
>>> +Optional properties
>>> +
>>> +- qcom,saw2-spm-cmd-wfi: The WFI command sequence
>>> +- qcom,saw2-spm-cmd-ret: The Retention command sequence
>>> +- qcom,saw2-spm-cmd-spc: The Standalone PC command sequence
>>> +- qcom,saw2-spm-cmd-pc: The Power Collapse command sequence. This
>>> sequence may
>>> +    turn off other SoC components.
>>> +- qcom,saw2-spm-cmd-gdhs: GDHS (Globally Distributed Head Switch)
>>> command
>>> +    sequence. This sequence will retain the memory but turn off the
>>> logic.
>>
>> I wonder if these should be properties of the idle states? That way the
>> driver isn't searching for them by name in DT, instead it knows what
>> state is associated with what sequence that the SPM needs to have
>> programmed.
>>
> I see the relation you are seeing. But its not a property of the idle
> state. Its an SoC specific property that the idle uses to indicate a
> state. Better off lying here. I doubt there would be a good support for
> holding SoC specific stuff in the ARM idle-states nodes.
>
>

What isn't specifically related to the 1) idle state and 2) CPU/L2/etc.
that the idle state is used in? I would think that by pointing to
different idle states from different CPU nodes we could cover all cases.
What is the SoC specific stuff in here?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

