Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3LBQ3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 11:29:42 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40611 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3LBQ3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 11:29:41 -0500
Date: Mon, 2 Dec 2013 16:29:39 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Andreas Noever <andreas.noever@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/12] Thunderbolt hotplug support for Apple hardware
 (testers needed)
Message-ID: <20131202162938.GA11241@srcf.ucam.org>
References: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385688949-7101-1-git-send-email-andreas.noever@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 02:35:37AM +0100, Andreas Noever wrote:> 
> There are still a number of limitations:
>  (1) The system must be booted with acpi_osi=Darwin. Otherwise ACPI will cut
> power to the controller.
>  (2) After suspend the controller is gone. I think that ACPI thinks that we are
> Windows and cuts power, even with acpi_osi=Darwin.

There's a few ACPI methods involved here. The first is DTLK, which is 
called by the firmware on resume. It'll cut power to the chip. So, you 
need to be able to power it back up. However, you only want to power it 
up if there's a device connected. The XRIL method will return 1 if 
there's a device connected and 0 otherwise. If there's a device 
connected, call XRPE with an argument of 1 to power it back up.

That works fine if there's no hotplugging involved, but there is so 
things get a little more complicated. Apple provide an out of band 
mechanism for receiving notifications on the device. Call the _GPE 
method and install a gpe handler for the value that you get back. This 
will be called on every device plug or unplug (possibly just plug? It's 
been a while since I tested). Call XRIL to confirm that there's a device 
attached and then call XRPE to power it up.

At least, that's my recollection. There's also the SXIO, SXIL, SXLV and 
SXFP methods that provide some kind of power management, but I'm not 
sure how those fit in.

If you want to confirm that you're supposed to be using these methods, 
call _DSM on the device with a UUID of 
C6B7B5A0-1813-1C44-B0C9-FE695EAF949B (see DTGP in the DSDT), arg1 of 1, 
arg2 of 0. If it's an Apple you'll get back return value of 1 and a 
buffer containing the string "power-save". If it's not an Apple, or if 
the device doesn't support power saving, you'll get back a zero or an 
error that the method wasn't found.


-- 
Matthew Garrett | mjg59@srcf.ucam.org
