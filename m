Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaIZOTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:19:49 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:16373 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbaIZOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:19:47 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19HfM3M7oH/ID55WcAqbxHEfrziaVWtp/4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 50C265EDE00
Date: Fri, 26 Sep 2014 10:19:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Subject: Re: [git pull] Devicetree changes for v3.15
Message-ID: <20140926141943.GC23926@titan.lakedaemon.net>
References: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
 <CACRpkdZoo=P7uTO1rNDD_HUPjfAk26C0=mNYPoZmTV0wcO3V-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZoo=P7uTO1rNDD_HUPjfAk26C0=mNYPoZmTV0wcO3V-w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Fri, Sep 26, 2014 at 02:30:53PM +0200, Linus Walleij wrote:
> On Tue, Apr 1, 2014 at 12:15 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> 
> > Here are the dt changes I've got queued up for v3.15. The full
> > description is below in the tag. Please pull.
> (...)
> > Jason Cooper (1):
> >       kbuild: dtbs_install: new make target

Exact patch is:

  f4d4ffc03efc kbuild: dtbs_install: new make target

> After this patch a while back I have observed the following behaviour
> of the kernel build:
> 
> make zImage
> make zImage
> -> incremental build, just relink
> 
> make zImage
> make dtbs
> make zImage
> -> The whole kernel gets rebuilt
> 
> So now if I happen to recompile my device trees, I suddenly want
> the entire zImage to be rebuilt to? It's by definition not changes that
> affect the kernel build :-(
> 
> I noticed this because my build scripts calls make dtbs && make zImage,
> and started to rebuild absolutely everything all the time.
> 
> Do you think this can be fixed? It's quite simple to reproduce...

Does the attached fix your problem?

thx,

Jason.

----------->8------------------------------------------
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 0ce9d0f71f2a..a88b13af58d2 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -313,7 +313,9 @@ $(INSTALL_TARGETS):
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $(boot)/dts/$@
 
 PHONY += dtbs dtbs_install
-dtbs dtbs_install: prepare scripts
+dtbs: scripts
+	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
+dtbs_install: prepare scripts
 	$(Q)$(MAKE) $(build)=$(boot)/dts MACHINE=$(MACHINE) $@
 
 # We use MRPROPER_FILES and CLEAN_FILES now
