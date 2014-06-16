Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaFPN0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:26:17 -0400
Received: from linode.aoot.com ([69.164.194.13]:45143 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbaFPN0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:26:13 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 09:26:13 EDT
Message-ID: <539EF072.4010003@opengridcomputing.com>
Date: Mon, 16 Jun 2014 08:26:10 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nick <xerofoify@gmail.com>, swise@chelsio.com
CC: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix memory leak in cm.c
References: <1402885579-2994-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1402885579-2994-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/15/2014 9:26 PM, Nick wrote:
> This patch fixes memory by checking in function,
> *get_skuff if it is be passing a Null skb
> struct.
> Cheers Nick
> Signed-off-by: Nick <xerofoify@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/cm.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index 5e153f6..f9477e2 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,7 +340,11 @@ static int status2errno(int status)
>    */
>   static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>   {
> -	if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
> +	if (!skb) {
> +		return NULL;
> +	}
> +
> +	else if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>   		skb_trim(skb, 0);
>   		skb_get(skb);
>   		skb_reset_transport_header(skb);

This patch is incorrect.  If skb is null, then get_skb() will allocate a 
new one.  The idea is to reuse skb if it can be reused (ie is linear and 
not cloned). Otherwise allocate a new one:

static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
{
         if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
                 skb_trim(skb, 0);
                 skb_get(skb);
                 skb_reset_transport_header(skb);
         } else {
                 skb = alloc_skb(len, gfp);
         }
         t4_set_arp_err_handler(skb, NULL, NULL);
         return skb;
}


However, if skb is not null and (is not linear or is cloned), then we 
leak the skb.  So there is a bug.

So the else clause should free skb if it not NULL before calling 
alloc_skb() to get a new one.

Steve.

