Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3FNPnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:43:55 -0400
Received: from mo-p04-ob.rzone.de ([81.169.146.178]:54459 "EHLO
	mo-p04-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3FNPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:43:53 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2013 11:43:53 EDT
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ4Kkzc/qnW2/7tWQ==
Date: Fri, 14 Jun 2013 17:28:43 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, kys@microsoft.com,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [PATCH net] hyperv: Fix vlan_proto setting in
 netvsc_recv_callback()
Message-ID: <20130614152843.GA11368@aepfle.de>
References: <1369757756-24572-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1369757756-24572-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.21.rev5641 (2013-02-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, Haiyang Zhang wrote:

> Since the recent addition of 8021AD, we need to set the new field vlan_proto in
> sk_buff. Otherwise, it will trigger BUG() call in vlan_proto_idx().

> @@ -284,7 +285,7 @@ int netvsc_recv_callback(struct hv_device *device_obj,
>  
>  	skb->protocol = eth_type_trans(skb, net);
>  	skb->ip_summed = CHECKSUM_NONE;
> -	skb->vlan_tci = packet->vlan_tci;
> +	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), packet->vlan_tci);


Just curious:

Doesnt that change behaviour in the sense that __vlan_hwaccel_put_tag()
now always adds VLAN_TAG_PRESENT to skb->vlan_tci, while before that
change packet->vlan_tci may or may not had this flag?

In other words, should a variant of this patch be backported if it was a
bug not not use __vlan_hwaccel_put_tag right from the start?

Olaf
