Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab3KFXLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:11:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3KFXLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:11:39 -0500
Date: Wed, 6 Nov 2013 17:12:16 -0600
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Brad Spengler <spender@grsecurity.net>,
        Christian Seiler <christian@iwakd.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>,
        Lxc development list <lxc-devel@lists.sourceforge.net>
Subject: Re: CLONE_PARENT after setns(CLONE_NEWPID)
Message-ID: <20131106231216.GA16974@ac100>
References: <20131106180232.GA8980@ac100>
 <20131106193311.GA18720@redhat.com>
 <87vc05jgak.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc05jgak.fsf@tw-ebiederman.twitter.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > Hi Serge,
> >
> > On 11/06, Serge Hallyn wrote:
> >>
> >> Hi Oleg,
> >>
> >> commit 40a0d32d1eaffe6aac7324ca92604b6b3977eb0e :
> >> "fork: unify and tighten up CLONE_NEWUSER/CLONE_NEWPID checks"
> >> breaks lxc-attach in 3.12.  That code forks a child which does
> >> setns() and then does a clone(CLONE_PARENT).  That way the
> >> grandchild can be in the right namespaces (which the child was
> >> not) and be a child of the original task, which is the monitor.
> 
> Serge that is a clever trick to get around the limitation that we can
> not change the pid namespace of our current process.  Given the
> challenging relaying of signals etc I can see why you would use this.
> 
> At the same time it makes me a little sad to see new users of
> CLONE_PARENT.  With CLONE_THREAD in existence the original reasons for
> CLONE_PARENT are gone now.
> 
> Having used bash as an init process I know it can handle unexpeted
> children.  However using CLONE_PARENT in this way still seems a little
> dodgy.  Or am I misunderstanding why you are using CLONE_PARENT?

FWIW Christian (cc:d from the start) was the author of that code, so he
can correct me if i mis-speak, but IIUC the design is:

1. pid X is the first process running lxc-attach.  It will be a monitor
for the process which is entered into the container

2. pid X forks pid Y, which does setns().  Now if it is setns()ing into
a pidns, it won't itself be in the new pidns, which is not satisfactory.
So

3. pid Y clones pid Z with CLONE_PARENT.  Y exists.  Z continues, as a
full member of the container, and a child of the monitor process.

So yes, as you said it's exactly to work around the fact that pid Y
can't change its own pidns.

-serge
