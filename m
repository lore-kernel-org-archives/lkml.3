Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaLBNGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:06:24 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:37347 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaLBNGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:06:23 -0500
Message-ID: <547DB94C.6010001@mvista.com>
Date: Tue, 02 Dec 2014 07:06:20 -0600
From: Corey Minyard <cminyard@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: minyard@acm.org, linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Add parameters to sysfs-added i2c devices
References: <1415976117-27755-1-git-send-email-minyard@acm.org> <547335FB.4020002@mvista.com> <20141201173848.GF3212@katana>
In-Reply-To: <20141201173848.GF3212@katana>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2014 11:38 AM, Wolfram Sang wrote:
> On Mon, Nov 24, 2014 at 07:43:23AM -0600, Corey Minyard wrote:
>> Ping, I haven't heard anything on this.
> Use cases please :) What client drivers would need that and what params
> do they need?

I'm adding an IPMI SMB driver, it should be going in 3.19.  These
devices have an IPMI bus address (not the I2C address), and it needs to
be specified if it varies from the default, or certain messages won't
work correctly.

It seems like this would be useful for other things; it's a little
surprising to me that no other devices need to have some parameters
passed in.

-corey

>> -corey
>>
>> On 11/14/2014 08:41 AM, minyard@acm.org wrote:
>>> From: Corey Minyard <cminyard@mvista.com>
>>>
>>> Some devices might need parameters to control their operation,
>>> add the ability to pass these parameters to the client.
>>>
>>> This also makes the parsing of sysfs-added I2C devices a little
>>> more flexible, allowing tabs and arbitrary numbers of spaces.
>>>
>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>> ---
>>>  drivers/i2c/i2c-core.c | 46 ++++++++++++++++++++++++++++++++++------------
>>>  include/linux/i2c.h    |  3 +++
>>>  2 files changed, 37 insertions(+), 12 deletions(-)
>>>
>>> I'm adding an SMBus IPMI driver, and it needs to be able to have
>>> the IPMI bus address specified in case it's not the default.
>>>
>>> Also, this seems like it would be useful for other devices that
>>> need some sort of configuration.
>>>
>>> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
>>> index f43b4e1..9a2ab13 100644
>>> --- a/drivers/i2c/i2c-core.c
>>> +++ b/drivers/i2c/i2c-core.c
>>> @@ -781,7 +781,10 @@ static int i2c_device_pm_restore(struct device *dev)
>>>  
>>>  static void i2c_client_dev_release(struct device *dev)
>>>  {
>>> -	kfree(to_i2c_client(dev));
>>> +	struct i2c_client *client = to_i2c_client(dev);
>>> +
>>> +	kfree(client->parms);
>>> +	kfree(client);
>>>  }
>>>  
>>>  static ssize_t
>>> @@ -1059,6 +1062,13 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
>>>  	client->flags = info->flags;
>>>  	client->addr = info->addr;
>>>  	client->irq = info->irq;
>>> +	if (info->parms) {
>>> +		client->parms = kstrdup(info->parms, GFP_KERNEL);
>>> +		if (!client->parms) {
>>> +			dev_err(&adap->dev, "Out of memory allocating parms\n");
>>> +			goto out_err_silent;
>>> +		}
>>> +	}
>>>  
>>>  	strlcpy(client->name, info->type, sizeof(client->name));
>>>  
>>> @@ -1207,31 +1217,43 @@ i2c_sysfs_new_device(struct device *dev, struct device_attribute *attr,
>>>  	struct i2c_adapter *adap = to_i2c_adapter(dev);
>>>  	struct i2c_board_info info;
>>>  	struct i2c_client *client;
>>> -	char *blank, end;
>>> +	char *pos, end;
>>>  	int res;
>>>  
>>>  	memset(&info, 0, sizeof(struct i2c_board_info));
>>>  
>>> -	blank = strchr(buf, ' ');
>>> -	if (!blank) {
>>> +	pos = strpbrk(buf, " \t");
>>> +	if (!pos) {
>>>  		dev_err(dev, "%s: Missing parameters\n", "new_device");
>>>  		return -EINVAL;
>>>  	}
>>> -	if (blank - buf > I2C_NAME_SIZE - 1) {
>>> +	if (pos - buf > I2C_NAME_SIZE - 1) {
>>>  		dev_err(dev, "%s: Invalid device name\n", "new_device");
>>>  		return -EINVAL;
>>>  	}
>>> -	memcpy(info.type, buf, blank - buf);
>>> +	memcpy(info.type, buf, pos - buf);
>>>  
>>> -	/* Parse remaining parameters, reject extra parameters */
>>> -	res = sscanf(++blank, "%hi%c", &info.addr, &end);
>>> -	if (res < 1) {
>>> +	while (isspace(*pos))
>>> +		pos++;
>>> +
>>> +	/* Parse address, saving remaining parameters. */
>>> +	res = sscanf(pos, "%hi%c", &info.addr, &end);
>>> +	if (res < 1 || !isspace(end)) {
>>>  		dev_err(dev, "%s: Can't parse I2C address\n", "new_device");
>>>  		return -EINVAL;
>>>  	}
>>> -	if (res > 1  && end != '\n') {
>>> -		dev_err(dev, "%s: Extra parameters\n", "new_device");
>>> -		return -EINVAL;
>>> +	if (res > 1 && end != '\n') {
>>> +		if (isspace(end)) {
>>> +			/* Extra parms, skip the address and space. */
>>> +			while (!isspace(*pos))
>>> +				pos++;
>>> +			while (isspace(*pos))
>>> +				pos++;
>>> +			info.parms = pos;
>>> +		} else {
>>> +			dev_err(dev, "%s: Extra parameters\n", "new_device");
>>> +			return -EINVAL;
>>> +		}
>>>  	}
>>>  
>>>  	client = i2c_new_device(adap, &info);
>>> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
>>> index b556e0a..e40fc56 100644
>>> --- a/include/linux/i2c.h
>>> +++ b/include/linux/i2c.h
>>> @@ -222,6 +222,7 @@ struct i2c_client {
>>>  	char name[I2C_NAME_SIZE];
>>>  	struct i2c_adapter *adapter;	/* the adapter we sit on	*/
>>>  	struct device dev;		/* the device structure		*/
>>> +	char *parms;			/* sysfs extra parms		*/
>>>  	int irq;			/* irq issued by device		*/
>>>  	struct list_head detected;
>>>  };
>>> @@ -255,6 +256,7 @@ static inline void i2c_set_clientdata(struct i2c_client *dev, void *data)
>>>   * @archdata: copied into i2c_client.dev.archdata
>>>   * @of_node: pointer to OpenFirmware device node
>>>   * @acpi_node: ACPI device node
>>> + * @parms: Parameters supplied on the sysfs command line
>>>   * @irq: stored in i2c_client.irq
>>>   *
>>>   * I2C doesn't actually support hardware probing, although controllers and
>>> @@ -276,6 +278,7 @@ struct i2c_board_info {
>>>  	struct dev_archdata	*archdata;
>>>  	struct device_node *of_node;
>>>  	struct acpi_dev_node acpi_node;
>>> +	char            *parms;
>>>  	int		irq;
>>>  };
>>>  

