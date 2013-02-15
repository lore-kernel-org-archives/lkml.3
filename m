Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922Ab3BOB6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 20:58:24 -0500
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:34657 "HELO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759880Ab3BOB6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 20:58:23 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Feb 2013 20:58:23 EST
Message-ID: <511D94DB.3050805@miraclelinux.com>
Date: Fri, 15 Feb 2013 10:52:27 +0900
From: Naohiro Ooiwa <naohiro.ooiwa@miraclelinux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Kurt Garloff <garloff@suse.de>,
        Roberto Angelino <robertangelino@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, mingo@kernel.org
Subject: [PATCH] clear IOCK NMI before panic
References: <511C8084.9000604@miraclelinux.com>
In-Reply-To: <511C8084.9000604@miraclelinux.com>
X-Forwarded-Message-Id: <511C8084.9000604@miraclelinux.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I tried to push an NMI button on HP DL380p Gen8's iLO4.
and then I received an IOCK NMI error.
When panic_on_io_nmi is set to 0, it seems that IOCK NMI error is sent repeatedly.

In case of panic_on_io_nmi=1 and kdump is available,
the second kernel started. But IOCK NMI is sent repeatedly
and second kernel couldn't take a dump.

Though this is just my guess,
We should clear the IOCK of NMI reason before panic().

I tried to create a patch, which works for me.
Is my patch reasonable?


Thanks you.
Naohiro Ooiwa


Signed-off-by: Naohiro Ooiwa <naohiro.ooiwa@miraclelinux.com>
---
 arch/x86/kernel/nmi.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
index f84f5c5..c3cbfbe 100644
--- a/arch/x86/kernel/nmi.c
+++ b/arch/x86/kernel/nmi.c
@@ -209,8 +209,11 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 		 reason, smp_processor_id());
 	show_regs(regs);

-	if (panic_on_io_nmi)
+	if (panic_on_io_nmi) {
+		reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
+		outb(reason, NMI_REASON_PORT);
 		panic("NMI IOCK error: Not continuing");
+	}

 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & NMI_REASON_CLEAR_MASK) | NMI_REASON_CLEAR_IOCHK;
-- 
1.7.10.4





