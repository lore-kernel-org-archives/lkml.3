Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab3HMSld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:41:33 -0400
Received: from sandeen.net ([63.231.237.45]:60797 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757257Ab3HMSla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:41:30 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2013 14:41:30 EDT
Message-ID: <520A7C31.2050802@sandeen.net>
Date: Tue, 13 Aug 2013 13:34:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: linux-next: Tree for Aug 13 (xfs)
References: <20130813182832.16d18ef3dbc267c1a229bcd6@canb.auug.org.au> <520A6607.7060002@infradead.org>
In-Reply-To: <520A6607.7060002@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/13 11:59 AM, Randy Dunlap wrote:
> On 08/13/13 01:28, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130812:
>>
> 
> on i386:
> 
> fs/built-in.o: In function `xfs_log_calc_minimum_size':
> (.text+0x1797a9): undefined reference to `__udivdi3'
> 
> 

See:

[PATCH] xfs: call roundup_64() to calculate the min_logblks

on the xfs list:

From: Jie Liu <jeff.liu@oracle.com>

Replace roundup() with roundup_64() as we calculate min_logblks
with 64-bit divisions.  Hence, call roundup() will cause the
following error while compiling a 32-bit kernel:

fs/built-in.o: In function `xfs_log_calc_minimum_size':
fs/xfs/xfs_log_rlimit.c:140: undefined reference to `__udivdi3'

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 fs/xfs/xfs_log_rlimit.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_rlimit.c b/fs/xfs/xfs_log_rlimit.c
index 6b17ef4..bbcec0b 100644
--- a/fs/xfs/xfs_log_rlimit.c
+++ b/fs/xfs/xfs_log_rlimit.c
@@ -136,10 +136,12 @@ xfs_log_calc_minimum_size(
 	 * Also, the log size should be a multiple of the log stripe unit, round
 	 * it up to lsunit boundary if lsunit is specified.
 	 */
-	if (lsunit)
-		min_logblks = roundup(BTOBB(max_logres), lsunit) + 2 * lsunit;
-	else
+	if (lsunit) {
+		min_logblks = roundup_64(BTOBB(max_logres), lsunit) +
+			      2 * lsunit;
+	} else
 		min_logblks = BTOBB(max_logres) + 2 * BBSIZE;
 	min_logblks *= XFS_MIN_LOG_FACTOR;
+
 	return XFS_BB_TO_FSB(mp, min_logblks);
 }
-- 

-Eric
