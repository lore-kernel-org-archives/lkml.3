Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab3LJCf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 21:35:28 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19150 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab3LJCfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 21:35:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Dec 2013 18:32:04 -0800
Date: Mon, 9 Dec 2013 18:35:24 -0800
From: Paul Walmsley <pwalmsley@nvidia.com>
X-X-Sender: pwalmsley@tamien
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?ISO-8859-15?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH] avr32: favr-32: clk_round_rate() can return a zero upon
 error
Message-ID: <alpine.DEB.2.02.1312091827300.4127@tamien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1849196134-1386642924=:4127"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1849196134-1386642924=:4127
Content-Type: text/plain; format=flowed; charset="ISO-8859-15"
Content-Transfer-Encoding: 8BIT


Treat both negative and zero return values from clk_round_rate() as
errors.  This is needed since subsequent patches will convert
clk_round_rate()'s return value to be an unsigned type, rather than a
signed type, since some clock sources can generate rates higher than
(2^31)-1 Hz.

Eventually, when calling clk_round_rate(), only a return value of zero
will be considered a error.  All other values will be considered valid
rates.  The comparison against values less than 0 is kept to preserve
the correct behavior in the meantime.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Håvard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
Applies on v3.13-rc3.  See also:

http://marc.info/?l=linux-arm-kernel&m=138542591313620&w=2

  arch/avr32/boards/favr-32/setup.c |    4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
index 7b1f2cd85400..1f121497b517 100644
--- a/arch/avr32/boards/favr-32/setup.c
+++ b/arch/avr32/boards/favr-32/setup.c
@@ -298,8 +298,10 @@ static int __init set_abdac_rate(struct platform_device *pdev)
  	 */
  	retval = clk_round_rate(pll1,
  			CONFIG_BOARD_FAVR32_ABDAC_RATE * 256 * 16);
-	if (retval < 0)
+	if (retval <= 0) {
+		retval = -EINVAL;
  		goto out_abdac;
+	}

  	retval = clk_set_rate(pll1, retval);
  	if (retval != 0)
--8323329-1849196134-1386642924=:4127--
