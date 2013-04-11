Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638Ab3DKU0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:26:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6173 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab3DKUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:25:59 -0400
X-Authority-Analysis: v=2.0 cv=C51rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=b77cu3XtdiUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=F3ZUODidjGwA:10 a=pGLkceISAAAA:8 a=vmLDa1wCAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=MSl-tDqOz04A:10 a=gv_BBZfBKR8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202547.903604783@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Karl Heiss <kheiss@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 010/171 ] sctp: Use correct sideffect command in duplicate cookie handling
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0010-sctp-Use-correct-sideffect-command-in-duplicate-cook.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

[ Upstream commit f2815633504b442ca0b0605c16bf3d88a3a0fcea ]

When SCTP is done processing a duplicate cookie chunk, it tries
to delete a newly created association.  For that, it has to set
the right association for the side-effect processing to work.
However, when it uses the SCTP_CMD_NEW_ASOC command, that performs
more work then really needed (like hashing the associationa and
assigning it an id) and there is no point to do that only to
delete the association as a next step.  In fact, it also creates
an impossible condition where an association may be found by
the getsockopt() call, and that association is empty.  This
causes a crash in some sctp getsockopts.

The solution is rather simple.  We simply use SCTP_CMD_SET_ASOC
command that doesn't have all the overhead and does exactly
what we need.

Reported-by: Karl Heiss <kheiss@gmail.com>
Tested-by: Karl Heiss <kheiss@gmail.com>
CC: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Vlad Yasevich <vyasevich@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sctp/sm_statefuns.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 9fca103..469ef67 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2042,7 +2042,7 @@ sctp_disposition_t sctp_sf_do_5_2_4_dupcook(const struct sctp_endpoint *ep,
 	}
 
 	/* Delete the tempory new association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
+	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 
 	/* Restore association pointer to provide SCTP command interpeter
-- 
1.7.10.4


