Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3EUHCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:02:48 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:61264 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3EUHCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <1368705021-24396-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1368705021-24396-1-git-send-email-tangchen@cn.fujitsu.com>
Date: Tue, 21 May 2013 10:02:45 +0300
X-Google-Sender-Auth: l4llh43_LqWLcSSaOX5SeTFLwNQ
Message-ID: <CAOJsxLEhSM1foG=fUcGyz1rvfPPirh4jW+dZuhO6ap5oKFk5ug@mail.gmail.com>
Subject: Re: [PATCH 1/1] numa, mm, memory-hotplug: Do not allocate pagetable
 to local node with MEMORY_HOTREMOVE enabled.
From: Pekka Enberg <penberg@kernel.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 2:50 PM, Tang Chen <tangchen@cn.fujitsu.com> wrote:
> The following patch-set allocated pagetables to local node.
> https://lkml.org/lkml/2013/4/11/829
>
> Doing this will break memory hot-remove.
>
> Before removing memory, the kernel offlines memory. If offlining
> memory fails, the memory cannot be removed. The pagetables are
> used by the kernel, so they cannot be offlined. Furthermore, they
> cannot be removed.
>
> Of course, we can free pagetable pages because the pagetables of
> the to be removed memory are useless. But offlining memory doesn't
> mean removing memory. If users only want to offline memory, the
> pagetables should not be freed.
>
> The minimum unit of memory online/offline is block. And by default,
> one block contains one section, which by default is 128MB. There is
> possiblity that half of the block is pagetable, and the other half
> is movable memory.
>
> When we offline this kind of block, the status of the block is
> uncertain. We cannot simply free the pagetables in this block because
> they may be used by other online blocks. But when doing memory
> hot-remove, the failure of offlining blocks will break the memory
> hot-remove logic.
>
>
> In order to fix it, we have three solutions:
>
> 1. Reserve the whole block (128MB), making no user can use the rest
>    parts of the block. And skip them when offlining memory.
>    When all the other blocks are offlined, free the pagetable, and remove
>    all the memory.
>
>    But we may lose some memory for this purpose. 128MB is a little big
>    to waste.
>
>
> 2. Keep this block online. Although the offline operation fails, it is
>    OK to remove memory.
>
>    But the offline operation will always fail. And generally speaking,
>    there are a lot of reasons of offline failing, it is difficult to
>    detect if it is OK to remove memory. So we don't suggest this way.
>
>
> 3. Migrate user pages and make this block offline. Offlining memory won't
>    stop the kernel using the pagetables stored in them, so it will be OK.
>
>    But this will change the semantics of "offline". I'm not sure if we
>    can do it in this way.
>
>
> So before we fix this problem, I think we should not allocate pagetables
> to local node when CONFIG_MEMORY_HOTREMOVE is enabled. And recover it when
> we confirm the direction and fix the problem.
>
> This patch is based on
> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-mm
>
> Any other solution for this problem is welcome.
>
>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>

Ugh. Special-casing for CONFIG_MEMORY_HOTPLUG is just begging for
trouble. Were you able to determine which commit broke memory
hot-remove?
