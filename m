Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbaIPQiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:38:05 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50721 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314AbaIPQiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <1410853730-16470-1-git-send-email-dborkman@redhat.com>
References: <1410853730-16470-1-git-send-email-dborkman@redhat.com>
Date: Tue, 16 Sep 2014 09:34:34 -0700
Message-ID: <CABg9mcvgq+8jKYZYgO2+n68hNsFbz5=22XUpOJWgmsdcuZeMzQ@mail.gmail.com>
Subject: Re: [PATCH arm64-next v4] net: bpf: arm64: address randomize and
 write protect JIT code
From: Z Lim <zlim.lnx@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
Cc: Daniel Borkmann <dborkman@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@plumgrid.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin, Will,

On Tue, Sep 16, 2014 at 12:48 AM, Daniel Borkmann <dborkman@redhat.com> wrote:
[...]
> +static void jit_fill_hole(void *area, unsigned int size)
> +{
> +       u32 *ptr;
> +       /* We are guaranteed to have aligned memory. */
> +       for (ptr = area; size >= sizeof(u32); size -= sizeof(u32))
> +               *ptr++ = cpu_to_le32(AARCH64_BREAK_FAULT);
> +}
[...]

Out of curiosity, I looked at objdump of the above code.

0000000000000088 <jit_fill_hole>:
      88:       71000c3f        cmp     w1, #0x3
      8c:       54000149        b.ls    b4 <jit_fill_hole+0x2c>
      90:       51001022        sub     w2, w1, #0x4
      94:       927e7442        and     x2, x2, #0xfffffffc
      98:       91001042        add     x2, x2, #0x4
      9c:       8b020002        add     x2, x0, x2
      a0:       52840001        mov     w1, #0x2000
 // #8192  <-- loops here
      a4:       72ba8401        movk    w1, #0xd420, lsl #16
      a8:       b8004401        str     w1, [x0],#4  <-- is there an
optimization such that we loop here?
      ac:       eb02001f        cmp     x0, x2
      b0:       54ffff81        b.ne    a0 <jit_fill_hole+0x18>
      b4:       d65f03c0        ret

I'm wondering if there's any optimizations that'll generate code that
loops at 0xa8 instead of 0xa0. w1 only needs to loaded with the
constant once, but here we're reloading it on every iteration of the
loop.

Thanks,
z
