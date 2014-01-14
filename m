Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaANBAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:00:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbaANA12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:27:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, Rajendra Nayak <rnayak@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.10 47/62] clk: clk-divider: fix divisor > 255 bug
Date: Mon, 13 Jan 2014 16:27:12 -0800
Message-Id: <20140114002711.801184188@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002710.464561569@linuxfoundation.org>
References: <20140114002710.464561569@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit 778037e1ccb75609846deca9e419449c1dc137fa upstream.

Commit 6d9252bd9a4bb (clk: Add support for power of two type dividers)
merged in v3.6 added the _get_val function to convert a divisor value to
a register field value depending on the flags. However it used the type
u8 for the div field, causing divisors larger than 255 to be masked
and the resultant clock rate to be too high.

E.g. in my case an 11bit divider was supposed to divide 24.576 MHz down
to 32.768KHz. The divisor was correctly calculated as 750 (0x2ee). This
was masked to 238 (0xee) resulting in a frequency of 103.26KHz.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Rajendra Nayak <rnayak@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk-divider.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -87,7 +87,7 @@ static unsigned int _get_table_val(const
 	return 0;
 }
 
-static unsigned int _get_val(struct clk_divider *divider, u8 div)
+static unsigned int _get_val(struct clk_divider *divider, unsigned int div)
 {
 	if (divider->flags & CLK_DIVIDER_ONE_BASED)
 		return div;


