Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3APPvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:51:45 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:59327 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754301Ab3APPvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:51:43 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18B1HefCvZ/IoiL3Pj7bcgfJp4p4CXhNDE=
Date: Wed, 16 Jan 2013 10:50:45 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Soeren Moch <smoch@web.de>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment
Message-ID: <20130116155045.GI25500@titan.lakedaemon.net>
References: <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <50F3F289.3090402@web.de>
 <20130115165642.GA25500@titan.lakedaemon.net>
 <20130115175020.GA3764@kroah.com>
 <20130115201617.GC25500@titan.lakedaemon.net>
 <20130115215602.GF25500@titan.lakedaemon.net>
 <50F5F1B7.3040201@web.de>
 <20130116024014.GH25500@titan.lakedaemon.net>
 <50F61D86.4020801@web.de>
 <50F66B1B.40301@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F66B1B.40301@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 09:55:55AM +0100, Soeren Moch wrote:
> On 16.01.2013 04:24, Soeren Moch wrote:
> >On 16.01.2013 03:40, Jason Cooper wrote:
> >>On Wed, Jan 16, 2013 at 01:17:59AM +0100, Soeren Moch wrote:
> >>>On 15.01.2013 22:56, Jason Cooper wrote:
> >>>>On Tue, Jan 15, 2013 at 03:16:17PM -0500, Jason Cooper wrote:

> OK, I could trigger the error
>   ERROR: 1024 KiB atomic DMA coherent pool is too small!
>   Please increase it with coherent_pool= kernel parameter!
> only with em28xx sticks and sata, dib0700 sticks removed.

Did you test the reverse scenario?  ie dib0700 with sata_mv and no
em28xx.

What kind of throughput are you pushing to the sata disk?

> >>What would be most helpful is if you could do a git bisect between
> >>v3.5.x (working) and the oldest version where you know it started
> >>failing (v3.7.1 or earlier if you know it).
> >>
> >I did not bisect it, but Marek mentioned earlier that commit
> >e9da6e9905e639b0f842a244bc770b48ad0523e9 in Linux v3.6-rc1 introduced
> >new code for dma allocations. This is probably the root cause for the
> >new (mis-)behavior (due to my tests 3.6.0 is not working anymore).
> 
> I don't want to say that Mareks patch is wrong, probably it triggers a
> bug somewhere else! (in em28xx?)

Of the four drivers you listed, none are using dma.  sata_mv is the only
one.

If one is to believe the comments in sata_mv.c:~151, then the alignment
is wrong for the sg_tbl_pool.

Could you please try the following patch?

thx,

Jason.

---8<----------
>From 566c7e30285e4c31d76724ea4811b016b753f24f Mon Sep 17 00:00:00 2001
From: Jason Cooper <jason@lakedaemon.net>
Date: Wed, 16 Jan 2013 15:43:37 +0000
Subject: [PATCH] ata: sata_mv: fix sg_tbl_pool alignment

If the comment is to be believed, the alignment should be 16B, and the
size 4K.  The current code sets both to 4K.  On some arm boards
(kirkwood), this causes:

   ERROR: 1024 KiB atomic DMA coherent pool is too small!
   Please increase it with coherent_pool= kernel parameter!

Set alignment to 16B to prevent exhausting the atomic_pool.

Signed-off-by: Jason Cooper <jason@lakedaemon.net>
---
 drivers/ata/sata_mv.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 68f4fb5..e2e5a8a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -148,6 +148,9 @@ enum {
 	 * CRPB needs alignment on a 256B boundary. Size == 256B
 	 * ePRD (SG) entries need alignment on a 16B boundary. Size == 16B
 	 */
+	MV_CRQB_Q_ALIGN		= 1024,
+	MV_CRPB_Q_ALIGN		= 256,
+	MV_SG_TBL_ALIGN		= 16,
 	MV_CRQB_Q_SZ		= (32 * MV_MAX_Q_DEPTH),
 	MV_CRPB_Q_SZ		= (8 * MV_MAX_Q_DEPTH),
 	MV_MAX_SG_CT		= 256,
@@ -3975,17 +3978,17 @@ done:
 static int mv_create_dma_pools(struct mv_host_priv *hpriv, struct device *dev)
 {
 	hpriv->crqb_pool   = dmam_pool_create("crqb_q", dev, MV_CRQB_Q_SZ,
-							     MV_CRQB_Q_SZ, 0);
+							MV_CRQB_Q_ALIGN, 0);
 	if (!hpriv->crqb_pool)
 		return -ENOMEM;
 
 	hpriv->crpb_pool   = dmam_pool_create("crpb_q", dev, MV_CRPB_Q_SZ,
-							     MV_CRPB_Q_SZ, 0);
+							MV_CRPB_Q_ALIGN, 0);
 	if (!hpriv->crpb_pool)
 		return -ENOMEM;
 
 	hpriv->sg_tbl_pool = dmam_pool_create("sg_tbl", dev, MV_SG_TBL_SZ,
-							     MV_SG_TBL_SZ, 0);
+							MV_SG_TBL_ALIGN, 0);
 	if (!hpriv->sg_tbl_pool)
 		return -ENOMEM;
 
-- 
1.8.1.1

