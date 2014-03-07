Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbaCGVjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:39:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43659 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaCGVjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:39:51 -0500
Date: Fri, 07 Mar 2014 16:39:48 -0500 (EST)
Message-Id: <20140307.163948.633184079575086092.davem@davemloft.net>
To: jasowang@redhat.com
Cc: mst@redhat.com, kvm@vger.kernel.org, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qinchuanyu@huawei.com
Subject: Re: [PATCH net V2] vhost: net: switch to use data copy if pending
 DMAs exceed the limit
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394170107-12018-1-git-send-email-jasowang@redhat.com>
References: <1394170107-12018-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Mar 2014 13:39:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri,  7 Mar 2014 13:28:27 +0800

> This is because the delay added by htb may lead the delay the finish
> of DMAs and cause the pending DMAs for tap0 exceeds the limit
> (VHOST_MAX_PEND). In this case vhost stop handling tx request until
> htb send some packets. The problem here is all of the packets
> transmission were blocked even if it does not go to VM2.

Isn't this essentially head of line blocking?

> We can solve this issue by relaxing it a little bit: switching to use
> data copy instead of stopping tx when the number of pending DMAs
> exceed half of the vq size. This is safe because:
> 
> - The number of pending DMAs were still limited (half of the vq size)
> - The out of order completion during mode switch can make sure that
>   most of the tx buffers were freed in time in guest.
> 
> So even if about 50% packets were delayed in zero-copy case, vhost
> could continue to do the transmission through data copy in this case.
> 
> Test result:
> 
> Before this patch:
> VM1 to VM2 throughput is 9.3Mbit/s
> VM1 to External throughput is 40Mbit/s
> CPU utilization is 7%
> 
> After this patch:
> VM1 to VM2 throughput is 9.3Mbit/s
> Vm1 to External throughput is 93Mbit/s
> CPU utilization is 16%
> 
> Completed performance test on 40gbe shows no obvious changes in both
> throughput and cpu utilization with this patch.
> 
> The patch only solve this issue when unlimited sndbuf. We still need a
> solution for limited sndbuf.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Qin Chuanyu <qinchuanyu@huawei.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I'd like some vhost experts reviewing this before I apply it.
