Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3BWLOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 06:14:06 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:55500 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab3BWLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 06:14:01 -0500
MIME-Version: 1.0
X-Originating-IP: [76.122.121.143]
In-Reply-To: <20130223094921.GG17833@n2100.arm.linux.org.uk>
References: <CAKb8eTkimk2jXAqPVUWcoQKFBba+=kpH96gRqx9pGGFFXGf15g@mail.gmail.com>
	<20130223094921.GG17833@n2100.arm.linux.org.uk>
Date: Sat, 23 Feb 2013 06:13:59 -0500
Message-ID: <CAKb8eT=fL03WgUOOSs+ynvqL8wyVCJk2+Rs8416Om4w_H4UQ1Q@mail.gmail.com>
Subject: Re: ARM: ixp4xx regression (bisected) since v3.5-rc1
From: Brad Parker <bparker@reach3d.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 4:49 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Feb 23, 2013 at 01:30:57AM -0500, Brad Parker wrote:
>> I then reversed this commit on 3.7.9 and the board booted
>> successfully. I'm not sure if this affects other boards of the same
>> arch or not, I only have access to a Pronghorn which also requires a
>> patch for the board files as they are not part of mainline.
>
> So it's an externally maintained board which breaks because of changes
> made in mainline?  Likely, it's not been updated for the mainline changes
> correctly.  *Sigh* unmerged external platform support sucks.
>
> What the commit you refer to above does is change the core code to do
> this:
>
> +                       if (hw->scan)
> +                               sys->bus = hw->scan(nr, sys);
> +                       else
> +                               sys->bus = pci_scan_root_bus(NULL, sys->busnr,
> +                                               hw->ops, sys, &sys->resources);
>
> then changes each of the IXP4xx board files:
>
> +       .ops            = &ixp4xx_ops,
> -       .scan           = ixp4xx_scan_bus,
>
> and removes this:
>
> -struct pci_bus * __devinit ixp4xx_scan_bus(int nr, struct pci_sys_data *sys)
> -{
> -       return pci_scan_root_bus(NULL, sys->busnr, &ixp4xx_ops, sys,
> -                                &sys->resources);
> -}
>
> What you will notice is that when .scan = NULL, and .ops = &ixp4xx_ops,
> the code is exactly identical.
>
> So, I doubt this is a regression with the mainline kernel, but is brought
> about by the non-visibility of your platforms code to mainline... I think
> your platform code needs updating appropriately.

You're right. I just forgot to add .ops, now it works without
reverting your commit. I think the patch could be merged in if someone
were willing to clean it up, I just don't really have the time. ADI
originally wrote the patch themselves for 2.6.26 and they claim that
it was included in 2.6.27 upstream, if that's true I assume it has
been removed at some point in the past. OpenWRT also maintains a
similar patch to get the board running on 3.3. I think the only thing
necessary to get it to 3.7/3.8 is remove .swizzle/.scan and add .ops.
