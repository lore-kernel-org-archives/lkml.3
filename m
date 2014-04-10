Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161181AbaDJTax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:30:53 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:26185
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161036AbaDJTas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:30:48 -0400
From: Stuart Yoder <stuart.yoder@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "agraf@suse.de" <agraf@suse.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kim.phillips@linaro.org" <kim.phillips@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "tech@virtualopensystems.com" <tech@virtualopensystems.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>
Subject: RE: [PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
Thread-Topic: [PATCH] PCI: Introduce new device binding path using
 pci_dev.driver_override
Thread-Index: AQHPUEM0ZC0wyBt2iUum7ooISIIUr5sLReZA
Date: Thu, 10 Apr 2014 19:30:32 +0000
Message-ID: <81d2e04877f04deeb15e6d0e57244385@DM2PR03MB352.namprd03.prod.outlook.com>
References: <20140404201818.14389.86188.stgit@bling.home>
In-Reply-To: <20140404201818.14389.86188.stgit@bling.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.168.49]
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(13464003)(189002)(199002)(377454003)(79102001)(74316001)(99396002)(83072002)(92566001)(2201001)(76576001)(20776003)(77982001)(76176999)(50986999)(54356999)(77096999)(81542001)(80976001)(4396001)(87936001)(33646001)(76482001)(99286001)(80022001)(2656002)(19580405001)(85852003)(81342001)(19580395003)(86362001)(74662001)(66066001)(74502001)(46102001)(83322001)(31966008)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB351;H:DM2PR03MB352.namprd03.prod.outlook.com;FPR:FCFEF199.86C217E2.F9E03B33.4ADCF8F1.20394;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3AJV3eL030070



> -----Original Message-----
> From: Alex Williamson [mailto:alex.williamson@redhat.com]
> Sent: Friday, April 04, 2014 3:19 PM
> To: bhelgaas@google.com; linux-pci@vger.kernel.org
> Cc: agraf@suse.de; kvm@vger.kernel.org; konrad.wilk@oracle.com;
> kim.phillips@linaro.org; gregkh@linuxfoundation.org; Yoder Stuart-B08248;
> linux-kernel@vger.kernel.org; libvir-list@redhat.com; iommu@lists.linux-
> foundation.org; tech@virtualopensystems.com;
> kvmarm@lists.cs.columbia.edu; christoffer.dall@linaro.org
> Subject: [PATCH] PCI: Introduce new device binding path using
> pci_dev.driver_override
> 
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
> echo > /sys/bus/pci/devices/0000:03:00.0/preferred_driver
> echo 0000:03:00.0 > /sys/bus/pci/devices/0000:03:00.0/driver/unbind
> echo 0000:03:00.0 > /sys/bus/pci/drivers_probe
> 
> Another advantage to this approach is that we can specify a driver
> override to force a specific binding or prevent any binding.  For
> instance when an IOMMU group is exposed to userspace through VFIO
> we require that all devices within that group are owned by VFIO.
> However, devices can be hot-added into an IOMMU group, in which case
> we want to prevent the device from binding to any driver (preferred
> driver = "none") or perhaps have it automatically bind to vfio-pci.
> With driver_override it's a simple matter for this field to be set
> internally when the device is first discovered to prevent driver
> matches.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Reviewed-by: Stuart Yoder <stuart.yoder@freescale.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
