Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3GYSZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:25:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975Ab3GYSZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:25:31 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <51F168FC.9070906@wwwdotorg.org>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
	<20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<51F168FC.9070906@wwwdotorg.org>
Date: Thu, 25 Jul 2013 11:25:30 -0700
Message-ID: <CAOesGMiLKysW2JG1jbef76Ves=-DAYEiE9d+s8YXWRXUJ+XhaQ@mail.gmail.com>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device
 tree janitoring / cleanup?]
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:05 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 07/25/2013 10:57 AM, Mark Rutland wrote:
>> On Thu, Jul 25, 2013 at 05:09:19PM +0100, Olof Johansson wrote:
> ...
>>> So, there really seems to be a need for a layered approach, one in
>>> which a binding "graduates" from being tentative to being locked in.
>>> I'm refraining from using the terms "staging" and "stable" here, since
>>> they have overloaded meaning in the kernel world that doesn't apply
>>> here.
>>
>> I'm not sure how realistic it is to have drivers in the kernel using
>> unstable bindings, and expect people to not rely on them, but I don't
>> have a better option to give. We need a big fat warning that an unstable
>> binding is in use.
>
> I don't think having people "rely" on the bindings is the issue so much
> as the awareness that if they do, there will be compatibility issues for
> unstable bindings.

If we continue doing what we do today, where we have (at least part
of) the device trees hosted with the kernel sources, then we can
introduce tentative changes to the device trees at the same time as
the code, so having the drivers rely on that seems appropriate.

Of course, things should not be static in that state, and have to move
out of it reasonably quickly.

>>> One problem that needs to be solved is obviously how a binding
>>> graduates from tentative to locked. This work isn't going to be very
>>> interesting to most people, I suspect. Think standards committee type
>>> work.
>>>
>>> A possible way to handle this is to have exactly that: A group of
>>> people that essentially constitute the "standards committee" that meet
>>> on a regular basis to review and approve new bindings. They should be
>>> people not just doing ARM Linux work, but other stakeholders in these
>>> bindings too. One of the things they should probably do is sift
>>> through our current in-kernel bindings and select those who seem ready
>>> to be locked in, review/discuss/decide upon that and once the decision
>>> is made, that specific binding does become part of the static,
>>> never-ever-change ABI of firmware-to-kernel interfaces.   That might
>>> also be the time that the binding is moved from the kernel to a
>>> separate repo, but that's a technicality that we'll let the DT
>>> maintainers decide among themselves, IMHO.
>>
>> We're going to need input from other OSs too, or the bindings will
>> remain Linux-specific regardless of how far away the bindings and dts
>> repo(s) is/are.
>
> And bootloaders too. Some U-Boot platforms are starting to use DT for
> exactly the same reason that the kernel does; to allow a single
> bootloader binary to run on a variety of different boards, with all
> configuration coming from DT.

Not only that, but in some cases u-boot might want to reach into the
device-tree of the launching kernel and tweak settings based on board
information. It already does this for things like memory and command
line, but there could be other cases where it wants to do so as well.
If things move around, or bindings change, this will obviously cause
problems. (I've already seen this with the Chrome OS u-boot vs
upstream kernels, partly due to a bug in the local fork of u-boot, but
still).

> On another related topic, something that may be useful for the DT
> bindings reviewer team is a basic checklist for new DT bindings.
> Something similar to Fedora's package review checklist. Perhaps also
> (yet another?) document on a bit of DT philosophy. If this sounds
> useful, I could try and take a stab at some basic initial version.

Sounds reasonable. Starting with one of the existing ones instead of
from scratch is a reasonable approach. A checklist and a best
practices doc would come a long way.

> We also need to decide (or just document) exactly what "describes the
> HW" means; see the thread on thermal limits, and consider the extension
> of describing hard/absolute thermal limits to describing use-cased base
> thermal profiles using the same schema, or not allowing that.

Yes indeed. A basic binding need just specify what the specific
hardware IP is, if the rest of the configuration of the IP can be
determined at runtime through other means (i.e. by autoprobing). It's
stuff beyond that that gets very complicated.

To talk semi-specifics: What about USB PHY tunings for a specific
board, where each of the three USB ports and their registers have
slightly different layout? Sure, we can take 10 properties to describe
each tunable field in each register, but at the end it will just be
used to craft the contents blindly, so we might just stuff the 32-bit
register value as a property instead. And in other cases we might
indeed want to describe each property independently. Determining what
is appropriate when is one of the most difficult parts of the review
workflow.


-Olof
