Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932379AbaGVWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:09:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:26937 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327AbaGVWJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:09:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,712,1400050800"; 
   d="scan'208";a="547426970"
Subject: [PATCH v5 5/7] crypto: SHA1 multibuffer submit and flush routines
 for AVX2
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1406033477.git.tim.c.chen@linux.intel.com>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jul 2014 15:09:41 -0700
Message-ID: <1406066981.2970.807.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the routines used to submit and flush buffers
belonging to SHA1 crypto jobs to the SHA1 multibuffer algorithm.  It is
implemented mostly in assembly optimized with AVX2 instructions.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S  | 327 +++++++++++++++++++++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c   |  64 +++++
 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S | 228 ++++++++++++++++
 3 files changed, 619 insertions(+)
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
 create mode 100644 arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S

diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S b/arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
new file mode 100644
index 0000000..85c4e1c
--- /dev/null
+++ b/arch/x86/crypto/sha-mb/sha1_mb_mgr_flush_avx2.S
@@ -0,0 +1,327 @@
+/*
+ * Flush routine for SHA1 multibuffer
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *      James Guilford <james.guilford@intel.com>
+ *	Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#include <linux/linkage.h>
+#include "sha1_mb_mgr_datastruct.S"
+
+
+.extern sha1_x8_avx2
+
+# LINUX register definitions
+#define arg1    %rdi
+#define arg2    %rsi
+
+# Common definitions
+#define state   arg1
+#define job     arg2
+#define len2    arg2
+
+# idx must be a register not clobbered by sha1_x8_avx2
+#define idx		%r8
+#define DWORD_idx	%r8d
+
+#define unused_lanes    %rbx
+#define lane_data       %rbx
+#define tmp2            %rbx
+#define tmp2_w		%ebx
+
+#define job_rax         %rax
+#define tmp1            %rax
+#define size_offset     %rax
+#define tmp             %rax
+#define start_offset    %rax
+
+#define tmp3            %arg1
+
+#define extra_blocks    %arg2
+#define p               %arg2
+
+
+# STACK_SPACE needs to be an odd multiple of 8
+_XMM_SAVE_SIZE  = 10*16
+_GPR_SAVE_SIZE  = 8*8
+_ALIGN_SIZE     = 8
+
+_XMM_SAVE       = 0
+_GPR_SAVE       = _XMM_SAVE + _XMM_SAVE_SIZE
+STACK_SPACE     = _GPR_SAVE + _GPR_SAVE_SIZE + _ALIGN_SIZE
+
+.macro LABEL prefix n
+\prefix\n\():
+.endm
+
+.macro JNE_SKIP i
+jne     skip_\i
+.endm
+
+.altmacro
+.macro SET_OFFSET _offset
+offset = \_offset
+.endm
+.noaltmacro
+
+# JOB* sha1_mb_mgr_flush_avx2(MB_MGR *state)
+# arg 1 : rcx : state
+ENTRY(sha1_mb_mgr_flush_avx2)
+	mov	%rsp, %r10
+	sub     $STACK_SPACE, %rsp
+	and     $~31, %rsp
+	mov     %rbx, _GPR_SAVE(%rsp)
+	mov     %r10, _GPR_SAVE+8*1(%rsp) #save rsp
+	mov	%rbp, _GPR_SAVE+8*3(%rsp)
+	mov	%r12, _GPR_SAVE+8*4(%rsp)
+	mov	%r13, _GPR_SAVE+8*5(%rsp)
+	mov	%r14, _GPR_SAVE+8*6(%rsp)
+	mov	%r15, _GPR_SAVE+8*7(%rsp)
+
+	# If bit (32+3) is set, then all lanes are empty
+	mov     _unused_lanes(state), unused_lanes
+	bt      $32+3, unused_lanes
+	jc      return_null
+
+	# find a lane with a non-null job
+	xor     idx, idx
+	offset = (_ldata + 1 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  one(%rip), idx
+	offset = (_ldata + 2 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  two(%rip), idx
+	offset = (_ldata + 3 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  three(%rip), idx
+	offset = (_ldata + 4 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  four(%rip), idx
+	offset = (_ldata + 5 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  five(%rip), idx
+	offset = (_ldata + 6 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  six(%rip), idx
+	offset = (_ldata + 7 * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+	cmovne  seven(%rip), idx
+
+	# copy idx to empty lanes
+copy_lane_data:
+	offset =  (_args + _data_ptr)
+	mov     offset(state,idx,8), tmp
+
+	I = 0
+.rep 8
+	offset =  (_ldata + I * _LANE_DATA_size + _job_in_lane)
+	cmpq    $0, offset(state)
+.altmacro
+	JNE_SKIP %I
+	offset =  (_args + _data_ptr + 8*I)
+	mov     tmp, offset(state)
+	offset =  (_lens + 4*I)
+	movl    $0xFFFFFFFF, offset(state)
+LABEL skip_ %I
+	I = (I+1)
+.noaltmacro
+.endr
+
+	# Find min length
+	vmovdqa _lens+0*16(state), %xmm0
+	vmovdqa _lens+1*16(state), %xmm1
+
+	vpminud %xmm1, %xmm0, %xmm2     # xmm2 has {D,C,B,A}
+	vpalignr $8, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,D,C}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has {x,x,E,F}
+	vpalignr $4, %xmm2, %xmm3, %xmm3    # xmm3 has {x,x,x,E}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has min value in low dword
+
+	vmovd   %xmm2, DWORD_idx
+	mov	idx, len2
+	and	$0xF, idx
+	shr	$4, len2
+	jz	len_is_0
+
+	vpand   clear_low_nibble(%rip), %xmm2, %xmm2
+	vpshufd $0, %xmm2, %xmm2
+
+	vpsubd  %xmm2, %xmm0, %xmm0
+	vpsubd  %xmm2, %xmm1, %xmm1
+
+	vmovdqa %xmm0, _lens+0*16(state)
+	vmovdqa %xmm1, _lens+1*16(state)
+
+	# "state" and "args" are the same address, arg1
+	# len is arg2
+	call	sha1_x8_avx2
+	# state and idx are intact
+
+
+len_is_0:
+	# process completed job "idx"
+	imul    $_LANE_DATA_size, idx, lane_data
+	lea     _ldata(state, lane_data), lane_data
+
+	mov     _job_in_lane(lane_data), job_rax
+	movq    $0, _job_in_lane(lane_data)
+	movl    $STS_COMPLETED, _status(job_rax)
+	mov     _unused_lanes(state), unused_lanes
+	shl     $4, unused_lanes
+	or      idx, unused_lanes
+	mov     unused_lanes, _unused_lanes(state)
+
+	movl	$0xFFFFFFFF, _lens(state, idx, 4)
+
+	vmovd    _args_digest(state , idx, 4) , %xmm0
+	vpinsrd  $1, _args_digest+1*32(state, idx, 4), %xmm0, %xmm0
+	vpinsrd  $2, _args_digest+2*32(state, idx, 4), %xmm0, %xmm0
+	vpinsrd  $3, _args_digest+3*32(state, idx, 4), %xmm0, %xmm0
+	movl    _args_digest+4*32(state, idx, 4), tmp2_w
+
+	vmovdqu  %xmm0, _result_digest(job_rax)
+	offset =  (_result_digest + 1*16)
+	mov     tmp2_w, offset(job_rax)
+
+return:
+
+	mov     _GPR_SAVE(%rsp), %rbx
+	mov     _GPR_SAVE+8*1(%rsp), %r10 #saved rsp
+	mov	_GPR_SAVE+8*3(%rsp), %rbp
+	mov	_GPR_SAVE+8*4(%rsp), %r12
+	mov	_GPR_SAVE+8*5(%rsp), %r13
+	mov	_GPR_SAVE+8*6(%rsp), %r14
+	mov	_GPR_SAVE+8*7(%rsp), %r15
+	mov     %r10, %rsp
+
+	ret
+
+return_null:
+	xor     job_rax, job_rax
+	jmp     return
+ENDPROC(sha1_mb_mgr_flush_avx2)
+
+
+#################################################################
+
+.align 16
+ENTRY(sha1_mb_mgr_get_comp_job_avx2)
+	push    %rbx
+
+	## if bit 32+3 is set, then all lanes are empty
+	mov     _unused_lanes(state), unused_lanes
+	bt      $(32+3), unused_lanes
+	jc      .return_null
+
+	# Find min length
+	vmovdqa _lens(state), %xmm0
+	vmovdqa _lens+1*16(state), %xmm1
+
+	vpminud %xmm1, %xmm0, %xmm2        # xmm2 has {D,C,B,A}
+	vpalignr $8, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,D,C}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has {x,x,E,F}
+	vpalignr $4, %xmm2, %xmm3, %xmm3    # xmm3 has {x,x,x,E}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has min value in low dword
+
+	vmovd   %xmm2, DWORD_idx
+	test    $~0xF, idx
+	jnz     .return_null
+
+	# process completed job "idx"
+	imul    $_LANE_DATA_size, idx, lane_data
+	lea     _ldata(state, lane_data), lane_data
+
+	mov     _job_in_lane(lane_data), job_rax
+	movq    $0,  _job_in_lane(lane_data)
+	movl    $STS_COMPLETED, _status(job_rax)
+	mov     _unused_lanes(state), unused_lanes
+	shl     $4, unused_lanes
+	or      idx, unused_lanes
+	mov     unused_lanes, _unused_lanes(state)
+
+	movl    $0xFFFFFFFF, _lens(state,  idx, 4)
+
+	vmovd   _args_digest(state, idx, 4), %xmm0
+	vpinsrd $1, _args_digest+1*32(state, idx, 4), %xmm0, %xmm0
+	vpinsrd $2, _args_digest+2*32(state, idx, 4), %xmm0, %xmm0
+	vpinsrd $3, _args_digest+3*32(state, idx, 4), %xmm0, %xmm0
+	movl    _args_digest+4*32(state, idx, 4), tmp2_w
+
+	vmovdqu %xmm0, _result_digest(job_rax)
+	movl    tmp2_w, _result_digest+1*16(job_rax)
+
+	pop     %rbx
+
+	ret
+
+.return_null:
+	xor     job_rax, job_rax
+	pop     %rbx
+	ret
+ENDPROC(sha1_mb_mgr_get_comp_job_avx2)
+
+.data
+
+.align 16
+clear_low_nibble:
+.octa	0x000000000000000000000000FFFFFFF0
+one:
+.quad  1
+two:
+.quad  2
+three:
+.quad  3
+four:
+.quad  4
+five:
+.quad  5
+six:
+.quad  6
+seven:
+.quad  7
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c b/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
new file mode 100644
index 0000000..4ca7e16
--- /dev/null
+++ b/arch/x86/crypto/sha-mb/sha1_mb_mgr_init_avx2.c
@@ -0,0 +1,64 @@
+/*
+ * Initialization code for multi buffer SHA1 algorithm for AVX2
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *	Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include "sha_mb_mgr.h"
+
+void sha1_mb_mgr_init_avx2(struct sha1_mb_mgr *state)
+{
+	unsigned int j;
+	state->unused_lanes = 0xF76543210;
+	for (j = 0; j < 8; j++) {
+		state->lens[j] = 0xFFFFFFFF;
+		state->ldata[j].job_in_lane = NULL;
+	}
+}
diff --git a/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S b/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
new file mode 100644
index 0000000..2ab9560
--- /dev/null
+++ b/arch/x86/crypto/sha-mb/sha1_mb_mgr_submit_avx2.S
@@ -0,0 +1,228 @@
+/*
+ * Buffer submit code for multi buffer SHA1 algorithm
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of version 2 of the GNU General Public License as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  Contact Information:
+ *      James Guilford <james.guilford@intel.com>
+ *	Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ *  BSD LICENSE
+ *
+ *  Copyright(c) 2014 Intel Corporation.
+ *
+ *  Redistribution and use in source and binary forms, with or without
+ *  modification, are permitted provided that the following conditions
+ *  are met:
+ *
+ *    * Redistributions of source code must retain the above copyright
+ *      notice, this list of conditions and the following disclaimer.
+ *    * Redistributions in binary form must reproduce the above copyright
+ *      notice, this list of conditions and the following disclaimer in
+ *      the documentation and/or other materials provided with the
+ *      distribution.
+ *    * Neither the name of Intel Corporation nor the names of its
+ *      contributors may be used to endorse or promote products derived
+ *      from this software without specific prior written permission.
+ *
+ *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ *  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/linkage.h>
+#include "sha1_mb_mgr_datastruct.S"
+
+
+.extern sha1_x8_avx
+
+# LINUX register definitions
+arg1    = %rdi
+arg2    = %rsi
+size_offset	= %rcx
+tmp2		= %rcx
+extra_blocks	= %rdx
+
+# Common definitions
+#define state   arg1
+#define job     %rsi
+#define len2    arg2
+#define p2      arg2
+
+# idx must be a register not clobberred by sha1_x8_avx2
+idx		= %r8
+DWORD_idx	= %r8d
+last_len	= %r8
+
+p               = %r11
+start_offset    = %r11
+
+unused_lanes    = %rbx
+BYTE_unused_lanes = %bl
+
+job_rax         = %rax
+len             = %rax
+DWORD_len	= %eax
+
+lane            = %rbp
+tmp3            = %rbp
+
+tmp             = %r9
+DWORD_tmp	= %r9d
+
+lane_data       = %r10
+
+# STACK_SPACE needs to be an odd multiple of 8
+STACK_SPACE     = 8*8 + 16*10 + 8
+
+# JOB* submit_mb_mgr_submit_avx2(MB_MGR *state, job_sha1 *job)
+# arg 1 : rcx : state
+# arg 2 : rdx : job
+ENTRY(sha1_mb_mgr_submit_avx2)
+
+	mov	%rsp, %r10
+	sub     $STACK_SPACE, %rsp
+	and	$~31, %rsp
+
+	mov     %rbx, (%rsp)
+	mov	%r10, 8*2(%rsp)	#save old rsp
+	mov     %rbp, 8*3(%rsp)
+	mov	%r12, 8*4(%rsp)
+	mov	%r13, 8*5(%rsp)
+	mov	%r14, 8*6(%rsp)
+	mov	%r15, 8*7(%rsp)
+
+	mov     _unused_lanes(state), unused_lanes
+	mov	unused_lanes, lane
+	and	$0xF, lane
+	shr     $4, unused_lanes
+	imul    $_LANE_DATA_size, lane, lane_data
+	movl    $STS_BEING_PROCESSED, _status(job)
+	lea     _ldata(state, lane_data), lane_data
+	mov     unused_lanes, _unused_lanes(state)
+	movl    _len(job),  DWORD_len
+
+	mov	job, _job_in_lane(lane_data)
+	shl	$4, len
+	or	lane, len
+
+	movl    DWORD_len,  _lens(state , lane, 4)
+
+	# Load digest words from result_digest
+	vmovdqu	_result_digest(job), %xmm0
+	mov	_result_digest+1*16(job), DWORD_tmp
+	vmovd    %xmm0, _args_digest(state, lane, 4)
+	vpextrd  $1, %xmm0, _args_digest+1*32(state , lane, 4)
+	vpextrd  $2, %xmm0, _args_digest+2*32(state , lane, 4)
+	vpextrd  $3, %xmm0, _args_digest+3*32(state , lane, 4)
+	movl    DWORD_tmp, _args_digest+4*32(state , lane, 4)
+
+	mov     _buffer(job), p
+	mov     p, _args_data_ptr(state, lane, 8)
+
+	cmp     $0xF, unused_lanes
+	jne     return_null
+
+start_loop:
+	# Find min length
+	vmovdqa _lens(state), %xmm0
+	vmovdqa _lens+1*16(state), %xmm1
+
+	vpminud %xmm1, %xmm0, %xmm2        # xmm2 has {D,C,B,A}
+	vpalignr $8, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,D,C}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has {x,x,E,F}
+	vpalignr $4, %xmm2, %xmm3, %xmm3   # xmm3 has {x,x,x,E}
+	vpminud %xmm3, %xmm2, %xmm2        # xmm2 has min value in low dword
+
+	vmovd   %xmm2, DWORD_idx
+	mov    idx, len2
+	and    $0xF, idx
+	shr    $4, len2
+	jz     len_is_0
+
+	vpand   clear_low_nibble(%rip), %xmm2, %xmm2
+	vpshufd $0, %xmm2, %xmm2
+
+	vpsubd  %xmm2, %xmm0, %xmm0
+	vpsubd  %xmm2, %xmm1, %xmm1
+
+	vmovdqa %xmm0, _lens + 0*16(state)
+	vmovdqa %xmm1, _lens + 1*16(state)
+
+
+	# "state" and "args" are the same address, arg1
+	# len is arg2
+	call    sha1_x8_avx2
+
+	# state and idx are intact
+
+len_is_0:
+	# process completed job "idx"
+	imul    $_LANE_DATA_size, idx, lane_data
+	lea     _ldata(state, lane_data), lane_data
+
+	mov     _job_in_lane(lane_data), job_rax
+	mov     _unused_lanes(state), unused_lanes
+	movq    $0, _job_in_lane(lane_data)
+	movl    $STS_COMPLETED, _status(job_rax)
+	shl     $4, unused_lanes
+	or      idx, unused_lanes
+	mov     unused_lanes, _unused_lanes(state)
+
+	movl	$0xFFFFFFFF, _lens(state, idx, 4)
+
+	vmovd    _args_digest(state, idx, 4), %xmm0
+	vpinsrd  $1, _args_digest+1*32(state , idx, 4), %xmm0, %xmm0
+	vpinsrd  $2, _args_digest+2*32(state , idx, 4), %xmm0, %xmm0
+	vpinsrd  $3, _args_digest+3*32(state , idx, 4), %xmm0, %xmm0
+	movl    4*32(state, idx, 4), DWORD_tmp
+
+	vmovdqu  %xmm0, _result_digest(job_rax)
+	movl    DWORD_tmp, _result_digest+1*16(job_rax)
+
+return:
+
+	mov     (%rsp), %rbx
+	mov	8*2(%rsp), %r10	#save old rsp
+	mov     8*3(%rsp), %rbp
+	mov	8*4(%rsp), %r12
+	mov	8*5(%rsp), %r13
+	mov	8*6(%rsp), %r14
+	mov	8*7(%rsp), %r15
+	mov     %r10, %rsp
+
+	ret
+
+return_null:
+	xor     job_rax, job_rax
+	jmp     return
+
+ENDPROC(sha1_mb_mgr_submit_avx2)
+
+.data
+
+.align 16
+clear_low_nibble:
+	.octa	0x000000000000000000000000FFFFFFF0
-- 
1.7.11.7



