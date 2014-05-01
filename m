Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaEARYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 13:24:38 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59434 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaEARYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 13:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <534F858B.4060208@ladisch.de>
References: <534F01D1.9000206@gmail.com>
	<534F858B.4060208@ladisch.de>
Date: Thu, 1 May 2014 10:24:36 -0700
X-Google-Sender-Auth: WNkv4M1CBgCxS6O8EgMIobgey_4
Message-ID: <CAA9_cmdoWEHRLFnbr-cnogEqGq7rE+2zyjuJyXZLX+4kDgiorA@mail.gmail.com>
Subject: Re: debug_dma_assert_idle - snd_hda_intel - cpu touching an active
 dma mapped cacheline
From: Dan Williams <dan.j.williams@intel.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: poma <pomidorabelisima@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 12:40 AM, Clemens Ladisch <clemens@ladisch.de> wrote:
> poma wrote:
>> Sound whispers,
>
> ???
>
>>  WARNING: CPU: 3 PID: 900 at lib/dma-debug.c:593 debug_dma_assert_idle+0x159/0x1d0()
>>  snd_hda_intel 0000:00:07.0: DMA-API: cpu touching an active dma mapped cacheline [cln=0x03014000]
>>  ...
>>  Mapped at:
>>   [<c074ec12>] debug_dma_alloc_coherent+0x22/0x70
>
> "Coherent" means "touching DMA mappings is allowed".
> Why does dma-debug complain about that?

Right, but coherency does not follow copy-on-write.  The check is
there to catch cases where a page is COW'd while an active dma mapping
on the source page is present.  Sure, the write is coherent, but due
to the COW it's going to the wrong page, so you are potentially
missing data in the new mapping.

See how NET_DMA inspired this check:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/dma/Kconfig?id=77873803363c
