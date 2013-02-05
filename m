Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab3BEPqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:46:06 -0500
Received: from smtp.opengridcomputing.com ([72.48.136.20]:58238 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab3BEPqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:46:02 -0500
Message-ID: <51112943.3040003@opengridcomputing.com>
Date: Tue, 05 Feb 2013 09:46:11 -0600
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipul Pandya <vipul@chelsio.com>
Subject: Re: infiniband: cxgb4: GCC warnings for 32 bit
References: <1360059358.1343.37.camel@x61.thuisdomein>
In-Reply-To: <1360059358.1343.37.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/5/2013 4:15 AM, Paul Bolle wrote:
> 0) Compiling cm.o for 32 bit triggers these GCC warnings:
>      drivers/infiniband/hw/cxgb4/cm.c: In function ‘passive_ofld_conn_reply’:
>      drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>      drivers/infiniband/hw/cxgb4/cm.c: In function ‘send_fw_pass_open_req’:
>      drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>      [last line repeated a number of times]
>
> 1) These two lines were added in commit
> 1cab775c3e75f1250c965feafd061d696df36e53 ("RDMA/cxgb4: Fix LE hash
> collision bug for passive open connection"). That commit was first
> released in v3.8-rc1. It's not obvious to me how to fix these warnings,
> since these lines are a bit puzzling.
>
> 2) These lines read:
>     rpl_skb = (struct sk_buff *)cpu_to_be64(req->cookie);
>
> and:
>     req->cookie = cpu_to_be64((u64)skb);
>
> 3) It is odd that both use cpu_to_be64(). It seems the first one should
> have been be64_to_cpu().

True, the first one should be be64_to_cpu().

> But 'cookie' is of type __u64 (see struct
> cpl_fw6_msg_ofld_connection_wr_rpl in
> drivers/net/ethernet/chelsio/cxgb4/t4_msg.h). So the use of both that
> type and the cpu_to_be64() macro looks a bit odd too.
>
> And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
> used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? Is
> there a requirement for it to be 64 bits wide on both 32 bit and 64 bit?

In general, these fields are __ types to highlight the fact that they 
define an interface between the host driver and adapter firmware.  These 
"cookie" fields are opaque to the firmware.  They are passed to firmware 
in a work request and then reflected back to the host in the reply to 
the work request.  Given this, I think there are two issues:

1) no swapping is really needed.  The values are opaque to firmware, and 
thus can stay in host byte order.

2) to remove the warning, we need something like:

req->cookie = (unsigned long)skb;

and
  
rpl_skb = (struct sk_buff *)(unsigned long)req->cookie;


Steve.

>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

