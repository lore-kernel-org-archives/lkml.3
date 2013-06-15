Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3FOPQf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 11:16:35 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39093 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3FOPQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 11:16:33 -0400
Date: Sat, 15 Jun 2013 16:16:28 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Aaron Lu <aaron.lu@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if
 firmware expects Windows 8
Message-ID: <20130615151628.GA9868@srcf.ucam.org>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
 <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
 <51BABC6F.3050201@intel.com>
 <1371230988.2490.2.camel@x230>
 <51BBC2E1.9040401@intel.com>
 <1371260284.523.2.camel@x230>
 <51BBEA32.1040002@intel.com>
 <20130615041945.GA4756@srcf.ucam.org>
 <51BC5E1B.2020400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BC5E1B.2020400@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 08:29:15PM +0800, Aaron Lu wrote:
> On 06/15/2013 12:19 PM, Matthew Garrett wrote:
> > The vendor will presumably have tested that backlight control works - if 
> > the GPU driver uses the ACPI interface and backlight control is broken, 
> > then the vendor would fix it.
> 
> I don't think GPU driver uses ACPI interface, that's why for some
> systems, ACPI interface is broken while the GPU's is not.

On systems where the ACPI interface is broken, the GPU driver clearly 
doesn't use the ACPI interface. As yet, we don't know if that's always 
true, though.

> > Sure, but it still requires the replacement of existing userspace. We 
> > need to fix the problem with existing userspace, too.
> 
> Yes. The problem is two way. First, some of the backlight interface
> privoder module provides a broken interface; Two, the userspace picked a
> broken interface while there are usable ones. For example, in the win8
> thinkpad case, the ACPI video driver provides broken interface and the
> GPU driver provides usable interface, but userspace choose ACPI video's
> interface. To make things complicated, if we make the broken interface
> disappear in ACPI video module, then the platform driver thinkpad_acpi
> will start to provide another broken interface. I have to say, solve it
> in the GPU code is a clever way, it's just a little weird to me for a
> broken interface to be blacklisted, we have to do it in another module,
> not the broken module itself.

The ACPI driver has no way of making this kind of policy decision. The 
GPU driver does.

> > No, I think we need to fix the bugs that currently require users to pass 
> > options.
> 
> For ACPI video driver, since it relies on firmware to do the right thing,
> if the functionality is broken, then it is, there is hardly anything we
> can do...(not always, we can quirk in some cases, but there are cases we
> can do nothing). In this case, we can:
> 1 Ask user to add acpi_backlight=vendor, so that ACPI video driver will
>   not create backlight interface and userspace will not pick it;
> 2 Add that model in DMI table in video_detect.c, eliminating the need for
>   that command line;
> 3 Add that model in DMI table in another module, let that module
>   unregister backlight interface provided by ACPI video as is done in
>   acer-wmi, asus-wmi, and i915 in this case;
> 3 Use the backlight section in xorg.conf to make X uses another
>   backlight interface. This may not work for distros that use
>   gsd-backlight-helper, which always prefers firmware.
> 
> Which one do you prefer?

I'd prefer to figure out how it works in Windows and implement it the 
same way.

> > How do these machines work under Windows? Until we know the answer to 
> > that, we don't know what the correct way to handle the problem is under 
> > Linux.
> 
> Do you mean we need to understand Windows behavior so that we can
> decide where to place the code to do the backlight management thing?
> So for win8 case, we know MS will use GPU driver to do backlight
> control, all this means to me is, ACPI video's and platform driver's
> interface are more likely broken on those systems, but it doesn't
> qualify why Linux' GPU driver should do the decision, it's not that the
> GPU driver can poke some GPU register and then decide oh, this model
> does not have working ACPI backlight interface. As this patch shows, we
> make the decision by OSI, which is not specific to GPU driver.

Sure it is - for all we know there's a value in the opregion space that 
tells the Intel GPU driver which interface we should be using. We don't 
know because Intel haven't released a version of the opregion driver 
newer than 2007. It may be that all Windows 8 GPU drivers use the GPU 
backlight control registers directly and never use any firmware 
interface, but right now we simply don't know that. All we can do is 
look at the existing cases we have and say that it appears that 
Intel graphics systems don't use the ACPI interface. Anything more than 
that requires more evidence.

> BTW, I don't think any module knows something better than another
> module, all quirk logic and DMI entry we currently have in Linux are
> got by user's feedback(bug reports), it doesn't seem to me some module
> is natrually the one that should make this decision. Or do I miss
> something?

The GPU driver makes the policy decision under Windows 8, so it's the 
natural place to make this decision on Windows 8 systems.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
