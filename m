Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757319Ab3CZXsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:48:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3CZWnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Karl Heiss <kheiss@gmail.com>, Neil Horman <nhorman@tuxdriver.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 09/98] sctp: Use correct sideffect command in duplicate cookie handling
Date: Tue, 26 Mar 2013 15:41:58 -0700
Message-Id: <20130326224243.410107448@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_statefuns.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -2082,7 +2082,7 @@ sctp_disposition_t sctp_sf_do_5_2_4_dupc
 	}
 
 	/* Delete the tempory new association. */
-	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
+	sctp_add_cmd_sf(commands, SCTP_CMD_SET_ASOC, SCTP_ASOC(new_asoc));
 	sctp_add_cmd_sf(commands, SCTP_CMD_DELETE_TCB, SCTP_NULL());
 
 	/* Restore association pointer to provide SCTP command interpeter


