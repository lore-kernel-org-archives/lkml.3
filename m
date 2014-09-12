Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbaILOqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:46:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35460 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaILOqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:46:10 -0400
Message-ID: <54130729.5010206@ti.com>
Date: Fri, 12 Sep 2014 20:16:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/6] phy: improved lookup method
References: <1408620803-10464-1-git-send-email-heikki.krogerus@linux.intel.com> <1408620803-10464-3-git-send-email-heikki.krogerus@linux.intel.com> <5411C0B2.3060505@ti.com> <20140912140720.GC30816@xps8300>
In-Reply-To: <20140912140720.GC30816@xps8300>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 12 September 2014 07:37 PM, Heikki Krogerus wrote:
> On Thu, Sep 11, 2014 at 09:03:06PM +0530, Kishon Vijay Abraham I wrote:
>>> +static struct phy *phy_find(struct device *dev, const char *con_id)
>>> +{
>>> +	const char *dev_id = dev ? dev_name(dev) : NULL;
>>> +	int match, best_found = 0, best_possible = 0;
>>> +	struct phy *phy = ERR_PTR(-ENODEV);
>>> +	struct phy_lookup *p, *pl = NULL;
>>> +
>>> +	if (dev_id)
>>> +		best_possible += 2;
>>> +	if (con_id)
>>> +		best_possible += 1;
>>> +
>>> +	list_for_each_entry(p, &phys, node) {
>>> +		match = 0;
>>> +		if (p->dev_id) {
>>> +			if (!dev_id || strcmp(p->dev_id, dev_id))
>>> +				continue;
>>> +			match += 2;
>>> +		}
>>> +		if (p->con_id) {
>>> +			if (!con_id || strcmp(p->con_id, con_id))
>>> +				continue;
>>> +			match += 1;
>>> +		}
>>> +
>>> +		if (match > best_found) {
>>> +			pl = p;
>>> +			if (match != best_possible)
>>> +				best_found = match;
>>> +			else
>>> +				break;
>>> +		}
>>> +	}
>>> +
>>> +	if (pl) {
>>> +		struct class_dev_iter iter;
>>> +		struct device *phy_dev;
>>> +
>>> +		class_dev_iter_init(&iter, phy_class, NULL, NULL);
>>> +		while ((phy_dev = class_dev_iter_next(&iter))) {
>>> +			if (!strcmp(dev_name(phy_dev), pl->phy_name)) {
>>
>> I'm not sure how it'll work with systems which has multiple PHYs since the "id"
>> component of the device is determined purely in runtime.
>>
>> I'd assume we'll be constantly patching the lookup data for non-dt boot :-/
> 
> I'm sorry but I don't think I understand (I must be a bit tired
> today)? Could you please elaborate?

Assume you have 2 phys in your system..
static struct phy_lookup usb_lookup = {
	.phy_name	= "phy-usb.0",
	.dev_id		= "usb.0",
	.con_id		= "usb",
};

static struct phy_lookup sata_lookup = {
	.phy_name	= "sata-usb.1",
	.dev_id		= "sata.0",
	.con_id		= "sata",
};

First you do modprobe phy-usb, the probe of USB PHY driver gets invoked and it
creates the PHY. The phy-core will find a free id (now it will be 0) and then
name the phy as phy-usb.0.
Then with modprobe phy-sata, the phy-core will create phy-sata.1.

This is an ideal case where the .phy_name in phy_lookup matches.

Consider if the order is flipped and the user does modprobe phy-sata first. The
phy_names won't match anymore (the sata phy device name would be "sata-usb.0").

Thanks
Kishon
