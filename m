Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbaC1SLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 14:11:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaC1RaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jan Seiffert <kaffeemonster@googlemail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 04/13] x86: bpf_jit: support negative offsets
Date: Fri, 28 Mar 2014 10:31:54 -0700
Message-Id: <20140328173053.660558137@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
References: <20140328173053.049244535@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/net/bpf_jit.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


