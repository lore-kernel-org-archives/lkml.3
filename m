Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbaEQJgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 05:36:22 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:43964 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbaEQJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 05:36:20 -0400
Date: Sat, 17 May 2014 11:36:15 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>, linux-kbuild@vger.kernel.org,
        mmarek@suse.cz
Subject: Re: [PATCH 8/8] Kbuild: add inline-account tool to find inline bloat
Message-ID: <20140517093615.GA16926@ravnborg.org>
References: <1400276595-6965-1-git-send-email-andi@firstfloor.org>
 <1400276595-6965-9-git-send-email-andi@firstfloor.org>
 <20140517083144.GA16691@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140517083144.GA16691@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2014 at 10:31:44AM +0200, Sam Ravnborg wrote:
> Hi Andi.
> 
> On Fri, May 16, 2014 at 02:43:15PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Add a tool to hunt for inline bloat. It uses objdump -S to account
> > inlines.
> I tried this on my sparc32 build - but it failed with:
> objdump: can't disassemble for architecture UNKNOWN!
> 
> It looks simple to add CROSS_COMPILE support but I did not do so.
> My python skills are non-existing.

Patched the calls to nm and objdump - but it gave no output
when I ran the script.

nm --print-size shows following output:
00002910 00000024 r CSWTCH.946
00002bd4 00000024 r CSWTCH.951
         U PDE_DATA
         U ROOT_DEV
000000fc 00000014 T SyS_accept
00002c98 000001a8 T SyS_accept4
00000fc4 0000008c T SyS_bind
00000eb4 00000094 T SyS_connect
00000d98 00000094 T SyS_getpeername
00000e2c 00000088 T SyS_getsockname
00000c6c 00000090 T SyS_getsockopt
00000f48 0000007c T SyS_listen
00000128 00000018 T SyS_recv
0000142c 000000f0 T SyS_recvfrom
00001920 000000d0 T SyS_recvmmsg
00001238 00000010 T SyS_recvmsg
00000110 00000018 T SyS_send
00001d38 00000010 T SyS_sendmmsg
00001db0 00000010 T SyS_sendmsg
000015f4 000000dc T SyS_sendto
00000cfc 0000009c T SyS_setsockopt
00000c0c 00000060 T SyS_shutdown
00003020 000000b4 T SyS_socket
000007ec 000001f8 T SyS_socketcall
00002e40 000001e0 T SyS_socketpair
000b776c 00000098 t T.1063
000b762c 000000d0 t T.1064


objdump -Sl shows following output:
000000d4 <sock_mmap>:
sock_mmap():
      d4:       9d e3 bf a0     save  %sp, -96, %sp
      d8:       c2 06 20 78     ld  [ %i0 + 0x78 ], %g1
      dc:       94 10 00 19     mov  %i1, %o2
      e0:       92 10 00 01     mov  %g1, %o1
      e4:       c2 00 60 18     ld  [ %g1 + 0x18 ], %g1
      e8:       c2 00 60 40     ld  [ %g1 + 0x40 ], %g1
      ec:       9f c0 40 00     call  %g1
      f0:       90 10 00 18     mov  %i0, %o0
      f4:       81 c7 e0 08     ret
      f8:       91 e8 00 08     restore  %g0, %o0, %o0

000000fc <SyS_accept>:
sys_accept():
      fc:       96 10 20 00     clr  %o3
     100:       82 13 c0 00     mov  %o7, %g1
     104:       40 00 00 00     call  104 <SyS_accept+0x8>
     108:       9e 10 40 00     mov  %g1, %o7
     10c:       01 00 00 00     nop

00000110 <SyS_send>:
SyS_send():
     110:       98 10 20 00     clr  %o4        ! 0 <sock_from_file-0x4c>
     114:       9a 10 20 00     clr  %o5
     118:       82 13 c0 00     mov  %o7, %g1
     11c:       40 00 00 00     call  11c <SyS_send+0xc>
     120:       9e 10 40 00     mov  %g1, %o7
     124:       01 00 00 00     nop

00000128 <SyS_recv>:
sys_recv():
     128:       98 10 20 00     clr  %o4        ! 0 <sock_from_file-0x4c>
     12c:       9a 10 20 00     clr  %o5
     130:       82 13 c0 00     mov  %o7, %g1
     134:       40 00 00 00     call  134 <SyS_recv+0xc>
     138:       9e 10 40 00     mov  %g1, %o7
     13c:       01 00 00 00     nop

	Sam
