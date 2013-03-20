Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3CTOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 10:38:38 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:58364 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3CTOih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 10:38:37 -0400
Date: Wed, 20 Mar 2013 07:38:32 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Subject: Re: [PATCHSET wq/for-3.10] workqueue: break up workqueue_lock into
 multiple locks
Message-ID: <20130320143832.GT3042@htj.dyndns.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
 <20130318195136.GG3042@htj.dyndns.org>
 <CAAmzW4N=t=aB194E-B185x1gqTJqNK4XO_diiaJrhjx+CN-_VA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4N=t=aB194E-B185x1gqTJqNK4XO_diiaJrhjx+CN-_VA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Wed, Mar 20, 2013 at 11:01:50PM +0900, JoonSoo Kim wrote:
> 2013/3/19 Tejun Heo <tj@kernel.org>:
> > On Wed, Mar 13, 2013 at 07:57:18PM -0700, Tejun Heo wrote:
> >> and available in the following git branch.
> >>
> >>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-finer-locking
> >
> > Applied to wq/for-3.10.
> 
> Hello, Tejun.
> 
> I know I am late, but, please give me a change to ask a question.
> 
> Finer locking for workqueue code is really needed?
> Is there a performance issue?
> I think that there is too many locks and locking rules,
> although the description about these are very nice.

It isn't about performance.  So, workqueue_lock is broken into three
locks by this series - wq_mutex, pwq_lock and mayday_lock.  The
primary reason for this patchset is wq_mutex.  We want to do blocking
operations while excluding workqueue and pool modifications which
isn't possible with workqueue_lock and at the same time there are
things which can't be protected by a mutex (should be a irq-safe
lock), so we need break up the lock.  After breaking off wq_mutex from
workqueue_lock.  Most stuff covered by workqueue_lock was pwq related
and mayday was the only one-off thing left, so one more lock there,
which I think actually make things easier to digest.

Thanks.

-- 
tejun
