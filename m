Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab3KYWGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:06:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63840 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752352Ab3KYWGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:06:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Move device_del() from pci_stop_dev() to pci_destroy_dev()
Date: Mon, 25 Nov 2013 23:19:03 +0100
Message-ID: <2101601.XbDHenBU6p@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAErSpo7LOVoSzOO1DbAhU6naq8YXKEd4A=Ls7DbaEt9jX8SBDg@mail.gmail.com>
References: <1384866598-19716-1-git-send-email-mika.westerberg@linux.intel.com> <53283503.VcSP9RLiFc@vostro.rjw.lan> <CAErSpo7LOVoSzOO1DbAhU6naq8YXKEd4A=Ls7DbaEt9jX8SBDg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 25, 2013 02:59:44 PM Bjorn Helgaas wrote:
> On Sat, Nov 23, 2013 at 5:17 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > After commit bcdde7e221a8 (sysfs: make __sysfs_remove_dir() recursive)
> > I'm seeing traces analogous to the one below in Thunderbolt testing:

[...]

> > (Mika Westerberg sees them too in his tests).
> >
> > Some investigation documented in kernel bug #65281 lead me to the
> > conclusion that the source of the problem is the device_del() in
> > pci_stop_dev() as it now causes the sysfs directory of the device
> > to be removed recursively along with all of its subdirectories.
> > That includes the sysfs directory of the device's subordinate
> > bus (dev->subordinate) and its "power" group.
> >
> > Consequently, when pci_remove_bus() is called for dev->subordinate
> > in pci_remove_bus_device(), it calls device_unregister(&bus->dev),
> > but at this point the sysfs directory of bus->dev doesn't exist any
> > more and its "power" group doesn't exist either.  Thus, when
> > dpm_sysfs_remove() called from device_del() tries to remove that
> > group, it triggers the above warning.
> >
> > That indicates a logical mistake in the design of
> > pci_stop_and_remove_bus_device(), which causes bus device objects
> > to be left behind their parents (bridge device objects) and can be
> > fixed by moving the device_del() from pci_stop_dev() into
> > pci_destroy_dev(), so pci_remove_bus() can be called for the
> > device's subordinate bus before the device itself is unregistered
> > from the hierarchy.  Still, the driver, if any, should be detached
> > from the device in pci_stop_dev(), so use device_release_driver()
> > directly from there.
> >
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=65281#c6
> > Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Applied to for-linus for v3.13.  Thanks a lot for all your work on this issue!

Thanks, and no problem! :-)

Rafael

