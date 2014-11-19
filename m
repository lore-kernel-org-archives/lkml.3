Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaKSXwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:52:36 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:42427 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaKSXwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:52:35 -0500
Date: Wed, 19 Nov 2014 15:52:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrey Ryabinin <a.ryabinin@samsung.com>
cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel: irq: use a kmem_cache for allocating struct
 irq_desc
In-Reply-To: <1415621218-6438-2-git-send-email-a.ryabinin@samsung.com>
Message-ID: <alpine.DEB.2.10.1411191551350.32057@chino.kir.corp.google.com>
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com> <1415621218-6438-2-git-send-email-a.ryabinin@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Andrey Ryabinin wrote:

> After enabling alignment checks in UBSan I've noticed a lot of
> reports like this:
> 
>     UBSan: Undefined behaviour in ../kernel/irq/chip.c:195:14
>     member access within misaligned address ffff88003e80d6f8
>     for type 'struct irq_desc' which requires 16 byte alignment
> 
> struct irq_desc declared with ____cacheline_internodealigned_in_smp
> attribute. However in some cases it allocated dynamically via kmalloc().
> In general case kmalloc() guaranties only sizeof(void *) alignment.
> We should use a separate slab cache to make struct irq_desc
> properly aligned on SMP configuration.
> 
> This also could slightly reduce memory usage on some configurations.
> E.g. in my setup sizeof(struct irq_desc) == 320. Which means that
> kmalloc-512 will be used for allocating irg_desc via kmalloc().
> In that case using separate slab cache will save us 192 bytes per
> each irq_desc.
> 
> Note: UBSan reports says that 'struct irq_desc' requires 16 byte alignment.
> It's wrong, in my setup it should be 64 bytes. This looks like a gcc bug,
> but it doesn't change the fact that irq_desc is misaligned.
> 
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>

I think this is just fine, I would just prefer that you do the memset() 
explicitly rather than introduce the new slab function for such a 
specialized purpose (unless there's other examples in the kernel where 
this would be useful).
