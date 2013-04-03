Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763146Ab3DCTJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:09:03 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:25532 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762073Ab3DCTJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:09:01 -0400
Message-ID: <1365016137.2897.26.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] netdev/phy: Implement ieee802.3 clause 45 in
 mdio-octeon.c
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Daney <ddaney.cavm@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, David Daney <david.daney@cavium.com>
Date: Wed, 3 Apr 2013 20:08:57 +0100
In-Reply-To: <1365013008-10914-1-git-send-email-ddaney.cavm@gmail.com>
References: <1365013008-10914-1-git-send-email-ddaney.cavm@gmail.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19764.005
X-TM-AS-Result: No--9.007700-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 11:16 -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> The Octeon SMI/MDIO interfaces can do clause 45 communications, so
> implement this in the driver.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/net/phy/mdio-octeon.c | 89 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 86 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
> index c2c878d..f4f3abf 100644
> --- a/drivers/net/phy/mdio-octeon.c
> +++ b/drivers/net/phy/mdio-octeon.c
[...]
>  static int octeon_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum)
>  {
>  	struct octeon_mdiobus *p = bus->priv;
>  	union cvmx_smix_cmd smi_cmd;
>  	union cvmx_smix_rd_dat smi_rd;
> +	unsigned int op = 1; /* MDIO_CLAUSE_22_READ */
>  	int timeout = 1000;
>  
> +	if (regnum & MII_ADDR_C45) {
> +		int r = octeon_mdiobus_c45_addr(p, phy_id, regnum);
> +		if (r < 0)
> +			return r;
> +
> +		regnum = (regnum >> 16) & 0x1f;
> +		op = 3; /* MDIO_CLAUSE_45_READ */
> +	} else {
> +		octeon_mdiobus_set_mode(p, C22);
> +	}
> +
> +
>  	smi_cmd.u64 = 0;
> -	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */
> +	smi_cmd.s.phy_op = op; /* MDIO_CLAUSE_22_READ */
[...]

This comment should now be removed.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

