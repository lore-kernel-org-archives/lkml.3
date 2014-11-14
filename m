Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965862AbaKNPbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:31:17 -0500
Received: from smtprelay-b32.telenor.se ([213.150.131.21]:54721 "EHLO
	smtprelay-b32.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbaKNPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:31:13 -0500
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 10:31:12 EST
X-SENDER-IP: [213.113.165.61]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMCAPQZZlTVcaU9PGdsb2JhbAANTodChDfJd4MgAoE1AQEBAQEBBQEBAQE4hD0BAQEBAgEjBAsBRQEFCwsYAgIFFgsCAgkDAgECARsWFAYNAQcBAYg0DroleJY+AQEBAQEBAQEBAQEBAQEBAQEBGoEtj3UHgneBVAEEmW2fVoM3AQEB
X-IPAS-Result: AgMCAPQZZlTVcaU9PGdsb2JhbAANTodChDfJd4MgAoE1AQEBAQEBBQEBAQE4hD0BAQEBAgEjBAsBRQEFCwsYAgIFFgsCAgkDAgECARsWFAYNAQcBAYg0DroleJY+AQEBAQEBAQEBAQEBAQEBAQEBGoEtj3UHgneBVAEEmW2fVoM3AQEB
X-IronPort-AV: E=Sophos;i="5.07,386,1413237600"; 
   d="scan'208";a="112187854"
Message-ID: <54661A94.4000107@euromail.se>
Date: Fri, 14 Nov 2014 16:07:00 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Peter Jones <pjones@redhat.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, ia64: Do not lose track of the EFI default VGA device
References: <1415969610-1469-1-git-send-email-rydberg@euromail.se> <20141114154252.0fb66bba@pluto.restena.lu>
In-Reply-To: <20141114154252.0fb66bba@pluto.restena.lu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2014 03:42 PM, Bruno Prémont wrote:
> On Fri, 14 Nov 2014 13:53:30 +0100 Henrik Rydberg wrote:
>> Since commit 20cde694027e ("x86, ia64: Move EFI_FB
>> vga_default_device() initialization to pci_vga_fixup()") in the 3.17
>> merge window, the EFI framebuffer depends on the VGA arbitration
>> layer. However, the configuration does not reflect this, which leads
>> to a hard-to-find bug when FB_EFI is configured without VGA_ARB. Add a
>> select clause to remedy this.
> 
> Could you be more verbose in why it depends on/needs VGA_ARB?

When the EFI framebuffer is configured but not VGA_ARB, the kernel manages to
lose track of the default VGA device in some cases. As a result, the X11
nouveau driver fails on my MacBookAir3,1 (GeForce 320M, nv50, 0xaf), which
is booting in EFI_STUB mode.

The code to select the right PCI device was literally moved from efifb.c to the
internals of vgaarb. The PCI sysfs layer seems to depend on
vga_default_device(), which is only defined when VGA_ARB is set.

> With EFI starting to show up on ARM this is not necessarily true
> (no PCI -> no VGA_ARB arbitration).
> 
> So it would need to at least be select VGA_ARB if (PCI && !S390)
> in order to not have broken kernel configuration (in more or less
> exotic cases) while depends on VGA_ARB would be the only correct option
> if the rule 'select only allowed for leafs' is enforced.

I agree that the tie probably should be somewhere else. I am fine with any
combination of flags that respects the fact that efifb used to define
vga_default_device(), apparently for good reason.

Thanks,
Henrik

