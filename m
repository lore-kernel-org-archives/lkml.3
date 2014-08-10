Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379AbaHJGNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 02:13:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46289 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751173AbaHJGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 02:13:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,299,1406563200"; 
   d="scan'208";a="34422796"
Message-ID: <53E70DB4.4000606@cn.fujitsu.com>
Date: Sun, 10 Aug 2014 14:14:12 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <phacht@linux.vnet.ibm.com>,
        <yinghai@kernel.org>, <fabf@skynet.be>, <Emilian.Medve@freescale.com>,
        Xishi Qiu <qiuxishi@huawei.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().
References: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, add Xishi Qiu <qiuxishi@huawei.com>

On 08/10/2014 02:12 PM, Tang Chen wrote:
> In memblock_find_in_range_node(), we defeind ret as int. But it shoule
> be phys_addr_t because it is used to store the return value from
> __memblock_find_range_bottom_up().
>
> The bug has not been triggered because when allocating low memory near
> the kernel end, the "int ret" won't turn out to be minus. When we started
> to allocate memory on other nodes, and the "int ret" could be minus.
> Then the kernel will panic.
>
> A simple way to reproduce this: comment out the following code in numa_init(),
>
>          memblock_set_bottom_up(false);
>
> and the kernel won't boot.
>
> Reported-by: Xishi Qiu <qiuxishi@huawei.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>   mm/memblock.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 6d2f219..70fad0c 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -192,8 +192,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
>   					phys_addr_t align, phys_addr_t start,
>   					phys_addr_t end, int nid)
>   {
> -	int ret;
> -	phys_addr_t kernel_end;
> +	phys_addr_t kernel_end, ret;
>   
>   	/* pump up @end */
>   	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)

