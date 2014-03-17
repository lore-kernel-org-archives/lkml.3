Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933526AbaCQOk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:40:27 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:33298 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbaCQOkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:40:24 -0400
Date: Mon, 17 Mar 2014 10:40:20 -0400
From: Tejun Heo <tj@kernel.org>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zento.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        bleung@chromium.org, sonnyrao@chromium.org,
        Luigi Semenzato <semenzato@chromium.org>
Subject: Re: [PATCH] backing_dev: Fix hung task on sync
Message-ID: <20140317144020.GA13749@htj.dyndns.org>
References: <1392437537-27392-1-git-send-email-dbasehore@chromium.org>
 <20140218225548.GI31892@mtj.dyndns.org>
 <20140219092731.GA4849@quack.suse.cz>
 <20140219190139.GQ10134@htj.dyndns.org>
 <CAGAzgspTZnUh_qi=FeQ4hS4LRiexPccTyALMg3Gt1K0ZZq_MuQ@mail.gmail.com>
 <20140316145951.GB26026@htj.dyndns.org>
 <CAGAzgsqD0aRnDMMyDCUVii6Rv22f97G0irpzFBz4c_ukKsn2hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGAzgsqD0aRnDMMyDCUVii6Rv22f97G0irpzFBz4c_ukKsn2hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Mar 16, 2014 at 12:13:55PM -0700, dbasehore . wrote:
> There's already behavior that is somewhat like that with the current
> implementation. If there's an item on a workqueue, it could run at any
> time. From the perspective of the driver/etc. that is using the
> workqueue, there should be no difference between work being on the
> workqueue and the kernel triggering a schedule right after the work is
> removed from the workqueue, but before the work function has done
> anything.

It is different.  mod_delayed_work() *guarantees* that the target work
item will become pending for execution at least after the specified
time has passed.  What you're suggesting removes any semantically
consistent meaning of the API.

> So to reiterate, calling mod_delayed_work on something that is already
> in the workqueue has two behaviors. One, the work is dispatched before
> mod_delayed_work can remove it from the workqueue. Two,
> mod_delayed_work removes it from the workqueue and sets the timer (or
> not in the case of 0). The behavior of the proposed change should be
> no different than the first behavior.

No, mod_delayed_work() does *one* thing - the work item is queued for
the specified delay no matter the current state of the work item.  It
is *guaranteed* that the work item will go pending after the specified
time.  That is the sole meaning of the API.

> This should not introduce new behavior from the perspective of the
> code using delayed_work. It is true that there is a larger window of
> time between when you call mod_delayed_work and when an already queued
> work item will run, but I don't believe that matters.

You're completely misunderstanding the API.  Plesae re-read it and
understand what it does first.

Thanks.

-- 
tejun
