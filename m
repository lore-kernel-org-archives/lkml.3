Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3H3Ty5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 15:54:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060Ab3H3Ty4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 15:54:56 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: linux-audit@redhat.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding task->pid and task->tgid]
Date: Fri, 30 Aug 2013 15:54:46 -0400
Message-ID: <3996102.evTQ9SbNnV@x2>
Organization: Red Hat
User-Agent: KMail/4.10.5 (Linux/3.10.9-200.fc19.x86_64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130830190646.GA30331@madcap2.tricolour.ca>
References: <cover.1377032086.git.rgb@redhat.com> <20130827171134.GB29147@redhat.com> <20130830190646.GA30331@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 30, 2013 03:06:46 PM Richard Guy Briggs wrote:
> On Tue, Aug 27, 2013 at 07:11:34PM +0200, Oleg Nesterov wrote:
> > Btw. audit looks unmaintained... if you are going to take care of
> > this code, perhaps you can look at
> > 
> > 	http://marc.info/?l=linux-kernel&m=137589907108485
> > 	http://marc.info/?l=linux-kernel&m=137590271809664

You don't want to clear the TIF audit flag when context == NULL. What that will 
do is make a bunch of inauditable processes. There are times when audit is 
disabled and then re-enabled later. If the flag gets cleared, then a task's 
syscall will never enter the auditing framework from kernel/entry_64.S.

That flag is 0 when auditing has never ever been enabled. If auditing is 
enabled, it should always be a 1 unless the task filter has determined that 
this process should not be audited ever. In practice, this is almost never 
used. But ensuring the TIF_SYSCALL_AUDIT set to 1 on all processes is why we 
have the boot argument. Not setting audit=1 on the boot arguments means that 
any process running before the audit daemon enables auditing can never ever be 
audited because the only place its set is when processes are cloned.

Hope this clears up the use. NAK to the patch, it'll break auditing.

-Steve
