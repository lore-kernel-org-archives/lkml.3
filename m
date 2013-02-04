Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab3BDEwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:52:22 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:50622 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3BDEwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:52:20 -0500
MIME-Version: 1.0
X-Originating-IP: [50.196.179.26]
In-Reply-To: <20130204030221.GY4503@ZenIV.linux.org.uk>
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com>
	<20130127195714.GA11224@samfundet.no>
	<20130127203009.GG4503@ZenIV.linux.org.uk>
	<20130127203954.GA22063@samfundet.no>
	<20130204001055.GV4503@ZenIV.linux.org.uk>
	<20130204003047.GW4503@ZenIV.linux.org.uk>
	<20130204013111.GX4503@ZenIV.linux.org.uk>
	<20130204030221.GY4503@ZenIV.linux.org.uk>
Date: Sun, 3 Feb 2013 20:52:18 -0800
X-Google-Sender-Auth: kHy8NbgEqvjak7fz36y-lCTzmFU
Message-ID: <CACiLriQbrKvo128hhH4Cd3U+qZwgXPGFEAs4b3=SsK59=4Kkkw@mail.gmail.com>
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 3, 2013 at 7:02 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Feb 04, 2013 at 01:31:11AM +0000, Al Viro wrote:
>
>> Unless I'm misreading ocavr32.pdf, that should be (R12, R10:R11, R9, R8) and
>> (R12, R10:R11, R9:R8, stack) resp., so fadvise64 doesn't need a wrapper, but
>> fadvise64_64 does.  And something like (s32, s32, s64, s64) would turn into
>> (R12, R11, R9:R8, stack, stack); AFAICS, we don't have anything that ugly...
>
> Oh, yes, we do - fallocate(2).  int fd, int mode, loff_t offset, loff_t len.
> On something like mips or sparc32 it packs nicely; on avr32 it doesn't.
> Could you confirm that I haven't misparsed the ABI?

You're right on -- in this case, the compiler will skip r10, and do
(r12, r11, r8:r9, stack). We pass the syscall number in r8, but we
also unconditionally move r7 to r8 in the syscall path, so it
shouldn't matter (libc does the opposite when necessary).

I remember some talk about having the compiler reuse r10 for the next
32-bit argument in cases like this, but I don't think it ever
happened.

Havard
