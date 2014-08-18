Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaHRXNm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 19:13:42 -0400
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:33604 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbaHRXNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 19:13:40 -0400
X-IronPort-AV: E=Sophos;i="5.01,889,1400050800"; 
   d="scan'208";a="42697588"
Subject: Re: [PATCH v2] cnic: Replace rcu_dereference() with
 rcu_access_pointer()
From: Michael Chan <mchan@broadcom.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
CC: <davem@davemloft.net>, <eddie.wai@broadcom.com>, <joe@perches.com>,
        <mingo@kernel.org>, <peterz@infradead.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20140817101149.GA3692@ada>
References: <20140817101149.GA3692@ada>
Content-Type: text/plain; charset="cp1252"
Date: Mon, 18 Aug 2014 16:13:39 -0700
Message-ID: <1408403619.7460.1.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-17 at 13:12 +0300, Andreea-Cristina Bernat wrote: 
> The "rcu_dereference()" calls are used directly in conditions.
> Since their return values are never dereferenced it is recommended to use
> "rcu_access_pointer()" instead of "rcu_dereference()".
> Therefore, this patch makes the replacements.
> 
> The following Coccinelle semantic patch was used:
> @@
> @@
> 
> (
>  if(
>  (<+...
> - rcu_dereference
> + rcu_access_pointer
>   (...)
>   ...+>)) {...}
> |
>  while(
>  (<+...
> - rcu_dereference
> + rcu_access_pointer
>   (...)
>   ...+>)) {...}
> )
> 
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>

Acked-by: Michael Chan <mchan@broadcom.com>

> ---
> v2: Modified subject line from
>  "rcu: Replace rcu_dereference() with rcu_access_pointer()"
>  to
>  "cnic: Replace rcu_dereference() with rcu_access_pointer()",
>  noted by David Miller <davem@davemloft.net>
> 
>  drivers/net/ethernet/broadcom/cnic.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
> index 8244e2b..dad9cb7 100644
> --- a/drivers/net/ethernet/broadcom/cnic.c
> +++ b/drivers/net/ethernet/broadcom/cnic.c
> @@ -381,7 +381,7 @@ static int cnic_iscsi_nl_msg_recv(struct cnic_dev *dev, u32 msg_type,
>  			break;
>  
>  		rcu_read_lock();
> -		if (!rcu_dereference(cp->ulp_ops[CNIC_ULP_L4])) {
> +		if (!rcu_access_pointer(cp->ulp_ops[CNIC_ULP_L4])) {
>  			rc = -ENODEV;
>  			rcu_read_unlock();
>  			break;
> @@ -525,7 +525,7 @@ int cnic_unregister_driver(int ulp_type)
>  	list_for_each_entry(dev, &cnic_dev_list, list) {
>  		struct cnic_local *cp = dev->cnic_priv;
>  
> -		if (rcu_dereference(cp->ulp_ops[ulp_type])) {
> +		if (rcu_access_pointer(cp->ulp_ops[ulp_type])) {
>  			pr_err("%s: Type %d still has devices registered\n",
>  			       __func__, ulp_type);
>  			read_unlock(&cnic_dev_lock);
> @@ -573,7 +573,7 @@ static int cnic_register_device(struct cnic_dev *dev, int ulp_type,
>  		mutex_unlock(&cnic_lock);
>  		return -EAGAIN;
>  	}
> -	if (rcu_dereference(cp->ulp_ops[ulp_type])) {
> +	if (rcu_access_pointer(cp->ulp_ops[ulp_type])) {
>  		pr_err("%s: Type %d has already been registered to this device\n",
>  		       __func__, ulp_type);
>  		mutex_unlock(&cnic_lock);


