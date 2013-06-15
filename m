Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3FOB0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 21:26:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:17460 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab3FOB0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 21:26:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,869,1363158000"; 
   d="scan'208";a="255282355"
Message-ID: <51BBC2E1.9040401@intel.com>
Date: Sat, 15 Jun 2013 09:26:57 +0800
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
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>  <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>  <51BABC6F.3050201@intel.com> <1371230988.2490.2.camel@x230>
In-Reply-To: <1371230988.2490.2.camel@x230>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2013 01:29 AM, Matthew Garrett wrote:
> On Fri, 2013-06-14 at 14:47 +0800, Aaron Lu wrote:
> 
>> What about a priority based solution? We can introduce a new field named
>> priority to backlight_device and instead of calling another module's
>> function like the unregister one here(which cause unnecessary module
>> dependency), we only need to boost priority for its own interface. This
>> field will be exported to sysfs, so user can change it during runtime
>> too. And we can also introduce a new kernel command line as
>> backlight.force_interface=raw/firmware/platform, to overcome the limited
>> functionality provided by acpi_backlight=video/vendor, which does not
>> involve GPU's interface.
> 
> How would that work with existing userspace?

User space tool will need to be updated to use this as stated in the
gist page, I've patches for gsd-backlight-helper and xorg-x11-drv-intel,
for others we can add I think if the priority based solution is deemed
useful.

> 
>> And we can place the quirk code in backlight layer instead of individual
>> backlight functionality provider module. Suppose we have a backlight
>> manager there, for all win8 systems, we can boost the raw type's
>> priority on its registration, so no need to add code in
>> intel/amd/etc./'s GPU driver code.
> 
> But we'd need to add code to every piece of userspace that currently
> uses the backlight, right?

Yes that's the case.

> 
>> With priority based solution, all backlight control interfaces stay,
>> the priority field is an indication given by kernel to user space.
> 
> We shouldn't export interfaces if we don't expect them to work.

It's not easy to decide if they work or not sometimes, e.g. I came
across a system that claims win8 in ACPI table and has an Intel GPU,
while its ACPI video interface also works. With this patch, the working
ACPI video interface is removed, while with the priority based solution,
the GPU's interface priority gets higher, but the ACPI video interface
still stays.

Thanks,
Aaron
