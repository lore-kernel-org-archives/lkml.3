Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721Ab3DGX3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:29:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46689 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934558Ab3DGX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Brad Spengler" <spender@grsecurity.net>,
        "Oded Horovitz" <oded@privatecore.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Matt Carlson" <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.803185134@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [36/74] tg3: fix length overflow in VPD firmware parsing
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 715230a44310a8cf66fbfb5a46f9a62a9b2de424 upstream.

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
Cc: Matt Carlson <mcarlson@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/broadcom/tg3.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13433,8 +13433,11 @@ static void __devinit tg3_read_vpd(struc
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

