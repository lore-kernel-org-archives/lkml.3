Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab3APK6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:58:07 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:34905 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321Ab3APK6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:58:04 -0500
Date: Wed, 16 Jan 2013 11:57:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Cong Ding <dinggnu@gmail.com>
Cc: Jim Quinlan <jim2101024@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH] mpis: cavium-octeon/executive/cvmx-l2c.c: fix
 uninitialized variable
Message-ID: <20130116105757.GB26569@linux-mips.org>
References: <1358200025-15994-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358200025-15994-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:47:03PM +0100, Cong Ding wrote:

> the variable dummy is used without initialization.

Interesting - I wonder how you found this one.  My compiler (gcc 4.7)
doesn't warn about this one.

Nor does gcc notice that the whole summing up business is wasted efford.

So here's my counter proposal.  It works because ptr is a volatile pointer
so the compiler will always dereference it even if the returned value is
not being used.  The resulting code is a bit smaller.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/cavium-octeon/executive/cvmx-l2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/cavium-octeon/executive/cvmx-l2c.c b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
index 9f883bf..ec3e059 100644
--- a/arch/mips/cavium-octeon/executive/cvmx-l2c.c
+++ b/arch/mips/cavium-octeon/executive/cvmx-l2c.c
@@ -286,7 +286,7 @@ uint64_t cvmx_l2c_read_perf(uint32_t counter)
 static void fault_in(uint64_t addr, int len)
 {
 	volatile char *ptr;
-	volatile char dummy;
+
 	/*
 	 * Adjust addr and length so we get all cache lines even for
 	 * small ranges spanning two cache lines.
@@ -300,7 +300,7 @@ static void fault_in(uint64_t addr, int len)
 	 */
 	CVMX_DCACHE_INVALIDATE;
 	while (len > 0) {
-		dummy += *ptr;
+		*ptr;
 		len -= CVMX_CACHE_LINE_SIZE;
 		ptr += CVMX_CACHE_LINE_SIZE;
 	}
