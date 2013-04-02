Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740Ab3DBW3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:29:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933658Ab3DBWOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:14:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Oded Horovitz <oded@privatecore.com>,
        Brad Spengler <spender@grsecurity.net>,
        Matt Carlson <mcarlson@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 18/68] tg3: fix length overflow in VPD firmware parsing
Date: Tue,  2 Apr 2013 15:13:07 -0700
Message-Id: <20130402221332.045800853@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221329.915209206@linuxfoundation.org>
References: <20130402221329.915209206@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13590,8 +13590,11 @@ static void __devinit tg3_read_vpd(struc
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


