Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569Ab3LER5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:57:32 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:34158 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab3LER53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <20131127152244.410F2C404EC@trevor.secretlab.ca>
References: <1383113571-13029-1-git-send-email-robherring2@gmail.com>
	<CAL_JsqKHZtidrzJPH+c-zyFUQNsxtEKxOYg+Nzyo9JYNDNexug@mail.gmail.com>
	<20131127152244.410F2C404EC@trevor.secretlab.ca>
Date: Thu, 5 Dec 2013 11:57:28 -0600
Message-ID: <CAL_Jsq+4yitHCtaKZ4nNxTg3Q4pUYF9RQY4Q=VTSs4ox-iSqSQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] of: add initcall with match boilerplate helpers
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 9:22 AM, Grant Likely <grant.likely@linaro.org> wrote:
> On Thu, 21 Nov 2013 17:23:14 -0600, Rob Herring <robherring2@gmail.com> wrote:
>> On Thu, Nov 21, 2013 at 6:50 AM, Grant Likely <grant.likely@linaro.org> wrote:
>> > On Wed, 30 Oct 2013 01:12:51 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> >> From: Rob Herring <rob.herring@calxeda.com>
>> >>
>> >> Add boilerplate helpers to create initcalls which are conditional on
>> >> matching on devicetree properties.

[snip]

>> > I'm not sure why this is necessary. I don't particularly have a problem
>> > with it, but I wouldn't normally try to filter out device drivers when
>> > the probe code simply won't get called.
>> >
>> > Considering it's paired with the previous patch that creates devices in
>> > the module init call, I'm assuming it is to support that use case. If so
>> > then I don't think it is a good idea. If there is another use case then
>> > maybe.
>>
>> This is for cases that are not drivers. Again, the motivation is how
>> do I do initialization on arm64 where there is not already some
>> conditional initialization hook. My approach to solve this is by
>> eliminating the machine_desc for highbank. While I don't really have a
>> need to do this on highbank itself, I do have a need for some of the
>> same functions present in mach-highbank for arm64.
>>
>> I realized quickly going down this path that I would have a repeated
>> pattern and that there's already a few other examples in the kernel of
>> something like this:
>>
>> static int __init some_initcall(void)
>> {
>>   if (of_machine_is_compatible("my-awesume-board"))
>>     return -ENODEV;
>>
>>   /* do some init stuff... */
>> }
>>
>> There are some examples using this here [1][2].
>
> It's still kind of a nasty pattern. I'd like to limit the use of this as
> much as possible and I'd like to make it as easy as possible to discover
> where things are coming from at boot. That's one of the things I like
> about machine_desc. It is a common entry point for SoC family specific
> behaviour.

But that is really no longer true now that all the machine_desc
function ptrs are optional. A given platform may or may not even be
calling some machine_desc functions. So the boot flow is already very
much a function of what is in the DTB rather than what machine is
selected.

> As for device drivers, the preferred model is to bind against something
> already registered. If it is not present, then it does nothing. To me
> there is a difference between making the behavour conditional on
> something that was registered vs. an arbitrary value in the device tree.
> The triggers for the former are exported in /dev/devices. The latter is
> 'magic'.  :-)

Again, this patch is for not device driver stuff.

> The problem with "if (of_machine_is_compatible())" initcalls is they are
> an exception to the normal flow of things. You have to go searching for
> specific strings to find out if they are getting called.

Umm, initcall_debug is your friend here.

A standard boilerplate here would actually help in finding these
cases. If arm64 continues to hold the line of no machine_desc, then
this won't be the exception. Are there currently enough exceptions to
justify factoring out this pattern? Obviously, I think there are and
think they will grow, not shrink.

Since none of the proponents of removing/avoiding machine_desc have
weighed in, we'll never reach any conclusion on this. I'll just
continue to open code this as I need to.

> I'm possibly splitting hairs here, but a big part of migration to the
> Linux device model is getting rid of modules that both register a device
> and then bind to it.

There will always be bits that don't fit into the driver model.

Rob
