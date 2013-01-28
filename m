Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab3A1Jin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:38:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3A1Jih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:38:37 -0500
From: Jason Wang <jasowang@redhat.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: How to find an unused TAP device with kernel 3.8 ?
Date: Mon, 28 Jan 2013 17:38:24 +0800
Message-ID: <3592886.xagLc7Uij9@jason-thinkpad-t430s>
User-Agent: KMail/4.9.4 (Linux/3.7.0-rc7+; KDE/4.9.4; x86_64; ; )
In-Reply-To: <5103B01D.5070303@gmx.de>
References: <5103B01D.5070303@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 26, 2013 11:29:49 AM Toralf Förster wrote:
> With kernel 3.8. I just realized that all pre-defined TAP devices are
> RUNNING even if no virtual linux system is using it. Now I'm wondering
> whether this is a new feature of the upcoming kernel, a bug of the old -
> and how I can avoid that.
> 
> Background : When I start a user mode linux instance, I currently grep
> for the next free tap device in this way :
> 
> Code:
> for t in $(ifconfig | grep "^tap" | cut -f1 -d:)
> do
>    ethtool $t | grep -q 'Link detected: no'
>    if [[ $? -eq 0 ]]; then
>       NET="tuntap,$t"
>       break
>    fi
> done
> 
> but this doesn't work now anymore.
> 
> Here is the diff in dmesg
> 
> $ diff 3.7.1 3.8.0-rc1+ | grep UP
> 
> < br0: flags=4355<UP,BROADCAST,PROMISC,MULTICAST>  mtu 1500
> 
> > br0: flags=4419<UP,BROADCAST,RUNNING,PROMISC,MULTICAST>  mtu 1500
> 
> < tap0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
> 
> > tap0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
> 
> more details : http://forums.gentoo.org/viewtopic-p-7211498.html#7211498

Looks like something wrong with the carrier detection of tap.

Please try the following patch to see if it helps.

Thanks.

diff --git a/drivers/net/tun.c b/drivers/net/tun.c                                                                                                                        
index cc09b67..d8a53c3 100644                                                                                                                                             
--- a/drivers/net/tun.c                                                                                                                                                   
+++ b/drivers/net/tun.c                                                                                                                                                   
@@ -438,6 +438,9 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
                sock_put(&tfile->sk);                                                                                                                                     
        }                                                                                                                                                                 
                                                                                                                                                                          
+       if (tun && tun->numqueues == 0)                                                                                                                                   
+               netif_carrier_off(tun->dev);                                                                                                                              
+                                                                                                                                                                         
        if (clean) {                                                                                                                                                      
                if (tun && tun->numqueues == 0 && tun->numdisabled == 0 &&                                                                                                
                    !(tun->flags & TUN_PERSIST))                                                                                                                          
@@ -473,6 +476,7 @@ static void tun_detach_all(struct net_device *dev)
        BUG_ON(tun->numqueues != 0);                                                                                                                                      
                                                                                                                                                                          
        synchronize_net();                                                                                                                                                
+       netif_carrier_off(dev);                                                                                                                                           
        for (i = 0; i < n; i++) {                                                                                                                                         
                tfile = rtnl_dereference(tun->tfiles[i]);                                                                                                                 
                /* Drop read queue */                                                                                                                                     
@@ -531,6 +535,7 @@ static int tun_attach(struct tun_struct *tun, struct file *file)
                sock_hold(&tfile->sk);                                                                                                                                    
                                                                                                                                                                          
        tun_set_real_num_queues(tun);                                                                                                                                     
+       netif_carrier_on(tun->dev);                                                                                                                                       
                                                                                                                                                                          
        /* device is allowed to go away first, so no need to hold extra                                                                                                   
         * refcnt.                                                                                                                                                        
--                                                                                                                                                                        
1.7.1  
