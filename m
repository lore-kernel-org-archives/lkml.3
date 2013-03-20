Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3CTXOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:14:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3CTXOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:14:33 -0400
Date: Thu, 21 Mar 2013 00:14:22 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Stern <stern@rowland.harvard.edu>,
        Chris Wilson <chris@chris-wilson.co.uk>, Greg KH <greg@kroah.com>,
        Harald Arnesen <skogtun.linux@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Meyer <thomas@m3y3r.de>, Shawn Starr <shawn.starr@rogers.com>,
        USB list <linux-usb@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Daniel Kurtz <djkurtz@chromium.org>,
        dri-devel@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: gm45 intel gfx can generate non-MSI irq# in MSI mode (was Re:
 [PATCH] drm/i915: stop using GMBUS IRQs on Gen4 chips (was Re: [3.9-rc1]
 irq 16: nobody cared (was [3.9-rc1] very poor interrupt responses
In-Reply-To: <CAE9FiQUyr4Tjw9F6o8FMf0+WMSFuucanskTT7e=eqjvRqi0HPQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1303210012001.16237@pobox.suse.cz>
References: <CAKMK7uGnZFaLQaZtoQ0Fz0ViNNjBvmf0Ak=qPmdAcm2mRBD7rA@mail.gmail.com> <Pine.LNX.4.44L0.1303191136020.15684-100000@netrider.rowland.org> <CAKMK7uGtLcuSsoumAgdB7ri+fR5ReNYcZELbqDcSueXVsewppg@mail.gmail.com>
 <CAE9FiQUyr4Tjw9F6o8FMf0+WMSFuucanskTT7e=eqjvRqi0HPQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Yinghai Lu wrote:

> > I guess I should have phrased it more precisely, but that's exactly
> > what I expect is happening on my machine: I don't have anything on
> > irq16 (i.e. in non-msi mode the gfx interrupt isn't shared) and hence
> > the irq is completely disabled. Which obviously makes it impossible
> > for me to reproduce the issue. To test that theory, is there a quick
> > way to force-enable a given interrupt, short of just hacking up a 2nd
> > dummy irq handler in my driver?
> 
> You may try to add another request_irq()
> after i915_load_modeset_init==>drm_irq_install.
> That could install one dummy action for ioapic irq for i915.
> 
> Also you may need to add one quirk that does not disable intx during
> msi enabling like:
> DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,
>                         0x2e22,
>                         quirk_msi_intx_disable_bug);
> 

This seemed to be really promising idea to me, as the DisINTx+ vs INTx+ 
discrepancy is very good hint, but unfortunately, after applying this:

---
 drivers/pci/quirks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0369fb6..8508e24 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2643,6 +2643,9 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1073,
 			quirk_msi_intx_disable_bug);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATTANSIC, 0x1083,
 			quirk_msi_intx_disable_bug);
+
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x2a42,
+			quirk_msi_intx_disable_bug);
 #endif /* CONFIG_PCI_MSI */
 
 /* Allow manual resource allocation for PCI hotplug bridges


The problem is still there ... so the inconsistency between DisINTx+ and 
INTx+ is unfortunately not the whole story.

-- 
Jiri Kosina
SUSE Labs
