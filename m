Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab3JWCsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 22:48:05 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42683 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab3JWCsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 22:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <52672DAC.1030307@asianux.com>
References: <523FD9E7.3050303@asianux.com>
	<523FDBD7.4040602@asianux.com>
	<C2D7FE5348E1B147BCA15975FBA2307514DED9@IN01WEMBXA.internal.synopsys.com>
	<523FE578.5060801@asianux.com>
	<52672DAC.1030307@asianux.com>
Date: Wed, 23 Oct 2013 03:48:01 +0100
Message-ID: <CAMqJFCou4SObPni5Lb_tX=0hQ__kF_9MLDC-6a1opptc9dxT-A@mail.gmail.com>
Subject: Re: [Suggestion] arc: compiler: bug: about an arc compiler's bug
 which is not in gcc main source code.
From: Joern Rennecke <joern.rennecke@embecosm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "jeremy.bennett@embecosm.com" <jeremy.bennett@embecosm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Zissulescu <Claudiu.Zissulescu@synopsys.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2013 03:00, Chen Gang <gang.chen@asianux.com> wrote:

> Binutils (1 issue, ld and as information):
>
>   when calling panic(), printk(), or memset() with R_ARC_S21W_PCREL, it may be overflow (I guess it need be R_ARC_S25W_PCREL).
>
>   /usr/local/bin/arc-elf32-ld --build-id -X -o .tmp_vmlinux1 -T /android/public-kernel/linux-next/arch/arc/kernel/vmlinux.lds arch/arc/kernel/head.o init/built-in.o --start-group usr/built-in.o arch/arc/built-in.o arch/arc/boot/dts/built-in.o arch/arc/plat-arcfpga/built-in.o arch/arc/plat-tb10x/built-in.o kernel/built-in.o mm/built-in.o fs/built-in.o ipc/built-in.o security/built-in.o crypto/built-in.o block/built-in.o lib/lib.a arch/arc/lib/lib.a /usr/local/lib/gcc/arc-elf32/4.8.0/libgcc.a lib/built-in.o arch/arc/lib/built-in.o /usr/local/lib/gcc/arc-elf32/4.8.0/libgcc.a drivers/built-in.o sound/built-in.o firmware/built-in.o net/built-in.o --end-group
>   /usr/local/bin/arc-elf32-ld: Error: Overflow detected in relocation value;
>   /usr/local/bin/arc-elf32-ld: Relocation value should be between 1048575 and -1048576 whereas it  2404264
>   /usr/local/bin/arc-elf32-ld: Global symbol: "panic".
>   /usr/local/bin/arc-elf32-ld:
>   Relocation type is:R_ARC_S21W_PCREL
>   FileName:arch/arc/built-in.o
>   Section Name:.text
>   Offset in Section:1716
>   /usr/local/bin/arc-elf32-ld: final link failed: Bad value
>   make: *** [vmlinux] Error 1

That just means that the image is too large to allow conditional
pc-relative calls (tail/sibcalls) or otherwise.

You can avoid generating them for functions with out a relevant
attribute with -mmedium-calls .



> GCC (2 issues, and gcc information):
>
>     CC      drivers/rtc/systohc.o
>   drivers/rtc/systohc.c: In function 'rtc_set_ntp_time':
>   drivers/rtc/systohc.c:44:1: internal compiler error: in arc_ifcvt, at config/arc/arc.c:8315
>    }
>    ^
>   0x939c94 arc_ifcvt
>         ../../gcc/gcc/config/arc/arc.c:8315
>   0x93a394 arc_reorg
>         ../../gcc/gcc/config/arc/arc.c:5985
>   0x7517d9 rest_of_handle_machine_reorg
>         ../../gcc/gcc/reorg.c:3927
>   Please submit a full bug report,
>   with preprocessed source if appropriate.
>   Please include the complete backtrace with any bug report.
>   See <http://gcc.gnu.org/bugs.html> for instructions.
>   make[2]: *** [drivers/rtc/systohc.o] Error 1
>   make[1]: *** [drivers/rtc] Error 2
>   make: *** [drivers] Error 2
>
>
>     CC [M]  drivers/target/target_core_pr.o
>   drivers/target/target_core_pr.c: In function 'target_scsi3_emulate_pr_in':
>   drivers/target/target_core_pr.c:4033:1: error: unrecognizable insn:
>    }
>    ^
>   (insn 846 194 196 12 (set (reg:QI 1 r1)
>           (subreg:QI (mem/j/c:DI (plus:SI (reg/v/f:SI 2 r2 [orig:199 pr_reg ] [199])
>                       (const_int 576 [0x240])) [0 pr_reg_50->pr_res_key+0 S8 A32]) 7)) drivers/target/target_core_pr.c:3677 -1
>        (nil))
>   drivers/target/target_core_pr.c:4033:1: internal compiler error: in extract_insn, at recog.c:2151
>   0x758fb5 _fatal_insn(char const*, rtx_def const*, char const*, int, char const*)
>         ../../gcc/gcc/rtl-error.c:109
>   0x758fe9 _fatal_insn_not_found(rtx_def const*, char const*, int, char const*)
>         ../../gcc/gcc/rtl-error.c:117
>   0x726e83 extract_insn(rtx_def*)
>         ../../gcc/gcc/recog.c:2151
>   0x726ef4 extract_insn_cached(rtx_def*)
>         ../../gcc/gcc/recog.c:2054
>   0x5fe026 cleanup_subreg_operands(rtx_def*)
>         ../../gcc/gcc/final.c:3305
>   0x750c2e reload(rtx_def*, int)
>         ../../gcc/gcc/reload1.c:1240
>   0x68e703 do_reload
>         ../../gcc/gcc/ira.c:4631
>   0x68e703 rest_of_handle_reload
>         ../../gcc/gcc/ira.c:4731
>   Please submit a full bug report,
>   with preprocessed source if appropriate.
>   Please include the complete backtrace with any bug report.
>   See <http://gcc.gnu.org/bugs.html> for instructions.
>   make[2]: *** [drivers/target/target_core_pr.o] Error 1
>   make[1]: *** [drivers/target] Error 2
>   make: *** [drivers] Error 2

Can these issues be reproduced with the lastest gcc version?  If so,
can you provide preprocessed source of the testcases and the compiler
flags to trigger the ICEs?
