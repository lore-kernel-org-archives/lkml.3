Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454AbaFQPaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 11:30:20 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:53347 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932869AbaFQPaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 11:30:14 -0400
From: "Steve Wise" <swise@opengridcomputing.com>
To: "'Nicholas Krause'" <xerofoify@gmail.com>, <swise@chelsio.com>
Cc: <roland@kernel.org>, <sean.hefty@intel.com>, <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1403018673-4819-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1403018673-4819-1-git-send-email-xerofoify@gmail.com>
Subject: RE: [PATCH] Checks for Null return of skb_alloc in send_flowc
Date: Tue, 17 Jun 2014 10:30:30 -0500
Message-ID: <003201cf8a41$1263a020$372ae060$@opengridcomputing.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIWNC7l8MmbjtDr5OlaNGEBEo4fP5roGP0A
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nicholas Krause [mailto:xerofoify@gmail.com]
> Sent: Tuesday, June 17, 2014 10:25 AM
> To: swise@chelsio.com
> Cc: roland@kernel.org; sean.hefty@intel.com; hal.rosenstock@gmail.com; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] Checks for Null return of skb_alloc in send_flowc
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 5e153f6..7e3d663 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -457,6 +457,10 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
>  	int i;
> 
>  	skb = get_skb(skb, flowclen, GFP_KERNEL);
> +	if (!skb) {
> +		kfree_skb(skb);
> +		pr_warn(MOD "%s failed to allocate skb.\n", __func__);
> +	}

You still don't have this right.  :( 

Like this:

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 5e153f6..3c55e88 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -457,6 +457,8 @@ static void send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
        int i;

        skb = get_skb(skb, flowclen, GFP_KERNEL);
+       if (!skb)
+               return;
        flowc = (struct fw_flowc_wr *)__skb_put(skb, flowclen);

        flowc->op_to_nparams = cpu_to_be32(FW_WR_OP(FW_FLOWC_WR) |



