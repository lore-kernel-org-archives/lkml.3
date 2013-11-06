Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab3KFCwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 21:52:41 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:41874 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab3KFCwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 21:52:40 -0500
MIME-Version: 1.0
In-Reply-To: <20131106021933.GA7242@kroah.com>
References: <1383641987-4403-1-git-send-email-felipe.contreras@gmail.com>
	<20131105125228.GB18093@kroah.com>
	<CAMP44s0i-xCNHW_PPyO57p9yt0X_9OaYSQDkVPoNKum=nEHQbw@mail.gmail.com>
	<20131105151609.GA20950@kroah.com>
	<CAMP44s2BmZY2vQXQKsWmF68td8w9i4YNzp-o37ZN3YzsyZ3SWA@mail.gmail.com>
	<20131106021933.GA7242@kroah.com>
Date: Tue, 5 Nov 2013 20:52:38 -0600
Message-ID: <CAMP44s2vHKuNyqRndWty+-Ua47KEL8fwfeq+sakC7MJKv5KrTw@mail.gmail.com>
Subject: Re: [PATCH] staging: new asus fan driver
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 8:19 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 05, 2013 at 01:54:51PM -0600, Felipe Contreras wrote:
>> On Tue, Nov 5, 2013 at 9:16 AM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>> > On Tue, Nov 05, 2013 at 08:29:40AM -0600, Felipe Contreras wrote:
>> >> On Tue, Nov 5, 2013 at 6:52 AM, Greg Kroah-Hartman
>> >> <gregkh@linuxfoundation.org> wrote:
>> >> > On Tue, Nov 05, 2013 at 02:59:47AM -0600, Felipe Contreras wrote:
>> >> >> Simple driver to enable control of the fan in ASUS laptops. So far this
>> >> >> has only been tested in ASUS Zenbook Prime UX31A, but according to some
>> >> >> online reference [1], it should work in other models as well.
>> >> >>
>> >> >> The implementation is very straight-forward, the only caveat is that the
>> >> >> fan speed needs to be saved after it has been manually changed because
>> >> >> it won't be reported properly until it goes back to 'auto' mode.
>> >> >>
>> >> >> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
>> >> >>
>> >> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>> >> >> ---
>> >> >>
>> >> >> Two incarnations of this code exists [1][2], one that used ACPI methods
>> >> >> directly, and one through WMI. Unfortunately the WMI version needs us to pass
>> >> >> physicall addresses which is not exactly clean, and that's the only reason the
>> >> >> code is proposed for staging.
>> >> >>
>> >> >> Most likely this cannot graduate until acpica gets support to receive virtual
>> >> >> addresses.
>> >> >
>> >> > When is that going to happen?
>> >>
>> >> I don't know. Presumably when I get it done, which might be never, or
>> >> a few days from now. Most likely it will take some time.
>> >
>> > Then why not just merge this to the proper place, instead of relying on
>> > staging?  I don't want to have to have a staging driver that is waiting
>> > on external things to get it merged, instead of issues with the driver
>> > itself, as you are now putting the burden of maintenance on me, for no
>> > good reason other than you being too "lazy" to get other stuff done :)
>>
>> *I* am too lazy? I am doing all the work. Nobody else is doing
>> anything about it.
>>
>> Linux is throttling the CPU speed of this machine without trying to to
>> increase the fan speed first, that is not ideal.
>>
>> So I do the first step of writing the fan driver and I get told it
>> shouldn't be a separate driver, it should be part of wmi, only to be
>> told later by the same person that it doesn't belong in wmi when I put
>> it there. Then I get told virt_to_physical() is not good, and it
>> should move to staging, and then I'm told you don't want it.
>
> Who told you to put it in staging?  That is the person that needs to be
> corrected here, it's not your issue, sorry, I didn't realize the
> backstory here.

Matthew Garrett. He said I should wrap my wmi fan code [1], so that it
compiles only when staging. I was doing that when I realized how ugly
it would all be, and there doesn't seem to be any precedent for that,
so I just wrote it as a separate driver.

> And I would push back on those people, if it solves your problem, and
> there's no other good solution, then it should go into the "real" part
> of the kernel.  Who has rejected this driver and for what reason?

Matthew Garrett. Because as it's described in the TODO, this code is
passing a physical address of our structs to the ACPI code, but that's
what the DSDT expects, there's no way around it. Doing virt_to_phys()
and passing that to the ACPI code might be a little ugly, but as far
as I know there's checks already in place.

Matthew said the acpica code is the one that should be doing the
virt_to_phys() conversion, which is probably true, but since nobody is
going to do that, the task is left for me.

Before going into this daunting task, I would rather have the CPU
throttling fixed by hooking the fan to a thermal zone, which was my
motivation of starting it in the first place, but I have not received
any help as to how to do that, I was hoping having the driver land
somewhere (e.g. staging) might help to get the first part out of the
way, and concentrate on how to actually make it useful.

[1] http://article.gmane.org/gmane.linux.power-management.general/39522

-- 
Felipe Contreras
