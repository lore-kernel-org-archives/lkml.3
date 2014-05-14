Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbaENTGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:06:36 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:64776 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaENTGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:06:32 -0400
MIME-Version: 1.0
In-Reply-To: <5373ABD2.9010508@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
	<20140514141914.446F7C4153D@trevor.secretlab.ca>
	<53738580.7000902@ahsoftware.de>
	<CACxGe6s4px_9CNk3bkc1OF1KGZGYdyh4gE_VufCKU5dLFBG48g@mail.gmail.com>
	<53739871.9070407@ahsoftware.de>
	<CAL_JsqJB4CAO60m1HTGQGHQRYVWcARxm_roOhn-PJh+ZR7OONg@mail.gmail.com>
	<5373ABD2.9010508@ahsoftware.de>
Date: Wed, 14 May 2014 14:06:31 -0500
Message-ID: <CAL_JsqJ-=amrmRR9FfnOH1ELDQ1kTaG3e1n878mgpZP1FUw_jA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
From: Rob Herring <robherring2@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 12:45 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 14.05.2014 19:30, schrieb Rob Herring:
>
>> On Wed, May 14, 2014 at 11:23 AM, Alexander Holler <holler@ahsoftware.de>
>> wrote:
>>>
>>> Am 14.05.2014 18:05, schrieb Grant Likely:
>>>
>>>> On Wed, May 14, 2014 at 4:02 PM, Alexander Holler <holler@ahsoftware.de>
>>>> wrote:
>>>>>
>>>>>
>>>>> Am 14.05.2014 16:19, schrieb Grant Likely:
>>>>>
>>>>>
>>>>>> Rather than a dtb schema change, for the most common properties (irqs,
>>>>>> clocks, gpios), we could extract dependencies at boot time. I don't
>>>>>> like
>>>>>> the idea of adding a separate depends-on property because it is very
>>>>>> easy to get it out of sync with the actual binding data (dtc is not
>>>>>> the
>>>>>> only tool that manipulates .dtbs. Firmware will fiddle with it too).
>>>>>
>>>>>
>>>>>
>>>>>
>>>>> Then that stuff has to fiddle correct. Sorry, but trying to solve all
>>>>> problems right from the beginning just leads to endless talks with no
>>>>> end
>>>>> and nothing will happen at all because nobody aggrees how to start.
>>>>
>>>>
>>>>
>>>> I appreciate the problem that you're trying to solve and why you're
>>>> using the dtc approach. My job is to poke at the solution and make
>>>> sure it is going to be reliable. Making sure all users know how to
>>>> fiddle with the new property correctly is not a trivial problem,
>>>> especially when it is firmware that will not necessarily be updated.
>>>
>>>
>>>
>>> The answer is just that they don't have to use this feature.
>>
>>
>> It's not just about users, but maintainers have to carry the code and
>> anything tied to DT is difficult to change or remove.
>>
>> Lots of inter-dependencies are already described in DT. We should
>> leverage those first and then look at how to add dependencies that are
>> not described.
>
>
> Again, that's what this feature is about. One of the problems it solves is
> that those dependencies which are described in the DT source in form of
> phandle reference, do disappear in the blobs because the init-system would
> have to know all bindings in order to identify phandle references (the
> dependencies) again.

They don't disappear, but they become binding specific to recover.
What you are loosing is type information which is something we would
like to solve as well.

You can regenerate or figure out the dependencies with knowledge of
the binding. The of_irq_init code does this. Maintaining this
information in the dtb that can be parsed in a generic way and having
the kernel handle non-bus oriented dependencies are really 2 separate
problems. Let's not try to solve it all at once.

>>>> I'm not saying flat out 'no' here, but before I merge anything, I have
>>>> to be reasonably certain that the feature is not going to represent a
>>>> maintenance nightmare over the long term.
>>>
>>>
>>>
>>> The maintenance nightmare is already present in form of all the
>>> workarounds
>>> which are trying to fix the initialzation order necessary for modern
>>> hardware.
>>
>>
>> Do you have concrete examples or cases where deferred probe does not work?
>
>
> Why do people come back to the deferred probe stuff?

Because it is there today and generally works.

> One of the biggest problem of the deferred probe stuff is the problem how to
> identify real problems if everything ends up with a deferred probe when an
> error occurs? That means if you display an error whenever something is
> deferred, the log becomes almost unreadable. If you don't display an error,
> you never will see an error. And how do you display the real error when
> deferred probes finally do fail? The deferred probe stuff doesn't has any
> information about the underlying error, so it can't display it.

This all sounds like "I don't like deferred probe because it is hard
to debug" to me. This all sounds solvable with better instrumentation
and debug capability. Why probe is deferred should be available at the
source when deciding to return -EPROBE_DEFER.

I still have not seen an example of A depends on B, deferred probe
fails because of ? and here is the code for A that works around the
problem.

> Anyway, this feature is totally independ of the deferred probe stuff and
> both can friendly live together.

Yes, except then we get to maintain both.

Rob
