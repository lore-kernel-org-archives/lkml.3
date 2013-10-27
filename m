Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3J0WPc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:15:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37949 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3J0WPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:15:31 -0400
Date: Sun, 27 Oct 2013 22:15:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org
Subject: Re: [PATCH] add new prctl for a per process wide close on exec V.3
Message-ID: <20131027221529.GG13318@ZenIV.linux.org.uk>
References: <1382874486-21311-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382874486-21311-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 12:48:06PM +0100, Stefani Seibold wrote:
> This small patch adds a runtime prctl config option for a per process
> "close on exec" without breaking existing code.
> 
> With this feature a developer can decide if the application will pass all non
> "close on exec" file descriptors to a new process or not.
> 
> The mode of the process wide "close on exec" can be set with PR_SET_CLOEXEC and
> PR_GET_CLOEXEC returns the current mode. Mode is one of the following:
> 
> - PR_CLOEXEC_DEFAULT closes only the fd's marked as "close on exec" in
>    the child process, this is the linux default behaviour.
> 
> - PR_CLOEXEC_ONCE closes all fd's expect 0, 1 and 2 which are regular
>    handled as in PR_CLOEXEC_DEFAULT and reset the mode of the child to
>    PR_CLOEXEC_DEFAULT.
> 
> - PR_CLOEXEC_INHERIT is like PR_CLOEXEC_ONCE, but the mode will stay in the
>    child
> 
> STDIO file descriptors will be passed to the child process depending on the
> ..._CLOEXEC flag. So the new modes should be compatible to regular code.
> 
> This patch will increase security since no developers can review all libraries
> which there are using. Also in a team of developers it is not always possible
> to have a full survey over the code which is produced. Or the output of a code
> generators and so one. This patch allows a kind of preventive measures.
> 
> It can also prevent resource occupation. Imagine a long running process (a
> daemon) is execute from the application after open some file desciptors. For
> example libpcsclite.so will not open the socket with SOCK_CLOEXEC. Or a device
> driver which alows only a single open. In both cases the resource cannot
> reopened after a close. Sigh!
> 
> The usage is very simple:
> 
> if (prctl(PR_SET_CLOEXEC, PR_CLOEXEC_INHERIT, 0, 0, 0)) {
> 	perror("PR_SET_CLOEXEC");
> 	exit(1);
> }
> 
> If the prctl PR_SET_CLOEXEC was missused in a library, the caller will
> fail!

NAK.  All your arguments about Big Bad Wolf^WLibrary leaking opened files
through execve() are completely missing that possibility that "proactive"
program using this kludge might be linked against a Big Bad Library that
spawns a process and expects close-on-exec to work as designed.

And if execve() is in your program and under your control and you worry about
library-opened descriptors leaking through execve(), something like
unshare(CLONE_FILES | CLONE_CLOSEALL) before execve() would be a much

