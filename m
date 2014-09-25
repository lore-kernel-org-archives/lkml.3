Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaIYJDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:03:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:63296 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaIYJDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="605132545"
Date: Thu, 25 Sep 2014 12:02:27 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>,
        Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH v2] i2c: move acpi code back into the core
Message-ID: <20140925090227.GE1786@lahna.fi.intel.com>
References: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411594591-5048-1-git-send-email-wsa@the-dreams.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:36:31PM +0200, Wolfram Sang wrote:
> Commit 5d98e61d337c ("I2C/ACPI: Add i2c ACPI operation region support")
> renamed the i2c-core module. This may cause regressions for
> distributions, so put the ACPI code back into the core.
> 
> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>

One comment though,

> Cc: Lan Tianyu <tianyu.lan@intel.com>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
> +#if defined(CONFIG_ACPI)
> +struct acpi_i2c_handler_data {
> +	struct acpi_connection_info info;
> +	struct i2c_adapter *adapter;
> +};
> +
> +struct gsb_buffer {
> +	u8	status;
> +	u8	len;
> +	union {
> +		u16	wdata;
> +		u8	bdata;
> +		u8	data[0];
> +	};
> +} __packed;

These two structures should be inside CONFIG_ACPI_I2C_OPREGION because
they are used in that code. However, this still works fine now as you
can't select CONFIG_ACPI_I2C_OPREGION without CONFIG_ACPI.

> +
> +static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
> +{
> +	struct i2c_board_info *info = data;
> +
> +	if (ares->type == ACPI_RESOURCE_TYPE_SERIAL_BUS) {
> +		struct acpi_resource_i2c_serialbus *sb;
> +
> +		sb = &ares->data.i2c_serial_bus;
> +		if (sb->type == ACPI_RESOURCE_SERIAL_TYPE_I2C) {
> +			info->addr = sb->slave_address;
> +			if (sb->access_mode == ACPI_I2C_10BIT_MODE)
> +				info->flags |= I2C_CLIENT_TEN;
> +		}
> +	} else if (info->irq < 0) {
> +		struct resource r;
> +
> +		if (acpi_dev_resource_interrupt(ares, 0, &r))
> +			info->irq = r.start;
> +	}
> +
> +	/* Tell the ACPI core to skip this resource */
> +	return 1;
> +}
