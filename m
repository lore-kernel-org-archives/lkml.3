Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab3BWWWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 17:22:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42496 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759273Ab3BWWWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 17:22:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] ACPI / PM: Take unusual configurations of power resources into account (was: Re: [GIT PATCH] USB patches for 3.9-rc1)
Date: Sat, 23 Feb 2013 23:29:15 +0100
Message-ID: <1491152.DMDr5jSnJ6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130223144859.GA2955@balto.lan>
References: <20130222085954.GA4352@redhat.com> <4258343.ok1n3SAim3@vostro.rjw.lan> <20130223144859.GA2955@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 03:48:59 PM Fabio Baltieri wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: ACPI / PM: Take unusual configurations of power resources into account
> > 
> > Commit d2e5f0c (ACPI / PCI: Rework the setup and cleanup of device
> > wakeup) moved the initial disabling of system wakeup for PCI devices
> > into a place where it can actually work and that exposed a hidden old
> > issue with crap^Wunusual system designs where the same power
> > resources are used for both wakeup power and device power control at
> > run time.
> > 
> > Namely, say there is one power resource such that the ACPI power
> > state D0 of a PCI device depends on that power resource (i.e. the
> > device is in D0 when that power resource is "on") and it is used
> > as a wakeup power resource for the same device.  Then, calling
> > acpi_pci_sleep_wake(pci_dev, false) for the device in question will
> > cause the reference counter of that power resource to drop to 0,
> > which in turn will cause it to be turned off.  As a result, the
> > device will go into D3cold at that point, although it should have
> > stayed in D0.
> > 
> > As it turns out, that happens to USB controllers on some laptops
> > and USB becomes unusable on those machines as a result, which is
> > a major regression from v3.8.
> > 
> > To fix this problem, (1) increment the reference counters of wakup
> > power resources during their initialization if they are "on"
> > initially, (2) prevent acpi_disable_wakeup_device_power() from
> > decrementing the reference counters of wakeup power resources that
> > were not enabled for wakeup power previously, and (3) prevent
> > acpi_enable_wakeup_device_power() from incrementing the reference
> > counters of wakeup power resources that already are enabled for
> > wakeup power.
> > 
> > In addition to that, if it is impossible to determine the initial
> > states of wakeup power resources, avoid enabling wakeup for devices
> > whose wakeup power depends on those power resources.
> > 
> > Reported-by: Dave Jones <davej@redhat.com>
> > Reported-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Works just fine!
> 
> Tested-by: Fabio Baltieri <fabio.baltieri@linaro.org>

Thanks for verifying!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
