Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab3C0QlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 12:41:01 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57998 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab3C0Qk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 12:40:59 -0400
Date: Wed, 27 Mar 2013 09:40:50 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Matt Carlson <mcarlson@broadcom.com>, Michael Chan <mchan@broadcom.com>,
        netdev@vger.kernel.org, Oded Horovitz <oded@privatecore.com>,
        Brad Spengler <spender@grsecurity.net>,
        Benjamin Li <benli@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] tg3: fix length overflow in VPD firmware parsing
Message-ID: <20130327164050.GA26838@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 184b89044fb6e2a74611dafa69b1dce0d98612c6 ("tg3: Use VPD fw version
when present") introduced VPD parsing that contained a potential length
overflow.

Limit the hardware's reported firmware string length (max 255 bytes) to
stay inside the driver's firmware string length (32 bytes). On overflow,
truncate the formatted firmware string instead of potentially overwriting
portions of the tg3 struct.

http://cansecwest.com/slides/2013/PrivateCore%20CSW%202013.pdf

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Oded Horovitz <oded@privatecore.com>
Reported-by: Brad Spengler <spender@grsecurity.net>
Cc: stable@vger.kernel.org
Cc: Matt Carlson <mcarlson@broadcom.com>
---
 drivers/net/ethernet/broadcom/tg3.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 67d2663..17a9727 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14604,8 +14604,11 @@ static void tg3_read_vpd(struct tg3 *tp)
 		if (j + len > block_end)
 			goto partno;
 
-		memcpy(tp->fw_ver, &vpd_data[j], len);
-		strncat(tp->fw_ver, " bc ", vpdlen - len - 1);
+		if (len >= sizeof(tp->fw_ver))
+			len = sizeof(tp->fw_ver) - 1;
+		memset(tp->fw_ver, 0, sizeof(tp->fw_ver));
+		snprintf(tp->fw_ver, sizeof(tp->fw_ver), "%.*s bc ", len,
+			 &vpd_data[j]);
 	}
 
 partno:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
