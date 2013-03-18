Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab3CRT5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:57:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:25728 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab3CRT5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:57:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="304663840"
Date: Mon, 18 Mar 2013 19:57:32 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Alan Stern <stern@rowland.harvard.edu>, Thomas Meyer <thomas@m3y3r.de>,
        Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [3.9-rc1] irq 16: nobody cared (was [3.9-rc1] very poor
 interrupt responses)
Message-ID: <20130318195728.GA3872@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jiri Kosina <jkosina@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
	Harald Arnesen <skogtun.linux@gmail.com>,
	Kernel development list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Peter Hurley <peter@hurleysoftware.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thomas Meyer <thomas@m3y3r.de>,
	Shawn Starr <shawn.starr@rogers.com>,
	USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
	Imre Deak <imre.deak@intel.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	dri-devel@lists.freedesktop.org
References: <1460519.ejNFI1DrGk@vostro.rjw.lan>
 <1363280764.26318.4.camel@thor.lan>
 <5657408.cYX6iimiA4@vostro.rjw.lan>
 <alpine.LNX.2.00.1303150851020.9529@pobox.suse.cz>
 <5142E7F0.4020002@gmail.com>
 <alpine.LNX.2.00.1303151424140.9529@pobox.suse.cz>
 <alpine.LNX.2.00.1303151609480.9529@pobox.suse.cz>
 <CAE9FiQUqPTUqPOzANnxpdfoRYPr+OiU5pFEoLKRiOFHd9Py4XQ@mail.gmail.com>
 <alpine.LNX.2.00.1303181010080.9529@pobox.suse.cz>
 <20130318191903.GS9021@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130318191903.GS9021@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 08:19:03PM +0100, Daniel Vetter wrote:
> On Mon, Mar 18, 2013 at 10:12:49AM +0100, Jiri Kosina wrote:
> > On Fri, 15 Mar 2013, Yinghai Lu wrote:
> > 
> > > > Just a datapoint -- I have put a trivial debugging patch in place, and it
> > > > reveals that "nobody cared" for irq 16 happens long after last
> > > >
> > > >         I915_WRITE(GMBUS4 + reg_offset, 0);
> > > >
> > > > has been performed in gmbus_wait_hw_status(). On the other hand, if I
> > > > comment out both GMBUS4 register offset writes in gmbus_wait_hw_status(),
> > > > then it of course falls back to GPIO bit-banging, but the "nobody cared"
> > > > for irq 16 is gone.
> > > >
> > > > So it seems like something gets severely confused by the I915_WRITE to
> > > > GMBUS4 + reg_offset. So far this seems to have been reported solely on
> > > > Lenovos as far as I can see (although a completely different types), so it
> > > > might be some platform-specific quirk?
> > > >
> > > > Honestly, I still don't understand how all the GMBUS stuff relates to IRQ
> > > > 16 at all.
> > > 
> > > that device is using
> > > i915 0000:00:02.0: irq 44 for MSI/MSI-X
> > > 
> > > so can you try to boot with pci=nomsi?
> > 
> > Yes, switching from MSI to IO-APIC-fasteoi makes the report about lost 
> > interrupts go away.
> > 
> > My understanding from the other mail is that DAniel Vetter already has an 
> > idea what might be going wrong with IRQ acking on GM45 chipsets; hopefully 
> > this datapoint regarding MSI will fit into it.
> 
> Yep, there's a big comment in the irq handler for that chipset that we
> have a gaping race with when using MSI interrupts. Although the comment
> bodly claims that the race is small enough to avoid the dreaded "nobody
> cared" message. Looks like gmbus is good at hitting that race - on newer
> chips it already brought up a similar race in handling pch interrupts.
> 
> Can you please give the below patch a whirl? It removes the probably race
> msi race avoidance code and replaces it with the same trick Paulo used to
> fix pch irq handling races.

Still nobody cares about irq16.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
