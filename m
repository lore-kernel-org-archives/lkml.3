Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaKJNyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:54:16 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34372 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaKJNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:54:13 -0500
Date: Mon, 10 Nov 2014 13:54:04 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com
Subject: Re: dmesg spam: "PnPBIOS: pnp_dock_thread: unexpected status 0x5
 flooding"
Message-ID: <20141110135404.2de623a5@alan.etchedpixels.co.uk>
In-Reply-To: <trinity-0270e0ae-a135-4789-9ed2-f8fd1f7cff71-1415318071046@3capp-webde-bs13>
References: <trinity-0270e0ae-a135-4789-9ed2-f8fd1f7cff71-1415318071046@3capp-webde-bs13>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2014 00:54:31 +0100
devzero@web.de wrote:

> Hi, 
> 
> on an ancient GX1 Geode embedded board (Evo T20/Wyse wt3235le Thin Client, which are cheap (<$10) and low power x86 embeded platform) , dmesg is getting constantly spammed with "PnPBIOS: pnp_dock_thread: unexpected status 0x5" during and after boot. 
> 
> Any ideas what this means and how to stop that?
> 
> It seems it comes from drivers/pnp/pnpbios/bioscalls.c -> pnpbios_print_status()  
> 
> Tried adding pnpbios=off, but with that the system does not boot anymore.
> 
> Being curious, why a non-existing docking-station is being "polled at regular intervals" (i.e. every 2 seconds - see drivers/pnp/pnpbios/core.c )

We poll for a dock, and if the BIOS reports that the function is not
supported we then exit the thread.

> 
> >From http://books.google.de/books?id=ibLa4I5EnC4C&pg=PA231&lpg=PA231&dq=pnp+docking+bios&source=bl&ots=ekCFm34U_B&sig=9Z9L55IAL7_3NtuM10jT3serncM&hl=de&sa=X&ei=mAZcVILnJsviO-r5gNgI&ved=0CCsQ6AEwAQ#v=onepage&q=pnp%20docking%20bios&f=false   i read:  "Function 05h - Get Docking Status Information at page 251" 

The spec is available at:

http://download.intel.com/support/motherboards/desktop/sb/pnpbiosspecificationv10a.pdf
 
> it  seems this is being the result of a "docking event" ? Does this mean, my system is erroneusly generating such docking events, even if there is no docking station at all?

Your BIOS appears to be making strange replies. Any error ought to have
the top bit set, so its reporting a nonsense value for some reason.

I've not seen other reports of pnp_dock_thread errors with a real dock.
The only reports at all are a couple of old ones in google that seem to
be similar and a Debian bug (294652) which appears to be your bug so I'd
suggest testing the following


Change the default to

              default:
                  pnpbios_print_status("pnp_dock..... etc)
	          printk(KERN_ERR "PnPBIOS: Disabling dock monitoring\n");
	          complete_and_exit(&unload_sem, 0);

that should produce you one error message, a warning that dock monitoring
is being disabled and then it should stfu.

If you can let us know if that does the trick then I can push it upstream.

Alan
