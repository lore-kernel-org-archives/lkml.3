Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965026Ab3BMWKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:10:03 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:52546 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3BMWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:10:00 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges property
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <robherring2@gmail.com>
Cc: Andrew Murray <andrew.murray@arm.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20130213212951.GA27849@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de> <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de> <511949C7.7070604@gmail.com> <20130212064523.GA28850@avionic-0098.mockup.avionic-design.de> <511BA1E0.9000404@gmail.com> <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de> <511BEF8D.7060506@gmail.com> <20130213212951.GA27849@avionic-0098.mockup.avionic-design.de>
Date: Wed, 13 Feb 2013 22:09:56 +0000
Message-Id: <20130213220956.DDEB43E3557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 22:29:51 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> On Wed, Feb 13, 2013 at 01:54:53PM -0600, Rob Herring wrote:
> > On 02/13/2013 08:25 AM, Thierry Reding wrote:
> > > On Wed, Feb 13, 2013 at 08:23:28AM -0600, Rob Herring wrote:
> > >> On 02/12/2013 12:45 AM, Thierry Reding wrote:
> > >>> On Mon, Feb 11, 2013 at 01:43:03PM -0600, Rob Herring wrote:
> > >>>> On 02/11/2013 02:22 AM, Thierry Reding wrote:
> > >>>>> From: Andrew Murray <andrew.murray@arm.com>
> > >>
> > >>>>> @@ -13,6 +13,7 @@
> > >>>>>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) > 0)
> > >>>>>  
> > >>>>>  static struct of_bus *of_match_bus(struct device_node *np);
> > >>>>> +static struct of_bus *of_find_bus(const char *name);
> > >>>>
> > >>>> Can you move this function up to avoid the forward declaration.
> > >>>
> > >>> It needs to be defined after the of_busses structure, which is defined
> > >>> below the CONFIG_PCI block where of_pci_process_ranges() is defined. I'd
> > >>> have to move that one as well and add another #ifdef CONFIG_PCI section.
> > >>> If you prefer that I can do that.
> > >>
> > >> Okay, it's fine as is.
> > >>
> > >>>>> +static struct of_bus *of_find_bus(const char *name)
> > >>>>> +{
> > >>>>> +	unsigned int i;
> > >>>>> +
> > >>>>> +	for (i = 0; i < ARRAY_SIZE(of_busses); i++)
> > >>>>> +		if (strcmp(name, of_busses[i].name) == 0)
> > >>>>                                               ^
> > >>>> space needed.
> > >>>
> > >>> I don't understand. Do you want the space to go between '.' and "name"?
> > >>
> > >> Must have been some dirt on my screen... Never mind.
> > >>
> > >> I'll apply these for 3.9.
> > > 
> > > Great, thanks!
> > 
> > Grant vetoed merging. We need to see the other architectures using these
> > functions rather than add yet another copy.
> 
> I think I've said this before, but converting the other architectures
> isn't very trivial, mostly because each has a specific way of storing
> the values read from these properties.

Sorry to be harsh, but this isn't new information. I've had to deal with
the pain more than once before of copied infrastructure that at some
time in the future needs to be merged again. Just looking at your patch
I can tell that it is directly derived from the powerpc
pci_process_bridge_OF_ranges() and which microblaze has already has a
verbatum copy of.

So, no, I'm not okay with it for v3.9. I don't want more copies of the
same code. This doesn't block your v3.10 drivers. When a better patch is
ready we can set up a separate branch with just the new functions in it
and the various subsystems can merge that in if needed to resolve
dependencies.

Instead, here is what you do; you've got the bones of a good approach,
but you need to show how it is derived from the powerpc approach. I'll
reply in specifics to the patches themselves, but I can definitely see
large blocks of code that can be moved out of powerpc & microblaze and
into drivers/of/address.c without getting into the platform-specific
PCI representations that you're concerned about.

Now, to be clear here, I'm asking you to change powerpc/microblaze code,
but I am *not asking you to test it*. This is a code move exercises, and
I will help you with it if you need.

> 
> So unless we want to block any new drivers from being merged, the only
> alternatives are to either merge these patches or include a copy of the
> same code in each new driver that needs the functionality (or open-code
> the functions in each driver).
> 
> There is quite a bit of rework required to unify the architecture
> specific PCI frameworks and I think Bjorn and others have been making
> quite a bit of progress in that direction. I think that these patches
> can help refactor some of those parts.
> 
> Thierry

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
