Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaCGUk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 15:40:28 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50691 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbaCGUk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:40:26 -0500
Date: Fri, 7 Mar 2014 13:40:21 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Steven Newbury <steve@snewbury.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
Message-ID: <20140307204021.GA9822@google.com>
References: <1391886379.2669.11.camel@x41>
 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
 <1391890927.1882.5.camel@x41>
 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
 <1391951759.6036.7.camel@artifact>
 <1391952344.25424.4.camel@x220>
 <CAErSpo6uj_Kuk0_F97nRsnM1Pss4C7=HeEaVu6D-NwFFK=1cvA@mail.gmail.com>
 <1394185698.5608.5.camel@x41>
 <CAErSpo4jiq38P3TNuGLGS--nbV9NtUAmiuK=cwWyFAneY-=eOA@mail.gmail.com>
 <1394212609.1987.6.camel@x41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394212609.1987.6.camel@x41>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 06:16:49PM +0100, Paul Bolle wrote:
> Bjorn Helgaas schreef op vr 07-03-2014 om 09:55 [-0700]:
> > On Fri, Mar 7, 2014 at 2:48 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> > > This might end up not being relevant. And this is surely documented
> > > somewhere, but anyhow:
> > > - what git magic returns the hashes of the 15 commits that merge commit
> > >   96702be56037 added to the tree; and
> > 
> > "git show 96702be56037" gives:
> > 
> >     commit 96702be560374ee7e7139a34cab03554129abbb4
> >     Merge: 04f982beb900 d56dbf5bab8c
> >     ...
> > 
> > 04f982beb900 is the previous HEAD, d56dbf5bab8c is the head of the
> > branch merged by this commit.  "git log 04f982beb900..96702be56037"
> > shows the commits merged.
> 
> Thanks. Fairly obvious, actually. Not sure why I didn't think of this
> myself.
> 
> > > - how can I use the list of those hashes to limit the range of commits
> > >   to do a git bisect?
> > 
> > I'm not a git bisect expert, but I *think* you should be able to do
> > something like this:
> > 
> >     git bisect start
> >     git bisect bad 96702be56037
> >     git bisect good 04f982beb900
> > 
> > (assuming you've verified that 96702be56037 really *is* bad and
> > 04f982beb900 really *is* good), and git should checkout something in
> > the middle and you can build and test it, then use "git bisect good"
> > or "git bisect bad" depending on the result.
> 
> Makes sense. Thanks again. 04f982beb900 appears to be good. So if
> 96702be56037 turns out to be bad bisecting might not turn into the
> ordeal it usually is. (On this machine, with my workflow, bisecting an
> v3.x..v3.x+1-rcy range takes a few days.)

It seems quite possible that I broke pci_bus_alloc_resource(), which could
cause an allocation failure like this.  

If you have a chance to try it, here's a debug patch against v3.14-rc5.  It
should apply cleanly to 96702be56037.  If you can try it, please attach the
dmesg log to the bugzilla.

Bjorn


diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 5c85350f4c3d..0dbba6c7c001 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -997,6 +997,7 @@ static int intel_alloc_chipset_flush_resource(void)
 	ret = pci_bus_alloc_resource(intel_private.bridge_dev->bus, &intel_private.ifp_resource, PAGE_SIZE,
 				     PAGE_SIZE, PCIBIOS_MIN_MEM, 0,
 				     pcibios_align_resource, intel_private.bridge_dev);
+	dev_info(&intel_private.bridge_dev->dev, "pci_bus_alloc ret %d\n", ret);
 
 	return ret;
 }
@@ -1007,6 +1008,7 @@ static void intel_i915_setup_chipset_flush(void)
 	u32 temp;
 
 	pci_read_config_dword(intel_private.bridge_dev, I915_IFPADDR, &temp);
+	dev_info(&intel_private.bridge_dev->dev, "I915_IFPADDR %#010x\n", temp);
 	if (!(temp & 0x1)) {
 		intel_alloc_chipset_flush_resource();
 		intel_private.resource_valid = 1;
@@ -1022,6 +1024,7 @@ static void intel_i915_setup_chipset_flush(void)
 		if (ret)
 			intel_private.resource_valid = 0;
 	}
+	dev_info(&intel_private.bridge_dev->dev, "ifp_resource %pR\n", &intel_private.ifp_resource);
 }
 
 static void intel_i965_g33_setup_chipset_flush(void)
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 00660cc502c5..1c6d75ae34d9 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -146,24 +146,31 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 
 	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
 
+	dev_info(&bus->dev, "%s: alloc %pR size %#llx from bus region [%#010llx-%#010llx]\n", __func__, res, (long long) size, (long long) region->start, (long long) region->end);
 	pci_bus_for_each_resource(bus, r, i) {
 		if (!r)
 			continue;
 
 		/* type_mask must match */
-		if ((res->flags ^ r->flags) & type_mask)
+		if ((res->flags ^ r->flags) & type_mask) {
+			dev_info(&bus->dev, "%s: %pR: wrong type (%#lx %#lx mask %#x)\n", __func__, r, res->flags, r->flags, type_mask);
 			continue;
+		}
 
 		/* We cannot allocate a non-prefetching resource
 		   from a pre-fetching area */
 		if ((r->flags & IORESOURCE_PREFETCH) &&
-		    !(res->flags & IORESOURCE_PREFETCH))
+		    !(res->flags & IORESOURCE_PREFETCH)) {
+			dev_info(&bus->dev, "%s: %pR: wrong prefetchability\n", __func__, r);
 			continue;
+		}
 
 		avail = *r;
 		pci_clip_resource_to_region(bus, &avail, region);
-		if (!resource_size(&avail))
+		if (!resource_size(&avail)) {
+			dev_info(&bus->dev, "%s: %pR: no space (avail %pR)\n", __func__, r, &avail);
 			continue;
+		}
 
 		/*
 		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to
@@ -179,6 +186,7 @@ static int pci_bus_alloc_from_region(struct pci_bus *bus, struct resource *res,
 		/* Ok, try it out.. */
 		ret = allocate_resource(r, res, size, min, max,
 					align, alignf, alignf_data);
+		dev_info(&bus->dev, "%s: %pR: alloc from %#llx-%#llx, ret %d\n", __func__, r, min, max, ret);
 		if (ret == 0)
 			return 0;
 	}
