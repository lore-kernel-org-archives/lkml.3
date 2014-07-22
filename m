Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbaGVKMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:12:21 -0400
Received: from hofr.at ([212.69.189.236]:36698 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353AbaGVKMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:12:20 -0400
Date: Tue, 22 Jul 2014 12:12:17 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Michal Marek <mmarek@suse.cz>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, cocci@systeme.lip6.fr,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scripts: coccinelle: kfree with TRACE_RET before ref is ok
	(resent)
Message-ID: <20140722101217.GA16183@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kfree.cocci currently triggers on constructs like
(resending with proper CC list and subject line)

drivers/staging/rts5208/spi.c
596    if (retval < 0) {
597            kfree(buf);
598            rtsx_clear_spi_error(chip);
599            spi_set_err_code(chip, SPI_HW_ERR);
600            TRACE_RET(chip, STATUS_FAIL);
601    }
602
603    rtsx_stor_access_xfer_buf(buf, pagelen, srb, &index, &offset,
                            TO_XFER_BUF);

with:

./drivers/staging/rts5208/spi.c:603:28-31: ERROR: reference preceded 
by free on line 597

but this should be fine - so TRACE_RET is added to the list of calls 
"protecting" access to freed objects see drivers/staging/rts5208/trace.h


Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 scripts/coccinelle/free/kfree.cocci |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scripts/coccinelle/free/kfree.cocci b/scripts/coccinelle/free/kfree.cocci
index 577b780..04d3f4f 100644
--- a/scripts/coccinelle/free/kfree.cocci
+++ b/scripts/coccinelle/free/kfree.cocci
@@ -101,6 +101,8 @@ kfree@p1(E,...)
 |
  return_ACPI_STATUS(...)
 |
+ TRACE_RET(...)
+|
  E@p2 // bad use
 )
 
-- 
1.7.10.4

