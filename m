Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab3DYXG1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 19:06:27 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37531 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab3DYXGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 19:06:25 -0400
Message-ID: <5179B6ED.9000301@gmail.com>
Date: Thu, 25 Apr 2013 18:06:21 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCHv2 1/4] Documentation: Add memory mapped ARM architected
 timer binding
References: <1365812863-5367-1-git-send-email-sboyd@codeaurora.org> <1365812863-5367-2-git-send-email-sboyd@codeaurora.org> <516C6F12.5020208@gmail.com> <516C7231.6060305@codeaurora.org> <5179A488.5050102@gmail.com> <5179B2B2.8000201@codeaurora.org>
In-Reply-To: <5179B2B2.8000201@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 05:48 PM, Stephen Boyd wrote:
> On 04/25/13 14:47, Rob Herring wrote:
>> On 04/15/2013 04:33 PM, Stephen Boyd wrote:
>>> On 04/15/13 14:20, Rob Herring wrote:
>>>> On Fri, Apr 12, 2013 at 7:27 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>>>> @@ -26,3 +30,52 @@ Example:
>>>>>                              <1 10 0xf08>;
>>>>>                 clock-frequency = <100000000>;
>>>>>         };
>>>>> +
>>>>> +** Memory mapped timer node properties
>>>>> +
>>>>> +- compatible : Should at least contain "arm,armv7-timer-mem".
>>>> Everything about this timer is architecturally defined? If not, let's
>>>> use a more specific name.
>>> I'm not sure I'm following you, but everything described here is part of
>>> the ARM definition. What would be a more specific name?
>> Something that corresponds to the particular implementation like
>> cortex-a15 (obviously not an example that has this). I'm fine with
>> leaving this for now, but would like to see that added when specific SOC
>> dts are added. Better to be specific in case we need to use it for
>> something like errata work-arounds. Of course we haven't done that so
>> far with the arch timer bindings...
> 
> Agreed. I'm under the impression that most of our compatible fields
> should be more specific than they currently are so we can workaround hw
> bugs like you say. Perhaps the catch all generic one should just be
> "arm,arm-timer-mem" since it isn't tied to any particular CPU type?
> 
>>
>>>>> +
>>>>> +- clock-frequency : The frequency of the main counter, in Hz. Optional.
>>>>> +
>>>>> +- reg : The control frame base address.
>>>>> +
>>>>> +Note that #address-cells, #size-cells, and ranges shall be present to ensure
>>>>> +the CPU can address a frame's registers.
>>>>> +
>>>>> +Frame:
>>>>> +
>>>>> +- frame-number: 0 to 7.
>>>> I'd really like to get rid of the frame numbers and sub-nodes. Is the
>>>> frame number significant to software?
>>> We need the frame number to read and write registers in the control
>>> frame (the first base in the parent node). We currently use it to
>>> determine if a frame has support for the virtual timer by reading the
>>> CNTTIDR (a register with 4 bits per frame describing capabilities). If
>>> we wanted to control access to the second view of a frame we would also
>>> need to configure the CNTPL0ACRn register that pertains to the frame
>>> we're controlling. Without a frame number we wouldn't know which
>>> register to write.
>> I've gone thru the memory mapped part of the spec now, so I think I
>> understand things better. I see how the frame number is needed, but...
>>
>> The control base is only accessible in secure or hyp mode. How does a
>> guest know that it is a guest and can't map the control base? Seems like
>> we need to allow a subset of the binding that is just a reg and
>> interrupts properties without the frame sub nodes.
> 
> I don't see that part. My understanding is that the control base is
> accessible in non-secure mode and by the guests. There are certain
> registers within that base that are only accessible in secure mode
> though: CNTFRQ and CNTNSAR. Also some registers are configurable:
> CNTACRn and CNTVOFFN. CNTVOFFN is only accessible in the hypervisor.

The example is section E.8 seems to say otherwise. Perhaps Mark R can
comment further.

> We don't really care about CNTFRQ because it's duplicated into each
> view. We do care about CNTNSAR. Luckily the spec "just works" there in
> the sense that we can use CNTTIDR in conjunction with CNTACRn and
> determine if we have access to a frame we're interested in if the
> CNTTIDR bits say the frame is present and the CNTACRn register says we
> can access it. If not then it must be locked down for secure users.
> 
> Unfortunately hardware doesn't have a way to say that a particular frame
> is reserved for the hypervisor or the guest kernel/userspace. We need
> some help from software, so we have the status property express that a
> particular frame is available. We have to assume the DT is going to be
> different depending on if you're the hypervisor or the guest. That's a
> valid assumption right? Otherwise I hope we can do some trapping of the
> guest's mapping to the control base and then rewrite what they read so
> that they only see the frame that we want to be available to them.

Yeah, I believe the only way to prevent access within non-secure world
is with the MMU. So I guess the example is just policy that the
hypervisor would/may not create a stage2 mapping. You still have the
same issue that the guest should not be passed the control base. You
could make the reg property optional, but then what do you do with the
node name?

Certainly the guest dtb will be different.

Rob

