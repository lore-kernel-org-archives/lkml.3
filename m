Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3JAV7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:59:20 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63535 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab3JAV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:59:18 -0400
Date: Tue, 1 Oct 2013 16:59:14 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: scottwood@freescale.com
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        a.motakis@virtualopensystems.com, agraf@suse.de,
        alex.williamson@redhat.com, stuart.yoder@freescale.com,
        B07421@freescale.com, B16395@freescale.com, R65777@freescale.com,
        peter.maydell@linaro.org, christoffer.dall@linaro.org,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
Message-Id: <20131001165914.a7ebe64aac3e4bb0f845da29@linaro.org>
In-Reply-To: <1380654938.10618.30.camel@snotra.buserror.net>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
	<1380654938.10618.30.camel@snotra.buserror.net>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Oct 2013 14:15:38 -0500
Scott Wood <scottwood@freescale.com> wrote:

> On Tue, 2013-10-01 at 13:38 -0500, Kim Phillips wrote:
> > Hi,
> > 
> > Santosh and I are having a problem figuring out how to enable binding
> > (and re-binding) platform devices to a platform VFIO driver (see
> > Antonis' WIP: [1]) in an upstream-acceptable manner.
> > 
> > Binding platform drivers currently depends on a string match in the
> > device node's compatible entry.  On an arndale, one can currently
> > rebind the same device to the same driver like so:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> > 
> > And one can bind it to the vfio-dt driver, as Antonis instructs, by
> > appending a 'vfio-dt' string to the device tree compatible entry for
> > the device.  Then this would work:
> > 
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> > echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> > 
> > Consequently, the hack patch below [2] allows any platform device to be
> > bound to the vfio-dt driver, without making changes to the device
> > tree.  It's a hack because I don't see having any driver name specific
> > code in drivers/base/bus.c being upstream acceptable.
> 
> Modifying the device tree is the worse part of this.
> 
> Is this part of your later suggestion to make compatible writeable after
> boot, or are you talking about messing with the device tree before boot
> (putting software config in the device tree, among other ickiness)?

writeable after boot

> > Alternately, device tree compatible entries may be made writeable after
> > boot, e.g.:
> > 
> > echo vfio-platform > /proc/device-tree/i2c\@12CE0000/compatible
> > 
> > [note s/vfio-dt/vfio-platform/]
> > 
> > but that would require the vfio-platform module be reloaded, thereby
> > unbinding it from any existing devices it was bound to: we're
> > seeking a more dynamic solution.
> 
> Eww.
> 
> Not to mention that the VFIO user might want to know what the compatible
> was,

well, technically the user would be able to get that info by reading
compatible before writing it, and ideally write the original value back
in addition to the new value.

> or that we might later want to unbind from VFIO and rebind to the
> kernel...

I believe that's independent:  it would depend on which driver's (VFIO,
kernel, or other) sysfs file the device address gets written into.

> > Alex Graf (cc'd) proposed an alternate approach: re-write the driver
> > name in the device's sysfs entry:
> > 
> > echo "vfio-platform" > /sys/bus/platform/devices/101e0000.rtc/driver/driver_name
> > 
> > The advantage of this approach is that we can achieve the re-bind
> > (unbind + bind) as an atomic operation, which alleviates userspace from
> > having to coordinate with other device operations (I think VM migration
> > is an example case here).
> > 
> > Note that driver_name currently doesn't exist in sysfs, so it would
> > either have to be added, or another means developed to rename the
> > driver symlink itself:
> 
> I think the ideal interface would be if you could write the sysfs device
> name into the vfio bind file (or some new file in the same directory),
> and have it claim that device (preferably with an atomic unbind from the
> previous driver).

ok.

> We shouldn't be messing around with compatible
> (either modifying it or telling VFIO which compatibles to look for) when
> we know the specific devices (not just type of devices) we want to bind.

ok, but I still don't see how to get past driver_match_device()'s
refusal to allow bind a non-compatible driver (or one who's name isn't
in the compatible list).

Kim
