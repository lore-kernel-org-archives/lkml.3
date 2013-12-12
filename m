Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab3LLCra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:47:30 -0500
Received: from ozlabs.org ([203.10.76.45]:48912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3LLCr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:47:27 -0500
Date: Thu, 12 Dec 2013 13:47:25 +1100
From: Anton Blanchard <anton@samba.org>
To: cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@ghostprotocols.net, mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf symbols: symbol-minimal.c causes random fd to be
 closed
Message-ID: <20131212134725.4dacdd06@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I hit a cryptic failure when testing a recent version
of perf:

  # perf report
  write failure on standard output: Bad file descriptor

The issue is in commit b68e2f91 (perf symbols: Introduce symsrc
structure). symsrc__destroy() does a close(ss->fd) but
ss->fd is only initialised in the symbol-elf.c case and
not for symbol-minimal.c.

The issue has been around for a while however most people
will build with libelf which wont use the symbol-minimal.c
code.

Cc: stable@vger.kernel.org # v3.8+
Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index 2d2dd05..3528204 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -254,6 +254,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso __maybe_unused,
 		goto out_close;
 
 	ss->type = type;
+	ss->fd = fd;
 
 	return 0;
 out_close:
