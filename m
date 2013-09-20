Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3ITLib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 07:38:31 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3ITLia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 07:38:30 -0400
Date: Fri, 20 Sep 2013 14:37:36 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] perf: potential underflow in perf_sample_ustack_size()
Message-ID: <20130920113736.GB8655@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code here is trying to ensure that we don't have a
"header_size + stack_size" which is more than USHRT_MAX.  I changed
the overflow check a little to make it more clear.

My concern here is that if "header_size + sizeof(u64)" is very large
then we could end up with underflow doing the subtraction and end up
with a "stack_size" larger than intended.

I don't know perf well enough to say if this is possible.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..eec9e683 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4217,11 +4217,13 @@ perf_sample_ustack_size(u16 stack_size, u16 header_size,
 	header_size += 2 * sizeof(u64);
 
 	/* Do we fit in with the current stack dump size? */
-	if ((u16) (header_size + stack_size) < header_size) {
+	if (header_size > USHRT_MAX - stack_size) {
 		/*
 		 * If we overflow the maximum size for the sample,
 		 * we customize the stack dump size to fit in.
 		 */
+		if (header_size + sizeof(u64) > USHRT_MAX)
+			return 0;
 		stack_size = USHRT_MAX - header_size - sizeof(u64);
 		stack_size = round_up(stack_size, sizeof(u64));
 	}
