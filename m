Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAZJ2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:28:43 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:56539 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaAZJ2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:28:41 -0500
Date: Sun, 26 Jan 2014 01:28:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mm: Avoid extra pxm_to_node()
In-Reply-To: <1390727415-26376-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1401260127370.15844@chino.kir.corp.google.com>
References: <1390727415-26376-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Yinghai Lu wrote:

> Index: linux-2.6/arch/x86/mm/srat.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/srat.c
> +++ linux-2.6/arch/x86/mm/srat.c
> @@ -50,14 +50,19 @@ static __init inline int srat_disabled(v
>  void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
>  {
>  	int i, j;
> +	int from_node, to_node;
>  
>  	for (i = 0; i < slit->locality_count; i++) {
> -		if (pxm_to_node(i) == NUMA_NO_NODE)
> +		from_node = pxm_to_node(i);
> +		if (from_node == NUMA_NO_NODE)
>  			continue;
> +
>  		for (j = 0; j < slit->locality_count; j++) {
> -			if (pxm_to_node(j) == NUMA_NO_NODE)
> +			to_node = pxm_to_node(j);
> +			if (to_node == NUMA_NO_NODE)
>  				continue;
> -			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
> +
> +			numa_set_distance(from_node, to_node,
>  				slit->entry[slit->locality_count * i + j]);
>  		}
>  	}

Might as well make them "const" while you're at it by moving the 
definitions inside the iteration blocks.
