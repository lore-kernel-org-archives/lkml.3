Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3FOEOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 00:14:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:3888 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3FOEOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 00:14:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,870,1363158000"; 
   d="scan'208";a="317346511"
Message-ID: <51BBEA32.1040002@intel.com>
Date: Sat, 15 Jun 2013 12:14:42 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
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
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>  <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>  <51BABC6F.3050201@intel.com> <1371230988.2490.2.camel@x230>  <51BBC2E1.9040401@intel.com> <1371260284.523.2.camel@x230>
In-Reply-To: <1371260284.523.2.camel@x230>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 09:38 AM, Matthew Garrett wrote:
> On Sat, 2013-06-15 at 09:26 +0800, Aaron Lu wrote:
>> It's not easy to decide if they work or not sometimes, e.g. I came
>> across a system that claims win8 in ACPI table and has an Intel GPU,
>> while its ACPI video interface also works. With this patch, the working
>> ACPI video interface is removed, while with the priority based solution,
>> the GPU's interface priority gets higher, but the ACPI video interface
>> still stays.
> 
> Well, Windows 8 will only use the ACPI backlight interface if the GPU
> driver decides to, right? So the logic for deciding whether to remove
> the ACPI backlight control or not should be left up to the GPU. There's

I don't know this. From the document I googled, Microsoft suggests under
win8, backlight should be controlled by the graphics driver for smooth
brightness level change, instead of ACPI or other methods. So it is
possible that OEM will not test the ACPI interface well and thus the
interface is likely broken. I don't see why GPU driver has any better
knowledge on which systems the firmware interface is broken or not.

> no harm in refusing to expose a working method if there's another
> working method, but there is harm in exposing a broken one and expecting
> userspace to know the difference.

BTW, the proposed solution is not meant to solve win8 problems alone, it
should make solving other problems easy and make individual backlight
control interface provider module independent with each other such as
the platform drivers will not need to check if ACPI video driver will
control backlight or not and can always create backlight interface(its
default priority is lower that ACPI video driver's so will not be taken
by user space by default, showing the same behavior of the current code).

The current acpi_backlight=video/vendor kernel command line is pretty
misleading, for laptops that do not have vendor backlight interface,
adding acpi_backlight=vendor actually makes the system using the GPU's
interface. Some laptops are using this switch to work around problems in
ACPI video driver and users think they are using vendor interface.
That's why I think we need a new command line as the
backlight.force_interface=raw/firmware/platform.

Instead of letting individual driver to make decisions on which
backlight interface this system should use(either in platform driver as
we currently did, see acer-wmi and asus-wmi, or GPU driver as this case),
I think we need a better and clear way to handle such things. For
example, suppose an acer laptop: vendor does not support backlight, ACPI
video's backlight interface is broken and GPU's works, to make it work,
user will need to select acer-wmi module while this module does not have
anything to do with the functionality, but simply because it serves as
the backlight manager for acer laptops.

The above information and idea is formed while solving bugs reported
in kernel bugzilla video component, the proposed solutin may not be good
enough, but I hope we can find a better way to handle backlight problems.

Thanks,
Aaron
