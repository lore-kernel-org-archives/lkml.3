Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763183Ab3DCTNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:13:23 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37777 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763010Ab3DCTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:13:22 -0400
Message-ID: <515C7F4E.3040108@gmail.com>
Date: Wed, 03 Apr 2013 12:13:18 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] netdev/phy: Implement ieee802.3 clause 45 in mdio-octeon.c
References: <1365013008-10914-1-git-send-email-ddaney.cavm@gmail.com> <1365016137.2897.26.camel@bwh-desktop.uk.solarflarecom.com>
In-Reply-To: <1365016137.2897.26.camel@bwh-desktop.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 12:08 PM, Ben Hutchings wrote:
> On Wed, 2013-04-03 at 11:16 -0700, David Daney wrote:
>> From: David Daney <david.daney@cavium.com>
>>
>> The Octeon SMI/MDIO interfaces can do clause 45 communications, so
>> implement this in the driver.
>>
>> Signed-off-by: David Daney <david.daney@cavium.com>
>> ---
>>   drivers/net/phy/mdio-octeon.c | 89 +++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 86 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
>> index c2c878d..f4f3abf 100644
>> --- a/drivers/net/phy/mdio-octeon.c
>> +++ b/drivers/net/phy/mdio-octeon.c
> [...]
>>   static int octeon_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum)
>>   {
>>   	struct octeon_mdiobus *p = bus->priv;
>>   	union cvmx_smix_cmd smi_cmd;
>>   	union cvmx_smix_rd_dat smi_rd;
>> +	unsigned int op = 1; /* MDIO_CLAUSE_22_READ */
>>   	int timeout = 1000;
>>
>> +	if (regnum & MII_ADDR_C45) {
>> +		int r = octeon_mdiobus_c45_addr(p, phy_id, regnum);
>> +		if (r < 0)
>> +			return r;
>> +
>> +		regnum = (regnum >> 16) & 0x1f;
>> +		op = 3; /* MDIO_CLAUSE_45_READ */
>> +	} else {
>> +		octeon_mdiobus_set_mode(p, C22);
>> +	}
>> +
>> +
>>   	smi_cmd.u64 = 0;
>> -	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */
>> +	smi_cmd.s.phy_op = op; /* MDIO_CLAUSE_22_READ */
> [...]
>
> This comment should now be removed.

You have very sharp eyes.  I will send yet another version of the patch 
with this removed.

David Daney


>
> Ben.
>

