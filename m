Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934974Ab3JPSBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:01:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934451Ab3JPRqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mischa Jonker <mjonker@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 13/50] ARC: Fix __udelay calculation
Date: Wed, 16 Oct 2013 10:44:59 -0700
Message-Id: <20131016174359.974775795@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174358.335646140@linuxfoundation.org>
References: <20131016174358.335646140@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mischa Jonker <mjonker@synopsys.com>

commit 7efd0da2d17360e1cef91507dbe619db0ee2c691 upstream.

Cast usecs to u64, to ensure that the (usecs * 4295 * HZ)
multiplication is 64 bit.

Initially, the (usecs * 4295 * HZ) part was done as a 32 bit
multiplication, with the result casted to 64 bit. This led to some bits
falling off, causing a "DMA initialization error" in the stmmac Ethernet
driver, due to a premature timeout.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/include/asm/delay.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arc/include/asm/delay.h
+++ b/arch/arc/include/asm/delay.h
@@ -53,11 +53,10 @@ static inline void __udelay(unsigned lon
 {
 	unsigned long loops;
 
-	/* (long long) cast ensures 64 bit MPY - real or emulated
+	/* (u64) cast ensures 64 bit MPY - real or emulated
 	 * HZ * 4295 is pre-evaluated by gcc - hence only 2 mpy ops
 	 */
-	loops = ((long long)(usecs * 4295 * HZ) *
-		 (long long)(loops_per_jiffy)) >> 32;
+	loops = ((u64) usecs * 4295 * HZ * loops_per_jiffy) >> 32;
 
 	__delay(loops);
 }


