Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524Ab3KMG4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 01:56:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:37953 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869Ab3KMG43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 01:56:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,690,1378882800"; 
   d="scan'208";a="432556888"
Message-ID: <528322CC.2000508@intel.com>
Date: Wed, 13 Nov 2013 14:57:16 +0800
From: Aaron Lu <aaron.lu@intel.com>
Organization: Intel, Shanghai, PRC
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] ACPI / driver core: Store a device pointer in struct
 acpi_dev_node
References: <3268437.YsusHvklcv@vostro.rjw.lan> <52803124.7000304@intel.com> <1683079.zjqzsOAjXB@vostro.rjw.lan>
In-Reply-To: <1683079.zjqzsOAjXB@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 09:45 PM, Rafael J. Wysocki wrote:
> On Monday, November 11, 2013 09:21:40 AM Lan Tianyu wrote:
>> On 2013年11月10日 08:58, Rafael J. Wysocki wrote:
>>> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>>
>>> Modify struct acpi_dev_node to contain a pointer to struct device
>>> ambedded in the struct acpi_device associated with the given device
>>> object (that is, its ACPI companion device) instead of an ACPI handle
>>> corresponding to that struct acpi_device.  Introduce two new macros
>>> for manipulating that pointer in a CONFIG_ACPI-safe way,
>>> ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
>>> ACPI_HANDLE() macro to take the above changes into account.
>>> Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
>>> use ACPI_COMPANION_SET() instead.  For some of them who used to
>>> pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
>>> introduce a helper routine acpi_preset_companion() doing an
>>> equivalent thing.
>>>
>>> The rationale for using a struct device pointer instead of a
>>> struct acpi_device one as the member of struct acpi_dev_node is
>>> that it allows device.h to avoid including linux/acpi.h which would
>>> introduce quite a bit of compilation overhead for stuff that doesn't
>>> care about ACPI.
>>> In turn, moving the macros to linux/acpi.h forces
>>> the stuff that does care about ACPI to include that file as
>>> appropriate anyway.
>>
>> How about declaring "struct acpi_device" in the device.h? This can help
>> to use struct acpi_device without including linux/acpi.h.
>>
>> struct iommu_ops and struct iommu_group have been used by the same way
>> in the device.h.
> 
> Yes, they are.  Well, that appears to work too.
> 
> Updated patch is appended.  It also contains some fixes for problems reported
> by the auto build system and it's been tested on x86-64 now, so it should be
> reasonably close to final.
> 
> Thanks,
> Rafael
> 
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node
> 
> Modify struct acpi_dev_node to contain a pointer to struct acpi_device
> associated with the given device object (that is, its ACPI companion
> device) instead of an ACPI handle corresponding to it.  Introduce two
> new macros for manipulating that pointer in a CONFIG_ACPI-safe way,
> ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
> ACPI_HANDLE() macro to take the above changes into account.
> Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
> use ACPI_COMPANION_SET() instead.  For some of them who used to
> pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
> introduce a helper routine acpi_preset_companion() doing an
> equivalent thing.
> 
> The main motivation for doing this is that there are things
> represented by struct acpi_device objects that don't have valid
> ACPI handles (so called fixed ACPI hardware features, such as
> power and sleep buttons) and we would like to create platform
> device objects for them and "glue" them to their ACPI companions
> in the usual way (which currently is impossible due to the
> lack of valid ACPI handles).  However, there are more reasons
> why it may be useful.
> 
> First, struct acpi_device pointers allow of much better type checking
> than void pointers which are ACPI handles, so it should be more
> difficult to write buggy code using modified struct acpi_dev_node
> and the new macros.  Second, the change should help to reduce (over
> time) the number of places in which the result of ACPI_HANDLE() is
> passed to acpi_bus_get_device() in order to obtain a pointer to the
> struct acpi_device associated with the given "physical" device,
> because now that pointer is returned by ACPI_COMPANION() directly.
> Finally, the change should make it easier to write generic code that
> will build both for CONFIG_ACPI set and unset without adding explicit
> compiler directives to it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Aaron Lu <aaron.lu@intel.com> for ATA and SDIO part.

Thanks,
Aaron
