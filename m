Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaKKN2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:28:33 -0500
Received: from mga03.intel.com ([134.134.136.65]:54068 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaKKN2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:28:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,361,1413270000"; 
   d="scan'208";a="605924645"
Message-ID: <1415712477.22887.172.camel@sauron.fi.intel.com>
Subject: Re: [PATCH V6] UBI: Extend UBI layer debug/messaging capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 11 Nov 2014 15:27:57 +0200
In-Reply-To: <5462003C.9090509@nod.at>
References: <1415023112-21704-1-git-send-email-tlinder@codeaurora.org>
		 <5460F7D8.2030100@nod.at> <5461C5AD.5040705@nod.at>
	 <1415707434.22887.158.camel@sauron.fi.intel.com> <5462003C.9090509@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-11 at 13:25 +0100, Richard Weinberger wrote:
> Am 11.11.2014 um 13:03 schrieb Artem Bityutskiy:
> > On Tue, 2014-11-11 at 09:15 +0100, Richard Weinberger wrote:
> >>> Do we really want the function name in every log message?
> >>> IMHO this is not wise except for pure debug logs.
> >>
> >> BTW: Why UBI-X? This looks odd. Either use UBIX or ubiX.
> > 
> > How about something like this (untested):
> > 
> > 
> > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > Date: Tue, 11 Nov 2014 13:56:34 +0200
> > Subject: [PATCH] UBI: clean-up printing helpers
> > 
> > Let's prefix UBI messages with 'ubiX' instead of 'UBI-X' - this is more
> > consistent with the way we name UBI devices.
> > 
> > Also, commit "32608703 UBI: Extend UBI layer debug/messaging capabilities"
> > added the function name print to 'ubi_msg()' - lets revert this change, since
> > these messages are supposed to be just informative messages, and not debugging
> > messages.
> 
> What is the benefit of having the function name still in ubi_warn() and ubi_err()?

The benefit is that it is easier to find the source code where the
message comes from. And not necessarily because the message is
"cryptic", but because you may want to check the possible reasons of the
problem from the code.

> e.g.
> [   95.511825] ubi0 error: ubi_attach_mtd_dev: mtd0 is already attached to ubi0
> 
> If the log message is so cryptic that you need to lookup it in the source to understand it,
> we better fix the message.

UBI messages are usually not cryptic, and I think we did try to keep
them user-friendly. If you hit a cryptic error or warning message, do
not hesitate to improve it please. Debug messages are often cryptic.

I am OK with removing function names from warnings and errors, though.
But they were there since the very beginning, and changing this is a
separate subject, so I'd prefer someone else to submit a corresponding
patch.

> > -#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
> > -					 ubi->ubi_num, __func__, ##__VA_ARGS__)
> > +#define ubi_msg(ubi, fmt, ...) pr_notice("ubi%d: " fmt "\n", \
> > +					 ubi->ubi_num, ##__VA_ARGS__)
> 
> We could even use UBI_NAME_STR here. :-)

OK, how about this (untested)

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Date: Tue, 11 Nov 2014 13:56:34 +0200
Subject: [PATCH v2] UBI: clean-up printing helpers

Let's prefix UBI messages with 'ubiX' instead of 'UBI-X' - this is more
consistent with the way we name UBI devices.

Also, commit "32608703 UBI: Extend UBI layer debug/messaging capabilities"
added the function name print to 'ubi_msg()' - lets revert this change, since
these messages are supposed to be just informative messages, and not debugging
messages.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 drivers/mtd/ubi/ubi.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f80ffab..ee7ac0b 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -50,13 +50,13 @@
 #define UBI_NAME_STR "ubi"
 
 /* Normal UBI messages */
-#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
-					 ubi->ubi_num, __func__, ##__VA_ARGS__)
+#define ubi_msg(ubi, fmt, ...) pr_notice(UBI_NAME_STR "%d: " fmt "\n", \
+					 ubi->ubi_num, ##__VA_ARGS__)
 /* UBI warning messages */
-#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
+#define ubi_warn(ubi, fmt, ...) pr_warn(UBI_NAME_STR "%d warning: %s: " fmt "\n", \
 					ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI error messages */
-#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
+#define ubi_err(ubi, fmt, ...) pr_err(UBI_NAME_STR "%d error: %s: " fmt "\n", \
 				      ubi->ubi_num, __func__, ##__VA_ARGS__)
 
 /* Background thread name pattern */
-- 
1.9.3




