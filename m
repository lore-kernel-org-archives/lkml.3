Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810Ab3CZP2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:28:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965452Ab3CZPYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:24:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Neil Horman <nhorman@tuxdriver.com>, Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 143/150] sctp: Use correct sideffect command in duplicate cookie handling
Date: Tue, 26 Mar 2013 15:20:42 +0000
Message-Id: <1364311249-14454-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Yasevich <vyasevich@gmail.com>

commit f2815633504b442ca0b0605c16bf3d88a3a0fcea upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sctp/sm_statefuns.c | 2 +-
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
1.8.1.2

