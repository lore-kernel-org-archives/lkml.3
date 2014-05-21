Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaEUIZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:25:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbaEUIZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:25:33 -0400
Message-ID: <537C62F7.10409@suse.de>
Date: Wed, 21 May 2014 10:25:27 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        linux-pci@vger.kernel.org
CC: kvm@vger.kernel.org, konrad.wilk@oracle.com, kim.phillips@linaro.org,
        gregkh@linuxfoundation.org, stuart.yoder@freescale.com,
        libvir-list@redhat.com, iommu@lists.linux-foundation.org,
        christoffer.dall@linaro.org, tech@virtualopensystems.com,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: Introduce new device binding path using pci_dev.driver_override
References: <20140520145136.28232.90707.stgit@bling.home>
In-Reply-To: <20140520145136.28232.90707.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 20.05.14 16:53, Alex Williamson wrote:
> The driver_override field allows us to specify the driver for a device
> rather than relying on the driver to provide a positive match of the
> device.  This shortcuts the existing process of looking up the vendor
> and device ID, adding them to the driver new_id, binding the device,
> then removing the ID, but it also provides a couple advantages.
>
> First, the above existing process allows the driver to bind to any
> device matching the new_id for the window where it's enabled.  This is
> often not desired, such as the case of trying to bind a single device
> to a meta driver like pci-stub or vfio-pci.  Using driver_override we
> can do this deterministically using:
>
> echo pci-stub > /sys/bus/pci/devices/0000:03:00.0/driver_override
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
>
> Previously we could not invoke drivers_probe after adding a device
> to new_id for a driver as we get non-deterministic behavior whether
> the driver we intend or the standard driver will claim the device.
> Now it becomes a deterministic process, only the driver matching
> driver_override will probe the device.
>
> To return the device to the standard driver, we simply clear the
> driver_override and reprobe the device:
>
> echo > /sys/bus/pci/devices/0000:03:00.0/driver_override
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
>
> Another advantage to this approach is that we can specify a driver
> override to force a specific binding or prevent any binding.  For
> instance when an IOMMU group is exposed to userspace through VFIO
> we require that all devices within that group are owned by VFIO.
> However, devices can be hot-added into an IOMMU group, in which case
> we want to prevent the device from binding to any driver (override
> driver = "none") or perhaps have it automatically bind to vfio-pci.
> With driver_override it's a simple matter for this field to be set
> internally when the device is first discovered to prevent driver
> matches.
>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Reviewed-by: Alexander Graf <agraf@suse.de>

I suppose Konrad's RB stays as well?


Alex

