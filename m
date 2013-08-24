Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3HXRmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 13:42:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37579 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755296Ab3HXRmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 13:42:49 -0400
Date: Sat, 24 Aug 2013 19:42:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: x86-ml <x86@kernel.org>
Cc: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Correct erratum 505 range
Message-ID: <20130824174246.GC28383@pd.tnic>
References: <20130824092500.GA28945@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130824092500.GA28945@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 11:25:00AM +0200, Borislav Petkov wrote:
> I've got one more patch which needs to go to tip/x86/ras for 3.12.
> It was not worth it IMO to send a pull request for a single patch so
> please apply.

Ok, one more but this is the last one, I promise! :-)

Thanks.

---
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Date: Sat, 24 Aug 2013 10:47:48 -0500
Subject: [PATCH] amd64_edac: Fix incorrect wraparounds

dct_base and dct_limit obtain 32 bit register values when they read
their respective pci config space registers. A left shift beyond 32 bits
will cause them to wrap around. Similar case for chan_addr as can be
seen from the bug report (link below). In the patch, we rectify this by
casting chan_addr to u64 and by comparing dct_base and dct_limit against
properly shifted sys_addr in order to compare the correct bits.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Link: http://lkml.kernel.org/r/20130819132302.GA12171@elgon.mountain
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 drivers/edac/amd64_edac.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 6952d432e62b..3c9e4e98c651 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1558,11 +1558,12 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	}
 
 	/* Verify sys_addr is within DCT Range. */
-	dct_base = (dct_sel_baseaddr(pvt) << 27);
-	dct_limit = (((dct_cont_limit_reg >> 11) & 0x1FFF) << 27) | 0x7FFFFFF;
+	dct_base = (u64) dct_sel_baseaddr(pvt);
+	dct_limit = (dct_cont_limit_reg >> 11) & 0x1FFF;
 
 	if (!(dct_cont_base_reg & BIT(0)) &&
-	    !(dct_base <= sys_addr && dct_limit >= sys_addr))
+	    !(dct_base <= (sys_addr >> 27) &&
+	      dct_limit >= (sys_addr >> 27)))
 		return -EINVAL;
 
 	/* Verify number of dct's that participate in channel interleaving. */
@@ -1584,7 +1585,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	if (leg_mmio_hole && (sys_addr >= BIT_64(32)))
 		chan_offset = dhar_offset;
 	else
-		chan_offset = dct_base;
+		chan_offset = dct_base << 27;
 
 	chan_addr = sys_addr - chan_offset;
 
@@ -1614,7 +1615,7 @@ static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 		amd64_read_pci_cfg(pvt->F1,
 				   DRAM_CONT_HIGH_OFF + (int) channel * 4,
 				   &tmp);
-		chan_addr +=  ((tmp >> 11) & 0xfff) << 27;
+		chan_addr +=  (u64) ((tmp >> 11) & 0xfff) << 27;
 	}
 
 	f15h_select_dct(pvt, channel);
-- 
1.8.4

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
