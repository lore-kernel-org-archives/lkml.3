Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbbAYSjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:39:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbbAYSKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.18 115/183] powernv: Fix OPAL tracepoint code
Date: Sun, 25 Jan 2015 10:07:17 -0800
Message-Id: <20150125180815.190200481@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit bfe5fda8e7ced129716f5741cf7ed2592a338824 upstream.

Patch c49f63530bb6 ("powernv: Add OPAL tracepoints") has a spurious
store to the stack:

	ld      r12,opal_tracepoint_refcount@toc(r2);           \
	std     r12,32(r1);                                     \

The store was originally used to save the current tracepoint status
so the entry and the exit tracepoints were always balanced. In the
end I just created a separate path when tracepoints are enabled.

The offset on the stack used for this store is not valid for ABIv2
and it causes strange issues. I noticed it because OPAL console input
was broken.

Fixes: c49f63530bb6 ("powernv: Add OPAL tracepoints")
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/opal-wrappers.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/powerpc/platforms/powernv/opal-wrappers.S
+++ b/arch/powerpc/platforms/powernv/opal-wrappers.S
@@ -40,7 +40,6 @@ BEGIN_FTR_SECTION;						\
 	b	1f;						\
 END_FTR_SECTION(0, 1);						\
 	ld	r12,opal_tracepoint_refcount@toc(r2);		\
-	std	r12,32(r1);					\
 	cmpdi	r12,0;						\
 	bne-	LABEL;						\
 1:


