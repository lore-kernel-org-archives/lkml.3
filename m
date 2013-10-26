Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3JZLnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 07:43:10 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:33783 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab3JZLnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 07:43:08 -0400
Date: Sat, 26 Oct 2013 13:43:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 3.12.rc4] Oops: unable to handle kernel paging request
 during shutdown
Message-ID: <20131026114303.GA24067@gmail.com>
References: <525BD08C.2080101@t-online.de>
 <CA+55aFwN++wO=rTFaH7m6YYQX+Fv3qDt6Hxs7UnPUJpFsrwSkA@mail.gmail.com>
 <CA+55aFy7TpvkVuPEOJ7Qqirwap1gXoD1_MrYLhgPAYuVpN8u=w@mail.gmail.com>
 <alpine.DEB.2.02.1310251221310.5266@ionos.tec.linutronix.de>
 <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw1Hm4QVeEigkByP5RppSL30oHnLoR16C=henf-a=uFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Oct 25, 2013 at 11:23 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Enable DEBUG_OBJECTS, DEBUG_OBJECTS_FREE, DEBUG_OBJECTS_TIMERS
> 
> Yes, but nobody has actually been able to trigger it with those. 
> It's pretty rare, and the debug options are so expensive that they 
> aren't reasonable to enable generally...
> 
> So we need to try to figure out how to trigger it, or narrow 
> things down some way..

If it's timing then maybe the 1 seconds delay isn't enough 
(especially if it's boot related, where we have a couple of delays 
already) - the patch below triples it.

(If the bug goes away due to some other side effect then this patch 
won't make a difference to reproducability.)

Thanks,

	Ingo

diff --git a/lib/kobject.c b/lib/kobject.c
index 084f7b1..124188f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -595,7 +595,7 @@ static void kobject_release(struct kref *kref)
 	pr_info("kobject: '%s' (%p): %s, parent %p (delayed)\n",
 		 kobject_name(kobj), kobj, __func__, kobj->parent);
 	INIT_DELAYED_WORK(&kobj->release, kobject_delayed_cleanup);
-	schedule_delayed_work(&kobj->release, HZ);
+	schedule_delayed_work(&kobj->release, 3*HZ);
 #else
 	kobject_cleanup(kobj);
 #endif
