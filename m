Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3GBWHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:07:03 -0400
Received: from fep18.mx.upcmail.net ([62.179.121.38]:33985 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3GBWHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:07:00 -0400
X-SourceIP: 84.112.62.194
Date: Wed, 3 Jul 2013 00:06:51 +0200
From: Thomas Zeitlhofer <thomas.zeitlhofer@nt.tuwien.ac.at>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jasowang@redhat.com
Subject: Re: tuntap regression in v3.9.8 and v3.10
Message-ID: <20130702220651.GA23097@toau.bambla>
References: <20130702195910.GA20271@toau.bambla>
 <CAOMZO5B7Yx7tRy8Q5wi6ngcD0FDJzKXHOEGPXyUo52+f3oUHEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5B7Yx7tRy8Q5wi6ngcD0FDJzKXHOEGPXyUo52+f3oUHEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 06:01:12PM -0300, Fabio Estevam wrote:
> On Tue, Jul 2, 2013 at 4:59 PM, Thomas Zeitlhofer
> <thomas.zeitlhofer@nt.tuwien.ac.at> wrote:
> > Commit "tuntap: set SOCK_ZEROCOPY flag during open" introduces a
> > regression which is observed with live migration of qemu/kvm based
> > virtual machines that are connected to an openvswitch bridge.
> >
> > Reverting this commit (b26c93c46a3dec25ed236d4ba6107eb4ed5d9401 in
> > v3.9.8 and accordingly 19a6afb23e5d323e1245baa4e62755492b2f1200 in
> > v3.10) fixes the following problem:
> 
> Should the sock_set_flag stay in tun_set_iff as it was prior to 54f968d6efd?
> 
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1652,6 +1652,7 @@ static int tun_set_iff(struct net *net, struct
> file *file, struct ifreq *ifr)
>                 tun->txflt.count = 0;
>                 tun->vnet_hdr_sz = sizeof(struct virtio_net_hdr);
> 
> +               sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);
>                 tun->filter_attached = false;
>                 tun->sndbuf = tfile->socket.sk->sk_sndbuf;
> 
> @@ -2159,8 +2160,6 @@ static int tun_chr_open(struct inode *inode,
> struct file * file)
>         set_bit(SOCK_EXTERNALLY_ALLOCATED, &tfile->socket.flags);
>         INIT_LIST_HEAD(&tfile->next);
> 
> -       sock_set_flag(&tfile->sk, SOCK_ZEROCOPY);
> -
>         return 0;
>  }

I guess no, as this also leads to a kernel panic (tested against v3.10).
