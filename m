Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3FENop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:44:45 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:48035 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3FENon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:44:43 -0400
Message-ID: <51AF40CB.5030101@cogentembedded.com>
Date: Wed, 05 Jun 2013 17:44:43 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost_net: clear msg.control for non-zerocopy case during
 tx
References: <1370418046-11851-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1370418046-11851-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-06-2013 11:40, Jason Wang wrote:

> When we decide not use zero-copy, msg.control should be set to NULL otherwise
> macvtap/tap may set zerocopy callbacks which may decrease the kref of ubufs
> wrongly.

> Bug were introduced by commit cedb9bdce099206290a2bdd02ce47a7b253b6a84
> (vhost-net: skip head management if no outstanding).

> This solves the following warnings:

> WARNING: at include/linux/kref.h:47 handle_tx+0x477/0x4b0 [vhost_net]()
> Modules linked in: vhost_net macvtap macvlan tun nfsd exportfs bridge stp llc openvswitch kvm_amd kvm bnx2 megaraid_sas [last unloaded: tun]
> CPU: 5 PID: 8670 Comm: vhost-8668 Not tainted 3.10.0-rc2+ #1566
> Hardware name: Dell Inc. PowerEdge R715/00XHKG, BIOS 1.5.2 04/19/2011
> ffffffffa0198323 ffff88007c9ebd08 ffffffff81796b73 ffff88007c9ebd48
> ffffffff8103d66b 000000007b773e20 ffff8800779f0000 ffff8800779f43f0
> ffff8800779f8418 000000000000015c 0000000000000062 ffff88007c9ebd58
> Call Trace:
> [<ffffffff81796b73>] dump_stack+0x19/0x1e
> [<ffffffff8103d66b>] warn_slowpath_common+0x6b/0xa0
> [<ffffffff8103d6b5>] warn_slowpath_null+0x15/0x20
> [<ffffffffa0197627>] handle_tx+0x477/0x4b0 [vhost_net]
> [<ffffffffa0197690>] handle_tx_kick+0x10/0x20 [vhost_net]
> [<ffffffffa019541e>] vhost_worker+0xfe/0x1a0 [vhost_net]
> [<ffffffffa0195320>] ? vhost_attach_cgroups_work+0x30/0x30 [vhost_net]
> [<ffffffffa0195320>] ? vhost_attach_cgroups_work+0x30/0x30 [vhost_net]
> [<ffffffff81061f46>] kthread+0xc6/0xd0
> [<ffffffff81061e80>] ? kthread_freezable_should_stop+0x70/0x70
> [<ffffffff817a1aec>] ret_from_fork+0x7c/0xb0
> [<ffffffff81061e80>] ? kthread_freezable_should_stop+0x70/0x70

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vhost/net.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)

> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 2b51e23..b07d96b 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -436,7 +436,8 @@ static void handle_tx(struct vhost_net *net)
>   				kref_get(&ubufs->kref);
>   			}
>   			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
> -		}
> +		} else

    You have to use {} on the *else* branch if you have it of the *if* 
branch (and vice versa), according to Documentation/CodingStyle.

> +			msg.msg_control = NULL;

WBR, Sergei

