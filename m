Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3A1TsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:48:25 -0500
Received: from mout.gmx.net ([212.227.17.20]:51116 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3A1TsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:48:23 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+WtTRLVJuW2WrV8fXj8L+nSU4RzVwJGSK+wdmlcS
	pNDF4KhYmO8kIz
Message-ID: <5106D3BE.3030401@gmx.de>
Date: Mon, 28 Jan 2013 20:38:38 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130111 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCHv2] tun: fix carrier on/off status
References: <5103B01D.5070303@gmx.de> <3592886.xagLc7Uij9@jason-thinkpad-t430s> <20130128101111.GB5337@redhat.com> <20130128103801.GA6648@redhat.com>
In-Reply-To: <20130128103801.GA6648@redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested-by: Toralf Förster <toralf.foerster@gmx.de>

On 01/28/2013 11:38 AM, Michael S. Tsirkin wrote:
> Commit c8d68e6be1c3b242f1c598595830890b65cea64a removed carrier off call
> from tun_detach since it's now called on queue disable and not only on
> tun close.  This confuses userspace which used this flag to detect a
> free tun. To fix, put this back but under if (clean).
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> 
> ---
> 
> Changes from v1:
> 	Don't set carrier off unless all queues are closed.
> 
> Note: didn't test in MQ mode - Jason, care checking this does the
> right thing there?
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index af372d0..06b2723 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -434,10 +434,13 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>  	}
>  
>  	if (clean) {
> -		if (tun && tun->numqueues == 0 && tun->numdisabled == 0 &&
> -		    !(tun->flags & TUN_PERSIST))
> -			if (tun->dev->reg_state == NETREG_REGISTERED)
> +		if (tun && tun->numqueues == 0 && tun->numdisabled == 0) {
> +			netif_carrier_off(tun->dev);
> +
> +			if (!(tun->flags & TUN_PERSIST) &&
> +			    tun->dev->reg_state == NETREG_REGISTERED)
>  				unregister_netdevice(tun->dev);
> +		}
>  
>  		BUG_ON(!test_bit(SOCK_EXTERNALLY_ALLOCATED,
>  				 &tfile->socket.flags));
> @@ -1644,10 +1647,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  		    device_create_file(&tun->dev->dev, &dev_attr_owner) ||
>  		    device_create_file(&tun->dev->dev, &dev_attr_group))
>  			pr_err("Failed to create tun sysfs files\n");
> -
> -		netif_carrier_on(tun->dev);
>  	}
>  
> +	netif_carrier_on(tun->dev);
> +
>  	tun_debug(KERN_INFO, tun, "tun_set_iff\n");
>  
>  	if (ifr->ifr_flags & IFF_NO_PI)
> 


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
