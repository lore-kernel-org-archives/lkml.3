Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaEaGHV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 02:07:21 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:49371 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaEaGHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 02:07:19 -0400
Date: Sat, 31 May 2014 10:07:13 +0400
From: Vasily Kulikov <segoon@openwall.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
Message-ID: <20140531060713.GA5315@cachalot>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
 <5385DA19.2060008@parallels.com>
 <20140528182824.GA5057@cachalot>
 <53863889.9080509@parallels.com>
 <20140529055954.GA10354@cachalot>
 <5386F8EA.8050501@parallels.com>
 <20140529111236.GA14576@cachalot>
 <53871A92.9000004@parallels.com>
 <20140529115946.GA19889@cachalot>
 <53872DAD.1070502@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53872DAD.1070502@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 16:53 +0400, Pavel Emelyanov wrote:
> On 05/29/2014 03:59 PM, Vasily Kulikov wrote:
> > On Thu, May 29, 2014 at 15:31 +0400, Pavel Emelyanov wrote:
> >> On 05/29/2014 03:12 PM, Vasily Kulikov wrote:
> >>> On Thu, May 29, 2014 at 13:07 +0400, Pavel Emelyanov wrote:
> >>>> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
> >>>>> On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
> >>>>> ] We need a direct method of getting the pid inside containers.
> >>>>> ] If some issues occurred inside container guest, host user
> >>>>> ] could not know which process is in trouble just by guest pid:
> >>>>> ] the users of container guest only knew the pid inside containers.
> >>>>> ] This will bring obstacle for trouble shooting.
> >>>>>
> >>>>> A new syscall might complicate trouble shooting by admin.
> >>>>
> >>>> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
> >>>> info? I think that would help.
> >>>
> >>> I like the idea with low level non-shell API which can be used by
> >>> utility like ps (or implementation of a new tool to work with complex
> >>> namespace hierarchies).  It should fit for troublesooting.  Then there
> >>> should be no reason to implement two different APIs for observation from
> >>> shell via FS and from applications.
> >>
> >> Maybe we can reuse the existing kcmp() system call? We would have to store
> >> the collected pid values in some hash/tree anyway, and kcmp() provides us
> >> good comparing function for doing this.
> >>
> >> Like we can call kcmp(pid1, pid2, KCMP_PID, nsfd1, nsfd2) which will mean
> >> "Are tasks with pid1 in namespace pointed by nsfd1 and with pid2 in namespace
> >> nsfd2 the same?"
> >>
> >> What do you think?
> > 
> > kcmp() is not needed, just compare inode numbers:
> > 
> >     # ls -il /proc/{43,self}/ns/mnt
> >     208182 lrwxrwxrwx 1 root root 0 мая   29 15:52 /proc/43/ns/mnt -> mnt:[4026531856]
> >     216556 lrwxrwxrwx 1 root root 0 мая   29 15:57 /proc/self/ns/mnt -> mnt:[4026531840]
> 
> But that's for comparing the namespaces, while I'm proposing the kcmp to
> check for PIDs.

Hm, right.

What about the following solution: export global process ID (PID in
init ns) which is visible inside of any namespace.  Then you can compare
numbers regardless in what namespace you are.

-- 
Vasily Kulikov
http://www.openwall.com - bringing security into open computing environments
