Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3FOM3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 08:29:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:61827 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab3FOM3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 08:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,871,1363158000"; 
   d="scan'208";a="353847220"
Message-ID: <51BC5E1B.2020400@intel.com>
Date: Sat, 15 Jun 2013 20:29:15 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>, Aaron Lu <aaron.lwe@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware
 expects Windows 8
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com> <51BABC6F.3050201@intel.com> <1371230988.2490.2.camel@x230> <51BBC2E1.9040401@intel.com> <1371260284.523.2.camel@x230> <51BBEA32.1040002@intel.com> <20130615041945.GA4756@srcf.ucam.org>
In-Reply-To: <20130615041945.GA4756@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 12:19 PM, Matthew Garrett wrote:
> On Sat, Jun 15, 2013 at 12:14:42PM +0800, Aaron Lu wrote:
>> On 06/15/2013 09:38 AM, Matthew Garrett wrote:
>>> Well, Windows 8 will only use the ACPI backlight interface if the GPU
>>> driver decides to, right? So the logic for deciding whether to remove
>>> the ACPI backlight control or not should be left up to the GPU. There's
>>
>> I don't know this. From the document I googled, Microsoft suggests under
>> win8, backlight should be controlled by the graphics driver for smooth
>> brightness level change, instead of ACPI or other methods. So it is
>> possible that OEM will not test the ACPI interface well and thus the
>> interface is likely broken. I don't see why GPU driver has any better
>> knowledge on which systems the firmware interface is broken or not.
> 
> The vendor will presumably have tested that backlight control works - if 
> the GPU driver uses the ACPI interface and backlight control is broken, 
> then the vendor would fix it.

I don't think GPU driver uses ACPI interface, that's why for some
systems, ACPI interface is broken while the GPU's is not.

> 
>>> no harm in refusing to expose a working method if there's another
>>> working method, but there is harm in exposing a broken one and expecting
>>> userspace to know the difference.
>>
>> BTW, the proposed solution is not meant to solve win8 problems alone, it
>> should make solving other problems easy and make individual backlight
>> control interface provider module independent with each other such as
>> the platform drivers will not need to check if ACPI video driver will
>> control backlight or not and can always create backlight interface(its
>> default priority is lower that ACPI video driver's so will not be taken
>> by user space by default, showing the same behavior of the current code).
> 
> Sure, but it still requires the replacement of existing userspace. We 
> need to fix the problem with existing userspace, too.

Yes. The problem is two way. First, some of the backlight interface
privoder module provides a broken interface; Two, the userspace picked a
broken interface while there are usable ones. For example, in the win8
thinkpad case, the ACPI video driver provides broken interface and the
GPU driver provides usable interface, but userspace choose ACPI video's
interface. To make things complicated, if we make the broken interface
disappear in ACPI video module, then the platform driver thinkpad_acpi
will start to provide another broken interface. I have to say, solve it
in the GPU code is a clever way, it's just a little weird to me for a
broken interface to be blacklisted, we have to do it in another module,
not the broken module itself.

> 
>> The current acpi_backlight=video/vendor kernel command line is pretty
>> misleading, for laptops that do not have vendor backlight interface,
>> adding acpi_backlight=vendor actually makes the system using the GPU's
>> interface. Some laptops are using this switch to work around problems in
>> ACPI video driver and users think they are using vendor interface.
>> That's why I think we need a new command line as the
>> backlight.force_interface=raw/firmware/platform.
> 
> No, I think we need to fix the bugs that currently require users to pass 
> options.

For ACPI video driver, since it relies on firmware to do the right thing,
if the functionality is broken, then it is, there is hardly anything we
can do...(not always, we can quirk in some cases, but there are cases we
can do nothing). In this case, we can:
1 Ask user to add acpi_backlight=vendor, so that ACPI video driver will
  not create backlight interface and userspace will not pick it;
2 Add that model in DMI table in video_detect.c, eliminating the need for
  that command line;
3 Add that model in DMI table in another module, let that module
  unregister backlight interface provided by ACPI video as is done in
  acer-wmi, asus-wmi, and i915 in this case;
3 Use the backlight section in xorg.conf to make X uses another
  backlight interface. This may not work for distros that use
  gsd-backlight-helper, which always prefers firmware.

Which one do you prefer?

> 
>> Instead of letting individual driver to make decisions on which
>> backlight interface this system should use(either in platform driver as
>> we currently did, see acer-wmi and asus-wmi, or GPU driver as this case),
>> I think we need a better and clear way to handle such things. For
>> example, suppose an acer laptop: vendor does not support backlight, ACPI
>> video's backlight interface is broken and GPU's works, to make it work,
>> user will need to select acer-wmi module while this module does not have
>> anything to do with the functionality, but simply because it serves as
>> the backlight manager for acer laptops.
> 
> How do these machines work under Windows? Until we know the answer to 
> that, we don't know what the correct way to handle the problem is under 
> Linux.

Do you mean we need to understand Windows behavior so that we can
decide where to place the code to do the backlight management thing?
So for win8 case, we know MS will use GPU driver to do backlight
control, all this means to me is, ACPI video's and platform driver's
interface are more likely broken on those systems, but it doesn't
qualify why Linux' GPU driver should do the decision, it's not that the
GPU driver can poke some GPU register and then decide oh, this model
does not have working ACPI backlight interface. As this patch shows, we
make the decision by OSI, which is not specific to GPU driver.

BTW, I don't think any module knows something better than another
module, all quirk logic and DMI entry we currently have in Linux are
got by user's feedback(bug reports), it doesn't seem to me some module
is natrually the one that should make this decision. Or do I miss
something?

Thanks,
Aaron
