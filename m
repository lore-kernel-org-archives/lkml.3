Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198Ab3DUE3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 00:29:33 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:50620 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab3DUE3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 00:29:32 -0400
Date: Sun, 21 Apr 2013 05:29:28 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Using __int128 on 64-bit architectures
In-Reply-To: <51464C00.5090107@zytor.com>
Message-ID: <alpine.LFD.2.03.1304210450490.17443@linux-mips.org>
References: <51464C00.5090107@zytor.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Mar 2013, H. Peter Anvin wrote:

> How desirable/portable is it to use __int128 on non-x86 64-bit
> architectures to get a 64*64 -> 128 bit multiply?  On x86-64 this works
> extremely well, but I'm worried about that needlessly breaking on other
> architectures.

 Hmm, nobody has replied, so just FYI such widening multiplication is 
available in all 64-bit MIPS hardware and GCC has supported it since 4.4 
or mid 2008 (older versions used a libgcc __multi3 helper, not quite so 
efficient as you can imagine).

$ cat mulditi3.c
typedef int int128_t __attribute__((mode(TI)));

int128_t mulditi3(long x, long y)
{
	int128_t _x = x, _y = y;
	return _x * _y;
}
$ mips64-linux-gcc -O2 -c mulditi3.c
$ mips64-linux-objdump -d mulditi3.o

mulditi3.o:     file format elf64-tradbigmips


Disassembly of section .text:

0000000000000000 <mulditi3>:
   0:	0085001c 	dmult	a0,a1
   4:	00001812 	mflo	v1
   8:	03e00008 	jr	ra
   c:	00001010 	mfhi	v0
$ 

(MFLO and MFHI are register moves from the MD accumulator to GPRs).  
There's an unsigned instruction variant as well.

 HTH,

  Maciej
