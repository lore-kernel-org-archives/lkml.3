Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaHGWJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:09:31 -0400
Received: from exprod5og118.obsmtp.com ([64.18.0.160]:34454 "HELO
	exprod5og118.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752088AbaHGWJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <53C4C584.1090109@gmail.com>
References: <1405376285-23008-1-git-send-email-isubramanian@apm.com>
	<1405376285-23008-5-git-send-email-isubramanian@apm.com>
	<53C4C584.1090109@gmail.com>
Date: Thu, 7 Aug 2014 15:09:25 -0700
Message-ID: <CAKh23FmULrDLd0uvqh=wA_UC9uZxnmGjipodk2u5TP6h4e8Q1w@mail.gmail.com>
Subject: Re: [PATCH v9 4/4] drivers: net: Add APM X-Gene SoC ethernet driver support.
From: Iyappan Subramanian <isubramanian@apm.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jcm@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 11:09 PM, Varka Bhadram <varkabhadram@gmail.com> wrote:
> On 07/15/2014 03:48 AM, Iyappan Subramanian wrote:
>
> (...)
>
> +static void xgene_enet_rd_mcx_mac(struct xgene_enet_pdata *pdata,
> +  u32 rd_addr, u32 *rd_data)
> +{
> + void __iomem *addr, *rd, *cmd, *cmd_done;
> + bool ret;
> +
> + addr = pdata->mcx_mac_addr + MAC_ADDR_REG_OFFSET;
> + rd = pdata->mcx_mac_addr + MAC_READ_REG_OFFSET;
> + cmd = pdata->mcx_mac_addr + MAC_COMMAND_REG_OFFSET;
> + cmd_done = pdata->mcx_mac_addr + MAC_COMMAND_DONE_REG_OFFSET;
> +
> + ret = xgene_enet_rd_indirect(addr, rd, cmd, cmd_done, rd_addr, rd_data);
> + if (!ret)
> + netdev_err(pdata->ndev, "MCX mac read failed, addr: %04x\n",
> +   rd_addr);
>
> if (!xgene_enet_rd_indirect(addr, rd, cmd, cmd_done, rd_addr, rd_data))
> netdev_err(pdata->ndev, "MCX mac read failed, addr: %04x\n",
>   rd_addr);
>
> +}
> +

I will apply the change here as well as at the wr_mcx_mac function.

>
> (...)
>
> +static int xgene_enet_mdio_write(struct mii_bus *bus, int mii_id, int
> regnum,
> + u16 val)
> +{
> + struct xgene_enet_pdata *pdata = bus->priv;
> + int ret;
> +
> + netdev_dbg(pdata->ndev, "mdio_wr: bus=%d reg=%d val=%x\n",
> +   mii_id, regnum, val);
> + ret = xgene_mii_phy_write(pdata, mii_id, regnum, val);
> +
> + return ret;
>
> return xgene_mii_phy_write(pdata, mii_id, regnum, val);
>
> No need of ret variable....

I will apply the change.

>
> +}
> +
> +
>
> (...)
>
> +
> + rx_ring->nbufpool = NUM_BUFPOOL;
> + rx_ring->buf_pool = buf_pool;
> + rx_ring->irq = pdata->rx_irq;
> + buf_pool->rx_skb = devm_kcalloc(dev, buf_pool->slots,
> +     sizeof(struct sk_buff *), GFP_KERNEL);
>
> Should match open paranthesis:

I will fix these.

>
> buf_pool->rx_skb = devm_kcalloc(dev, buf_pool->slots,
> sizeof(struct sk_buff *),
> GFP_KERNEL);
>
> + if (!buf_pool->rx_skb) {
> + ret = -ENOMEM;
> + goto err;
> + }
> +
> + buf_pool->dst_ring_num = xgene_enet_dst_ring_num(buf_pool);
> + rx_ring->buf_pool = buf_pool;
> + pdata->rx_ring = rx_ring;
> +
> + /* allocate tx descriptor ring */
> + ring_id = xgene_enet_get_ring_id(RING_OWNER_ETH0, eth_bufnum++);
> + tx_ring = xgene_enet_create_desc_ring(ndev, ring_num++,
> +      RING_CFGSIZE_16KB, ring_id);
> + if (!tx_ring) {
> + ret = -ENOMEM;
> + goto err;
> + }
> + pdata->tx_ring = tx_ring;
> +
> + cp_ring = pdata->rx_ring;
> + cp_ring->cp_skb = devm_kcalloc(dev, tx_ring->slots,
> +     sizeof(struct sk_buff *), GFP_KERNEL);
>
> Ditto
>
> + if (!cp_ring->cp_skb) {
> + ret = -ENOMEM;
> + goto err;
> + }
> + pdata->tx_ring->cp_ring = cp_ring;
> + pdata->tx_ring->dst_ring_num = xgene_enet_dst_ring_num(cp_ring);
> +
> + pdata->tx_qcnt_hi = pdata->tx_ring->slots / 2;
> + pdata->cp_qcnt_hi = pdata->rx_ring->slots / 2;
> + pdata->cp_qcnt_low = pdata->cp_qcnt_hi / 2;
> +
> + return 0;
> +
> +err:
> + xgene_enet_free_desc_rings(pdata);
> + return ret;
> +}
> +
>
> (...)
>
> +
> +static struct of_device_id xgene_enet_match[] = {
> + {.compatible = "apm,xgene-enet",},
> + {},
> +};
> +
> +MODULE_DEVICE_TABLE(of, xgene_enet_match);
> +
> +static struct platform_driver xgene_enet_driver = {
> + .driver = {
> +   .name = "xgene-enet",
> +   .owner = THIS_MODULE,
>
> No need to update .owner. module_platform_driver() will do for you.
>
> see:
> http://lxr.free-electrons.com/source/include/linux/platform_device.h#L190

I will remove the owner field initialization.

>
> +   .of_match_table = xgene_enet_match,
> +   },
> + .probe = xgene_enet_probe,
> + .remove = xgene_enet_remove,
> +};
> +
> +module_platform_driver(xgene_enet_driver);
> +
> +MODULE_DESCRIPTION("APM X-Gene SoC Ethernet driver");
> +MODULE_VERSION(XGENE_DRV_VERSION);
> +MODULE_AUTHOR("Keyur Chudgar <kchudgar@apm.com>");
> +MODULE_LICENSE("GPL");
>
> This is lengthy patch... Its better if you split the patch...

This is the base driver and it will be difficult to split the patches
at this stage.

>
> --
> Regards,
> Varka Bhadram.
