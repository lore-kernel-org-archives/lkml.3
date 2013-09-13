Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab3IMS2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729Ab3IMS2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:28:19 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding task->pid and task->tgid]
Date: Fri, 13 Sep 2013 14:28:17 -0400
Message-ID: <3158155.5GaQBOllp8@x2>
Organization: Red Hat
User-Agent: KMail/4.10.5 (Linux/3.10.11-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130908155435.GC4663@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <3996102.evTQ9SbNnV@x2> <20130908155435.GC4663@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, September 08, 2013 05:54:35 PM Oleg Nesterov wrote:
> Sorry for delay, vacation.
> 
> First of all, I do not pretend I understand this code. This was mostly
> the question, and in fact I mostly asked about audit_bprm() in 0/1.
> 
> However,
> 
> On 08/30, Steve Grubb wrote:
> > On Friday, August 30, 2013 03:06:46 PM Richard Guy Briggs wrote:
> > > On Tue, Aug 27, 2013 at 07:11:34PM +0200, Oleg Nesterov wrote:
> > > > Btw. audit looks unmaintained... if you are going to take care of
> > > > this code, perhaps you can look at
> > > > 
> > > > 	http://marc.info/?l=linux-kernel&m=137589907108485
> > > > 	http://marc.info/?l=linux-kernel&m=137590271809664
> > 
> > You don't want to clear the TIF audit flag when context == NULL. What that
> > will do is make a bunch of inauditable processes. There are times when
> > audit is disabled and then re-enabled later. If the flag gets cleared,
> > then a task's syscall will never enter the auditing framework from
> > kernel/entry_64.S.
> > 
> > That flag is 0 when auditing has never ever been enabled. If auditing is
> > enabled, it should always be a 1 unless the task filter has determined
> > that
> > this process should not be audited ever. In practice, this is almost never
> > used. But ensuring the TIF_SYSCALL_AUDIT set to 1 on all processes is why
> > we have the boot argument. Not setting audit=1 on the boot arguments
> > means that any process running before the audit daemon enables auditing
> > can never ever be audited because the only place its set is when
> > processes are cloned.
>
> Then why audit_alloc() doesn't set TIF_SYSCALL_AUDIT unconditionally?

The code I'm looking at does right at the end of the function.


> And I do not understand "when context == NULL" above. Say,
> audit_syscall_entry() does nothing if !audit_context, and nobody except
> copy_process() does audit_alloc(). So why do we need to trigger the audit's
> paths if it is NULL?

Because if you enter the audit framework, that means auditing has been turned 
on at some point in the past, and could be turned back on at some point in the 
future. If auditing has never been enabled, then you never enter the audit 
framework at all. If the context is NULL, then audit is not currently enabled. 

-Steve
