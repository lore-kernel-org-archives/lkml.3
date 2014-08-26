Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbaHZJzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:55:11 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:53720 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaHZJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:55:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Bresticker <abrestic@chromium.org>, linux-tegra@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Jonas Bonn <jonas@southpole.se>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: Re: [PATCH v2 2/9] mailbox: Add NVIDIA Tegra XUSB mailbox driver
Date: Tue, 26 Aug 2014 11:54:43 +0200
Message-ID: <5184912.mY2hCPH20k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140826090810.GH17263@ulmo>
References: <1408381705-3623-1-git-send-email-abrestic@chromium.org> <6589717.GOLq1GlTCJ@wuerfel> <20140826090810.GH17263@ulmo>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:B4k6mLmPhLwicyPC9fP3trzOPLxT02GVa0YKzcgixwM
 w9+ZVhFSAfXDOniRHfXC2BRd8cnK2xyRzhAp10AyNTOAUZoPdT
 +fEHizizz+VTxizR3oEaTOhPXneAOkts1lStOsETTAU+sCju/j
 GB5KOXzPvB29+gkfNwgEH3jL16m5GVHUCEBUbLWGaW9Cox1QEX
 nZ6vP0Gia6Z/Z6ZXSxFaV3tLw2VV6swHMihs6sanhnenAE2Iqb
 WmUE5k02kROESGbsPas8ha8QZ2NhQkB/3AJv/tLCmqds/lhC9v
 dwBS7Vf2N3wnWt2qyiuN91IItkdiRr2RoNRkPsmiycy3a7c5PJ
 V/rklV6Lra/0mCB73syw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2014 11:08:11 Thierry Reding wrote:
> On Tue, Aug 26, 2014 at 10:09:25AM +0200, Arnd Bergmann wrote:
> > On Tuesday 26 August 2014 09:50:25 Thierry Reding wrote:
> > > On Tue, Aug 26, 2014 at 09:43:50AM +0200, Arnd Bergmann wrote:
> > > > On Tuesday 26 August 2014 08:57:31 Thierry Reding wrote:
> > > > > On Mon, Aug 25, 2014 at 01:01:52PM -0600, Stephen Warren wrote:
> > > > > > On 08/18/2014 11:08 AM, Andrew Bresticker wrote:
> > > > > [...]
> > > > > > >+static int tegra_xusb_mbox_probe(struct platform_device *pdev)
> > > > > > 
> > > > > > >+    res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > > > >+    if (!res)
> > > > > > >+            return -ENODEV;
> > > > > > 
> > > > > > Should devm_request_mem_region() be called here to claim the region?
> > > > > > 
> > > > > > >+    mbox->regs = devm_ioremap_nocache(&pdev->dev, res->start,
> > > > > > >+                                      resource_size(res));
> > > > > > >+    if (!mbox->regs)
> > > > > > >+            return -ENOMEM;
> > > > > > 
> > > > > > Is _nocache required? I don't see other drivers using it. I assume there's
> > > > > > nothing special about the mbox registers.
> > > > > 
> > > > > Most drivers should be using devm_ioremap_resource() which will use the
> > > > > _nocache variant of devm_ioremap() when appropriate. Usually the region
> > > > > will not be marked cacheable (IORESOURCE_CACHEABLE) and therefore be
> > > > > remapped uncached.
> > > > > 
> > > > 
> > > > Note that ioremap() and ioremap_nocache() are the same. We really shouldn't
> > > > ever call ioremap_nocache().
> > > 
> > > Perhaps we should remove ioremap_nocache() in that case. Or ioremap(),
> > > really, and keep only those variants that do what they claim to do.
> > 
> > That would be good, but there are many instances of either one:
> > 
> > arnd@wuerfel:/git/arm-soc$ git grep -w ioremap | wc
> >    2156   13402  183732
> > arnd@wuerfel:/git/arm-soc$ git grep -w ioremap_nocache | wc
> >     485    2529   42955
> 
> Ugh... nothing that I currently have time for. Perhaps this is a good
> one for the Janitors? I'm not sure if the kernelnewbies.org TODO list is
> still frequented since many pages seem to be very old. Is there some
> other place where I could add this?

I'm not sure if it's really worth it. One thing we might do is just
remove all definitions of ioremap_nocache and add a wrapper to
include/linux/io.h, to make it more obvious what is going on.

> > > > devm_ioremap_resource() and pci_iomap() checking for IORESOURCE_CACHEABLE is
> > > > rather silly, since it doesn't call ioremap_cache() in that case.
> > > 
> > > Then that should be fixed.
> > 
> > Yes. I'd suggest we just ignore that flag and always call ioremap here.
> > 
> > When I checked this before, IORESOURCE_CACHEABLE only ever gets set for
> > PCI ROM BARs, which we don't map into the kernel.
> 
> There's still a few users of ioremap_cache() around and they are
> potential candidates for a conversion to devm_ioremap_resource(), so I
> think it'd still make sense to keep the check.

Possibly. Note that these are all in architecture-specific code, as
evidenced by the fact that we have multiple names for this function:

ioremap_cache:    arm, arm64, x86, ia64, sh
ioremap_cached:   metag, unicore32
ioremap_cachable: mips

All other architectures have none of the above.

An alternative approach would be to kill off IORESOURCE_CACHEABLE
and introduce a devm_ioremap_resource_cache() helper when the first
driver wants it.

	Arnd
