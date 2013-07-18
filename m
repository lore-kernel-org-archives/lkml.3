Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934671Ab3GRX1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 19:27:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:55180 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933481Ab3GRX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 19:27:23 -0400
Date: Fri, 19 Jul 2013 01:27:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ming Lei <tom.leiming@gmail.com>, Linda Walsh <lkml@tlinx.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: BUG: key ffff880c1148c478 not in .data! (V3.10.0)
Message-ID: <20130718232718.GA14824@pd.tnic>
References: <51D9EAF3.4050804@tlinx.org>
 <CACVXFVPRwakzB6vtqRqL49StHKdugCpxDyNvx3VzcDC7GggFMQ@mail.gmail.com>
 <20130712080428.GB359@x4>
 <20130712134115.GI24008@pd.tnic>
 <51E00B55.5070003@infradead.org>
 <20130712142106.GJ24008@pd.tnic>
 <20130712131340.1a371662.mchehab@infradead.org>
 <3908561D78D1C84285E8C5FCA982C28F31C7D83C@ORSMSX106.amr.corp.intel.com>
 <20130718164215.GC15992@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F31C92B23@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31C92B23@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 04:51:48PM +0000, Luck, Tony wrote:
> +	BUG_ON(mci->mc_idx >= EDAC_MAX_MCS);
> 
> Do we have to "BUG_ON()" here?  Couldn't we be gentler with something like:
> 
> 	if (mci->mc_idx >= EDAC_MAX_MCS) {
> 		printk_once(KERN_WARNING "Too many memory controllers\n");
> 		return; /* probably need to make sure caller copes with this ... so more stuff there */

Yeah, we can do something like this:

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 429e971e02d7..c55ad285c285 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -725,6 +725,11 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 	int ret = -EINVAL;
 	edac_dbg(0, "\n");
 
+	if (mci->mc_idx >= EDAC_MAX_MCS) {
+		pr_warn_once("Too many memory controllers: %d\n", mci->mc_idx);
+		return ret;
+	}
+
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_mc_dump_mci(mci);
--

right near the beginning of the function so that we can save us the
unwinding.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
