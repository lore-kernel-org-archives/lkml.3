Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab3FRJ1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:27:10 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:64113 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3FRJ1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <20130618084845.GM5461@arwen.pp.htv.fi>
References: <1371539701-11441-1-git-send-email-chao.xie@marvell.com>
	<20130618080130.GC5461@arwen.pp.htv.fi>
	<51C0191F.2050104@ti.com>
	<20130618082428.GF5461@arwen.pp.htv.fi>
	<51C01B80.3050803@ti.com>
	<20130618083712.GJ5461@arwen.pp.htv.fi>
	<51C01E11.8050201@ti.com>
	<20130618084845.GM5461@arwen.pp.htv.fi>
Date: Tue, 18 Jun 2013 17:27:07 +0800
Message-ID: <CADApbeiT+zv9kkrJ+J3XMZ1WWBXeHaQ20u12V2+DbOs3mB6vzA@mail.gmail.com>
Subject: Re: [PATCH] USB: initialize or shutdown PHY when add or remove host controller
From: Chao Xie <xiechao.mail@gmail.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, Chao Xie <chao.xie@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 4:48 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jun 18, 2013 at 11:45:05AM +0300, Roger Quadros wrote:
>> >>>>> this looks wrong for two reasons:
>> >>>>>
>> >>>>> a) you're not grabbing the PHY here.
>> >>>>>
>> >>>>>         You can't just assume another entity grabbed your PHY for you.
>> >>>>
>> >>>> Isn't that done in the controller drivers e.g. ehci-fsl.c, ohci-omap, etc?
>> >>>
>> >>> right, and what I'm saying is that it should all be re-factored into
>> >>> ehci-hcd core :-)
>> >>>
>> >>>> If the controllers don't want HCD core to manage the PHY they can just set it
>> >>>> to some error code.
>> >>>
>> >>> they shouldn't have the choice, otherwise it'll be a bit of a PITA to
>> >>> maintain the code. ehci core tries to grab the PHY, if it's not there,
>> >>> try to continue anyway. Assume it's not needed.
>> >>>
>> >>
>> >> OK fine, but ehci-omap is a weird case as it needs a slightly different
>> >> sequence as to when PHY is initialized depending on which mode it is. (Transceiver
>> >> or transceiver-less). please see this fix.
>> >> http://www.spinics.net/lists/stable/msg12106.html
>> >>
>> >> All I'm saying as that ehci-omap needs a way to tell hcd core that it needs PHY
>> >> handling for itself.
>> >
>> > why don't you do that always ? Meaning, why don't you *always* take PHY
>> > out of suspend ? If PHY is suspended, you can't wakeup unless you have
>> > (in OMAP case) pad wakeup working, right ?
>> >
>>
>> Maybe I wasn't clear before. This is nothing about wakeup and e always take PHY out of suspend.
>> The problem is when to take it out of suspend relative to when EHCI controller starts.
>> Let me clarify.
>>
>> In Transceiver mode we need this.
>>
>> - bring phy out of reset
>> - start EHCI controller
>>
>> Whereas for Transceiver-less mode we need this.
>>
>> - start EHCI controller
>> - bring phy out of reset
>>
>> If there is some way to signal this behaviour to the HCD core, it
>> should be good enough.
>
> alright, now I get it. That's quite messed up that it has to be this way
> :-p
>
It depends on the host controler's driver ehci-xxx to get the phy and
set it to hcd->phy.
If some controller do not want HCD or EHCI-HCD to do the phy
initialization and shutdown, just do not set hcd->phy, and it will be
NULL.
If the host controller driver successlly get the phy, it can set
hcd->phy, or it need return false in its probe.


> --
> balbi
