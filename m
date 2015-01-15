Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbbAORYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 12:24:18 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:45388 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbbAORYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 12:24:14 -0500
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
To: mpe@ellerman.id.au
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        paulus@samba.org, Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH] pseries/le: Fix another endiannes issue in RTAS call from xmon
Date: Thu, 15 Jan 2015 18:23:47 +0100
Message-Id: <1421342627-7214-1-git-send-email-ldufour@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421295950.11409.3.camel@ellerman.id.au>
References: <1421295950.11409.3.camel@ellerman.id.au>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011517-0021-0000-0000-0000028F5C1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 3b8a3c010969 ("powerpc/pseries: Fix endiannes issue in RTAS
call from xmon") was fixing an endianness issue in the call made from
xmon to RTAS.

However, as Michael Ellerman noticed, this fix was not complete, the
token value was not byte swapped. This lead to call an unexpected and
most of the time unexisting RTAS function, which is silently ignored
by RTAS.

This fix addresses this hole.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
---
 arch/powerpc/xmon/xmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 5b150f0c5df9..13c6e200b24e 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -337,6 +337,7 @@ static inline void disable_surveillance(void)
 	args.token = rtas_token("set-indicator");
 	if (args.token == RTAS_UNKNOWN_SERVICE)
 		return;
+	args.token = cpu_to_be32(args.token);
 	args.nargs = cpu_to_be32(3);
 	args.nret = cpu_to_be32(1);
 	args.rets = &args.args[3];
-- 
1.9.1

