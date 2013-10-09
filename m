Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab3JITDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 15:03:53 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:17971
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab3JITDw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 15:03:52 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Yoder Stuart-B08248 <B08248@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>,
        Kim Phillips <kim.phillips@linaro.org>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "a.motakis@virtualopensystems.com" <a.motakis@virtualopensystems.com>,
        "agraf@suse.de" <agraf@suse.de>,
        Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "santosh.shukla@linaro.org" <santosh.shukla@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Topic: RFC: (re-)binding the VFIO platform driver to a platform device
Thread-Index: AQHOvtVyiXjaos/F7ECAilSa5Xx4A5ngRDQAgAAiCgCAAECXgIAAC74AgADT3ICAADSaMIAAAtYAgAADCQCAAB/ggIAACLGAgAACMICAAAU8gIAAIuWAgAE8pICAAAXnAIAABMAAgAAWmACACVE7IA==
Date: Wed, 9 Oct 2013 19:02:25 +0000
Message-ID: <9F6FE96B71CF29479FF1CDC8046E15036DDA62@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1380738758.12932.43.camel@snotra.buserror.net>
 <20131002184330.GC5108@cbox> <20131002203735.GA10871@kroah.com>
 <1380748121.12932.89.camel@snotra.buserror.net>
 <20131002211631.GA11914@kroah.com>
 <1380749715.12932.109.camel@snotra.buserror.net>
 <20131002234009.GA27714@kroah.com>
 <1380825207.12932.151.camel@snotra.buserror.net>
 <20131003185434.GA26123@kroah.com>
 <1380827494.12932.161.camel@snotra.buserror.net>
 <20131003203226.GB27336@kroah.com>
In-Reply-To: <20131003203226.GB27336@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.82.120.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have been thinking about this issue some more.  As Scott mentioned,
'wildcard' matching for a driver can be fairly done in the platform
bus driver.  We could add a new flag to the platform driver struct:

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 4f8bef3..4d6cf14 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -727,6 +727,10 @@ static int platform_match(struct device *dev, struct device_driver *drv)
        struct platform_device *pdev = to_platform_device(dev);
        struct platform_driver *pdrv = to_platform_driver(drv);

+       /* the driver matches any device */
+       if (pdrv->match_any)
+               return 1;
+
        /* Attempt an OF style match first */
        if (of_driver_match_device(dev, drv))
                return 1;

However, the more problematic issue is that a bus driver has no way to 
differentiate from an explicit bind request via sysfs and a bind that
happened through bus probing.

I think something like the new flag in the snippet below would enable the platform
bus to support platform drivers that only bind on explicit request:

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 4c289ab..daf6d24 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -201,7 +201,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
        int err = -ENODEV;

        dev = bus_find_device_by_name(bus, NULL, buf);
-       if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
+       if (dev && dev->driver == NULL && driver_match_device(drv, dev, 1)) {
                if (dev->parent)        /* Needed for USB */
                        device_lock(dev->parent);
                device_lock(dev);
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 35fa368..bb53785 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -389,7 +389,7 @@ static int __device_attach(struct device_driver *drv, void *data)
 {
        struct device *dev = data;

-       if (!driver_match_device(drv, dev))
+       if (!driver_match_device(drv, dev, 0))
                return 0;

        return driver_probe_device(drv, dev);
@@ -450,7 +450,7 @@ static int __driver_attach(struct device *dev, void *data)
         * is an error.
         */

-       if (!driver_match_device(drv, dev))
+       if (!driver_match_device(drv, dev, 0))
                return 0;

        if (dev->parent)        /* Needed for USB */


diff --git a/drivers/base/base.h b/drivers/base/base.h
index 2cbc677..7a15ef3 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -114,9 +114,9 @@ extern void driver_detach(struct device_driver *drv);
 extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 extern void driver_deferred_probe_del(struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
-                                     struct device *dev)
+                                     struct device *dev, int explicit_bind)
 {
-       return drv->bus->match ? drv->bus->match(dev, drv) : 1;
+       return drv->bus->match ? drv->bus->match(dev, drv, explicit_bind) : 1;
 }

Of, course the above change would need to be propagated to the different
bus drivers that implement the 'match' function.

Regards,
Stuart

