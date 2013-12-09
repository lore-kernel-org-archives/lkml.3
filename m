Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3LIH0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:26:34 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:63892 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3LIH0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:26:30 -0500
MIME-Version: 1.0
In-Reply-To: <52A56DE5.5010206@st.com>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-2-git-send-email-wens@csie.org> <52A56DE5.5010206@st.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Mon, 9 Dec 2013 15:26:09 +0800
X-Google-Sender-Auth: 04yxo0BzeyB0xLDz3VNjfOxar-A
Message-ID: <CAGb2v67ySacOLsYDZ14SgWLS7-3kMq7G48nb2Ubz+Sfycbg9fw@mail.gmail.com>
Subject: Re: [PATCH 01/10] net: stmmac: Enable stmmac main clock when probing hardware
To: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
Cc: netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peppe,

On Mon, Dec 9, 2013 at 3:14 PM, Giuseppe CAVALLARO
<peppe.cavallaro@st.com> wrote:
> Hello Chen-Yu
>
>
> On 12/6/2013 6:29 PM, Chen-Yu Tsai wrote:
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> ---
>>
>> Guiseppe previously stated that the "stmmaceth" clock is the
>> main clock that drives the IP. The stmmac driver does not
>> enable this clock during the probe phase. When the driver is
>> built in to the kernel, this is fine because the clock maybe
>> on by default, or the boot loader had enabled it.
>>
>> If stmmac is built as a module, when the module is loaded,
>> the clock may be found unused and disabled by the kernel.
>
>
> the clk_prepare_enable is then called in the open.
> Is it not working for you?
> Do you mean that the stmmac_hw_init fails if you do not move
> the clk_get and clk_prepare_enable on top of the stmmac_dvr_probe?
>

Exactly. The clock needs to be enabled prior to stmmac_dvr_probe.
Otherwise, stmmac_mdio_register will fail to find a usable PHY.

The DWMAC core I am working with does not support chip ID or
HW capability flags. I suspect those would fail, too.

Disabling the clock at the end of stmmac_dvr_probe is to make
sure it plays nice with existing power management callbacks.

Chen-Yu

>>
>>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 24
>> +++++++++++++----------
>>   1 file changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 8d4ccd3..7da71ed 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -2688,10 +2688,17 @@ struct stmmac_priv *stmmac_dvr_probe(struct device
>> *device,
>>         if ((phyaddr >= 0) && (phyaddr <= 31))
>>                 priv->plat->phy_addr = phyaddr;
>>
>> +       priv->stmmac_clk = clk_get(priv->device, STMMAC_RESOURCE_NAME);
>> +       if (IS_ERR(priv->stmmac_clk)) {
>> +               pr_warn("%s: warning: cannot get CSR clock\n", __func__);
>> +               goto error_clk_get;
>> +       }
>> +       clk_prepare_enable(priv->stmmac_clk);
>> +
>>         /* Init MAC and get the capabilities */
>>         ret = stmmac_hw_init(priv);
>>         if (ret)
>> -               goto error_free_netdev;
>> +               goto error_hw_init;
>>
>>         ndev->netdev_ops = &stmmac_netdev_ops;
>>
>> @@ -2729,12 +2736,6 @@ struct stmmac_priv *stmmac_dvr_probe(struct device
>> *device,
>>                 goto error_netdev_register;
>>         }
>>
>> -       priv->stmmac_clk = clk_get(priv->device, STMMAC_RESOURCE_NAME);
>> -       if (IS_ERR(priv->stmmac_clk)) {
>> -               pr_warn("%s: warning: cannot get CSR clock\n", __func__);
>> -               goto error_clk_get;
>> -       }
>> -
>>         /* If a specific clk_csr value is passed from the platform
>>          * this means that the CSR Clock Range selection cannot be
>>          * changed at run-time and it is fixed. Viceversa the driver'll
>> try to
>> @@ -2759,15 +2760,18 @@ struct stmmac_priv *stmmac_dvr_probe(struct device
>> *device,
>>                 }
>>         }
>>
>> +       clk_disable_unprepare(priv->stmmac_clk);
>> +
>>         return priv;
>>
>>   error_mdio_register:
>> -       clk_put(priv->stmmac_clk);
>> -error_clk_get:
>>         unregister_netdev(ndev);
>>   error_netdev_register:
>>         netif_napi_del(&priv->napi);
>> -error_free_netdev:
>> +error_hw_init:
>> +       clk_disable_unprepare(priv->stmmac_clk);
>> +       clk_put(priv->stmmac_clk);
>> +error_clk_get:
>>         free_netdev(ndev);
>>
>>         return NULL;
>>
>
