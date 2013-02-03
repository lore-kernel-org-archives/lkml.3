Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3BCXDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:03:20 -0500
Received: from mx4-phx2.redhat.com ([209.132.183.25]:38517 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3BCXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:03:18 -0500
Date: Sun, 3 Feb 2013 18:03:00 -0500 (EST)
From: David Airlie <airlied@redhat.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Message-ID: <1702145791.9796585.1359932580460.JavaMail.root@redhat.com>
In-Reply-To: <510D0293.8030509@openvz.org>
Subject: Re: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend
 finalization
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.40.183]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Rafael J. Wysocki wrote:
> > On Tuesday, January 29, 2013 12:55:15 PM Rafael J. Wysocki wrote:
> >> On Tuesday, January 29, 2013 11:04:57 AM Konstantin Khlebnikov
> >> wrote:
> >>> Rafael J. Wysocki wrote:
> >>>> On Monday, January 28, 2013 04:17:42 PM Bjorn Helgaas wrote:
> >>>>> [+cc Rafael]
> >>>>>
> >>>>> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> >>>>> <khlebnikov@openvz.org>   wrote:
> >>>>>> This patch effectively reverts commit
> >>>>>> 42eca2302146fed51335b95128e949ee6f54478f
> >>>>>> ("PCI: Don't touch card regs after runtime suspend D3")
> >>>>>>
> >>>>>> | This patch checks whether the pci state is saved and doesn't
> >>>>>> | attempt to hit
> >>>>>> | any registers after that point if it is.
> >>>>>>
> >>>>>> This seems completely wrong. Yes, PCI configuration space has
> >>>>>> been saved by
> >>>>>> driver, but this doesn't means that all job is done and device
> >>>>>> has been
> >>>>>> suspended and ready for waking up in the future.
> >>>>>>
> >>>>>> For example driver e1000e for ethernet in my thinkpad x220
> >>>>>> saves pci-state
> >>>>>> but device cannot wakeup after that, because it needs some
> >>>>>> ACPI callbacks
> >>>>>> which usually called from pci_finish_runtime_suspend().
> >>>>>>
> >>>>>> | Optimus (dual-gpu) laptops seem to have their own form of
> >>>>>> | D3cold, but
> >>>>>> | unfortunately enter it on normal D3 transitions via the ACPI
> >>>>>> | callback.
> >>>>>>
> >>>>>> Hardware which disappears from the bus unexpectedly is
> >>>>>> exception, so let's
> >>>>>> handle it as an exception. Its driver should set device state
> >>>>>> to D3cold and
> >>>>>> the rest code will handle it properly.
> >>>>>
> >>>>> Functions in D3cold don't have power, so it's completely
> >>>>> expected that
> >>>>> they would disappear from the bus and not respond to config
> >>>>> accesses.
> >>>>> Maybe Dave was referring to D3hot, where functions *should*
> >>>>> respond to
> >>>>> config accesses.  I dunno.

Just to clarify what is going on with optimus laptops:

D3cold didn't exist as a real thing, so when you call the ACPI method
to enter D3, it actually powers off the card completely, I've actually
in my future work fixed it so that the driver then reports it being in
D3cold when that happens.

The problem here was originally that the kernel didn't care if we hit
D3hot or D3cold, it wanted to finish the dynamic suspend, however
in this case there was no way it could.

So I'm happy with any solution that means cards reporting being in D3cold,
won't get touched again after they return.

Dave.
