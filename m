Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaIQInO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:43:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:22434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaIQInI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:43:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="604050313"
Message-ID: <1410943355.28850.92.camel@sauron.fi.intel.com>
Subject: Re: [RFC] Don'd hold work_sem while calling worker functions
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 11:42:35 +0300
In-Reply-To: <1410873998-2955-1-git-send-email-richard@nod.at>
References: <1410873998-2955-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 15:26 +0200, Richard Weinberger wrote:
> I fail to see why we need work_sem while wrk->func() is executed.
> Artem, do you have an idea?
> 
> Having the wear_leveling_worker() called without work_sem held
> would simplify the fastmap code too. I'm currently reworking some
> of it's code and I'm in locking hell. 8-)

Well, the best way for getting clue about the meaning of an R/W
semaphore with an unlimited amount of read-takers I found for myself is
to focus on the write-takers. Read-takers are non-interesting, because
they can race freely.

So let's check write-takers.

There are 2 of them - one in your code, one in the one I wrote many
years ago.

"Mine" is in 'ubi_wl_flush()':

        down_write(&ubi->work_sem);
        up_write(&ubi->work_sem);

And the only reason it is there is to make sure that flush() really
flushes the queue, and when 'ubi_wl_flush()' returns, you may be sure
that all the in-flight works were finished.

There are other ways to achieve this, but I probably found using the R/W
semaphore to be the easiest. Indeed, just make all the works have it in
read mode, and when you have to wait for all the in-flight works to
complete, you take it in write mode - easy.

IOW, this is a bit of an unusual use of R/W semaphores.

HTH.

P.S. Generally, if you have a trouble with a lock, start with checking
the place where it is defined, I tried to document locks there briefly.
And there may be pices of useful comments elsewhere. This should be true
for both UBI and UBIFS. So just a general hint.

For 'work_sem' you'd need to check ubi.h. But unfortunately, the comment
there is not helpful, and even has a typo which makes it confusing.

While on it, would you refine the comment and say something like:

work_sem: used to wait for all the scheduled works to finish and prevent
new works from being submitted


-- 
Best Regards,
Artem Bityutskiy

