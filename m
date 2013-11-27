Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3K0BLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:11:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758839Ab3K0A7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.12 111/116] s390/time: fix get_tod_clock_ext inline assembly
Date: Tue, 26 Nov 2013 16:58:04 -0800
Message-Id: <20131127005744.608688012@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit 7ab64a85e1a009046f97413a573e83fd85f7804d upstream.

The get_tod_clock_ext inline assembly does not specify its output
operands correctly. This can cause incorrect code to be generated.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/include/asm/timex.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -71,9 +71,11 @@ static inline void local_tick_enable(uns
 
 typedef unsigned long long cycles_t;
 
-static inline void get_tod_clock_ext(char *clk)
+static inline void get_tod_clock_ext(char clk[16])
 {
-	asm volatile("stcke %0" : "=Q" (*clk) : : "cc");
+	typedef struct { char _[sizeof(clk)]; } addrtype;
+
+	asm volatile("stcke %0" : "=Q" (*(addrtype *) clk) : : "cc");
 }
 
 static inline unsigned long long get_tod_clock(void)


