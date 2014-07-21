Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbaGUJmn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 05:42:43 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:33084 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaGUJmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 05:42:42 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.72.173]
In-Reply-To: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
References: <1405680903-28176-1-git-send-email-yuezha@microsoft.com>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 21 Jul 2014 11:42:21 +0200
Message-ID: <CAG-2HqXFBUmpTAE8h13-DmP6Fq42viHzmuH9OfNoLgjW8XcQ3Q@mail.gmail.com>
Subject: Re: [PATCH] Hyperv: Trigger DHCP renew after host hibernation
To: Yue Zhang <yuezha@microsoft.com>
Cc: netdev <netdev@vger.kernel.org>, driverdev-devel@linuxdriverproject.org,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, olaf@aepfle.de,
        jasowang@redhat.com, David Miller <davem@davemloft.net>,
        haiyangz@microsoft.com, kys@microsoft.com, huishao@microsoft.com,
        decui@microsoft.com, Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:55 PM, Yue Zhang <yuezha@microsoft.com> wrote:
> From: Yue Zhang <yuezha@microsoft.com>
>
> This patch addresses the comment from Olaf Hering and Greg KH
> for a previous commit 3a494e710367 ("hyperv: Add handler for
> RNDIS_STATUS_NETWORK_CHANGE event")
>
> In previous solution, the driver calls "network restart" to
> force a DHCP renew when the host is back from hibernation.
>
> In this fix, the driver will keep network carrier offline for
> 10 seconds and then bring it back. So that ifplugd daemon will
> notice this change and refresh DHCP lease.
>
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
>
> Signed-off-by: Yue Zhang <yuezha@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index a9c5eaa..559c97d 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -33,6 +33,7 @@
>  #include <linux/if_vlan.h>
>  #include <linux/in.h>
>  #include <linux/slab.h>
> +#include <linux/delay.h>
>  #include <net/arp.h>
>  #include <net/route.h>
>  #include <net/sock.h>
> @@ -792,8 +793,7 @@ static void netvsc_link_change(struct work_struct *w)
>         struct netvsc_device *net_device;
>         struct rndis_device *rdev;
>         bool notify, refresh = false;
> -       char *argv[] = { "/etc/init.d/network", "restart", NULL };
> -       char *envp[] = { "HOME=/", "PATH=/sbin:/usr/sbin:/bin:/usr/bin", NULL };
> +       int delay;
>
>         rtnl_lock();
>
> @@ -816,8 +816,21 @@ static void netvsc_link_change(struct work_struct *w)
>
>         rtnl_unlock();
>
> -       if (refresh)
> -               call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> +       if (refresh) {
> +               /*
> +                * Keep the carrier offline for 10 seconds
> +                * to notify ifplugd daemon network change
> +                */
> +               for (delay = 0; delay < 10; delay++) {
> +                       rtnl_lock();
> +                       netif_carrier_off(net);
> +                       rtnl_unlock();
> +                       ssleep(1);
> +               }
> +               rtnl_lock();
> +               netif_carrier_on(net);
> +               rtnl_unlock();
> +       }

Why is it necessary to wait for ten seconds? Why not just:

if (refresh) {
        rtnl_lock();
        netif_carrier_off(net);
        netif_carrier_on(net);
        rtnl_unlock();
}

At least systemd-networkd will renew the dhcp lease as long as it gets
NEWLINK messages indicating that the carrier was lost and regained,
regardless of the time between events. Is there any reason not to do
this?

Cheers,

Tom

>         if (notify)
>                 netdev_notify_peers(net);
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
