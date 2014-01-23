Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaAWWBc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 17:01:32 -0500
Received: from xes-mad.com ([216.165.139.218]:54074 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaAWWBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 17:01:31 -0500
X-Greylist: delayed 1025 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Jan 2014 17:01:30 EST
Message-ID: <52E18D25.6070403@xes-inc.com>
Date: Thu, 23 Jan 2014 15:44:05 -0600
From: Peter Tyser <ptyser@xes-inc.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org
CC: Samuel Ortiz <sameo@linux.intel.com>, x86@kernel.org,
        James Ralston <james.d.ralston@intel.com>
Subject: Re: Kernel freeze with v3.13 on Avoton CPUs
References: <20140123065051.GA1402@roeck-us.net>
In-Reply-To: <20140123065051.GA1402@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:50 AM, Guenter Roeck wrote:
> Hi folks,
> 
> we are seeing an odd problem with kernel version 3.13 running on Mohan Peak
> with an Avoton 8-core CPU. The kernel boots to the login prompt and then
> freezes silently within a few seconds.
> 
> The problem disappears if we revert patch 8477128fe0 (mfd: lpc_ich: Add support
> for Intel Avoton SoC).
> 
> v3.10.27 runs fine. If we cherry-pick 8477128fe0 on top of 3.10.27 we see
> exactly the same problem.
> 
> Any idea what might be causing this, and/or what we could do to track this down
> further ?

I took a look at the Avoton datasheet, and it looks like its register
layout is close, but not identical to the other ICH chipsets supported
by the lpc_ich driver which could be part of the issue.

Eg the "enable ACPI BAR" bit is in register offset 0x44 of PCI device
31, function 0 on most ICH chipsets, while it's in 0x40 on the Avoton.
So on the Avoton the "enable ACPI BAR" bit isn't being set by the
lpc_ich driver.  If your BIOS didn't set this bit, it could cause
erratic behavior since Linux assumes the ACPI region has been enabled.
The driver is also writing to offset 0x44 which is RO/reserved on the
Avoton.  In theory this should be OK, but clearly isn't "correct".

The same comment applies to the GPIO register in PCI device 31, function
0.  The current lpc_ich driver enables the GPIO region in offset 0x4C
while the Avoton does in 0x48.

I'm not sure if the above explains the specific behavior you saw, but
does indicate that the driver shouldn't be used for the Avoton as-is.

I don't have an Avoton to try and reproduce, but do have access to a Bay
Trail platform which appears to have the same register layout as the
Avoton.  I can give adding it to the lpc_ich driver a shot in the next
week and see if I run into the same issues as you did.

In the short term we could either revert 8477128fe0 or wait a bit until
more investigation is done in hopes that we can fix it.

Peter
