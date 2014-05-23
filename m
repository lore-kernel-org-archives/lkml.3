Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbaEWJKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:10:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60283 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753010AbaEWJKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:10:47 -0400
Date: Fri, 23 May 2014 11:10:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Chen Yucong <slaoub@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v2] x86/mce: Distirbute the clear operation of mces_seen
 to Per-CPU rather than only monarch CPU
Message-ID: <20140523091041.GA21332@pd.tnic>
References: <1400551885-13828-1-git-send-email-slaoub@gmail.com>
 <537C040E.3040901@jp.fujitsu.com>
 <1400637782.14703.32.camel@debian>
 <537C12BC.6080408@jp.fujitsu.com>
 <1400642398.14703.42.camel@debian>
 <537C1F24.8000604@jp.fujitsu.com>
 <3908561D78D1C84285E8C5FCA982C28F328115FD@ORSMSX114.amr.corp.intel.com>
 <1400808739.19982.48.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1400808739.19982.48.camel@debian>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 09:32:19AM +0800, Chen Yucong wrote:
> ...if we reach a timeout, there is very little
> chance for recovering. Thought. the probability for this situation to
> happen is very slight, it's not impossible. Indeed, it's hard to know
> the precise causes for timeout.

Ok, enough talking, let's close that hole and get on with our lives:

---
From: Borislav Petkov <bp@suse.de>
Date: Fri, 23 May 2014 11:06:35 +0200
Subject: [PATCH] mce: Panic when a core has reached a timeout

There is very little and maybe practically nothing we can do to recover
from a system where at least one core has reached a timeout during the
whole monarch cores gathering. So panic when that happens.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bfde4871848f..529ccc488f5a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -704,8 +704,7 @@ static int mce_timed_out(u64 *t)
 	if (!mca_cfg.monarch_timeout)
 		goto out;
 	if ((s64)*t < SPINUNIT) {
-		/* CHECKME: Make panic default for 1 too? */
-		if (mca_cfg.tolerant < 1)
+		if (mca_cfg.tolerant <= 1)
 			mce_panic("Timeout synchronizing machine check over CPUs",
 				  NULL, NULL);
 		cpu_missing = 1;
-- 
1.9.0

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
