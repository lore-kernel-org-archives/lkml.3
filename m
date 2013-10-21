Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3JUIwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39740 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754183Ab3JUIwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "Neil Horman" <nhorman@tuxdriver.com>,
        "Michio Honda" <micchie@sfc.wide.ad.jp>,
        "Vlad Yasevich" <vyasevich@gmail.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.420144098@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 102/149] net: sctp: fix smatch warning in 
 sctp_send_asconf_del_ip
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit 88362ad8f9a6cea787420b57cc27ccacef000dbe ]

This was originally reported in [1] and posted by Neil Horman [2], he said:

  Fix up a missed null pointer check in the asconf code. If we don't find
  a local address, but we pass in an address length of more than 1, we may
  dereference a NULL laddr pointer. Currently this can't happen, as the only
  users of the function pass in the value 1 as the addrcnt parameter, but
  its not hot path, and it doesn't hurt to check for NULL should that ever
  be the case.

The callpath from sctp_asconf_mgmt() looks okay. But this could be triggered
from sctp_setsockopt_bindx() call with SCTP_BINDX_REM_ADDR and addrcnt > 1
while passing all possible addresses from the bind list to SCTP_BINDX_REM_ADDR
so that we do *not* find a single address in the association's bind address
list that is not in the packed array of addresses. If this happens when we
have an established association with ASCONF-capable peers, then we could get
a NULL pointer dereference as we only check for laddr == NULL && addrcnt == 1
and call later sctp_make_asconf_update_ip() with NULL laddr.

BUT: this actually won't happen as sctp_bindx_rem() will catch such a case
and return with an error earlier. As this is incredably unintuitive and error
prone, add a check to catch at least future bugs here. As Neil says, its not
hot path. Introduced by 8a07eb0a5 ("sctp: Add ASCONF operation on the
single-homed host").

 [1] http://www.spinics.net/lists/linux-sctp/msg02132.html
 [2] http://www.spinics.net/lists/linux-sctp/msg02133.html

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Michio Honda <micchie@sfc.wide.ad.jp>
Acked-By: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Vlad Yasevich <vyasevich@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sctp/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ba0108f..c53d01e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -814,6 +814,9 @@ static int sctp_send_asconf_del_ip(struct sock		*sk,
 			goto skip_mkasconf;
 		}
 
+		if (laddr == NULL)
+			return -EINVAL;
+
 		/* We do not need RCU protection throughout this loop
 		 * because this is done under a socket lock from the
 		 * setsockopt call.

