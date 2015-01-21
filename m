Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbbAUQUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:20:35 -0500
Received: from mail-db3on0091.outbound.protection.outlook.com ([157.55.234.91]:35998
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752024AbbAUQUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:20:33 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
From: Andri Yngvason <andri.yngvason@marel.com>
In-Reply-To: <20150120214537.GB16828@linux>
CC: Linux-CAN <linux-can@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20141223154654.GB6460@vivalin-002> <20150120214409.GA16828@linux>
 <20150120214537.GB16828@linux>
Message-ID: <20150121162025.2933.13836@shannon>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 2/5] can: kvaser_usb: Consolidate and unify state change
 handling
Date: Wed, 21 Jan 2015 16:20:25 +0000
X-Originating-IP: [10.100.11.118]
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 212.30.206.5)
 smtp.mailfrom=Andri.Yngvason@marel.com; 
X-Forefront-Antispam-Report: CIP:212.30.206.5;CTRY:IS;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(51704005)(377424004)(46102003)(88526003)(19580405001)(19580395003)(6806004)(16796002)(77156002)(83506001)(33716001)(86362001)(57986006)(76506005)(92566002)(106466001)(50986999)(87936001)(71226002)(77096005)(76176999)(23676002)(54356999)(64706001)(2950100001)(50466002)(47776003);DIR:OUT;SFP:1101;SCL:1;SRVR:DBXPR05MB255;H:smtp.marel.com;FPR:;SPF:Pass;MLV:sfv;PTR:smtp.marel.com;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DBXPR05MB255;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DBXPR05MB255;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DBXPR05MB255;
X-OriginatorOrg: marel.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 16:20:29.1149
 (UTC)
X-MS-Exchange-CrossTenant-Id: e5f498be-7303-45fd-a594-9e3fd22a77d7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5f498be-7303-45fd-a594-9e3fd22a77d7;Ip=[212.30.206.5]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBXPR05MB255
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Ahmed S. Darwish (2015-01-20 21:45:37)
> From: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> 
> Replace most of the can interface's state and error counters
> handling with the new can-dev can_change_state() mechanism.
> 
> Suggested-by: Andri Yngvason <andri.yngvason@marel.com>
> Signed-off-by: Ahmed S. Darwish <ahmed.darwish@valeo.com>
> ---
>  drivers/net/can/usb/kvaser_usb.c | 114 +++++++++++++++++++--------------------
>  1 file changed, 55 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> index 971c5f9..0386d3f 100644
> --- a/drivers/net/can/usb/kvaser_usb.c
> +++ b/drivers/net/can/usb/kvaser_usb.c
> @@ -620,40 +620,43 @@ static void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
>  }
>  
>  static void kvaser_usb_rx_error_update_can_state(struct kvaser_usb_net_priv *priv,
> -                                                const struct kvaser_usb_error_summary *es)
> +                                                const struct kvaser_usb_error_summary *es,
> +                                                struct can_frame *cf)
>  {
>         struct net_device_stats *stats;
> -       enum can_state new_state;
> -
> -       stats = &priv->netdev->stats;
> -       new_state = priv->can.state;
> +       enum can_state cur_state, new_state, tx_state, rx_state;
>  
>         netdev_dbg(priv->netdev, "Error status: 0x%02x\n", es->status);
>  
> -       if (es->status & M16C_STATE_BUS_OFF) {
> -               priv->can.can_stats.bus_off++;
> +       stats = &priv->netdev->stats;
> +       new_state = cur_state = priv->can.state;
> +
> +       if (es->status & M16C_STATE_BUS_OFF)
>                 new_state = CAN_STATE_BUS_OFF;
> -       } else if (es->status & M16C_STATE_BUS_PASSIVE) {
> -               if (priv->can.state != CAN_STATE_ERROR_PASSIVE)
> -                       priv->can.can_stats.error_passive++;
> +       else if (es->status & M16C_STATE_BUS_PASSIVE)
>                 new_state = CAN_STATE_ERROR_PASSIVE;
> -       }
>  
>         if (es->status == M16C_STATE_BUS_ERROR) {
> -               if ((priv->can.state < CAN_STATE_ERROR_WARNING) &&
> -                   ((es->txerr >= 96) || (es->rxerr >= 96))) {
> -                       priv->can.can_stats.error_warning++;
> +               if ((cur_state < CAN_STATE_ERROR_WARNING) &&
> +                   ((es->txerr >= 96) || (es->rxerr >= 96)))
>                         new_state = CAN_STATE_ERROR_WARNING;
> -               } else if (priv->can.state > CAN_STATE_ERROR_ACTIVE) {
> +               else if (cur_state > CAN_STATE_ERROR_ACTIVE)
>                         new_state = CAN_STATE_ERROR_ACTIVE;
> -               }
>         }
>  
>         if (!es->status)
>                 new_state = CAN_STATE_ERROR_ACTIVE;
>  
> +       if (new_state != cur_state) {
> +               tx_state = (es->txerr >= es->rxerr) ? new_state : 0;
> +               rx_state = (es->txerr <= es->rxerr) ? new_state : 0;
> +
> +               can_change_state(priv->netdev, cf, tx_state, rx_state);
This (below) is redundant. It doesn't harm but at this point can_change_state
has set priv->can.state to new_state.
> +               new_state = priv->can.state;
> +       }
> +
>         if (priv->can.restart_ms &&
> -           (priv->can.state >= CAN_STATE_BUS_OFF) &&
> +           (cur_state >= CAN_STATE_BUS_OFF) &&
>             (new_state < CAN_STATE_BUS_OFF)) {
>                 priv->can.can_stats.restarts++;
>         }
> @@ -665,18 +668,17 @@ static void kvaser_usb_rx_error_update_can_state(struct kvaser_usb_net_priv *pri
>  
>         priv->bec.txerr = es->txerr;
>         priv->bec.rxerr = es->rxerr;
> -       priv->can.state = new_state;
>  }
>  
>  static void kvaser_usb_rx_error(const struct kvaser_usb *dev,
>                                 const struct kvaser_msg *msg)
>  {
> -       struct can_frame *cf;
> +       struct can_frame *cf, tmp_cf = { .can_id = CAN_ERR_FLAG, .can_dlc = CAN_ERR_DLC };
>         struct sk_buff *skb;
>         struct net_device_stats *stats;
>         struct kvaser_usb_net_priv *priv;
>         struct kvaser_usb_error_summary es = { };
> -       enum can_state old_state;
> +       enum can_state old_state, new_state;
>  
>         switch (msg->id) {
>         case CMD_CAN_ERROR_EVENT:
> @@ -721,60 +723,54 @@ static void kvaser_usb_rx_error(const struct kvaser_usb *dev,
>         }
>  
>         /* Update all of the can interface's state and error counters before
> -        * trying any skb allocation that can actually fail with -ENOMEM.
> +        * trying any memory allocation that can actually fail with -ENOMEM.
> +        *
> +        * We send a temporary stack-allocated error can frame to
> +        * can_change_state() for the very same reason.
> +        *
> +        * TODO: Split can_change_state() responsibility between updating the
> +        * can interface's state and counters, and the setting up of can error
> +        * frame ID and data to userspace. Remove stack allocation afterwards.
>          */
>         old_state = priv->can.state;
> -       kvaser_usb_rx_error_update_can_state(priv, &es);
> +       kvaser_usb_rx_error_update_can_state(priv, &es, &tmp_cf);
> +       new_state = priv->can.state;
>  
>         skb = alloc_can_err_skb(priv->netdev, &cf);
>         if (!skb) {
>                 stats->rx_dropped++;
>                 return;
>         }
> +       memcpy(cf, &tmp_cf, sizeof(*cf));
>  
> -       if (es.status & M16C_STATE_BUS_OFF) {
> -               cf->can_id |= CAN_ERR_BUSOFF;
> -
> -               if (!priv->can.restart_ms)
> -                       kvaser_usb_simple_msg_async(priv, CMD_STOP_CHIP);
> -               netif_carrier_off(priv->netdev);
> -       } else if (es.status & M16C_STATE_BUS_PASSIVE) {
> -               if (old_state != CAN_STATE_ERROR_PASSIVE) {
> -                       cf->can_id |= CAN_ERR_CRTL;
> -
> -                       if (es.txerr || es.rxerr)
> -                               cf->data[1] = (es.txerr > es.rxerr)
> -                                               ? CAN_ERR_CRTL_TX_PASSIVE
> -                                               : CAN_ERR_CRTL_RX_PASSIVE;
> -                       else
> -                               cf->data[1] = CAN_ERR_CRTL_TX_PASSIVE |
> -                                             CAN_ERR_CRTL_RX_PASSIVE;
> +       if (new_state != old_state) {
> +               if (es.status & M16C_STATE_BUS_OFF) {
> +                       if (!priv->can.restart_ms)
> +                               kvaser_usb_simple_msg_async(priv, CMD_STOP_CHIP);
> +                       netif_carrier_off(priv->netdev);
> +               }
> +
This block is wrong. The usage of PROT_ACTIVE is based on a misunderstanding.
It's used in some drivers to signify back-to-error-active but its original
meaning is something completely different, AFAIK.
This is handled in can_change_state() using a new CTRL message; namely:
CAN_ERR_CTRL_ACTIVE. The newest version of can-utils is up to date with this.
> +               if (es.status == M16C_STATE_BUS_ERROR) {
> +                       if ((old_state >= CAN_STATE_ERROR_WARNING) ||
> +                           (es.txerr < 96 && es.rxerr < 96)) {
> +                               if (old_state > CAN_STATE_ERROR_ACTIVE) {
> +                                       cf->can_id |= CAN_ERR_PROT;
> +                                       cf->data[2] = CAN_ERR_PROT_ACTIVE;
> +                               }
> +                       }
>                 }
> -       }
>  
> -       if (es.status == M16C_STATE_BUS_ERROR) {
> -               if ((old_state < CAN_STATE_ERROR_WARNING) &&
> -                   ((es.txerr >= 96) || (es.rxerr >= 96))) {
> -                       cf->can_id |= CAN_ERR_CRTL;
> -                       cf->data[1] = (es.txerr > es.rxerr)
> -                                       ? CAN_ERR_CRTL_TX_WARNING
> -                                       : CAN_ERR_CRTL_RX_WARNING;
> -               } else if (old_state > CAN_STATE_ERROR_ACTIVE) {
This is also redundant, and wrong:
> +               if (!es.status) {
>                         cf->can_id |= CAN_ERR_PROT;
>                         cf->data[2] = CAN_ERR_PROT_ACTIVE;
>                 }
> -       }
>  
> -       if (!es.status) {
> -               cf->can_id |= CAN_ERR_PROT;
> -               cf->data[2] = CAN_ERR_PROT_ACTIVE;
> -       }
> -
> -       if (priv->can.restart_ms &&
> -           (old_state >= CAN_STATE_BUS_OFF) &&
> -           (priv->can.state < CAN_STATE_BUS_OFF)) {
> -               cf->can_id |= CAN_ERR_RESTARTED;
> -               netif_carrier_on(priv->netdev);
> +               if (priv->can.restart_ms &&
> +                   (old_state >= CAN_STATE_BUS_OFF) &&
> +                   (new_state < CAN_STATE_BUS_OFF)) {
> +                       cf->can_id |= CAN_ERR_RESTARTED;
> +                       netif_carrier_on(priv->netdev);
> +               }
>         }
>  
>         if (es.error_factor) {
> -- 
> 1.9.1

Looking over the patch again, I've noticed that there are a few things that are
not quite right.

Marc, could you merge the "move bus_off++" patch before you merge this so that I
won't have to incorporate this patch-set into it?

--
Andri
