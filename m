Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaHURTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:19:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660AbaHURTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:19:40 -0400
Date: Thu, 21 Aug 2014 19:17:26 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernel: signal: NULL ptr deref when killing process
Message-ID: <20140821171726.GB27140@redhat.com>
References: <20140820150619.GA12706@redhat.com> <53F48402.4080302@oracle.com> <20140820141252.GA27301@redhat.com> <3200.1408638173@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3200.1408638173@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > David, any other reason why ->real_cred can be NULL ? (assuming that I
> > interpret this asm correctly).
>
> It should only be possible to see ->real_cred as being NULL after exit_creds()
> has been called from __put_task_struct() for a task that has finished
> construction.

Yes, thanks, this was my understanding...

> Is there a race between kill() and exit() brought on by the kill path only
> using the RCU read lock?  This doesn't prevent ->real_cred from being
> modified, but it looks like this should, in combination with
> delayed_put_task_struct(), prevent it from being cleared.

Yes, rcu should protect us from both delayed_put_pid() and delayed_put_task().
Everything looks correct... And there are a lot of other similar users of
find_vpid/find_task_by_vpid/pid_task/etc under rcu, I can't recall any bug
in this area.

I am puzzled. Note also that ->signal == NULL. Will try to think more,
but so far I have no any idea.

Oleg.

