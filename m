Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbaIWOdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:33:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63547 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaIWOdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:33:07 -0400
Date: Tue, 23 Sep 2014 10:33:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Yifan Zhang <zhangyf@marvell.com>
Cc: Jing Xiang <jxiang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yifan.zhangm@gmail.com" <yifan.zhangm@gmail.com>
Subject: Re: [PATCH] workqueue: fix a workqueue kernel panic issue.
Message-ID: <20140923143303.GC19208@htj.dyndns.org>
References: <1410941884-26034-1-git-send-email-zhangyf@marvell.com>
 <4737A960563B524DA805CA602BE04B307EEE6C2694@SC-VEXCH2.marvell.com>
 <20140922033946.GA23583@htj.dyndns.org>
 <4737A960563B524DA805CA602BE04B307EEEA98F6B@SC-VEXCH2.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4737A960563B524DA805CA602BE04B307EEEA98F6B@SC-VEXCH2.marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 03:40:55AM -0700, Yifan Zhang wrote:
> You can tell it is a bug when pwq = get_work_pwq() return NULL, and
> cpu_intensive = pwq->wq->flags use it w/o check.

A bug somewhere else.

> Normally get_work_pwq doesn't return NULL, but we had a bug in code
> which makes INIT_WORK(&work, do_work) is called in multi-thread. In
> some cases, work_struct is re-init just before get_work_pwq is
> called, it makes work_struct->data is invalid and thus causes the
> problem. It is indeed a bug of ourselves, and after fix it there is
> no such issue. But I wonder we still a NULL check before dereference
> pwq here anyway, since get_work_pwq may return NULL in some cases.

Do you realize how timing dependent that particular pattern of
breakage is?  If you're doing INIT_WORK() in racy way, there are many
places which can break in workqueue.  It's not that different from
random memory corruption.  It doesn't make any sense at all to add a
special case code for that in one particular place where this specific
incidence happens to trigger.  In general, don't do things like this
anywhere in the kernel.

Thanks.

-- 
tejun
