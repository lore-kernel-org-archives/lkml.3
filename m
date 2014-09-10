Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaIJOlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:41:17 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:53048 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaIJOlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:41:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-aW05r2B-3JM8P4JrXYb5rMSt=HFkdhXAi=bkSfPn4xjcuHg@mail.gmail.com>
References: <CAG-aW05r2B-3JM8P4JrXYb5rMSt=HFkdhXAi=bkSfPn4xjcuHg@mail.gmail.com>
Date: Wed, 10 Sep 2014 16:41:13 +0200
Message-ID: <CAG-aW05QCTd+0Gq7RfYto5RXY50icvTgrqJXrhm+f_tc7e4qsw@mail.gmail.com>
Subject: Re: slab kmalloc guard patch uncovers potential issue with crypto,
 triggered by cryptomgr_test
From: Matt <jackdachef@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 4:35 PM, Matt <jackdachef@gmail.com> wrote:
> Hi Herbert,
> Hi David,
>
> (added maintainers according to https://www.kernel.org/doc/linux/MAINTAINERS)
>
> Hi crypto ML,
>
>
> running a kernel with Mikulas Patocka's kmalloc guard patch for slab
> the following message appears during boot:
>
> [    1.439704] AVX2 version of gcm_enc/dec engaged.
> [    1.444420] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
> [    1.449029] kmalloc: red zone damaged, pointer ffff8807fa48bcc0,
> real_size 192, size 160, red zone ffff8807fa4fccc0
> [    1.449033] CPU: 1 PID: 127 Comm: cryptomgr_test Not tainted 3.16.2-test+ #1
> [    1.449034] Hardware name: ASUS All Series/P9D WS, BIOS 1804 04/17/2014
> [    1.449036]  0000000000000000 ffffffff829ef90e ffff8807fa48bcc0
> ffffffff8218c799
> [    1.449039]  ffff8807fa48bcc0 ffffffff82186d9f ffff8807fa48bcc0
> ffffffff824a22aa
> [    1.449042]  ffffffffffffffff 0000000000000069 000000000000008a
> ffffffff824a18c3
> [    1.449044] Call Trace:
> [    1.449048]  [<ffffffff829ef90e>] ? dump_stack+0x4a/0x75
> [    1.449052]  [<ffffffff8218c799>] ? ksize+0x9/0x30
> [    1.449054]  [<ffffffff82186d9f>] ? kzfree+0xf/0x30
> [    1.449057]  [<ffffffff824a22aa>] ? alg_test_hash+0x4a/0x90
> [    1.449059]  [<ffffffff824a18c3>] ? alg_test+0x113/0x2b0
> [    1.449062]  [<ffffffff8249e4d0>] ? crypto_unregister_pcomp+0x10/0x10
> [    1.449064]  [<ffffffff8249e508>] ? cryptomgr_test+0x38/0x40
> [    1.449066]  [<ffffffff820e864a>] ? kthread+0xca/0xe0
> [    1.449068]  [<ffffffff820e8580>] ? kthread_create_on_node+0x180/0x180
> [    1.449071]  [<ffffffff829f752c>] ? ret_from_fork+0x7c/0xb0
> [    1.449072]  [<ffffffff820e8580>] ? kthread_create_on_node+0x180/0x180
> [    1.449074] kmalloc: red zone damaged, pointer ffff8807fa48bcc0,
> real_size 192, size 160, red zone ffff8807fa4fccc0
> [    1.449077] CPU: 1 PID: 127 Comm: cryptomgr_test Not tainted 3.16.2-test+ #1
> [    1.449078] Hardware name: ASUS All Series/P9D WS, BIOS 1804 04/17/2014
> [    1.449079]  0000000000000000 ffffffff829ef90e ffff8807fa48bcc0
> ffffffff821b5d7f
> [    1.449082]  ffff8807fa48bcc0 0000000000000000 ffffffff82ac18b8
> ffff8807fa48bc00
> [    1.449084]  0000000000000000 ffff8807fa48bc40 ffffffff824a22aa
> ffffffffffffffff
> [    1.449087] Call Trace:
> [    1.449088]  [<ffffffff829ef90e>] ? dump_stack+0x4a/0x75
> [    1.449091]  [<ffffffff821b5d7f>] ? kfree+0x1f/0x1d0
> [    1.449093]  [<ffffffff824a22aa>] ? alg_test_hash+0x4a/0x90
> [    1.449095]  [<ffffffff824a18c3>] ? alg_test+0x113/0x2b0
> [    1.449097]  [<ffffffff8249e4d0>] ? crypto_unregister_pcomp+0x10/0x10
> [    1.449099]  [<ffffffff8249e508>] ? cryptomgr_test+0x38/0x40
> [    1.449101]  [<ffffffff820e864a>] ? kthread+0xca/0xe0
> [    1.449102]  [<ffffffff820e8580>] ? kthread_create_on_node+0x180/0x180
> [    1.449104]  [<ffffffff829f752c>] ? ret_from_fork+0x7c/0xb0
> [    1.449106]  [<ffffffff820e8580>] ? kthread_create_on_node+0x180/0x180
> [    1.449138] sha1_ssse3: Using AVX2 optimized SHA-1 implementation
> [    1.449182] alg: No test for crc32 (crc32-pclmul)
> [    1.449188] sha256_ssse3: Using AVX2 optimized SHA-256 implementation
> [    1.449262] sha512_ssse3: Using AVX2 optimized SHA-512 implementation
>
> link to the patch: http://marc.info/?l=linux-kernel&m=140995770121230&w=2
>
>
> The kernel this appears on only has 2 reiserfs fixes, BFQ, BFS and
> this patch added on top:
> https://github.com/kernelOfTruth/linux/commits/linux-3.16.2-test
>
>
> Kernel config is attached
>
>
> Kind Regards
>
> Matt


Adding the main Linux Kernel Mailing List for good measure
