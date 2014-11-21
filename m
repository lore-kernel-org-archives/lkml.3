Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKUSNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:13:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37003 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaKUSNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:13:37 -0500
Date: Fri, 21 Nov 2014 19:13:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: rui wang <ruiv.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "Wang, Rui Y" <rui.y.wang@intel.com>
Subject: Re: [PATCH v3] x86/mce: Try printing all machine check banks known
 before panic
Message-ID: <20141121181334.GC4274@pd.tnic>
References: <1416388961-24159-1-git-send-email-ruiv.wang@gmail.com>
 <20141119102954.GA5617@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294198E@ORSMSX114.amr.corp.intel.com>
 <20141120101505.GA791@pd.tnic>
 <CANVTcTa++Ef04JSYpfrCVuua5B0Wv=ASyr_H7nfHSQ-vC9GV3Q@mail.gmail.com>
 <20141121164140.GA4274@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3294F888@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:20:53PM +0000, Luck, Tony wrote:
> > leave them in. Then you can read them out again on panic time. The mce
> > log buffer will have to become a circular buffer or something like that.
> 
> This is a mixed bag.  If there are a bunch of errors so that we overflow the buffer,
> then general wisdom says that people want to see the first errors, as the later
> ones may just be secondary effects from the earlier ones.
> 
> But - lots of systems don't run mcelog(8) daemon.  So the buffer just fills
> up with the first 32 errors (perhaps all relatively harmless corrected errors)
> and then when some serious stuff happens we have no place to log :-)

Of course we do - we overwrite the first one. Changing it into a
circular buffer will give us last 32 errors logged.

> Perhaps we need separate buffers for UC=0 and UC=1?  Or something else??

Well, adding yet another arbitrary length buffer of struct mces used in
yet another context scenario doesn't help that either, does it?

This chunk particularly makes me go WTH?!:

+ * All valid error banks seen during MCE are temporarily saved here.
+ * There are multiple components which can report an error. For now
+ * 8 might be enough but it's subject to change in the future.
+ */
+#define MAX_ERRORS     8
+static struct mce banks_saved[MAX_ERRORS];

It sounds to me like we need to go back to the drawing board and analyze
why that thing happens first:

[  177.806166] Kernel panic - not syncing: Machine check from unknown source

Now this comes from mce_reign() which is entered by the CPU which
entered the #MC handler first, according to the comments above it.

So basically it tells me that we want all the MCEs from the last
"round," so to speak, where we had to summon all cores into the indian
clearing of #MC to quickly show each other's wounds :-) :-)

Now, if MCE_LOG_LEN records, aka 32, are not enough because the error
happened at some point in the past, there are two possibilities:

* error got logged into mcelog and is long out to dmesg.

So we go look at dmesg. Not very easy to do when we panic, I know, so we
better make sure we have serial connected.


 [ Btw., we can know when userspace is eating up error data:
   drivers/ras/debugfs.c. If it doesn't, we can then dump it to dmesg.
   We'll have to teach mcelog/ras daemons to open that file so that we
   don't issue to dmesg. ]


* error is not logged yet so still in mcelog and we simply dump it out
to dmesg.

In any case, we cannot have fixed-size buffer for some number of errors
and rely on it always having the error which caused the #MC as something
will consume it at some point anyway.

So maybe if we could get a more detailed explanation of when this thing
happens, then we might address it better.

And also:

        /*
         * No machine check event found. Must be some external
         * source or one CPU is hung. Panic.
         */
        if (global_worst <= MCE_KEEP_SEVERITY && mca_cfg.tolerant < 3)
                mce_panic("Machine check from unknown source", NULL, NULL);

Provided this comment is correct, it doesn't sound like any MCE record
will ever tell us what causes the error as an external source or a hung
CPU doesn't generate an MCE record in any bank, does it?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
