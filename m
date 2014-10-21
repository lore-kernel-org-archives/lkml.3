Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933126AbaJUU3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:29:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49901 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932529AbaJUU3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:29:07 -0400
Date: Tue, 21 Oct 2014 22:28:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: slaoub@gmail.com, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141021202840.GD4420@pd.tnic>
References: <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic>
 <1412138102.21488.20.camel@debian>
 <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com>
 <20141008225750.GH16892@pd.tnic>
 <20141009165339.GA11360@arav-dinar>
 <20141009173529.GC17647@pd.tnic>
 <5436DB72.1090507@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5436DB72.1090507@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 02:01:06PM -0500, Aravind Gopalakrishnan wrote:
> I actually agree with this approach. So no argument:)

Ok, thanks, here's a patch.

Btw, I'm pushing the whole queue to a ras-for-3.19 branch at
https://git.kernel.org/cgit/linux/kernel/git/bp/bp.git if you'd like to
take a look and see whether we haven't forgotten anything before I send
it to tip guys.

Thanks.

---
From: Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, MCE, AMD: Drop software-defined bank in error thresholding

Aravind had the good question about why we're assigning a
software-defined bank when reporting error thresholding errors instead
of simply using the bank which reports the last error causing the
overflow.

Digging through git history, it pointed to

95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")

which added that functionality. The problem with this, however, is that
tools don't know about software-defined banks and get puzzled. So drop
that K8_MCE_THRESHOLD_BASE and simply use the hw bank reporting the
thresholding interrupt.

Save us a couple of MSR reads while at it.

Reported-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Link: https://lkml.kernel.org/r/5435B206.60402@amd.com
Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/mce.h           | 1 -
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 958b90f761e5..276392f121fb 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -78,7 +78,6 @@
 /* Software defined banks */
 #define MCE_EXTENDED_BANK	128
 #define MCE_THERMAL_BANK	(MCE_EXTENDED_BANK + 0)
-#define K8_MCE_THRESHOLD_BASE   (MCE_EXTENDED_BANK + 1)
 
 #define MCE_LOG_LEN 32
 #define MCE_LOG_SIGNATURE	"MACHINECHECK"
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 9af7bd74828b..6606523ff1c1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -318,10 +318,9 @@ static void amd_threshold_interrupt(void)
 
 log:
 	mce_setup(&m);
-	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
-	rdmsrl(address, m.misc);
 	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);
-	m.bank = K8_MCE_THRESHOLD_BASE + bank * NR_BLOCKS + block;
+	m.misc = ((u64)high << 32) | low;
+	m.bank = bank;
 	mce_log(&m);
 
 	wrmsrl(MSR_IA32_MCx_STATUS(bank), 0);
-- 
2.0.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
