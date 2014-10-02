Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbaJBPUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:20:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:46261 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaJBPUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:20:23 -0400
Message-ID: <1412263212.8085.6.camel@debian>
Subject: [PATCH] x86, MCE, AMD: move invariant code out from loop body
From: Chen Yucong <slaoub@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@gmail.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 02 Oct 2014 23:20:12 +0800
In-Reply-To: <20141002143819.GE16452@pd.tnic>
References: <1411377812.1917.112.camel@cyc> <20140922191100.GC4709@pd.tnic>
	 <20141002143819.GE16452@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:38 +0200, Borislav Petkov wrote:
> 
> On Mon, Sep 22, 2014 at 09:11:00PM +0200, Borislav Petkov wrote:
> > On Mon, Sep 22, 2014 at 05:23:32PM +0800, Chen Yucong wrote:
> > >  Hi Boris,
> > > 
> > > I have found the following code snippet in mce_amd.c. 
> > > 
> > > /* cpu init entry point, called from mce.c with preempt off */
> > > void mce_amd_feature_init(struct cpuinfo_x86 *c)
> > > {
> > >         ... ...
> > >         for (bank = 0; bank < mca_cfg.banks; ++bank) {
> > >                 for (block = 0; block < NR_BLOCKS; ++block) {
> > >                         ... ...
> > >                         mce_threshold_block_init(&b, offset);
> > >                         mce_threshold_vector = amd_threshold_interrupt;
> > >                 }
> > >         }
> > > }
> > > 
> > > Why should "mce_threshold_vector = amd_threshold_interrupt" be placed in
> > > the inner loop body?
> > 
> > Yeah, it was added sloppily with b276268631af3, I'm not surprised. Feel
> > free to send a fix.
> 
> do you still want to send a fix or should I fix it up quickly?
> 

From: Chen Yucong <slaoub@gmail.com>
Subject: [PATCH] x86, MCE, AMD: move invariant code out from loop body

"mce_threshold_vector = amd_threshold_interrupt;" is loop invariant code
in mce_amd_feature_init(). So it should be moved out from loop body.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 5d4999f..f727701 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -253,9 +253,10 @@ void mce_amd_feature_init(struct cpuinfo_x86 *c)
 			}
 
 			mce_threshold_block_init(&b, offset);
-			mce_threshold_vector = amd_threshold_interrupt;
 		}
 	}
+
+	mce_threshold_vector = amd_threshold_interrupt;
 }
 
 /*
-- 
1.7.10.4




