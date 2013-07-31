Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab3GaUhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:37:43 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:54132 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3GaUhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130731201457.GA24642@n2100.arm.linux.org.uk>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<1999586.84BnWE5EUh@thinkpad>
	<20130731191209.GA8027@netboy>
	<1409617.9untvfnOTJ@flatron>
	<20130731200017.GC8027@netboy>
	<20130731201457.GA24642@n2100.arm.linux.org.uk>
Date: Wed, 31 Jul 2013 16:37:36 -0400
Message-ID: <CAKON4Ow7rE9cDj_tS7kmYN4incM+ay=BK96q-ph2JxYH3xiQzg@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arend van Spriel <arend@broadcom.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>, mbizon@freebox.fr,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 4:14 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jul 31, 2013 at 10:00:17PM +0200, Richard Cochran wrote:
>> On Wed, Jul 31, 2013 at 09:29:35PM +0200, Tomasz Figa wrote:
>> >
>> > I showed you two example solutions that could handle this use case without
>> > stable binding ABI, just to prove that b) is not the only option (even if
>> > it's the best one, which I continue to agree on, don't get me wrong).
>>
>> You only showed *one* solution (b) that satisfies the use case. The
>> use case was:
>>
>>    User acquires a machine running ARM Linux version 3.x, with u-boot
>>    and dtb in a read only flash partition. The board boots and works just
>>                 ^^^^^^^^^^^^^^^^^^^^^^^^^
>>    fine. However, for his application, the user requires a new kernel
>>    feature that appeared in version 3.y where y > x. He compiles the new
>>    kernel, and it also works.
>>
>> But you suggested:
>>
>>  a) using DT as direct replacement for board files - this means that you
>>     are free to say that DTSes are strictly coupled with kernel version
>>     and you are free to modify the bindings - see the analogy to board
>>     files, where you could modify the platform data structures and could
>>     not directly copy board file from one kernel version to another,
>>
>> In the use case, the kernel is upgraded, but not the DTB. So this
>> solution makes no sense.
>
> That's also crap for another reason.  DT on the whole is _supposed_ to
> describe what the hardware is, and how it is wired up in a WELL DEFINED
> and STABLE manner.  Unfortunately, there's a *BIG* mistake that was made
> - having this /chosen node in DT which gets used for "software"
> configuration - eg, the command line and so forth.
>
> That was a mistake because it means that the DT isn't purely a
> description of the hardware.  Such stuff should have been left in ATAGs,
> and DT should have been placed into its own ATAG entry.  There would
> not have been any conflict between ATAGs and DT, because ATAGs generally
> don't deal with hardware configuration - the only real bit of hardware
> configuration conveyed via ATAGs is the location of memory and size of
> memory.
>
> However, if we go back to the idea that DT is supposed to describe the
> hardware, _and_ that the way to describe that hardware is well defined
> and _stable_ (as it should be) then there should be no reason what so
> ever that your old DT blob should not continue working in later kernels.
> If it doesn't, then the contract that DT promised when we first moved
> over to using DT has been _broken_.

Suppose your DT predates PINCTRL and the CPU needs the pins set to
function.  But setting the pins up is a board specific function. How
is this going to get implemented in a generic kernel that doesn't have
any board specific code in it?

I would propose that we only need to worry about DTs that got put into
boot loaders and not worry about ones that were only used when
appended to a kernel.

For those deployed bootloader based DTs we'd use a quirk system to
catch them at early boot time and add in the missing PINCTRL
information.  The function of this quirk system is to update deployed
DTs with the needed information to allow a completely generic kernel
to run.

Now we can have a very clean generic kernel with all of the board
specific fixups localized to a single spot - the quirk for those
deployed DTs. And hopefully new boards won't need any quirks.

>
> Quite frankly, the fact that this discussion has gone on soo far, and
> everyone is saying that the existing DT descriptions to date (for what,
> two years) are all unstable is really extremely sad.
>
> I've stated in my previous postings what I think very clearly - and it
> comes down to the fact that every DT binding which is in existence in
> a released kernel _is_ by that very nature a stable binding.  If it
> wasn't a stable binding, it should have been clearly marked as such
> and been subject to CONFIG_EXPERIMENTAL (when it existed) or
> CONFIG_STAGING or similar.
>
> We even went as far as creating documentation for the bindings - directly
> along side the documentation for PPC bindings, with no distinction.
>
> Given all that, it's down right insulting to those who have been using
> ARM kernels to now start off a discussion about making these things
> stable.  Those people who think that these bindings are not stable need
> to wake up to reality - we have USERS of this stuff over the last two
> years.  It's found its way into products.  If we're going to keep this
> stuff "unstable" then we are actively _hurting_ our users.
>
> I'll say it again: if a binding has been in a final kernel, it is by
> definition a *stable* binding, and compatibility with that binding
> *must* be maintained.
>
> If we're not going to do that, then we owe all the users of the ARM
> kernel a VERY BIG apology.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Jon Smirl
jonsmirl@gmail.com
