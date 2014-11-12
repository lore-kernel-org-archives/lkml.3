Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039AbaKLBlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:41:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276AbaKLBlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:41:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nibble Max <nibble.max@gmail.com>, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 074/203] media: m88ts2022: fix 32bit overflow on filter calc
Date: Wed, 12 Nov 2014 10:15:44 +0900
Message-Id: <20141112011546.092298033@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit f538e085138e519e25ae0828bd6c6e7492ce8ca4 upstream.

Maximum satellite symbol rate used is 45000000Sps which overflows
when multiplied by 135. As final calculation result is fraction,
we could use mult_frac macro in order to keep calculation inside
32 bit number limits and prevent overflow.

Original bug and fix was provided by Nibble Max. I decided to
implement it differently as it is now.

Reported-by: Nibble Max <nibble.max@gmail.com>
Tested-by: Nibble Max <nibble.max@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/tuners/m88ts2022.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/tuners/m88ts2022.c
+++ b/drivers/media/tuners/m88ts2022.c
@@ -314,7 +314,7 @@ static int m88ts2022_set_params(struct d
 	div_min = gdiv28 * 78 / 100;
 	div_max = clamp_val(div_max, 0U, 63U);
 
-	f_3db_hz = c->symbol_rate * 135UL / 200UL;
+	f_3db_hz = mult_frac(c->symbol_rate, 135, 200);
 	f_3db_hz +=  2000000U + (frequency_offset_khz * 1000U);
 	f_3db_hz = clamp(f_3db_hz, 7000000U, 40000000U);
 


