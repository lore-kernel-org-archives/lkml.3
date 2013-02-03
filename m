Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3BCXZc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:25:32 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60115 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab3BCXZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:25:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: David Airlie <airlied@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization
Date: Mon, 04 Feb 2013 00:31:45 +0100
Message-ID: <2897697.mWlee59MAU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1354083114.9797983.1359933595870.JavaMail.root@redhat.com>
References: <1354083114.9797983.1359933595870.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 03, 2013 06:19:55 PM David Airlie wrote:
> 
> ----- Original Message -----
> > From: "Konstantin Khlebnikov" <khlebnikov@openvz.org>
> > To: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: "Bjorn Helgaas" <bhelgaas@google.com>, linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
> > linux-pci@vger.kernel.org, "Dave Airlie" <airlied@redhat.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
> > Sent: Saturday, 2 February, 2013 10:12:03 PM
> > Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend finalization
> > 
> > Rafael J. Wysocki wrote:
> > > On Tuesday, January 29, 2013 12:55:15 PM Rafael J. Wysocki wrote:
> > >> On Tuesday, January 29, 2013 11:04:57 AM Konstantin Khlebnikov
> > >> wrote:
> > >>> Rafael J. Wysocki wrote:
> > >>>> On Monday, January 28, 2013 04:17:42 PM Bjorn Helgaas wrote:
> > >>>>> [+cc Rafael]
> > >>>>>
> > >>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> > >>>>> <khlebnikov@openvz.org>   wrote:
> > >>>>>> This patch effectively reverts commit
> > >>>>>> 42eca2302146fed51335b95128e949ee6f54478f
> > >>>>>> ("PCI: Don't touch card regs after runtime suspend D3")
> > >>>>>>
> > >>>>>> | This patch checks whether the pci state is saved and doesn't
> > >>>>>> | attempt to hit
> > >>>>>> | any registers after that point if it is.
> > >>>>>>
> > >>>>>> This seems completely wrong. Yes, PCI configuration space has
> > >>>>>> been saved by
> > >>>>>> driver, but this doesn't means that all job is done and device
> > >>>>>> has been
> > >>>>>> suspended and ready for waking up in the future.
> > >>>>>>
> > >>>>>> For example driver e1000e for ethernet in my thinkpad x220
> > >>>>>> saves pci-state
> > >>>>>> but device cannot wakeup after that, because it needs some
> > >>>>>> ACPI callbacks
> > >>>>>> which usually called from pci_finish_runtime_suspend().
> > >>>>>>
> > >>>>>> | Optimus (dual-gpu) laptops seem to have their own form of
> > >>>>>> | D3cold, but
> > >>>>>> | unfortunately enter it on normal D3 transitions via the ACPI
> > >>>>>> | callback.
> > >>>>>>
> > >>>>>> Hardware which disappears from the bus unexpectedly is
> > >>>>>> exception, so let's
> > >>>>>> handle it as an exception. Its driver should set device state
> > >>>>>> to D3cold and
> > >>>>>> the rest code will handle it properly.
> > >>>>>
> > >>>>> Functions in D3cold don't have power, so it's completely
> > >>>>> expected that
> > >>>>> they would disappear from the bus and not respond to config
> > >>>>> accesses.
> > >>>>> Maybe Dave was referring to D3hot, where functions *should*
> > >>>>> respond to
> > >>>>> config accesses.  I dunno.
> > >>>>>
> > >>>>> Just to be clear, it sounds like 42eca230 caused a regression
> > >>>>> on your
> > >>>>> e1000e device?  If so, I guess we should revert it unless you
> > >>>>> and Dave
> > >>>>> can figure out a better patch that fixes both your e1000e
> > >>>>> device and
> > >>>>> the Optimus issue.
> > >>>>
> > >>>> Yes, if there's a regression, let's revert it, but I'd like the
> > >>>> regression
> > >>>> to be described clearly.
> > >>>
> > >>> Yep, this is regression.
> > >>>
> > >>> commit 42eca2302146fed51335b95128e949ee6f54478f ("PCI: Don't
> > >>> touch
> > >>> card regs after runtime suspend D3") changes state convention
> > >>> during
> > >>> runtime-suspend transaction too much. If PCI configuration space
> > >>> has been saved by driver that does not means that all job is done
> > >>> and device has been suspended and ready for waking up in the
> > >>> future.
> > >>>
> > >>> e1000e saves pci-config space itself, but it requires operations
> > >>> which
> > >>> pci_finish_runtime_suspend() does: preparing for wake (calling
> > >>> particular
> > >>> platform pm-callbacks) and switching to proper sleep state.
> > >>
> > >> Well, I'd argue this is a bug in e1000e.  Why does it need to save
> > >> the PCI
> > >> config space even though pci_pm_runtime_suspend() will do that
> > >> anyway?
> > >
> > > I honestly don't think we should revert 42eca2302146 because of
> > > this.
> > >
> > > Yes, there is a requirement that drivers not save the PCI config
> > > space by
> > > themselves unless they want to do the whole power management by
> > > themselves too
> > > and e1000e is not following that.  So either we need to drop the
> > > pci_save_state() from __e1000_shutdown() which I would prefer (I'm
> > > not really
> > > sure why it is there), or e1000_runtime_suspend() needs to call
> > > pci_finish_runtime_suspend() by itself.
> > 
> > Yet another problem: some drivers calls pci_save_state() from
> > ->probe() callback
> > to use this saved state in pci_error_handlers->slot_reset().
> > As result pdev->state_saved is true mostly all time.
> > At least e1000e and drivers/pci/pcie/portdrv_pci.c are doing this.
> > 
> > I think it will be safer to revert 42eca2302146 in v3.8
> > 
> 
> btw I've no problem reverting this for 3.8, though I'd like to get a fix in for 3.9 then,
> the code relying on this change is still not completed, so a revert shouldn't break anything.
> 
> but definitely if a card goes into D3cold, we need to not poke any registers on it after it
> returns.

Sure.

As I said, I don't think it is necessary to revert 42eca2302146 and I've got a
confirmation from Boris that the approach proposed so far works, so now it only
is a matter of cutting final patches and testing them.

I'm not quite sure what Konstantin's plans in that respect are, though.
Konstantin, care to tell us?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
