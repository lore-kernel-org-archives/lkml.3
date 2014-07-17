Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158AbaGQKFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:05:12 -0400
Received: from senator.holtmann.net ([87.106.208.187]:34721 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaGQKFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:05:09 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] bluetooth: never linger on process exit
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1405412728-4706-1-git-send-email-vdavydov@parallels.com>
Date: Thu, 17 Jul 2014 12:05:26 +0200
Cc: "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Linux Bluetooth mailing list 
	<linux-bluetooth@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <2ECFA3A4-C890-4512-86CD-B17EFDB57663@holtmann.org>
References: <1405412728-4706-1-git-send-email-vdavydov@parallels.com>
To: Vladimir Davydov <vdavydov@parallels.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vladimir,

please always include linux-bluetooth@vger.kernel.org since otherwise it might be missed in the massive amount of emails that is LKML.

> If the current process is exiting, lingering on socket close will make
> it unkillable, so we should avoid it.
> 
> Reproducer:
> 
>  #include <sys/types.h>
>  #include <sys/socket.h>
> 
>  #define BTPROTO_L2CAP   0
>  #define BTPROTO_SCO     2
>  #define BTPROTO_RFCOMM  3
> 
>  int main()
>  {
>          int fd;
>          struct linger ling;
> 
>          fd = socket(PF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
>          //or: fd = socket(PF_BLUETOOTH, SOCK_DGRAM, BTPROTO_L2CAP);
>          //or: fd = socket(PF_BLUETOOTH, SOCK_SEQPACKET, BTPROTO_SCO);
> 
>          ling.l_onoff = 1;
>          ling.l_linger = 1000000000;
>          setsockopt(fd, SOL_SOCKET, SO_LINGER, &ling, sizeof(ling));
> 
>          return 0;
>  }
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Johan Hedberg <johan.hedberg@gmail.com>
> ---
> net/bluetooth/l2cap_sock.c  |    3 ++-
> net/bluetooth/rfcomm/sock.c |    3 ++-
> net/bluetooth/sco.c         |    6 ++++--
> 3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index e1378693cc90..d0fd8b04f2e6 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -1111,7 +1111,8 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
> 		l2cap_chan_close(chan, 0);
> 		lock_sock(sk);
> 
> -		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime)
> +		if (sock_flag(sk, SOCK_LINGER) && sk->sk_lingertime &&
> +		    !(current->flags & PF_EXITING))
> 			err = bt_sock_wait_state(sk, BT_CLOSED,
> 						 sk->sk_lingertime);
> 	}

The only other example of using PF_EXITING I found is net/ipv4/af_inet.c and if this is the preferred way of handling this, the patch looks fine to me.

Regards

Marcel

