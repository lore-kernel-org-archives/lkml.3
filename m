Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaFDXtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:49:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40629 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaFDXX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Corey Minyard <cminyard@mvista.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 016/103] ipmi: Reset the KCS timeout when starting error recovery
Date: Wed,  4 Jun 2014 16:24:39 -0700
Message-Id: <20140604232547.351478037@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corey Minyard <cminyard@mvista.com>

commit eb6d78ec213e6938559b801421d64714dafcf4b2 upstream.

The OBF timer in KCS was not reset in one situation when error recovery
was started, resulting in an immediate timeout.

Reported-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/ipmi/ipmi_kcs_sm.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmi_kcs_sm.c
+++ b/drivers/char/ipmi/ipmi_kcs_sm.c
@@ -251,8 +251,9 @@ static inline int check_obf(struct si_sm
 	if (!GET_STATUS_OBF(status)) {
 		kcs->obf_timeout -= time;
 		if (kcs->obf_timeout < 0) {
-		    start_error_recovery(kcs, "OBF not ready in time");
-		    return 1;
+			kcs->obf_timeout = OBF_RETRY_TIMEOUT;
+			start_error_recovery(kcs, "OBF not ready in time");
+			return 1;
 		}
 		return 0;
 	}


