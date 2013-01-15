Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3AOPMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:12:10 -0500
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:51051 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757202Ab3AOPMG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:12:06 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:11:06 +0100
Subject: RE: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Topic: [RFCv2 05/11] remoteproc: Load firmware once.
Thread-Index: Ac3fISzLO8uV1e1EQOKX/NgPfD/gqwPJc+Hw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE05F@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-6-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021616.GC28692@WorkStation.localnet>
In-Reply-To: <20121221021616.GC28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

> From: Ido Yariv [mailto:ido@wizery.com]  Friday, December 21, 2012 3:16 AM
> > Load the firmware once and pave the way for two way
> > communication of virtio configuration and status bits.
> > The virtio ring device address is now stored in the resource
> > table.
> >
> > NOTE:  This patch requires device firmware change! The device
> > 	memory layout changes. The virtio rings are no longer
> > 	located at start of device memory. But the vring address
> > 	can be read from the resource table. Also Carveout
> > 	must be located before the virtio rings in the resource
> > 	table.
> >
> > Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> In case the remote processor is added, booted and then rebooted, the
> program sections wont be reinitialized. This can be a bit problematic,
> since the firmware might assume values are initialized in its data
> sections.
> 
> How about the following alternative approach - instead of loading the
> firmware in advance, we could allocate just a small (private) buffer,
> holding a copy of the resource table. Our copy will be updated with the
> addresses of the vrings we allocate, along with the notification ids.
> Each time the remote processor is booted, we could reload the firmware
> and overwrite the resource table section with our own private copy.
> virtio's configuration space and status will probably need to be updated
> in both copies of the resource table, so it would be consistent across
> boots.

I have kept the approach of loading firmware once for initial boot and crash.
But added reloading of firmware if the system is stopped and then started again.
This should solve your concerns above. This avoids requesting the same firmware
twice when calling rproc_add and at reboot. This will should improve boot time as
firmware will be loaded once not twice. But there is a catch, the memory layout
will change, the vrings are no longer allocated first, instead the firmware must read
the vring address from the resource table.

> > -static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
> > +static void rproc_fw_load(const struct firmware *fw, void *context)
> >  {
> > +	struct rproc *rproc = context;
> >  	struct device *dev = &rproc->dev;
> >  	const char *name = rproc->firmware;
> >  	struct resource_table *table;
> >  	int ret, tablesz;
> >
> > +	if (!fw)
> > +		goto release_fw;
> > +
> >  	ret = rproc_fw_sanity_check(rproc, fw);
> >  	if (ret)
> > -		return ret;
> > +		goto release_fw;
> >
> >  	dev_info(dev, "Booting fw image %s, size %zd\n", name, fw->size);
> >
> > @@ -800,7 +805,7 @@ static int rproc_fw_boot(struct rproc *rproc, const
> struct firmware *fw)
> >  	ret = rproc_enable_iommu(rproc);
> 
> iommu is enabled when the firmware is loaded, but disabled on shutdown,
> so it could get out of balance when the remote processor is rebooted.

OK, I'll make a separate patch that calls iommu_enable from rproc_boot
and iommu_disable from rproc_shutdown in order to keep the handling of
this symmetric.

> 
> ...
> 
> >  int rproc_boot(struct rproc *rproc)
> >  {
> > -	const struct firmware *firmware_p;
> >  	struct device *dev;
> >  	int ret;
> >
> > @@ -1004,27 +967,28 @@ int rproc_boot(struct rproc *rproc)
> >  	/* skip the boot process if rproc is already powered up */
> >  	if (atomic_inc_return(&rproc->power) > 1) {
> >  		ret = 0;
> > -		goto unlock_mutex;
> > +		goto downref_driver;
> 
> In case the rproc is already powered up, module_put should probably be
> called to balance try_module_get. This is actually an existing bug in the
> code.

I have changed the ref-counting so that  rproc->power is handled first in rproc_boot()
and rproc_shutdown(), and then module ref-counting follows device's start() and
stop() functions. Hopefully this should make it easier to keep the module ref in sync.

Regards,
Sjur
