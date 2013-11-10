Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3KJPO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:14:29 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:42890 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab3KJPOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:14:11 -0500
Date: Sun, 10 Nov 2013 07:16:40 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] ACPI / driver core: Store a device pointer in struct
 acpi_dev_node
Message-ID: <20131110151640.GC26793@kroah.com>
References: <3268437.YsusHvklcv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3268437.YsusHvklcv@vostro.rjw.lan>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 10, 2013 at 01:58:42AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Modify struct acpi_dev_node to contain a pointer to struct device
> ambedded in the struct acpi_device associated with the given device
> object (that is, its ACPI companion device) instead of an ACPI handle
> corresponding to that struct acpi_device.  Introduce two new macros
> for manipulating that pointer in a CONFIG_ACPI-safe way,
> ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
> ACPI_HANDLE() macro to take the above changes into account.
> Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
> use ACPI_COMPANION_SET() instead.  For some of them who used to
> pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
> introduce a helper routine acpi_preset_companion() doing an
> equivalent thing.
> 
> The rationale for using a struct device pointer instead of a
> struct acpi_device one as the member of struct acpi_dev_node is
> that it allows device.h to avoid including linux/acpi.h which would
> introduce quite a bit of compilation overhead for stuff that doesn't
> care about ACPI.  In turn, moving the macros to linux/acpi.h forces
> the stuff that does care about ACPI to include that file as
> appropriate anyway.
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
> First, struct device pointers allow of much better type checking
> than void pointers which are ACPI handles, so it should be more
> difficult to write buggy code using modified struct acpi_dev_node
> and the new macros.  Second, it should help to reduce the number
> of places in which the result of ACPI_HANDLE() is passed to
> acpi_bus_get_device() in order to obtain a pointer to the
> struct acpi_device associated with the given "physical" device,
> because now that pointer can be obtained directly by applying
> to_acpi_device() to the result of the ACPI_COMPANION() macro.
> Finally, it should make it easier to write generic code that will
> build both for CONFIG_ACPI set and unset without adding explicit
> compiler directives to it.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
> 
> Hi Everybody,
> 
> First of all, I haven't tested this yet, so caveat emptor.  I have compiled
> it on x86-64 for CONFIG_ACPI set and unset and I'm going to feed it to the
> auto build system shortly in case I overlooked something build-related.
> 
> Please have a look and let me know if you have any problems with this in
> principle.  If not, I'd like to queue it up for inclusion by the end of
> the merge window or in the -rc2 time frame (to avoid collisions with any
> big merges), as I'd like to be able to work on top of it during the 3.14
> cycle if possible.

At first glance, this looks good to me, thanks for removing that void *,
I like this a lot better now.

greg k-h
