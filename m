Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3BWJtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 04:49:33 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48878 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3BWJt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 04:49:28 -0500
Date: Sat, 23 Feb 2013 09:49:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Brad Parker <bparker@reach3d.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ARM: ixp4xx regression (bisected) since v3.5-rc1
Message-ID: <20130223094921.GG17833@n2100.arm.linux.org.uk>
References: <CAKb8eTkimk2jXAqPVUWcoQKFBba+=kpH96gRqx9pGGFFXGf15g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKb8eTkimk2jXAqPVUWcoQKFBba+=kpH96gRqx9pGGFFXGf15g@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 01:30:57AM -0500, Brad Parker wrote:
> I then reversed this commit on 3.7.9 and the board booted
> successfully. I'm not sure if this affects other boards of the same
> arch or not, I only have access to a Pronghorn which also requires a
> patch for the board files as they are not part of mainline.

So it's an externally maintained board which breaks because of changes
made in mainline?  Likely, it's not been updated for the mainline changes
correctly.  *Sigh* unmerged external platform support sucks.

What the commit you refer to above does is change the core code to do
this:

+                       if (hw->scan)
+                               sys->bus = hw->scan(nr, sys);
+                       else
+                               sys->bus = pci_scan_root_bus(NULL, sys->busnr,
+                                               hw->ops, sys, &sys->resources);

then changes each of the IXP4xx board files:

+       .ops            = &ixp4xx_ops,
-       .scan           = ixp4xx_scan_bus,

and removes this:

-struct pci_bus * __devinit ixp4xx_scan_bus(int nr, struct pci_sys_data *sys)
-{
-       return pci_scan_root_bus(NULL, sys->busnr, &ixp4xx_ops, sys,
-                                &sys->resources);
-}

What you will notice is that when .scan = NULL, and .ops = &ixp4xx_ops,
the code is exactly identical.

So, I doubt this is a regression with the mainline kernel, but is brought
about by the non-visibility of your platforms code to mainline... I think
your platform code needs updating appropriately.
