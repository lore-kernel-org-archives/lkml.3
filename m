Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaDOIH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:57 -0400
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:22766 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaDOIHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:07:51 -0400
From: Sathya Perla <Sathya.Perla@Emulex.Com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>,
        Subramanian Seetharaman <subbu.seetharaman@Emulex.Com>,
        Ajit Khaparde <Ajit.Khaparde@Emulex.Com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Topic: [PATCH 1/1] driver/net: add missing rtnl lock/unlock for benet
Thread-Index: AQHPWHZ0bsT8dc/t9U2+WUWO6psh85sSUZaA
Date: Tue, 15 Apr 2014 08:07:49 +0000
Message-ID: <b4855c2a-5a63-47a5-ba61-f9ce736f6401@CMEXHTCAS1.ad.emulex.com>
References: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
In-Reply-To: <1397544352-28841-1-git-send-email-zhen-hual@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [138.239.141.147]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Li, Zhen-Hua [mailto:zhen-hual@hp.com]
> 
> In benet driver, netif_device_detach and netif_device_attach should be
> called between rtnl_lock and rtnl_unlock.

Zhen, it's not clear to me why rtnl_lock is needed around netif_device_attach().
Can you pls explain what exact data-structure you are protecting with the lock?

Are you see warning stack trace? I don't see ASSERT_RTNL() called anywhere from netif_device_attach/detach()?

thanks!

> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/net/ethernet/emulex/benet/be_main.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/emulex/benet/be_main.c
> b/drivers/net/ethernet/emulex/benet/be_main.c
> index 3e6df47..9c44b3f 100644
> --- a/drivers/net/ethernet/emulex/benet/be_main.c
> +++ b/drivers/net/ethernet/emulex/benet/be_main.c
> @@ -4555,8 +4555,11 @@ static void be_func_recovery_task(struct work_struct *work)
>  		rtnl_unlock();
> 
>  		status = lancer_recover_func(adapter);
> -		if (!status)
> +		if (!status) {
> +			rtnl_lock();
>  			netif_device_attach(adapter->netdev);
> +			rtnl_unlock();
> +		}
>  	}
> 
>  	/* In Lancer, for all errors other than provisioning error (-EAGAIN),
> @@ -4784,12 +4787,12 @@ static int be_suspend(struct pci_dev *pdev, pm_message_t
> state)
>  	be_intr_set(adapter, false);
>  	cancel_delayed_work_sync(&adapter->func_recovery_work);
> 
> +	rtnl_lock();
>  	netif_device_detach(netdev);
>  	if (netif_running(netdev)) {
> -		rtnl_lock();
>  		be_close(netdev);
> -		rtnl_unlock();
>  	}
> +	rtnl_unlock();
>  	be_clear(adapter);
> 
>  	pci_save_state(pdev);
> @@ -4804,7 +4807,9 @@ static int be_resume(struct pci_dev *pdev)
>  	struct be_adapter *adapter = pci_get_drvdata(pdev);
>  	struct net_device *netdev =  adapter->netdev;
> 
> +	rtnl_lock();
>  	netif_device_detach(netdev);
> +	rtnl_unlock();
> 
>  	status = pci_enable_device(pdev);
>  	if (status)
> @@ -4832,7 +4837,9 @@ static int be_resume(struct pci_dev *pdev)
> 
>  	schedule_delayed_work(&adapter->func_recovery_work,
>  			      msecs_to_jiffies(1000));
> +	rtnl_lock();
>  	netif_device_attach(netdev);
> +	rtnl_unlock();
> 
>  	if (adapter->wol_en)
>  		be_setup_wol(adapter, false);
> @@ -4853,7 +4860,9 @@ static void be_shutdown(struct pci_dev *pdev)
>  	cancel_delayed_work_sync(&adapter->work);
>  	cancel_delayed_work_sync(&adapter->func_recovery_work);
> 
> +	rtnl_lock();
>  	netif_device_detach(adapter->netdev);
> +	rtnl_unlock();
> 
>  	be_cmd_reset_function(adapter);
> 
> @@ -4957,7 +4966,9 @@ static void be_eeh_resume(struct pci_dev *pdev)
> 
>  	schedule_delayed_work(&adapter->func_recovery_work,
>  			      msecs_to_jiffies(1000));
> +	rtnl_lock();
>  	netif_device_attach(netdev);
> +	rtnl_unlock();
>  	return;
>  err:
>  	dev_err(&adapter->pdev->dev, "EEH resume failed\n");
> --
> 1.7.10.4

