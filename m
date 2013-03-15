Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3COPO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:14:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab3COPO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:14:26 -0400
Date: Fri, 15 Mar 2013 16:14:17 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Harald Arnesen <skogtun.linux@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared  (was [3.9-rc1] very poor interrupt
 responses)
In-Reply-To: <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
Message-ID: <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1303141050310.1983-100000@iolanthe.rowland.org> <1460519.ejNFI1DrGk@vostro.rjw.lan> <1363280764.26318.4.camel@thor.lan> <5657408.cYX6iimiA4@vostro.rjw.lan> <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz> <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Jiri Kosina wrote:

> > I have the same problem on my Lenovo T500. I think the graphics card is
> > involved.
> > 
> > This laptop has "hybrid graphics" - one Intel GMA 4500MHD and one ATI
> > Mobility Radeon HD 3650. When I boot with the Intel card, I get "irq 16:
> > nobody cared" during boot, not when I boot with the ATI card.
> 
> Confirming this. After a lot of hassle, I have bisected this reliably to
> 
> 	commit 28c70f162a315bdcfbe0bf940a740ef8bfb918d6
> 	Author: Daniel Vetter <daniel.vetter@ffwll.ch>
> 	Date:   Sat Dec 1 13:53:45 2012 +0100
> 
> 	    drm/i915: use the gmbus irq for waits
> 
> Adding Daniel, Imre and Daniel to CC while I will try to figure out what's 
> happening in parallel.
> 
> Attaching dmesg.txt from the machine with 28c70f162a as head, with 
> drm.debug=0xe.

Just a datapoint -- I have put a trivial debugging patch in place, and it 
reveals that "nobody cared" for irq 16 happens long after last

	I915_WRITE(GMBUS4 + reg_offset, 0);

has been performed in gmbus_wait_hw_status(). On the other hand, if I 
comment out both GMBUS4 register offset writes in gmbus_wait_hw_status(), 
then it of course falls back to GPIO bit-banging, but the "nobody cared" 
for irq 16 is gone. 

So it seems like something gets severely confused by the I915_WRITE to 
GMBUS4 + reg_offset. So far this seems to have been reported solely on 
Lenovos as far as I can see (although a completely different types), so it 
might be some platform-specific quirk?

Honestly, I still don't understand how all the GMBUS stuff relates to IRQ 
16 at all. 

-- 
Jiri Kosina
SUSE Labs
