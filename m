Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaG2QHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:07:00 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:45874
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaG2QG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:06:59 -0400
Date: Tue, 29 Jul 2014 18:06:56 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Aditya Kali <adityakali@google.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/5] RFC: CGroup Namespaces
Message-ID: <20140729160656.GA6980@mail.hallyn.com>
References: <1405626731-12220-1-git-send-email-adityakali@google.com>
 <20140724163628.GN26600@ubuntumail>
 <CAGr1F2GcAema-E2q6PFj=R0Z505iD7JshrMuMdfPTJ95wMiQMA@mail.gmail.com>
 <20140729045159.GB31047@mail.hallyn.com>
 <CALCETrW5yQLo-SvDgqjt881OD1GnuxMmGKjoohYT4nwtYw=9+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrW5yQLo-SvDgqjt881OD1GnuxMmGKjoohYT4nwtYw=9+w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> On Mon, Jul 28, 2014 at 9:51 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Aditya Kali (adityakali@google.com):
> >> Thank you for your review. I have tried to respond to both your emails here.
> >>
> >> On Thu, Jul 24, 2014 at 9:36 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> >> > Quoting Aditya Kali (adityakali@google.com):
> >> >> Background
> >> >>   Cgroups and Namespaces are used together to create “virtual”
> >> >>   containers that isolates the host environment from the processes
> >> >>   running in container. But since cgroups themselves are not
> >> >>   “virtualized”, the task is always able to see global cgroups view
> >> >>   through cgroupfs mount and via /proc/self/cgroup file.
> >> >>
> >> > Hi,
> >> >
> >> > A few questions/comments:
> >> >
> >> > 1. Based on this description, am I to understand that after doing a
> >> >    cgroupns unshare, 'mount -t cgroup cgroup /mnt' by default will
> >> >    still mount the global root cgroup?  Any plans on "changing" that?
> >>
> >> This is suggested in the "Possible Extensions of CGROUPNS" section.
> >> More details below.
> >>
> >> >    Will attempts to change settings of a cgroup which is not under
> >> >    our current ns be rejected?  (That should be easy to do given your
> >> >    patch 1/5).  Sorry if it's done in the set, I'm jumping around...
> >> >
> >>
> >> Currently, only 'cgroup_attach_task', 'cgroup_mkdir' and
> >> 'cgroup_rmdir' of cgroups outside of cgroupns-root are prevented. The
> >> read/write of actual cgroup properties are not prevented. Usual
> >> permission checks continue to apply for those. I was hoping that
> >> should be enough, but see more comments towards the end.
> >>
> >> > 2. What would be the reprecussions of allowing cgroupns unshare so
> >> >    long as you have ns_capable(CAP_SYS_ADMIN) to the user_ns which
> >> >    created your current ns cgroup?  It'd be a shame if that wasn't
> >> >    on the roadmap.
> >> >
> >>
> >> Its certainly on the roadmap, just that some logistics were not clear
> >> at this time. As pointed out by Andy Lutomirski on [PATCH 5/5] of this
> >> series, if we allow cgroupns creation to ns_capable(CAP_SYS_ADMIN)
> >> processes, we may need some kind of explicit permission from the
> >> cgroup subsystem to allow this. One approach could be an explicit
> >
> > So long as you do ns_capable(cgroup_ns->user_ns, CAP_SYS_ADMIN) I think
> > you're fine.
> >
> > The only real problem I can think of with unsharing a cgroup_ns is that
> > you could lock a setuid-root application someplace it wasn't expecting.
> > The above check guarantees that you were privileged enough that you'd
> > better be trusted in this user namespace.
> >
> > (Unless there is some possible interaction I'm overlooking)
> 
> I think that, if it's done this way, you'd have to unshare cgroupns
> before unsharing userns, since you forfeit that capability when you
> unshare your userns.  That means that the new cgroupns ends up being
> associated w/ the root userns, which may not be what you want.
> 
> You could unshare both namespaces in one syscall and give that some
> magic semantics, but that's kind of weird.  It would be nice if you
> could unshare your userns and temporarily retains caps in the parent,
> but there is no such mechanism right now.

Hm, good point.
