Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaEZEXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:23:16 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:51679 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbaEZEXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:23:15 -0400
Date: Mon, 26 May 2014 00:23:11 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] workqueue: remove the unneeded cpu_relax() in
 __queue_work()
Message-ID: <20140526042311.GA14432@htj.dyndns.org>
References: <1400748257-14165-1-git-send-email-laijs@cn.fujitsu.com>
 <20140522134758.GA5065@htj.dyndns.org>
 <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53Xs91KMdsYCsqM-NNJYtb+byajjc668aiM2vMFBv3JaA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:21:25PM +0800, Lai Jiangshan wrote:
> On Thu, May 22, 2014 at 9:47 PM, Tejun Heo <tj@kernel.org> wrote:
> This is not busy wait, the retry and numa_pwq_tbl() guarantee that
> the retry will get a new pwq (even without cpu_relax()) as the comments says,

Yes, *eventually*.  It's not guaranteed to succeed on the immediate
next try.  This is a busy wait.

> and the refcnt of this new pwq is very very likely non-zero and
> cpu_relax() can't
> increase the probability of non-zero-refcnt. cpu_relax() is useless here.
> 
> It is different from spin_lock() or some other spin code.
> 
> it is similar to the loop of __task_rq_lock() which also guarantees progress.

No, it's not.  __task_rq_lock() *already* sees the updated value to
use for the next time.  Here, we see the old one dead and the new one
is guaranteed to show up pretty soon but we're still busy waiting for
it.

-- 
tejun
