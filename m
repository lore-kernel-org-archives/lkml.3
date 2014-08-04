Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaHDTjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:39:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25427 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbaHDTjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:39:45 -0400
Message-ID: <53DFE175.5040602@oracle.com>
Date: Mon, 04 Aug 2014 15:39:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        davem@davemloft.net
CC: linux-wireless@vger.kernel.org, linux-nfc@ml01.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFC: Read frag at a time when sending packets
References: <1403234596-19149-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1403234596-19149-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?

On 06/19/2014 11:23 PM, Sasha Levin wrote:
> Right now userspace can pass a large chunk of data and the kernel
> will attempt to allocate all of it to copy it in from userspace.
> 
> The problem is that there is no upper limit on the size userspace
> can pass. Right now userspace can even force a machine to run out
> of memory by forcing the kernel to allocate large chunks of memory.
> 
> To avoid imposing a limit, instead of allocating the entire block,
> we can allocate just the size of the biggest frag possible and read
> it from userspace one frag at a time.
> 
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
> 
>  ** WARNING: COMPLETELY UNTESTED ** (I don't have the hardware).
> 
>  net/nfc/llcp_commands.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
> index a3ad69a..da68924 100644
> --- a/net/nfc/llcp_commands.c
> +++ b/net/nfc/llcp_commands.c
> @@ -727,27 +727,27 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
>  	if (local == NULL)
>  		return -ENODEV;
>  
> -	msg_data = kzalloc(len, GFP_KERNEL);
> +	remote_miu = sock->remote_miu > LLCP_MAX_MIU ?
> +			local->remote_miu : sock->remote_miu;
> +
> +	msg_data = kzalloc(remote_miu, GFP_KERNEL);
>  	if (msg_data == NULL)
>  		return -ENOMEM;
>  
> -	if (memcpy_fromiovec(msg_data, msg->msg_iov, len)) {
> -		kfree(msg_data);
> -		return -EFAULT;
> -	}
> -
>  	remaining_len = len;
>  	msg_ptr = msg_data;
>  
>  	do {
> -		remote_miu = sock->remote_miu > LLCP_MAX_MIU ?
> -				local->remote_miu : sock->remote_miu;
> -
>  		frag_len = min_t(size_t, remote_miu, remaining_len);
>  
>  		pr_debug("Fragment %zd bytes remaining %zd",
>  			 frag_len, remaining_len);
>  
> +		if (memcpy_fromiovec(msg_data, msg->msg_iov, frag_len)) {
> +			kfree(msg_data);
> +			return -EFAULT;
> +		}
> +
>  		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
>  					 frag_len + LLCP_HEADER_SIZE, &err);
>  		if (pdu == NULL) {
> 

