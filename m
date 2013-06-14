Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3FNS6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 14:58:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:34975 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab3FNS6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 14:58:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,868,1363158000"; 
   d="scan'208";a="353592891"
Date: Fri, 14 Jun 2013 12:00:03 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: i2c: introduce i2c helper i2c_find_client_by_name()
Message-ID: <20130614190003.GA19617@bingao-desk1.fm.intel.com>
References: <20130606183346.GA13259@bingao-desk1.fm.intel.com>
 <CAHp75VcYgpUVpOnKOzkYoZXbEPO_0QG7=WUXza55wpOyRwcKCA@mail.gmail.com>
 <20130606212620.GA13620@bingao-desk1.fm.intel.com>
 <CAHp75VcGUtWyPHrvYDW59-4g8F2m58-Us3CrbJ2bnYJdxnd1Sg@mail.gmail.com>
 <20130611171119.GA35135@bingao-desk1.fm.intel.com>
 <CAHp75VdZA_gouZohD1J+o9ybpXVLLQH=D7QDo9OznW93iBDZpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdZA_gouZohD1J+o9ybpXVLLQH=D7QDo9OznW93iBDZpQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 10:29:09AM +0300, Andy Shevchenko wrote:
> On Tue, Jun 11, 2013 at 8:11 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
> > On Sun, Jun 09, 2013 at 10:53:35PM +0300, Andy Shevchenko wrote:
> >> Please, try to avoid top posting in the future emails.
> >>
> >> On Fri, Jun 7, 2013 at 12:26 AM, Bin Gao <bin.gao@linux.intel.com> wrote:
> >> > With v4l2, the camera sensor i2c devices are taken over by v4l2 master
> >> > driver, i.e. ISP driver, and are not expected to be accessed from
> >> > user sapce by ioctl. So ISP driver has to register them by itself to
> >> > get all related information for further communication. Please check
> >> > v4l2_i2c_new_subdev_board() in drivers/media/video/v4l2-common.c for details.
> >>
> >> Yes, this is legacy approach for non-DT/non-ACPI5 platforms.
> >
> > So what's the new approach for DT/ACPI5 platforms?
> 
> When DT or ACPI5 is enabled and used the devices are enumerated
> through corresponding frameworks in the kernel automatically. So, you
> get them initialized just after i2c host.

This is also true for SFI.
 
> >> > The platform code can definitely disallow calling i2c_register_board_info()
> >> > to register them but keep the i2c devices list and then let ISP driver register
> >> > them. But, problems come when a single kernel is going to run on two platforms
> >> > - one platform has ACPI5 and the other has SFI.
> >>
> >> You have to forget about SFI. Your ISP subdevices use plain platform
> >> data anyway.
> >
> > Why have to forget about SFI which is supported by upstream kernel?
> 
> It doesn't matter. Second sentence above is explained why. SFI,
> unfortunately, has few design flaws, that's why the information
> located there is not much useful in ISP case.

No, from device enumeration point of view, SFI is doing the same thing
as DT and ACPI5. I didn't see any flaws here.


> >> In ACPI 5 case v4l2 framework must be extended to cover that case.
> > To extend v4l2 framework is one of the options,
> 
> That is proper option.
> 
> > but this helper is also one
> > option.
> 
> I think this helper doesn't align to the current workflow.

Even you prefer to extend v4l2, you still need this helper.
The idea is just to move the unregister/register from a specific ISP driver
to v4l2.

I think you misunderstood my pionts somehow. Let me clarfiy a little bit:

Current solution:
1. Platform codes(on top of DT/ACPI5/SFI) don't call i2c_register_board_info(),
instead, prepare a table(kind of platform data) that has all camera i2c device information.
2. ISP driver registers devices listed in the table to i2c core - this makes sure
v4l2 takes over these devices.
The problem with this solution is that when a camera device runs on both ACPI5 and
SFI, the platform codes will get a bit complicated and it's difficult to ensure one
binary kernel runs on both platforms(ACPI5 and SFI).
(To extend v4l2 with this solution doen't resolve my problem)

Solution I'm suggesting:
1. Let the platform codes call i2c_register_board_info() anyway.
2. Since ISP driver knows which camera devices it supports, so it simply unregisters
those devices (get the client by the introduced helper), then register it within v4l2.
This solution ensure one binary kernel can run on both platforms.
(To extend v4l2 with this solution could not be feasible, the device table is
ISP driver specific, not v4l2 specific)

> >> > The dynamic unregister and then
> >> > register based on this new helper will not have dependency on firmware interface -
> >> > the same platform code will work for all platforms.
> >>
> >> It's not a care of the ISP driver. I think you have to talk to Sakari
> >> about your issues.
> >
> > We have to do it in the ISP driver if we want one binary kernel
> > supporting multiple platforms.
> 
> What I'm talking about is not contradicting with that.
> 
> >> >> > A good example is that an ISP(Imaging Signal Processor) driver needs
> >> >> > register i2c camera sensor devices via v4l2, so it has to unregister
> >> >> > all i2c clients that were previously registered by calling
> >> >> > i2c_register_board_info(), and then re-register.
> 
> >> >> Why do you need to re-register them at run time?
> 
> Still this question is not answered.
> 
> 
> --
> With Best Regards,
> Andy Shevchenko
