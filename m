Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbaENL1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:27:50 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50275 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbaENL1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:27:49 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-b8-53735331d24c
Message-id: <53735330.9090408@samsung.com>
Date: Wed, 14 May 2014 13:27:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jiada Wang <jiada_wang@mentor.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] clk: Fix slab corruption in clk_unregister()
References: <1397863783-10728-1-git-send-email-sboyd@codeaurora.org>
 <1397863783-10728-3-git-send-email-sboyd@codeaurora.org>
In-reply-to: <1397863783-10728-3-git-send-email-sboyd@codeaurora.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xy7qGwcXBBjdPWFj0/Km0ONv0ht1i
	0+NrrBaXd81hs3g64SKbxY8z3SwObB6X+3qZPO5c28PmsXlJvcfur02MHn1bVjF6fN4kF8AW
	xWWTkpqTWZZapG+XwJXxZU07S8Ec1YprX1ezNjCel+ti5OSQEDCR2PzxNROELSZx4d56ti5G
	Lg4hgaWMEttnn2eFcD4xSiy+eYQRpIpXQEvi/qYDbCA2i4CqxKyfN1hBbDYBQ4neo31ANRwc
	ogIREo8vCEGUC0r8mHyPBcQWEVCX+L7jJNgCZoGDjBL3/q4DmyMs4CrxbMousDlCAvUS079e
	BWvgBIpf2bSGHcRmFtCR2N86jQ3ClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKppckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGCEh/mUH4+JjVocYBTgYlXh4f6wqChZiTSwrrsw9xCjBwawkwsto
	URwsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbGj8Lq3wTvhq/Ov9Uzc+L7rB4fR1YPGPZfrnM9/
	Ky/mfWF30ZOjm2nKlEU+Vj9eeDSeC/7cEBNyNeb3021CzxPKJGu8PsQbP7OpUlhhl/JxGdui
	4wuvX1/E1rsi02hOcVTb5c5H+tnXYx8kHogKjZbrWJ17PbCEdTl7AGPWbt0lCl6BVU2n7ymx
	FGckGmoxFxUnAgBn5TBwTwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/14 01:29, Stephen Boyd wrote:
> When a clock is unregsitered, we iterate over the list of
> children and reparent them to NULL (i.e. orphan list). While
> iterating the list, we should use the safe iterators because the
> children list for this clock is changing when we reparent the
> children to NULL. Failure to iterate safely can lead to slab
> corruption like this:
> 
> =============================================================================
> BUG kmalloc-128 (Not tainted): Poison overwritten
> -----------------------------------------------------------------------------
> 
> Disabling lock debugging due to kernel taint
> INFO: 0xed0c4900-0xed0c4903. First byte 0x0 instead of 0x6b
> INFO: Allocated in clk_register+0x20/0x1bc age=297 cpu=2 pid=70
>  __slab_alloc.isra.39.constprop.42+0x410/0x454
>  kmem_cache_alloc_trace+0x200/0x24c
>  clk_register+0x20/0x1bc
>  devm_clk_register+0x34/0x68
>  0xbf0000f0
>  platform_drv_probe+0x18/0x48
>  driver_probe_device+0x94/0x360
>  __driver_attach+0x94/0x98
>  bus_for_each_dev+0x54/0x88
>  bus_add_driver+0xe8/0x204
>  driver_register+0x78/0xf4
>  do_one_initcall+0xc4/0x17c
>  load_module+0x19ac/0x2294
>  SyS_init_module+0xa4/0x110
>  ret_fast_syscall+0x0/0x48
> INFO: Freed in clk_unregister+0xd4/0x140 age=23 cpu=2 pid=73
>  __slab_free+0x38/0x41c
>  clk_unregister+0xd4/0x140
>  release_nodes+0x164/0x1d8
>  __device_release_driver+0x60/0xb0
>  driver_detach+0xb4/0xb8
>  bus_remove_driver+0x5c/0xc4
>  SyS_delete_module+0x148/0x1d8
>  ret_fast_syscall+0x0/0x48
> INFO: Slab 0xeec50b90 objects=25 used=0 fp=0xed0c5400 flags=0x4080
> INFO: Object 0xed0c48c0 @offset=2240 fp=0xed0c4a00
> 
> Bytes b4 ed0c48b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> Object ed0c48c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c48d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c48e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c48f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c4900: 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  ....kkkkkkkkkkkk
> Object ed0c4910: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c4920: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> Object ed0c4930: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
> Redzone ed0c4940: bb bb bb bb                                      ....
> Padding ed0c49e8: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> Padding ed0c49f8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
> CPU: 3 PID: 75 Comm: mdev Tainted: G    B         3.14.0-11033-g2054ba5ca781 #35
> [<c0014be0>] (unwind_backtrace) from [<c0012240>] (show_stack+0x10/0x14)
> [<c0012240>] (show_stack) from [<c04b74a0>] (dump_stack+0x70/0xbc)
> [<c04b74a0>] (dump_stack) from [<c00f7a78>] (check_bytes_and_report+0xbc/0x100)
> [<c00f7a78>] (check_bytes_and_report) from [<c00f7c48>] (check_object+0x18c/0x218)
> [<c00f7c48>] (check_object) from [<c00f7efc>] (__free_slab+0x104/0x144)
> [<c00f7efc>] (__free_slab) from [<c04b6668>] (__slab_free+0x3dc/0x41c)
> [<c04b6668>] (__slab_free) from [<c014c008>] (load_elf_binary+0x88/0x12b4)
> [<c014c008>] (load_elf_binary) from [<c0105a44>] (search_binary_handler+0x78/0x18c)
> [<c0105a44>] (search_binary_handler) from [<c0106fc0>] (do_execve+0x490/0x5dc)
> [<c0106fc0>] (do_execve) from [<c0036b8c>] (____call_usermodehelper+0x134/0x168)
> [<c0036b8c>] (____call_usermodehelper) from [<c000f048>] (ret_from_fork+0x14/0x2c)
> FIX kmalloc-128: Restoring 0xed0c4900-0xed0c4903=0x6b
> 
> Fixes: fcb0ee6a3d33 (clk: Implement clk_unregister)
> Cc: Jiada Wang <jiada_wang@mentor.com>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/clk/clk.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index f71093bf83ab..7cf2c093cc54 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2140,9 +2140,10 @@ void clk_unregister(struct clk *clk)
>  
>  	if (!hlist_empty(&clk->children)) {
>  		struct clk *child;
> +		struct hlist_node *t;
>  
>  		/* Reparent all children to the orphan list. */
> -		hlist_for_each_entry(child, &clk->children, child_node)
> +		hlist_for_each_entry_safe(child, t, &clk->children, child_node)
>  			clk_set_parent(child, NULL);
>  	}
>  
> 


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
