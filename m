Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbaD3Rcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:32:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42206 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759256AbaD3Rca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:32:30 -0400
Date: Wed, 30 Apr 2014 13:32:28 -0400 (EDT)
Message-Id: <20140430.133228.1835236768036652448.davem@davemloft.net>
To: zhangjie14@huawei.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linville@tuxdriver.com, jeffrey.t.kirsher@intel.com,
        rusty@rustcorp.com.au, mst@redhat.com, jasowang@redhat.com,
        qinchuanyu@huawei.com, liuyongan@huawei.com, zhaoshenglong@huawei.com
Subject: Re: [PATCH net-next] virtio-net: Set needed_headroom for
 virtio-net when VIRTIO_F_ANY_LAYOUT is true
From: David Miller <davem@davemloft.net>
In-Reply-To: <535F824A.5060804@huawei.com>
References: <535F824A.5060804@huawei.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Apr 2014 10:32:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zhangjie (HZ)" <zhangjie14@huawei.com>
Date: Tue, 29 Apr 2014 18:43:22 +0800

> This is a small supplement for commit e7428e95a06fb516fac1308bd0e176e27c0b9287
> ("virtio-net: put virtio-net header inline with data"). TCP packages have
> enough room to put virtio-net header in, but UDP packages do not. By
> setting dev->needed_headroom for virtio-net device, UDP packages could have
> enough room.
> 
> For UDP packages, sk_buff is alloced in fun __ip_append_data. The size is
> "alloclen + hh_len + 15", and "hh_len = LL_RESERVED_SPACE(rt-dst.dev);".
> The Macro is defined as follows:
> #define LL_RESERVED_SPACE(dev) \
>      ((((dev)->hard_header_len+(dev)->needed_headroom)\
>      &~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
> By default, for UDP packages, after skb is allocated, only 16 bytes
> reserved. And 2 bytes remained after mac header is set. That is not enough
> to put virtio-net header in. If we set dev->needed_headroom to 12 or 10
> (according to mergeable_rx_bufs is on or off ), more room can be reserved.
> Then there is enough room for UDP packages to put the header in.
> 
> test result list as below:
> guest and host: suse11sp3, netperf, intel 2.4GHz
> +-------+---------+---------+---------+---------+
> |       |   old             |   new             |
> +-------+---------+---------+---------+---------+
> | UDP   |  Gbit/s | pps     |  Gbit/s | pps     |
> | 64    |  0.57   | 692232  |  0.61   | 742420  |
> | 256   |  1.60   | 686860  |  1.71   | 733331  |
> | 512   |  2.92   | 674576  |  3.07   | 710446  |
> | 1024  |  4.99   | 598977  |  5.17   | 620821  |
> | 1460  |  5.68   | 483757  |  7.16   | 610519  |
> | 4096  |  6.98   | 637468  |  7.21   | 658471  |
> +-------+---------+---------+---------+---------+
> 
> Signed-off-by: Zhang Jie <zhangjie14@huawei.com>

Applied.
