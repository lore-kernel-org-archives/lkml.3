Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaDALXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:23:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbaDALTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:19:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Jan Seiffert <kaffeemonster@googlemail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 139/144] x86: bpf_jit: support negative offsets
Date: Tue,  1 Apr 2014 12:15:43 +0100
Message-Id: <1396350948-29910-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

commit fdfaf64e75397567257e1051931f9a3377360665 upstream.

Commit a998d4342337 claimed to introduce negative offset support to x86 jit,
but it couldn't be working, since at the time of the execution
of LD+ABS or LD+IND instructions via call into
bpf_internal_load_pointer_neg_helper() the %edx (3rd argument of this func)
had junk value instead of access size in bytes (1 or 2 or 4).

Store size into %edx instead of %ecx (what original commit intended to do)

Fixes: a998d4342337 ("bpf jit: Let the x86 jit handle negative offsets")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Cc: Jan Seiffert <kaffeemonster@googlemail.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/net/bpf_jit.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/net/bpf_jit.S b/arch/x86/net/bpf_jit.S
index 877b9a1..0149575 100644
--- a/arch/x86/net/bpf_jit.S
+++ b/arch/x86/net/bpf_jit.S
@@ -140,7 +140,7 @@ bpf_slow_path_byte_msh:
 	push	%r9;						\
 	push	SKBDATA;					\
 /* rsi already has offset */					\
-	mov	$SIZE,%ecx;	/* size */			\
+	mov	$SIZE,%edx;	/* size */			\
 	call	bpf_internal_load_pointer_neg_helper;		\
 	test	%rax,%rax;					\
 	pop	SKBDATA;					\
-- 
1.9.1

