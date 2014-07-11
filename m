Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaGKJZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:25:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42474 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbaGKJZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:25:06 -0400
Date: Fri, 11 Jul 2014 11:24:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 4/6] x86-mce: Add spinlocks to prevent duplicated MCP and
 CMCI reports.
Message-ID: <20140711092454.GA17083@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-5-git-send-email-hskinnemoen@google.com>
 <20140710164151.GA5603@pd.tnic>
 <CAFQmdRbguE7O16diTNMXMU-3E8Zeu=Y=vcXVHKRyxzbq09TfzQ@mail.gmail.com>
 <20140710184416.GE5603@pd.tnic>
 <CA+8MBbKNQEk5UQnVf-G8zeMiYE2FpyztHE6_RoDs3RM_8mrVow@mail.gmail.com>
 <20140710191224.GF5603@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140710191224.GF5603@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:12:24PM +0200, Borislav Petkov wrote:
> I'll think about it more tomorrow - my brain is twisted enough for
> today. :-)

Ok, new day, new luck. :-)

So, following yesterday's discussion, our problem is IMHO that shared
banks could be read multiple times before they're finally cleared,
leading to repeated MCE records.

Now, staring at machine_check_poll, the processing is controlled by one
bit - MCI_STATUS_VAL - which decides what happens next.

So how about we change processing around this one bit: we let only one
reader access MSR_IA32_MCx_STATUS(i) and clear it right afterwards by
saving its contents to m.status previously.

Concurrent callers of machine_check_poll will not read the MCI_STATUS
MSR and since they look at the local copy m.status which is 0, they'll
go to the next bank.

And this for the cost of a locked CMPXCHG when we have to inc
poll_reader which should be cheaper than disabling IRQs everytime.

I.e., something like that. Hmm...

---
diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
index 09edd0b65fef..5483b507025a 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
@@ -19,6 +19,7 @@ struct mce_bank {
 	unsigned char init;				/* initialise bank? */
 	struct device_attribute attr;			/* device attribute */
 	char			attrname[ATTR_LEN];	/* attribute name */
+	atomic_t		poll_reader;		/* sync for polled shared banks */
 };
 
 int mce_severity(struct mce *a, int tolerant, char **msg);
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index bb92f38153b2..443861da86e4 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -609,9 +609,20 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		m.addr = 0;
 		m.bank = i;
 		m.tsc = 0;
+		m.status = 0;
 
 		barrier();
-		m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+
+		if (atomic_add_unless(&mce_banks[i].poll_reader, 1, 1)) {
+			m.status = mce_rdmsrl(MSR_IA32_MCx_STATUS(i));
+
+			if (m.status & MCI_STATUS_VAL)
+				/* clear status register for this bank */
+				mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
+
+			atomic_dec(&mce_banks[i].poll_reader);
+		}
+
 		if (!(m.status & MCI_STATUS_VAL))
 			continue;
 
@@ -637,17 +648,12 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		if (!(flags & MCP_DONTLOG) && !mca_cfg.dont_log_ce)
 			mce_log(&m);
 
-		/*
-		 * Clear state for this bank.
-		 */
-		mce_wrmsrl(MSR_IA32_MCx_STATUS(i), 0);
 	}
 
 	/*
 	 * Don't clear MCG_STATUS here because it's only defined for
 	 * exceptions.
 	 */
-
 	sync_core();
 }
 EXPORT_SYMBOL_GPL(machine_check_poll);



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
