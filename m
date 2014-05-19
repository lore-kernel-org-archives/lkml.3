Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638AbaESUD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:03:58 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59953 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932143AbaESUD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:03:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC][PATCH 2/3] PM / sleep: Mechanism to avoid resuming runtime-suspended devices unnecessarily
Date: Mon, 19 May 2014 22:20:51 +0200
Message-ID: <3015549.0dZ2xYlt4R@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140519021831.29767863@jacob-desktop>
References: <20140515000320.3c1c9256@jacob-desktop> <1491497.iq6zE5EtMa@vostro.rjw.lan> <20140519021831.29767863@jacob-desktop>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 19, 2014 02:18:31 AM Jacob Pan wrote:
> On Fri, 16 May 2014 23:08:01 +0200
> "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> 
> > On Friday, May 16, 2014 08:20:55 AM Jacob Pan wrote:
> > > On Thu, 15 May 2014 11:58:55 -0400 (EDT)
> > > Alan Stern <stern@rowland.harvard.edu> wrote:
> > > 
> > > > On Thu, 15 May 2014, Jacob Pan wrote:
> > > > 
> > > > > On Thu, 15 May 2014 10:29:42 -0400 (EDT)
> > > > > Alan Stern <stern@rowland.harvard.edu> wrote:
> > > > > 
> > > > > > On Thu, 15 May 2014, Jacob Pan wrote:
> > > > > > 
> > > > > > > > > should we respect ignore_children flag here? not all
> > > > > > > > > parent devices create children with proper .prepare()
> > > > > > > > > function. this allows parents override children.
> > > > > > > > > I am looking at USB, a USB device could have logical
> > > > > > > > > children such as ep_xx, they don't go through the same
> > > > > > > > > subsystem .prepare().
> > > > > > > > 
> > > > > > > > Well, I'm not sure about that.  Let me consider that for a
> > > > > > > > while.
> > > > > > > OK. let me be more clear about the situation i see in USB.
> > > > > > > Correct me if I am wrong, a USB device will always has at
> > > > > > > least one endpoint/ep_00 as a kid for control pipe, it is a
> > > > > > > logical device. So when device_prepare() is called, its
> > > > > > > call back is NULL which makes .direct_complete = 0. Since
> > > > > > > children device suspend is called before parents, the
> > > > > > > parents .direct_complete flag will always get cleared.
> > > > > > > 
> > > > > > > What i am trying to achieve here is to see if we avoid
> > > > > > > resuming built-in (hardwired connect_type) non-hub USB
> > > > > > > devices based on this new patchset. E.g. we don't want to
> > > > > > > resume/suspend USB camera every time in system
> > > > > > > suspend/resume cycle if they are already rpm suspended. We
> > > > > > > can save ~100ms resume time for the devices we have tested.
> > > > > > 
> > > > > > This is a good point, but I don't think it is at all related
> > > > > > to ignore_children.
> > > > > > 
> > > > > > Instead, it seems that the best way to solve it would be to
> > > > > > add a ->prepare() handler for usb_ep_device_type that would
> > > > > > always turn on direct_complete.
> > > > > > 
> > > > > yeah, that would solve the problem with EP device type. But what
> > > > > about other subdevices. e.g. for USB camera, uvcvideo device? We
> > > > > can add .prepare(return 1;) for each level but would it be
> > > > > better to have a flag similar to ignore_children if not
> > > > > ignore_children itself.
> > > > 
> > > > Something like that could always be added.
> > > or, how about if a device's .prepare() is NULL, we could
> > > assume .direct_resume() should be set. i.e.
> > 
> > You mean direct_complete (which is a flag, not a function), I suppose?
> > 
> yes.
> > Wouldn't that go a bit too far?  It seems to be based on the
> > assumption that all devices having no ->prepare() callback can be
> > safely left in runtime suspend over a system suspend/resume cycle,
> > but is that assumption actually satisfied for all such devices?
> > 
> yes, I agree it is risky though i don't see problems with my limited
> testing. But on the other side, it is too strict.
> I also tried adding .prepare( return 1;) to usb_ep_device_type pm ops,
> that didn't work either. The reason is that ep devices don't support
> runtime pm (disable_depth > 0). I think in this case ignore_children
> flag should be the right indicator to ignore pm_runtime_suspended()?

I guess an "ignore this device completely for PM" flag as suggested by
Alan would be better.

Rafael

