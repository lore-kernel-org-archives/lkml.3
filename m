Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab3H1UVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:21:00 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34227 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3H1UU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:20:58 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/1] of: fdt: fix memory initialization for expanded DT
To: Wladislav Wiebe <wladislav.kw@gmail.com>, rob.herring@calxeda.com,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <5208C04A.5000303@gmail.com>
References: <5208C04A.5000303@gmail.com>
Date: Wed, 28 Aug 2013 21:21:00 +0100
Message-Id: <20130828202100.9134B3E0B6B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Aug 2013 13:00:26 +0200, Wladislav Wiebe <wladislav.kw@gmail.com> wrote:
> Already existing property flags are filled wrong for properties created from
> initial FDT. This could cause problems if this DYNAMIC device-tree functions
> are used later, i.e. properties are attached/detached/replaced. Simply dumping
> flags from the running system show, that some initial static (not allocated via
> kzmalloc()) nodes are marked as dynamic.
> 
> I putted some debug extensions to property_proc_show(..) :
> ..
> +       if (OF_IS_DYNAMIC(pp))
> +               pr_err("DEBUG: xxx : OF_IS_DYNAMIC\n");
> +       if (OF_IS_DETACHED(pp))
> +               pr_err("DEBUG: xxx : OF_IS_DETACHED\n");
> 
> when you operate on the nodes (e.g.: ~$ cat /proc/device-tree/*some_node*) you
> will see that those flags are filled wrong, basically in most cases it will dump
> a DYNAMIC or DETACHED status, which is in not true.
> (BTW. this OF_IS_DETACHED is a own define for debug purposes which which just
> make a test_bit(OF_DETACHED, &x->_flags)
> 
> If nodes are dynamic kernel is allowed to kfree() them. But it will crash
> attempting to do so on the nodes from FDT -- they are not allocated via
> kzmalloc().
> 
> Signed-off-by: Wladislav Wiebe <wladislav.kw@gmail.com>
> ---
>  drivers/of/fdt.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index 6bb7cf2..b10ba00 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -392,6 +392,8 @@ static void __unflatten_device_tree(struct boot_param_header *blob,
>  	mem = (unsigned long)
>  		dt_alloc(size + 4, __alignof__(struct device_node));
> 
> +	memset((void *)mem, 0, size);
> +

It seems to me that this would be a problem for any call to the early
allocation function; early_init_dt_alloc_memory_arch(). There is at
least one other call to the allocator via of_alias_scan(). I think this
patch is okay for now (I'll add the missing hunk), but it should be
revisited.

Most of the platforms use the memblock_alloc implementation; that can
probably be consolidated and removed from arch code. I've just crafted a
patch and I'll be posting it shortly.

g.
