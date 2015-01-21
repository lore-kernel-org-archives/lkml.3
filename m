Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbbAUEUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 23:20:45 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:44007 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbbAUETk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 23:19:40 -0500
Message-ID: <54BF28D8.70107@amacapital.net>
Date: Tue, 20 Jan 2015 20:19:36 -0800
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org
CC: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        keescook@chromium.org, vgoyal@redhat.com, whissi@whissi.de
Subject: Re: [PATCH 0/6] randomize kernel physical address and virtual address
 separately
References: <1421811437-2787-1-git-send-email-bhe@redhat.com>
In-Reply-To: <1421811437-2787-1-git-send-email-bhe@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 07:37 PM, Baoquan He wrote:
> Currently kaslr only randomize physical address of kernel loading, then add the delta
> to virtual address of kernel text mapping. Because kernel virtual address can only be
> from __START_KERNEL_map to LOAD_PHYSICAL_ADDR+CONFIG_RANDOMIZE_BASE_MAX_OFFSET, namely
> [0xffffffff80000000, 0xffffffffc0000000], so physical address can only be randomized
> in region [LOAD_PHYSICAL_ADDR, CONFIG_RANDOMIZE_BASE_MAX_OFFSET], namely [16M, 1G].
> 
> So hpa and Vivek suggested the randomization should be done separately for both physical
> and virtual address. In this patchset I tried it. And after randomization, relocation
> handling only depends on virtual address changing, means I only check whether virtual
> address is randomized to other position, if yes relocation need be handled, if no just
> skip the relocation handling though physical address is randomized to different place.
> Now physical address can be randomized from 16M to 4G, virtual address offset can be
> from 16M to 1G.
> 
> Leftover problem:
>     hpa want to see the physical randomization can cover the whole physical memory. I
> checked code and found it's hard to do. Because in arch/x86/boot/compressed/head_64.S
> an identity mapping of 4G is built and then kaslr and decompressing are done. The #PF
> handler solution which he suggested is only available after jump into decompressed
> kernel, namely in arch/x86/kernel/head_64.S. I didn't think of a way to do the whole
> memory covering for physical address randomization, any suggestion or idea?
> 

I have no idea what the #PF thing you're referring to is, but I have
code to implement a #PF handler in boot/compressed if it would be
helpful.  It's two patches:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=sync_rand_seed&id=89476ea6a2becbaee4f45c3b6689ff31b6aa959a

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=sync_rand_seed&id=142d86921e6f271261584016fc8cfa5cdbf455ba

You can't recover from a page fault in my version of this code, but that
would be straightforward to add.

--Andy
