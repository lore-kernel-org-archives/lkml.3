Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3ILPN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:13:56 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:24812 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3ILPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:13:55 -0400
Message-ID: <1378998712.12538.18.camel@misato.fc.hp.com>
Subject: Re: [Bug report] Warning when hot-add an ACPI0004 device.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Date: Thu, 12 Sep 2013 09:11:52 -0600
In-Reply-To: <52314A89.2060809@cn.fujitsu.com>
References: <52314A89.2060809@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-12 at 13:00 +0800, Tang Chen wrote:
> Hi Rafael, Toshi,
> 
> When we hot-add an ACPI0004 device, we got the following warning:
> 
> 	acpi ACPI0004:01: Attempt to re-insert
> 
> The ACPI0004 device is a System Board in Fujitsu server, which has two
> numa nodes (processors and memory).
> 
> It seems that we reserved the ACPI_NOTIFY_DEVICE_CHECK event twice in
> acpi_hotplug_notify_cb().
> 
> 
> According to bisect, this happens after the following commit:
> 
>  From 68a67f6c78b80525d9b3c6672e7782de95e56a83 Mon Sep 17 00:00:00 2001
> From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> Date: Sun, 3 Mar 2013 23:05:55 +0100
> Subject: [PATCH 1/1] ACPI / container: Use common hotplug code
> 
> Switch the ACPI container driver to using common device hotplug code
> introduced previously.  This reduces the driver down to a trivial
> definition and registration of a struct acpi_scan_handler object.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Toshi Kani <toshi.kani@hp.com>
> Tested-by: Toshi Kani <toshi.kani@hp.com>
> ---
>   drivers/acpi/container.c | 146 
> ++++-------------------------------------------
>   1 file changed, 10 insertions(+), 136 deletions(-)
> 
> 
> I'm now investigating this problem. If you have any idea about why this
> happens, please let me know.

With the above change, container devices use the common notify handler,
which logs the warning message in question when it receives device check
twice on a same device.  Before the change, the container-specific
notify handler did not log this message in the same case (but considered
it as an eject request).

So, I suspect that you are getting device check twice regardless of the
kernel change.  Can you check KERN_DEBUG messages to see if that is the
case?  The notify handler logs all events with KERN_DEBUG.

Thanks,
-Toshi

