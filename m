Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3FEKfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 06:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3FEKe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 06:34:58 -0400
Date: Wed, 5 Jun 2013 13:35:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com
Subject: Re: [net-next rfc V3 1/9] macvtap: fix a possible race between queue
 selection and changing queues
Message-ID: <20130605103528.GE31830@redhat.com>
References: <1370414192-5830-1-git-send-email-jasowang@redhat.com>
 <1370414192-5830-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370414192-5830-2-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 02:36:24PM +0800, Jason Wang wrote:
> Complier may generate codes that re-read the vlan->numvtaps during
> macvtap_get_queue(). This may lead a race if vlan->numvtaps were changed in the
> same time and which can lead unexpected result (e.g. very huge value).
> 
> We need prevent the compiler from generating such codes by adding an
> ACCESS_ONCE() to make sure vlan->numvtaps were only read once.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I would add that this is a theoretical issue, so no need
for stable.

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  drivers/net/macvtap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index 68efb91..5e485e3 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -172,7 +172,7 @@ static struct macvtap_queue *macvtap_get_queue(struct net_device *dev,
>  {
>  	struct macvlan_dev *vlan = netdev_priv(dev);
>  	struct macvtap_queue *tap = NULL;
> -	int numvtaps = vlan->numvtaps;
> +	int numvtaps = ACCESS_ONCE(vlan->numvtaps);
>  	__u32 rxq;
>  
>  	if (!numvtaps)
> -- 
> 1.7.1
