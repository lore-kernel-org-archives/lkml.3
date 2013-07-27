Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab3G0TW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 15:22:56 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63240 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3G0TWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 15:22:54 -0400
MIME-Version: 1.0
In-Reply-To: <1441731.8CGUI1tUxh@flatron>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
	<51F39FD8.6080808@broadcom.com>
	<20130727183059.GD4813@netboy>
	<1441731.8CGUI1tUxh@flatron>
Date: Sat, 27 Jul 2013 15:22:52 -0400
Message-ID: <CAKON4Owg7guXo7TjtW3_C2Q07jNT8L6f6648AwXYBOxx2GA28w@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have people
 interested in device tree janitoring / cleanup?]
From: "jonsmirl@gmail.com" <jonsmirl@gmail.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Olof Johansson <olof@lixom.net>, Mark Brown <broonie@kernel.org>,
        Arend van Spriel <arend@broadcom.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 2:51 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Saturday 27 of July 2013 20:31:01 Richard Cochran wrote:
>> On Sat, Jul 27, 2013 at 12:24:24PM +0200, Arend van Spriel wrote:
>> > That is a nice summary of how we got from null to now and Richard
>> > seems to be simply saying: let's stop mucking about and make this a
>> > project with a well-defined process of dealing with staging and
>> > stable bindings and keep stable bindings stable.
>>
>> Yes, that is right.
>>
>> Frankly, I am really surprised and shocked at the cavalier attitude
>> expressed here WRT DT bindings in released kernels. Think about the
>> *users* of this code. Not everyone working with ARM Linux is a kernel
>> developer or a DT guru. There is really no indication at all that the
>> ARM Linux DT stuff released so far are not stable and trustworthy.
>>
>> It is not nice to provide such a mess, and the idea that we *must*
>> have a mess because the whole system in still in development is bogus,
>> IMHO. Just make sure that the mainline kernel is really working and
>> that the DT bindings *there* are for keeps.
>>
>> It is your job as kernel developers.
>
> Well, it depends on how we use the DT. There are (at least) two possible
> usage scenarios:
>
>  a) using DT as direct replacement for board files - this means that you
>     are free to say that DTSes are strictly coupled with kernel version
>     and you are free to modify the bindings - see the analogy to board
>     files, where you could modify the platform data structures and could
>     not directly copy board file from one kernel version to another,
>
>  b) using DT as an ABI - this is the original way, i.e. define stable
>     bindings and make sure that anu DTB built for older kernel will work,
>     with equal or greater set of functionality on newer kernels.

c) There was very good suggestion earlier about using quirks to fix up
legacy DTBs.  I really like that since the DTB can both be an ABI and
we can continue to evolve the kernel. The quirk code will have little
impact since it will be run at boot time and then discarded.

So there would be an evolving schema that represents the device tree
as understood by a particular kernel.  And then there would be a bunch
of quirks for converting the 'legacy' deployed DTBs into this
tree.These deployed DTBs are only the ones in boot loaders since they
are the only ones that can be seen by multiple kernels.

There are a lot of good places in this process to attach error
checking. For example the quirk code could complain about any DTBs it
is unable to fix up. And verifying things against the schema provides
a single point of contact for device tree design. The universal schema
will force discussion of how to create generic bindings for things
like DMA controllers.

Plus it is still possible to experiment in this model. Bind your DTB
to the kernel. Those DTBs won't be run through the quirk code. You'll
be able to have experimental elements that dtc will flag as not
matching the schema but they'll still be there.

Evolution also works very well. Each release of the kernel will
archive the schema and quirks at the point in time when it is
released.


>
> Now I believe in this thread the point whether we should use a) or b) or a
> combination of both has been raised.
>
> As for current situation, from users' perspective it's almost no
> difference. With a) they can use appended DTB feature (or hack, whatever
> you prefer). With b) they just upload new zImage/uImage/whatever, leaving
> old DTB as is, if they don't want any new functionality. If there is
> support added for new functionality, they must update their DTBs anyway,
> so there is no clear advantage of b) over a) in this matter.
>
> So, basically, this is not an obvious issue. Without analyzing (and
> discussing) possible use cases, issues, consequences and whatever, there
> is no obvious answer, such as "just stabilize whatever we have now!" or
> "go back to board files!".
>
> We have what we have, it is not perfect, some things have been screwed up,
> but we can't just leave that behind and say "now we'll be doing everything
> correctly", we must fix that up. People don't do everything correctly from
> the start, this is what the whole staging vs stable topic is about.
>
> Best regards,
> Tomasz
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Jon Smirl
jonsmirl@gmail.com
