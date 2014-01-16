Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbaAPRKC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:10:02 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:46852 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaAPRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:10:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC 06/18] regmap: Formalise use of non-bus context
To: Pawel Moll <pawel.moll@arm.com>, Mark Brown <broonie@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
In-Reply-To: <1389272911.23721.49.camel@hornet>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com> < 1387815830-8794-7-git-send-email-pawel.moll@arm.com> <20131224124538. GZ30815@sirena.org.uk> <1389272911.23721.49.camel@hornet>
Date: Thu, 16 Jan 2014 17:09:54 +0000
Message-Id: <20140116170954.C3CBCC40973@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Jan 2014 13:08:31 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Tue, 2013-12-24 at 12:45 +0000, Mark Brown wrote:
> > I'd note that I wasn't CCed on most of this series so I'm not entirely
> > sure what it's trying to do.
> 
> Apologies. The series is quite long and I didn't want to bother too many
> people with mostly irrelevant changes. Will copy you on the whole thing
> next time.
> 
> > > Bus-less maps (ones with reg_read and reg_write functions
> > > defined in regmap_config) were given the context passed
> > > in regmap_init(), but it was still called "bus_context".
> > > 
> > > This patch formalises this aspect by renaming it to simple
> > > "context" and adds the missing link, free_context function
> > > in regmap_config, which allows bus-less maps to use the
> > > context in classic way.
> > 
> > This should be two patches, one patch to do the rename and one to add
> > the operation.  
> 
> Sure, will do.
> 
> > The obvious question here is why is this callback useful
> > - what is being allocated in a regmap specific context that needs to be
> > lifetime managed separately to the thing doing the creation?  I can't
> > see any obvious reason why this would ever get used.
> 
> First of all, it's just a generalization of the free_context already
> existing in regmap_bus (and used by regmap-mmio). And in case of this
> series it is being used to release extra resource added allocated for a
> "busless" regmap_config. Briefly, I'm using devm_regmap_init() to
> "attach" a custom regmap configuration to a device when it is being
> created (which is then dev_get_regmap()-ed in the driver, as you saw in
> the regulator patch) and its context is a pointer to kzallocated data.
> free_context is used to release it when devm resource is being removed.

Have you thought through all the implications here? What you've
described effectively changes the devm model. devm operates under the
assumption that devm data only exists between probe() and remove() time.
If you 'preload' devm data then the preloaded data will get discarded at
remove() time which breaks if the driver is remove and probed again at
runtime.

g.

