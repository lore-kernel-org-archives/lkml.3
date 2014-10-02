Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338AbaJBEGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 00:06:05 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33328 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaJBEGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 00:06:02 -0400
Message-ID: <542CCF1D.5090609@roeck-us.net>
Date: Wed, 01 Oct 2014 21:05:49 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: atull@opensource.altera.com, jdelvare@suse.de
CC: lm-sensors@lm-sensors.org, lgirdwood@gmail.com, broonie@kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v4 2/4] pmbus: core: add helpers for byte write and read
 modify write
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com> <1412190349-16343-3-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1412190349-16343-3-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.542CCF29.00B6,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 12:05 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>
> Add two helper functions:
>   * pmbus_write_byte_data  = paged byte write
>   * pmbus_update_byte_data = paged byte read/modify/write
>
> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> ---
>   drivers/hwmon/pmbus/pmbus_core.c |   31 +++++++++++++++++++++++++++++++
>   1 file changed, 31 insertions(+)
>
> diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
> index 291d11f..d6c3701 100644
> --- a/drivers/hwmon/pmbus/pmbus_core.c
> +++ b/drivers/hwmon/pmbus/pmbus_core.c
> @@ -253,6 +253,37 @@ int pmbus_read_byte_data(struct i2c_client *client, int page, u8 reg)
>   }
>   EXPORT_SYMBOL_GPL(pmbus_read_byte_data);
>
> +int pmbus_write_byte_data(struct i2c_client *client, int page, u8 reg, u8 value)
> +{
> +	int rv;
> +
> +	rv = pmbus_set_page(client, page);
> +	if (rv < 0)
> +		return rv;
> +
> +	return i2c_smbus_write_byte_data(client, reg, value);
> +}
> +EXPORT_SYMBOL_GPL(pmbus_write_byte_data);
> +
> +int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
> +			   u8 mask, u8 value)
> +{
> +	unsigned int tmp;
> +	int rv;
> +
> +	rv = pmbus_read_byte_data(client, page, reg);
> +	if (rv < 0)
> +		return rv;
> +
> +	tmp = (rv & ~mask) | (value & mask);
> +
> +	if (tmp != rv)
> +		rv = pmbus_write_byte_data(client, page, reg, tmp);
> +
> +	return rv;
> +}
> +EXPORT_SYMBOL_GPL(pmbus_update_byte_data);
> +
>   /*
>    * _pmbus_read_byte_data() is similar to pmbus_read_byte_data(), but checks if
>    * a device specific mapping function exists and calls it if necessary.
>

Results in:

drivers/hwmon/pmbus/pmbus_core.c:259:5: warning: symbol 'pmbus_write_byte_data' was not declared. Should it be static?
drivers/hwmon/pmbus/pmbus_core.c:271:5: warning: symbol 'pmbus_update_byte_data' was not declared. Should it be static?
drivers/hwmon/pmbus/pmbus_core.c:259:5: warning: no previous prototype for 'pmbus_write_byte_data' [-Wmissing-prototypes]
drivers/hwmon/pmbus/pmbus_core.c:271:5: warning: no previous prototype for 'pmbus_update_byte_data' [-Wmissing-prototypes]

No need to resubmit. I added a patch to un-export the functions
and merged patch 2 and 3 together in order to avoid a warning
after patch 2. We can always export the new helper functions
later if needed.

Guenter

