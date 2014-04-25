Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaDYTv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:51:28 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:33231 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaDYTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:51:10 -0400
MIME-Version: 1.0
In-Reply-To: <87ha5h42va.fsf@x220.int.ebiederm.org>
References: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
 <87ha5h42va.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Apr 2014 12:50:49 -0700
Message-ID: <CALCETrX3GjNkhKkST9Nw4sk2ETt=MRUWcc+bNXnGFTXn7ve-ww@mail.gmail.com>
Subject: Re: pid ns feature request
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 12:37 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> Unless I'm missing some trick, it's currently rather painful to mount
>> a namespace /proc.  You have to actually be in the pid namespace to
>> mount the correct /proc instance, and you can't unmount the old /proc
>> until you've mounted the new /proc.  This means that you have to fork
>> into the new pid namespace before you can finish setting it up.
>
> Yes.  You have to be inside just about all namespaces before you can
> finish setting them up.
>
> I don't know the context in which needed to be inside the pid namespace
> is a burden.

I'm trying to sandbox myself.  I unshare everything, setup up new
mounts, pivot_root, umount the old stuff, fork, and wait around for
the child to finish.

This doesn't work: the parent can't mount the new /proc, and the child
can't either because it's too late.

The only solution I can think of without kernel changes is to fork the
child (pid 1) before pivot_root, which makes everything more
complicated.  I suppose I can unshare, fork immediately, have the
child set up all the mounts, and then wake the parent, but this is an
annoying bit of extra complexity for no obvious gain.

>
>> Would it make sense to add a mount option to procfs to request a mount
>> for pid_ns_for_children instead of task_active_pid_ns?
>
> This is about the using setns and unshare?
>
> Adding a proc amount option that takes a pid namespace file descriptor
> would be the general solution, and might be worth implementing.
>
> Getting a pid namespace file descriptors when there are no pids might be
> a challenge.

Indeed, hence my request for a specific mode to mount /proc for
pid_ns_for_children.

FWIW, I also tried forking, having the child mount /proc and exit,
then forking again later on.  That also doesn't work -- it looks like
you can't recreate pid 1 after it does.

--Andy
