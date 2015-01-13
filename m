Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbbAMQqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:46:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:49102 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbbAMQq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:46:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511630760"
Message-ID: <1421167477.4459.229.camel@spandruv-desktop.jf.intel.com>
Subject: Re: [PATCH] i2c / ACPI: Pick the first address if device has
 multiple
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 13 Jan 2015 08:44:37 -0800
In-Reply-To: <20150113155059.GN7660@katana>
References: <1419860928-195404-1-git-send-email-mika.westerberg@linux.intel.com>
	 <20150113155059.GN7660@katana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 16:50 +0100, Wolfram Sang wrote: 
> On Mon, Dec 29, 2014 at 03:48:48PM +0200, Mika Westerberg wrote:
> > ACPI specification allows I2C devices with multiple addresses. The current
> > implementation goes over all addresses and assigns the last one to the
> > device. This is typically not the primary address of the device.
> > 
> > Instead of doing that we assign the first address to the device and then
> > let the driver handle rest of the addresses as it wishes.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> 
> Yes, seems better than what we do know. But maybe taking the lowest
> address is a bit better heuristic than taking the first address?
> Not sure, though...
The problem in taking lowest is that in many cases in current devices,
the lowest address may end being 0x0C, which is reserved address for
SMBUS (ARA). This will require different handling. Unfortunately ACPI
doesn't have a way to distinguish whether SMBUS support is desired or
not. 
The other option is to skip all reserved addresses for SMBUS also and
then create on the lowest.

Thanks,
Srinivas 
> 
> > ---
> >  drivers/i2c/i2c-core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> > index 39d25a8cb1ad..a06be43b7842 100644
> > --- a/drivers/i2c/i2c-core.c
> > +++ b/drivers/i2c/i2c-core.c
> > @@ -102,7 +102,7 @@ static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
> >  		struct acpi_resource_i2c_serialbus *sb;
> >  
> >  		sb = &ares->data.i2c_serial_bus;
> > -		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> > +		if (!info->addr && sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> >  			info->addr = sb->slave_address;
> >  			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
> >  				info->flags |= I2C_CLIENT_TEN;
> > -- 
> > 2.1.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


