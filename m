Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3JFH2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 03:28:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab3JFH2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 03:28:11 -0400
Message-ID: <1381044461.5370.23.camel@marge.simpson.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 08000060
From: Mike Galbraith <bitbucket@online.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Sun, 06 Oct 2013 09:27:41 +0200
In-Reply-To: <20131005234728.GA22657@localhost>
References: <20131005234728.GA22657@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:6t7iHNo57t+Ex4TTUSxkcX6LZWaaRbxomcqzqST1bVg
 RrXHbyKMKM6CJnGeDk2hhpBagIDiLlWw7kagEkzga7ZN2jA3F+
 /0Xjv5bg2ME25VpdfM2l+TCexWKhFfGZqgKvl+foJYshvL5yL5
 P8I/qfbrMHwNWZSy387KEu49iu7icustR97Q2iAx9Pi/ljFcL7
 nv+dkJ3Q8IR7krMDY+/Qn/MKuvRYsSwOCa9BX9zzGtjsqtvvpn
 PZKTp8a7AgDb7zxKPsbdYlF61+imYQgMXw3HFA4Ne6bxXOCdyg
 CryxRVedouXYk/G7z3ZHK4GAEmWwIlVICWxGUDat5i5SsCqPMK
 Q8HH57joMzuQSaBbU9CsAi4ym/HhDMNIM1xiEwWa2xFf70IBrF
 3OsN7JO5eB7rA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-10-06 at 07:47 +0800, Fengguang Wu wrote: 
> Hi Peter,
> 
> Here is another bisect on a different kconfig.

No explosions here, it gives my compiler a terminal tummy ache.

marge:/usr/local/src/kernel/linux-3.x-tip # make net/sunrpc/xprtsock.o
make[1]: Nothing to be done for `all'.
make[1]: Nothing to be done for `relocs'.
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
<stdin>:1220:2: warning: #warning syscall kcmp not implemented [-Wcpp]
<stdin>:1223:2: warning: #warning syscall finit_module not implemented [-Wcpp]
  CC [M]  net/sunrpc/xprtsock.o
net/sunrpc/xprtsock.c: In function ‘xs_setup_tcp’:
net/sunrpc/xprtsock.c:2844:1: internal compiler error: in advance_target_bb, at sched-rgn.c:3486
Please submit a full bug report,
with preprocessed source if appropriate.
See <http://bugs.opensuse.org/> for instructions.
make[1]: *** [net/sunrpc/xprtsock.o] Error 1
make: *** [net/sunrpc/xprtsock.o] Error 2

marge:/usr/local/src/kernel/linux-3.x-tip # gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/x86_64-suse-linux/4.6/lto-wrapper
Target: x86_64-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-languages=c,c++,objc,fortran,obj-c++,java,ada --enable-checking=release --with-gxx-include-dir=/usr/include/c++/4.6 --enable-ssp --disable-libssp --disable-plugin --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux' --disable-libgcj --disable-libmudflap --with-slibdir=/lib64 --with-system-zlib --enable-__cxa_atexit --enable-libstdcxx-allocator=new --disable-libstdcxx-pch --enable-version-specific-runtime-libs --program-suffix=-4.6 --enable-linux-futex --without-system-libunwind --with-arch-32=i586 --with-tune=generic --build=x86_64-suse-linux
Thread model: posix
gcc version 4.6.2 (SUSE Linux)

marge:/usr/local/src/kernel/linux-3.x-tip # git bisect good
0c44c2d0f459cd7e275242b72f500137c4fa834d is the first bad commit
commit 0c44c2d0f459cd7e275242b72f500137c4fa834d
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Sep 11 15:19:24 2013 +0200

    x86: Use asm goto to implement better modify_and_test() functions
    
    Linus suggested using asm goto to get rid of the typical SETcc + TEST
    instruction pair -- which also clobbers an extra register -- for our
    typical modify_and_test() functions.
    
    Because asm goto doesn't allow output fields it has to include an
    unconditinal memory clobber when it changes a memory variable to force
    a reload.
    
    Luckily all atomic ops already imply a compiler barrier to go along
    with their memory barrier semantics.
    
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/n/tip-0mtn9siwbeo1d33bap1422se@git.kernel.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

:040000 040000 512c7965864218ef5a40569f80dd617fc75b60f9 22c5286cc1aa1e336c8b0d7efba08f3f3eff0640 M      arch

git bisect start
# good: [1da177e4c3f41524e886b7f1b8a0c1fc7321cac2] Linux-2.6.12-rc2
git bisect good 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2
# bad: [5e08c0bc7c26ef5cd1626cf3d56c428d6aa61679] Merge branch 'x86/urgent'
git bisect bad 5e08c0bc7c26ef5cd1626cf3d56c428d6aa61679
# good: [b9f399594d12e353dcb609c25219bdaa76c2a050] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
git bisect good b9f399594d12e353dcb609c25219bdaa76c2a050
# good: [be3eed2e96340d3c7a4d1ea1d63e7bd6095d1e34] netfilter: nf_ct_h323: fix usage of MODULE_ALIAS_NFCT_HELPER
git bisect good be3eed2e96340d3c7a4d1ea1d63e7bd6095d1e34
# good: [ecd9883724b78cc72ed92c98bcb1a46c764fff21] ipv6: fix race condition regarding dst->expires and dst->from.
git bisect good ecd9883724b78cc72ed92c98bcb1a46c764fff21
# good: [359d786b0402bac88d5bd6ad5a02c2a773f1b9f9] Merge tag 'at91-cleanup' of git://github.com/at91linux/linux-at91 into next/cleanup
git bisect good 359d786b0402bac88d5bd6ad5a02c2a773f1b9f9
# good: [97473630c78e687deb59284b19d09a095d38bc36] Merge remote-tracking branch 'asoc/topic/mxs' into asoc-next
git bisect good 97473630c78e687deb59284b19d09a095d38bc36
# good: [cc998ff8811530be521f6b316f37ab7676a07938] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
git bisect good cc998ff8811530be521f6b316f37ab7676a07938
# good: [b0dd663b60944a3ce86430fa35549fb37968bda0] netpoll: Should handle ETH_P_ARP other than ETH_P_IP in netpoll_neigh_reply
git bisect good b0dd663b60944a3ce86430fa35549fb37968bda0
# good: [c31eeaced22ce8bd61268a3c595d542bb38c0a4f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
git bisect good c31eeaced22ce8bd61268a3c595d542bb38c0a4f
# good: [9c295bdf93935584839e8b1de23e97898a6b76a0] kvm tools: Add kvm__trigger_irq()
git bisect good 9c295bdf93935584839e8b1de23e97898a6b76a0
# good: [efee6ad6b0aa0899ccad0f379b83ce9c3287dad5] kvm tools: use bitwise 'and' in kvm-ipc
git bisect good efee6ad6b0aa0899ccad0f379b83ce9c3287dad5
# good: [305c6f0770c0420f2c618778517647649c813d23] kvm tools: arm: consolidate CPU node generation
git bisect good 305c6f0770c0420f2c618778517647649c813d23
# bad: [d229a4718e80e8ba0fed36a2702af343ddc71b6c] Merge branch 'x86/uv'
git bisect bad d229a4718e80e8ba0fed36a2702af343ddc71b6c
# bad: [67208898949a3647597f64788147a013906552ef] Merge branch 'timers/core'
git bisect bad 67208898949a3647597f64788147a013906552ef
# bad: [75f93fed50c2abadbab6ef546b265f51ca975b27] sched: Revert need_resched() to look at TIF_NEED_RESCHED
git bisect bad 75f93fed50c2abadbab6ef546b265f51ca975b27
# bad: [0c44c2d0f459cd7e275242b72f500137c4fa834d] x86: Use asm goto to implement better modify_and_test() functions
git bisect bad 0c44c2d0f459cd7e275242b72f500137c4fa834d
# good: [40a0c68ca9b49fb3e7292c1bae035ba5bcb27903] Merge branch 'sched/urgent' into sched/core
git bisect good 40a0c68ca9b49fb3e7292c1bae035ba5bcb27903
# good: [9bd721c55c8a886b938a45198aab0ccb52f1f7fa] sched/balancing: Consider max cost of idle balance per sched domain
git bisect good 9bd721c55c8a886b938a45198aab0ccb52f1f7fa
# good: [4314895165623879937f46d767673654662b570c] sched: Micro-optimize by dropping unnecessary task_rq() calls
git bisect good 4314895165623879937f46d767673654662b570c
# first bad commit: [0c44c2d0f459cd7e275242b72f500137c4fa834d] x86: Use asm goto to implement better modify_and_test() functions


