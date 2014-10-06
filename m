Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaJFWMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:12:32 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:39627 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJFWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:12:30 -0400
MIME-Version: 1.0
In-Reply-To: <1412632298.2916.42.camel@joe-AO725>
References: <1412632298.2916.42.camel@joe-AO725>
Date: Mon, 6 Oct 2014 15:12:28 -0700
Message-ID: <CAHA+R7NjP42U+oggUMVXLOde22=d46BGA2Hrjms16+288pGbuw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: core: Quiet W=1 warnings for unused vars
 and static functions
From: Cong Wang <cwang@twopensource.com>
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 6, 2014 at 2:51 PM, Joe Perches <joe@perches.com> wrote:
> John, can you please verify that these gen_stats accesses
> are unnecessary?  I believe the compiler can elide them in
> any case, but I'm not sure what you intended here.
>
>  net/core/dev.c       | 4 ++--
>  net/core/gen_stats.c | 4 ----
>  net/core/rtnetlink.c | 3 +--
>  3 files changed, 3 insertions(+), 8 deletions(-)

You need to split this patch.


> diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
> index 14681b9..01be9cf 100644
> --- a/net/core/gen_stats.c
> +++ b/net/core/gen_stats.c
> @@ -106,13 +106,9 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
>         for_each_possible_cpu(i) {
>                 struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
>                 unsigned int start;
> -               __u64 bytes;
> -               __u32 packets;
>
>                 do {
>                         start = u64_stats_fetch_begin_irq(&bcpu->syncp);
> -                       bytes = bcpu->bstats.bytes;
> -                       packets = bcpu->bstats.packets;
>                 } while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));


Looks like we really need them:

diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 14681b9..7948ecf 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -115,8 +115,8 @@ __gnet_stats_copy_basic_cpu(struct
gnet_stats_basic_packed *bstats,
                        packets = bcpu->bstats.packets;
                } while (u64_stats_fetch_retry_irq(&bcpu->syncp, start));

-               bstats->bytes += bcpu->bstats.bytes;
-               bstats->packets += bcpu->bstats.packets;
+               bstats->bytes += bytes;
+               bstats->packets += packets;
        }
 }
