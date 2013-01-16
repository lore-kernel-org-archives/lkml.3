Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759140Ab3APKnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:43:24 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:46564 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759121Ab3APKnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:43:20 -0500
Message-ID: <50F68443.3040900@suse.cz>
Date: Wed, 16 Jan 2013 11:43:15 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20121129 Thunderbird/18.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: -next: no resume from suspend
References: <50F3D9E8.6040802@suse.cz> <16191961.j5ydKsJ3d3@vostro.rjw.lan>
In-Reply-To: <16191961.j5ydKsJ3d3@vostro.rjw.lan>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 01:56 PM, Rafael J. Wysocki wrote:
> On Monday, January 14, 2013 11:11:52 AM Jiri Slaby wrote:
>> Hi,
>>
>> since friday's -next (the last known to be working is the last monday's)
>> I cannot resume from suspend. The last thing I see with
>> no_console_suspend is:
>> i915: No ACPI video bus found
>>
>> But I used to see the message always, so this is no difference. Any idea
>> before I start bisecting?
> 
> Well, what's the next message you normally see with no_console_suspend?

As I wrote in the other message, the kernel is spinning in
acpi_rs_get_aml_length. There are weird resources in the list. For
serial 00:05 there is resource with type and length equal to 0 and for
parport_pc 00:06 there is resource type 58196295 with length of
134284152. See:
acpi_rs_get_aml_length: ffff8801b9f7b380 type=3 len=16
acpi_rs_get_aml_length: ffff8801b9f7b390 type=0 len=0
acpi_rs_get_aml_length: BAD ffff8801b9f7b390 type=0 len=0
serial 00:05: activation failed
dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
PM: Device 00:05 failed to resume: error -5
acpi_rs_get_aml_length: ffff8801b9f7b680 type=3 len=24
acpi_rs_get_aml_length: ffff8801b9f7b698 type=58196295 len=134284152
parport_pc 00:06: activation failed
dpm_run_callback(): pnp_bus_resume+0x0/0x80 returns -5
PM: Device 00:06 failed to resume: error -5

if (!length)
  return error;

makes it resume again with the errors above...

This was 3.8.0-rc3-next-20130114. Going to test 20130116 as there are
these patches:
616979e memory-hotplug: remove sysfs file of node
a41a27d ACPI / PM: remove leading whitespace from #ifdef
ace2342 ACPI / PM: Consolidate suspend-specific and hibernate-specific code
27a5fb8 ACPI / PM: Move device power management functions to device_pm.c
717a5d1 ACPI / PM: Export power states of ACPI devices via sysfs
ee8f808 ACPI / PM: Common string representations of device power states
44fed9b ACPI / PM: More visible function for retrieving device power states
81ed027 ACPI / PM: Change the way power transitions to D3cold are
carried out
113542c ACPI: Use system level attribute of wakeup power resources
c6fdf80 ACPI: Take power resource initialization errors into account
b6568e5 ACPI / scan: Consolidate extraction of power resources lists
8a0a4d6 ACPI / scan: Remove unnecessary initialization of local variables
5c24aa4 ACPI / scan: Move power state initialization to a separate routine
59e8500 ACPI / PM: Take order attribute of wakeup power resources into
account
f369253 ACPI / PM: Take order attribute of power resources into account
3170b40 ACPI: Do not use device power states of power resources
17ece8c ACPI: Drop power resources driver
5e4cd24 ACPI / scan: Treat power resources in a special way
5b32520 ACPI / scan: More straightforward preparation of ACPI device objects
5a62e76 ACPI / PM: Rework the handling of devices depending on power
resources
5993c46 ACPI: update ej_event interface to take acpi_device
05404d8 ACPI / scan: Add second pass to acpi_bus_trim()
cecdb19 ACPI / scan: Change the implementation of acpi_bus_trim()
ae28179 ACPI / scan: Drop the second argument of acpi_bus_trim()
b17b537 ACPI / scan: Drop the second argument of acpi_device_unregister()
a412a11 ACPI / glue: Fix build with ACPI_GLUE_DEBUG set
abe9921 ACPI / scan: Fix check of device_attach() return value.
e92a79b ACPI thermal: remove unnecessary newline from exception message
2b16c77 ACPI sysfs: remove unnecessary newline from exception
f1f37cb ACPI video: remove unnecessary newline from error messages
b43e106 ACPICA: Cleanup table handler naming conflicts.
42f8fb7 ACPICA: Source restructuring: split large files into 8 new files.

thanks,
-- 
js
suse labs
