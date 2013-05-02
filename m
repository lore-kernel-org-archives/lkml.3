Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200Ab3EBUyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:54:00 -0400
Received: from a9-66.smtp-out.amazonses.com ([54.240.9.66]:39370 "EHLO
	a9-66.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759629Ab3EBUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:53:59 -0400
Date: Thu, 2 May 2013 20:53:57 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: glommer@parallels.com, penberg@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-next-20130422] Bug in SLAB?
In-Reply-To: <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
Message-ID: <0000013e6705da99-094923c6-e239-43d2-8f0c-5e661656a27c-000000@email.amazonses.com>
References: <0000013e56e9304a-1042a95a-d4dd-43c5-8b8a-c670f50ac54e-000000@email.amazonses.com> <201304300645.FCE37285.tVHJLSOMQFOFFO@I-love.SAKURA.ne.jp> <0000013e5b56d067-7982dfa6-08a2-4c48-ad77-6888b5114c5f-000000@email.amazonses.com>
 <201305010101.CGB86424.JFQOtSFOVOLFHM@I-love.SAKURA.ne.jp> <0000013e5bfc7c4d-54fa9464-dccd-4157-b4a5-22594261eaf3-000000@email.amazonses.com> <201305012114.AED78178.tFSHFQOOJLMOFV@I-love.SAKURA.ne.jp>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.05.02-54.240.9.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 May 2013, Tetsuo Handa wrote:

> The culprit location is possibly in SLAB because the kernel boots if built with
> CONFIG_DEBUG_SLAB=n || CONFIG_DEBUG_SPINLOCK=n || CONFIG_DEBUG_PAGEALLOC=n.

I have booted such a configuration just fine. Please have a look at the
kernel config that I send or send me yours.

Here is a patch that restores the old behavior for SLAB



Subject: slab: Return NULL for oversized allocations

The inline path seems to have changed the SLAB behavior for very large
kmalloc allocations. This patch restores the old behavior.

Signed-off-by: Christoph Lameter <cl@linux.com>


Index: linux/include/linux/slab_def.h
===================================================================
--- linux.orig/include/linux/slab_def.h	2013-05-02 15:02:45.864728115 -0500
+++ linux/include/linux/slab_def.h	2013-05-02 15:06:14.940474110 -0500
@@ -126,6 +126,9 @@ static __always_inline void *kmalloc(siz
 		if (!size)
 			return ZERO_SIZE_PTR;

+		if (size >= KMALLOC_MAX_SIZE)
+			return NULL;
+
 		i = kmalloc_index(size);

 #ifdef CONFIG_ZONE_DMA
@@ -172,6 +175,9 @@ static __always_inline void *kmalloc_nod
 		if (!size)
 			return ZERO_SIZE_PTR;

+		if (size > KMALLOC_MAX_SIZE)
+			return NULL;
+
 		i = kmalloc_index(size);

 #ifdef CONFIG_ZONE_DMA
