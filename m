Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394AbaBKQuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 11:50:44 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44681 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKQuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:50:39 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0
Date: Tue, 11 Feb 2014 11:49:58 -0500
Message-Id: <1392137400-4205-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20140211121411.GA4368@infradead.org>
References: <20140211121411.GA4368@infradead.org>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2014 07:14 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 10, 2014 at 09:15:42PM -0500, Peter Hurley escreveu:
>>> Bisected it down to:
>
>>> eb3e4668bd9e0bbda592e830e889f137e44ec9e4 is the first bad commit
>>> Author: Peter Hurley <peter@hurleysoftware.com>
>>> Date:   Mon Dec 2 14:24:42 2013 -0500
>
>>>      n_tty: Un-inline slow-path n_tty_receive_char()
>
>>> In a hurry now, will continue later, trying to understand what is the problem
>>> introduced by the above cset...
>
>>> Need to revert just this one to confirm that it is the culprit, etc.
>
>> Thanks for the report and bisect. Seems unlikely this commit is the
>> cause, but very likely to be some change I made since 3.13, since
>> I can repro on 3.14-rc1 but not on 3.13.2 -stable. I can also repro
>> this on 3.12 + the patch stack from me for 3.13 and 3.14.
>
>> I'm looking into this now.
>
> I just reverted just this cset and the problem persisted, so I'll wait
> for you on this one :-) 

My bisection pointed to:

eafbe67f84761d787802e5113d895a316b6292fe is the first bad commit
commit eafbe67f84761d787802e5113d895a316b6292fe
Author: Peter Hurley <peter@hurleysoftware.com>
Date:   Mon Dec 2 14:24:45 2013 -0500

    n_tty: Refactor input_available_p() by call site

Apologies for the breakage; the patch below should fix it.

Regards,
Peter Hurley

--- >% ---
From: Peter Hurley <peter@hurleysoftware.com>
Date: Tue, 11 Feb 2014 10:10:07 -0500
Subject: [PATCH] n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0

Commit eafbe67f84761d787802e5113d895a316b6292fe,
  n_tty: Refactor input_available_p() by call site
broke poll() when TIME_CHAR(tty) and MIN_CHAR(tty) are both 0.

When TIME_CHAR and MIN_CHAR are both 0, input is available if the
read_cnt is 1 (not 0).

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index cb8017a..2747a3b 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1896,7 +1896,7 @@ err:
 static inline int input_available_p(struct tty_struct *tty, int poll)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int amt = poll && !TIME_CHAR(tty) ? MIN_CHAR(tty) : 1;
+	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
 
 	if (ldata->icanon && !L_EXTPROC(tty)) {
 		if (ldata->canon_head != ldata->read_tail)
-- 
1.8.1.2

