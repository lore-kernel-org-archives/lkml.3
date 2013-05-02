Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763824Ab3ECW6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 18:58:15 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37031 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756855Ab3ECW6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 18:58:14 -0400
Date: Thu, 2 May 2013 12:52:33 -0700
From: Matt Helsley <matthltc@linux.vnet.ibm.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Colin Cross <ccross@android.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matthew Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 07/10] futex: use freezable blocking call
Message-ID: <20130502195233.GC24627@us.ibm.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-8-git-send-email-ccross@android.com>
 <517EF9AB.8080508@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <517EF9AB.8080508@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050322-5806-0000-0000-000020FF0CA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 03:52:27PM -0700, Darren Hart wrote:
> Colin,
> 
> I don't know anything about when or when not to use freezable*, and I
> suspect that may be true for others as well. A more complete
> description of why it's acceptable here in the commit log might help
> expedite acceptance.
> 
> 
> Matt,
> 
> I have a vague memory of discussing something similar to this with you.
> Do you see any potential problems here?

Re: vague memories: We discussed futexes in the context of the old
checkpoint/restart patch series (<= 2.6.32).

This change looks correct to me.

> --
> Darren
> 
> On 04/29/2013 02:45 PM, Colin Cross wrote:
> > Avoid waking up every thread sleeping in a futex_wait call during
> > suspend and resume by calling a freezable blocking call.

(in addition to suspend/resume: freeze/thaw via the cgroup freezer.
I'm going to call it freeze/thaw since that should cover both cases..)

Here's my shot at explaining what I *think* the commit is supposed fix:

I imagine that before this patch on a highly-contended futex there
could be a thundering herd during freeze/thaw -- the wakeups are
*likely* to be painful because lots of tasks could be woken from the
schedule() call by the freezer only to find that the futex state hasn't
changed.

With this change the freezer won't wake these tasks up because the
FREEZER_SKIP flag is set while in the schedule() call and thus the
thundering herd won't be triggered by the freezer.

Cheers,
	-Matt Helsley

