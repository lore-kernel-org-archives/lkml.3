Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303AbaEUATn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 20:19:43 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44221 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaEUATl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 20:19:41 -0400
Message-ID: <537BF116.9000900@gmail.com>
Date: Wed, 21 May 2014 08:19:34 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: gerrit@erg.abdn.ac.uk
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>, David Miller <davem@davemloft.net>,
        dccp@vger.kernel.org, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH linux-next] net/dccp/timer.c: use 'u64' instead of 's64' to
 avoid compiler's warning
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'dccp_timestamp_seed' is initialized once by ktime_get_real() in
dccp_timestamping_init(). It is always less than ktime_get_real()
in dccp_timestamp().

Then, ktime_us_delta() in dccp_timestamp() will always return positive
number. So can use manual type cast to let compiler and do_div() know
about it to avoid warning.

The related warning (with allmodconfig under unicore32):

    CC [M]  net/dccp/timer.o
  net/dccp/timer.c: In function ‘dccp_timestamp’:
  net/dccp/timer.c:285: warning: comparison of distinct pointer types lacks a cast


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 net/dccp/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dccp/timer.c b/net/dccp/timer.c
index 16f0b22..1cd46a3 100644
--- a/net/dccp/timer.c
+++ b/net/dccp/timer.c
@@ -280,7 +280,7 @@ static ktime_t dccp_timestamp_seed;
  */
 u32 dccp_timestamp(void)
 {
-	s64 delta = ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
+	u64 delta = (u64)ktime_us_delta(ktime_get_real(), dccp_timestamp_seed);
 
 	do_div(delta, 10);
 	return delta;
-- 
1.9.2.459.g68773ac
