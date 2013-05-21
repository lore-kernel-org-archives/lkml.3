Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3EUHsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:48:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:1907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3EUHsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:48:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="340661528"
Message-ID: <1369122596.4432.22.camel@ymzhang.sh.intel.com>
Subject: Re: Subject : [ PATCH ]
 pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: linasvepstas@gmail.com
Cc: "Liu, Joseph" <Joseph.Liu@emulex.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Tue, 21 May 2013 15:49:56 +0800
In-Reply-To: <CAHrUA36OxKn1ucaA4-1jHU=4P+hCWOTVa2ECAwpxEoBWSRAv8A@mail.gmail.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
	 <CAErSpo7+AbHi_TwxwHTJunpFb=CMhwMdCni6+NjbhdA=35XhvA@mail.gmail.com>
	 <CF6E51640088844D9CADE5541A7C2FEB33EBC11D@CMEXMB1.ad.emulex.com>
	 <CAHrUA36OxKn1ucaA4-1jHU=4P+hCWOTVa2ECAwpxEoBWSRAv8A@mail.gmail.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 10:37 -0500, Linas Vepstas wrote:
> I think Joe Liu has it right.  I'm going to top-post because things
> are a bit tangled below.  I urge a review of
> /Documentation/PCI/pci-error-recovery.txt, as that gives the details.
> 
> The intended sequence is that, after an error, the device driver gets
> a shot at running some diagnostics & dumps, and then the pci
> bridges/controllers/ports/links are reset (by platform code, viz. aer
> in this case) to a state resembling a fresh power-on.  Then the
> .slot_reset() callback is called on the device driver, to tell the
> driver "hey everything upstream is now working, go set yourself up for
> normal ops."  Thus, in particular, one should have pdev->error_state =
> pci_channel_io_normal; before .slot_reset() is called, and the PCI
> config space contents should resemble a fresh power-on state (and
> **NOT** some other saved state!)
> 
> If the device driver wanted to leave the card in a dead state, it had
> several opportunities to say so, earlier in the callback sequence.  If
> the driver wanted to fiddle with the card with the old PCI config
> space, it already had a chance to do that too, before the
> bridges/controllers/ports/links were fully reset by the platform.   By
> the time that .slot_reset() is being called, both the platform and the
> device driver are expecting smooth sailing ahead.
Yes. It's flexible for drivers to do that in many callbacks. AER framework
provides such flexibility.

> 
> So, looking at the original patch, it seems reasonable. 
I agree.

>  My impression
> is that maybe the AER driver had been doing not quite the right thing
> for a long time.
Pls. provide evidence/facts. The new patch is to facilitate device driver
implementation. It doesn't mean current AER driver is incorrect. We need
a tradeoff.

Just like what Bjoin says, we shouldn't change error_state to pci_channel_io_normal
before we really recover the hardware. The patch changes it just because
drivers might call some functions to recover the devices, while such functions
need (error_state==pci_channel_io_normal).

> 
> -- Linas Vepstas


