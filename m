Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbaDGSNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 14:13:34 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:57263
	"EHLO hallynmail2" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755051AbaDGSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 14:13:32 -0400
Date: Mon, 7 Apr 2014 20:13:31 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sean Pajot <sean.pajot@execulink.com>,
        lxc-devel@lists.linuxcontainers.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lxc-devel] Kernel bug? Setuid apps and user namespaces
Message-ID: <20140407181331.GA15012@mail.hallyn.com>
References: <5266BEA3.6020008@execulink.com>
 <20131022193718.GA18463@ac100>
 <874n89rsoc.fsf@xmission.com>
 <20140402172049.GA13240@sergelap>
 <20140402173248.GA22804@mail.hallyn.com>
 <533EF65E.6050508@mit.edu>
 <20140404183022.GA6728@sergelap>
 <CALCETrUki+k+NsaAYTbvaUqFTwH_AUDtwLv0XRYx+zA=c3zACw@mail.gmail.com>
 <20140404191000.GA13496@sergelap>
 <CALCETrW-M9QoqzkKyk9gRPLfx1fiTzs8_oAhdK6_kk=17PQc0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW-M9QoqzkKyk9gRPLfx1fiTzs8_oAhdK6_kk=17PQc0Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Fri, Apr 4, 2014 at 12:10 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> On Fri, Apr 4, 2014 at 11:30 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> >> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> >> On 04/02/2014 10:32 AM, Serge E. Hallyn wrote:
> >> >> > (Sorry - the lxc-devel list has moved, so replying to all with the
> >> >> > correct list address;   please reply to this rather than my previous
> >> >> > email)
> >> >> >
> >> >> > Quoting Serge Hallyn (serge.hallyn@ubuntu.com):
> >> >> >> Hi Eric,
> >> >> >>
> >> >> >> (sorry, I don't seem to have the email I actually wanted to reply
> >> >> >> to in my mbox, but it is
> >> >> >> https://lists.linuxcontainers.org/pipermail/lxc-devel/2013-October/005857.html)
> >> >> >>
> >> >> >> You'd said,
> >> >> >>> Someone needs to read and think through all of the corner cases and see
> >> >> >>> if we can ever have a time when task_dumpable is false but root in the
> >> >> >>> container would not or should not be able to see everything.
> >> >> >>>
> >> >> >>> In particular I am worried about the case of a setuid app calling setns,
> >> >> >>> and entering a lesser privileged user namespace.  In my foggy mind that
> >> >> >>> might be a security problem.  And there might be other similar crazy
> >> >> >>> cases.
> >> >> >>
> >> >> >> Can we make use of current->mm->exe_file->f_cred->user_ns?
> >> >> >>
> >> >> >> So either always use
> >> >> >> make_kgid(current->mm->exe_file->f_cred->user_ns, 0)
> >> >> >> instead of make_kuid(cred->user_ns, 0), or check that
> >> >> >> (current->mm->exe_file->f_cred->user_ns == cred->user_ns)
> >> >> >> and, if not, assume that the caller has done a setns?
> >> >>
> >> >> Do you have a summary of the issue?  I'm a little lost here.
> >> >
> >> > Sure - when running an unprivileged container, tasks which become
> >> > !dumpable end up with /proc/$pid/fd/ being owned by the global
> >> > root user, which inside the container is nobody:nogroup.  Examples
> >> > are the user's sshd threads and apache, and in the past I think I've
> >> > seen it with logind or getty too.
> >>
> >> Other than the aesthetics, why does this matter?  Things in the
> >> container who are actually mapped to nobody still can't access those
> >> files?
> >
> > Bc root cannot look at the fds.
> 
> Right.  I guess this is a problem.
> 
> >
> >> The alternative (using the container's owner) sounds a bit scary.
> >
> > If the file being run belongs to the container, why would it be scary?
> > Bc some fds may have been not closed when the task did execve, where
> > the previous bprm file may have been on the host?
> 
> Meh.  I'm not worried about that case, and that one probably doesn't
> cause !dumpable anyway.  The nasty cases are unshare and setns.
> 
> I'm starting to think that we need to extend dumpable to something
> much more general like a list of struct creds that someone needs to be
> able to ptrace, *in addition to current creds* in order to access
> sensitive /proc files, coredumps, etc.  If you get started as setuid,

Hm, yeah, this sort of makes sense.

> then you start with two struct creds in the list (or maybe just your
> euid and uid).  If you get started !setuid, then your initial creds
> are in the list.  It's possible that few or no things will need to
> change that list after execve.
> 
> If all of the entries and current->cred are in the same user_ns, then
> we can dump as userns root.  If they're in different usernses, then we
> dump as global root or maybe the common ancestor root.
> setuid(getuid()) and other such nastiness may have to empty the list,
> or maybe we can just use a prctl for that.

A few questions,

1. is there any other action which would trigger adding a new cred to
the ist?

2. would execve clear (and re-init) the list of creds?

> If this idea works, it would be straightforward to implement, it might
> solve a number of problems.
> 
> --Andy
