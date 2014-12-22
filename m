Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbaLVPbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:31:31 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51026 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbaLVPb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:31:28 -0500
MIME-Version: 1.0
In-Reply-To: <54982C98.9070806@oracle.com>
References: <54982C98.9070806@oracle.com>
Date: Mon, 22 Dec 2014 19:31:27 +0400
Message-ID: <CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>
Subject: Re: fs: proc: gpf in find_entry
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "davej >> Dave Jones" <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-22 17:37 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
> Hi all,
>
> While fuzzing with trinity inside a KVM tools guest running the latest -next
> kernel, I've stumbled on the following spew:
>
> [ 2015.960381] general protection fault: 0000 [#1] PREEMPT SMP KASAN

Actually this is NULL-ptr dereference. Since you are using kasan with
inline instrumentation
NULL-ptr deref transforms into GPF.


> [ 2015.970534] RAX: 0000000000000000 RBX: ffff88000003a960 RCX: 0000000000000073
> [ 2015.970534] RDX: 1ffff10101c8f3c4 RSI: 0000000000000000 RDI: ffff88080e479e20
> [ 2015.970534] RBP: ffff88080e477a28 R08: 0000000000000066 R09: 0000000000000073
> [ 2015.970534] R10: ffffda0017d55630 R11: dfffe90000000000 R12: ffff88005fc644b8
> [ 2015.970534] R13: dfffe90000000000 R14: ffffffff92464884 R15: 0000000000000000

[...]

> All code
> ========
>    0:   e8 03 42 80 3c          callq  0x3c804208
>    5:   28 00                   sub    %al,(%rax)
>    7:   0f 85 ff 01 00 00       jne    0x20c
>    d:   4c 8b 7b 18             mov    0x18(%rbx),%r15
>   11:   4d 85 ff                test   %r15,%r15
>   14:   0f 84 de 01 00 00       je     0x1f8
>   1a:   41 f6 c7 07             test   $0x7,%r15b
>   1e:   0f 85 d4 01 00 00       jne    0x1f8
>   24:   4c 89 f8                mov    %r15,%rax
>   27:   48 c1 e8 03             shr    $0x3,%rax
>   2b:*  42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)               <-- trapping instruction

Three commands above are result of KASAN's instrumentation.
They check shadow for address in %r15:
     if (*((%r15 >> 3) + kasan_shadow_offset)


>   30:   0f 85 b5 01 00 00       jne    0x1eb
>   36:   4d 8b 37                mov    (%r15),%r14

And here is memory access, that KASAN checking.
