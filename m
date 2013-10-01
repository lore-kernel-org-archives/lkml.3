Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3JATPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:15:50 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:54888
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223Ab3JATPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:15:47 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1380654938.10618.30.camel@snotra.buserror.net>
Subject: Re: RFC: (re-)binding the VFIO platform driver to a platform device
From: Scott Wood <scottwood@freescale.com>
To: Kim Phillips <kim.phillips@linaro.org>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <a.motakis@virtualopensystems.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        <stuart.yoder@freescale.com>, Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>
Date: Tue, 1 Oct 2013 14:15:38 -0500
In-Reply-To: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
References: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 13:38 -0500, Kim Phillips wrote:
> Hi,
> 
> Santosh and I are having a problem figuring out how to enable binding
> (and re-binding) platform devices to a platform VFIO driver (see
> Antonis' WIP: [1]) in an upstream-acceptable manner.
> 
> Binding platform drivers currently depends on a string match in the
> device node's compatible entry.  On an arndale, one can currently
> rebind the same device to the same driver like so:
> 
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind
> 
> And one can bind it to the vfio-dt driver, as Antonis instructs, by
> appending a 'vfio-dt' string to the device tree compatible entry for
> the device.  Then this would work:
> 
> echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
> echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind
> 
> Consequently, the hack patch below [2] allows any platform device to be
> bound to the vfio-dt driver, without making changes to the device
> tree.  It's a hack because I don't see having any driver name specific
> code in drivers/base/bus.c being upstream acceptable.

Modifying the device tree is the worse part of this.

Is this part of your later suggestion to make compatible writeable after
boot, or are you talking about messing with the device tree before boot
(putting software config in the device tree, among other ickiness)?

> Alternately, device tree compatible entries may be made writeable after
> boot, e.g.:
> 
> echo vfio-platform > /proc/device-tree/i2c\@12CE0000/compatible
> 
> [note s/vfio-dt/vfio-platform/]
> 
> but that would require the vfio-platform module be reloaded, thereby
> unbinding it from any existing devices it was bound to: we're
> seeking a more dynamic solution.

Eww.

Not to mention that the VFIO user might want to know what the compatible
was, or that we might later want to unbind from VFIO and rebind to the
kernel...

> Alex Graf (cc'd) proposed an alternate approach: re-write the driver
> name in the device's sysfs entry:
> 
> echo "vfio-platform" > /sys/bus/platform/devices/101e0000.rtc/driver/driver_name
> 
> The advantage of this approach is that we can achieve the re-bind
> (unbind + bind) as an atomic operation, which alleviates userspace from
> having to coordinate with other device operations (I think VM migration
> is an example case here).
> 
> Note that driver_name currently doesn't exist in sysfs, so it would
> either have to be added, or another means developed to rename the
> driver symlink itself:

I think the ideal interface would be if you could write the sysfs device
name into the vfio bind file (or some new file in the same directory),
and have it claim that device (preferably with an atomic unbind from the
previous driver).  We shouldn't be messing around with compatible
(either modifying it or telling VFIO which compatibles to look for) when
we know the specific devices (not just type of devices) we want to bind.

-Scott



