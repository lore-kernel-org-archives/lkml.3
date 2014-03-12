Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaCLVgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:36:09 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:52854 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaCLVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:35:56 -0400
MIME-Version: 1.0
In-Reply-To: <1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com>
	<1394658311-17769-2-git-send-email-jgunthorpe@obsidianresearch.com>
Date: Wed, 12 Mar 2014 16:35:54 -0500
Message-ID: <CAL_Jsq+qdbiwXErkZv1zZ9rphYY9NP6zHmmjw313tMvGeSTODg@mail.gmail.com>
Subject: Re: [PATCH v2a RESEND 2/2] of_mdio: Allow the DT to specify the phy
 ID and avoid autoprobing
From: Rob Herring <robherring2@gmail.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Rob Herring <robh+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 4:05 PM, Jason Gunthorpe
<jgunthorpe@obsidianresearch.com> wrote:
> This makes the generic of_mdiobus_register parse the DT compatible string for
> the pattern ethernet-phy-idAAAA.BBBB. If present it should be a value that
> matches the phy-id register normally readable through MDIO.
>
> When the ID is given the phy autoprobing is defeated and the phy is
> created directly.
>
> This is necessary to support phy's that cannot be autoprobed when
> of_mdiobus_register is called. Specifically, my case has the phy in reset at
> of_mdiobus_register, the reset is only released once the ethernet driver
> starts, before it attaches to the phy.
>
> Tested on ARM Kirkwood with phy id 0x01410e90 (Marvell 88E1318)
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/of/of_mdio.c | 30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
>
> There was some reworking of the original code in v3.14-rc6, this resolves the
> merge conflicts and I retested the resolved patch on Kirkwood.
>
> Florian, do you know what path to mainline a this patch should take?

Via David's net tree.

>
> Thanks,
> Jason
>
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index 5b3c24f..6cdcbda 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -43,6 +43,30 @@ static void of_set_phy_supported(struct phy_device *phydev, u32 max_speed)
>         }
>  }
>
> +/* Extract the clause 22 phy ID from the compatible string of the form
> + * ethernet-phy-idAAAA.BBBB */
> +static int of_get_phy_id(struct device_node *device, u32 *phy_id)
> +{
> +       const char *cp;
> +       int cplen, l;
> +       unsigned int upper, lower;
> +
> +       cp = of_get_property(device, "compatible", &cplen);
> +       if (cp == NULL)
> +               return -EINVAL;
> +       while (cplen > 0) {

This can all be:

  of_property_for_each_string(device, "compatible", prop, cp)

> +               if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
> +                       *phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
> +                       return 0;
> +               }
> +
> +               l = strlen(cp) + 1;
> +               cp += l;
> +               cplen -= l;
> +       }
> +       return -EINVAL;
> +}
> +
>  static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *child,
>                                    u32 addr)
>  {
> @@ -50,11 +74,15 @@ static int of_mdiobus_register_phy(struct mii_bus *mdio, struct device_node *chi
>         bool is_c45;
>         int rc;
>         u32 max_speed = 0;
> +       u32 phy_id;
>
>         is_c45 = of_device_is_compatible(child,
>                                          "ethernet-phy-ieee802.3-c45");
>
> -       phy = get_phy_device(mdio, addr, is_c45);
> +       if (!is_c45 && !of_get_phy_id(child, &phy_id))
> +               phy = phy_device_create(mdio, addr, phy_id, 0, NULL);
> +       else
> +               phy = get_phy_device(mdio, addr, is_c45);
>         if (!phy || IS_ERR(phy))
>                 return 1;
>
> --
> 1.8.1.2
>
