Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaEEV3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756403AbaEEV3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:29:14 -0400
Date: Mon, 5 May 2014 17:29:05 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
Message-ID: <20140505212905.GA6867@madcap2.tricolour.ca>
References: <cover.1398176489.git.rgb@redhat.com>
 <20140501223212.GA25669@mail.hallyn.com>
 <20140502142851.GC24111@madcap2.tricolour.ca>
 <20140502210044.GF2631@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502210044.GF2631@ubuntumail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/02, Serge Hallyn wrote:
> Quoting Richard Guy Briggs (rgb@redhat.com):
> > On 14/05/02, Serge E. Hallyn wrote:
> > > Quoting Richard Guy Briggs (rgb@redhat.com):
> > > > I saw no replies to my questions when I replied a year after Aris' posting, so
> > > > I don't know if it was ignored or got lost in stale threads:
> > > >         https://www.redhat.com/archives/linux-audit/2013-March/msg00020.html
> > > >         https://www.redhat.com/archives/linux-audit/2013-March/msg00033.html
> > > > 	(https://lists.linux-foundation.org/pipermail/containers/2013-March/032063.html)
> > > >         https://www.redhat.com/archives/linux-audit/2014-January/msg00180.html
> > > > 
> > > > I've tried to answer a number of questions that were raised in that thread.
> > > > 
> > > > The goal is not quite identical to Aris' patchset.
> > > > 
> > > > The purpose is to track namespaces in use by logged processes from the
> > > > perspective of init_*_ns.  The first patch defines a function to list them.
> > > > The second patch provides an example of usage for audit_log_task_info() which
> > > > is used by syscall audits, among others.  audit_log_task() and
> > > > audit_common_recv_message() would be other potential use cases.
> > > > 
> > > > Use a serial number per namespace (unique across one boot of one kernel)
> > > > instead of the inode number (which is claimed to have had the right to change
> > > > reserved and is not necessarily unique if there is more than one proc fs).  It
> > > > could be argued that the inode numbers have now become a defacto interface and
> > > > can't change now, but I'm proposing this approach to see if this helps address
> > > > some of the objections to the earlier patchset.
> > > > 
> > > > There could also have messages added to track the creation and the destruction
> > > > of namespaces, listing the parent for hierarchical namespaces such as pidns,
> > > > userns, and listing other ids for non-hierarchical namespaces, as well as other
> > > > information to help identify a namespace.
> > > > 
> > > > There has been some progress made for audit in net namespaces and pid
> > > > namespaces since this previous thread.  net namespaces are now served as peers
> > > > by one auditd in the init_net namespace with processes in a non-init_net
> > > > namespace being able to write records if they are in the init_user_ns and have
> > > > CAP_AUDIT_WRITE.  Processes in a non-init_pid_ns can now similarly write
> > > > records.  As for CAP_AUDIT_READ, I just posted a patchset to check capabilities
> > > > of userspace processes that try to join netlink broadcast groups.
> > > > 
> > > > 
> > > > Questions:
> > > > Is there a way to link serial numbers of namespaces involved in migration of a
> > > > container to another kernel?  (I had a brief look at CRIU.)  Is there a unique
> > > > identifier for each running instance of a kernel?  Or at least some identifier
> > > > within the container migration realm?
> > > 
> > > Eric Biederman has always been adamantly opposed to adding new namespaces
> > > of namespaces, so the fact that you're asking this question concerns me.
> > 
> > I have seen that position and I don't fully understand the justification
> > for it other than added complexity.
> > 
> > One way that occured to me to be able to identify a kernel instance was
> > to look at CPU serial numbers or other CPU entity intended to be
> > globally unique, but that isn't universally available.
> 
> That's one issue, which is uniqueness of namespaces cross-machines.
> 
> But it gets worse if we consider that after allowing in-container audit,
> we'll have a nested container running, then have the parent container
> migrated to another host (or just checkpointed and restarted);  Now the
> nexted container's indexes will all be changed.  Is there any way audit
> can track who's who after the migration?

Presumably the namespace serial numbers before and after would be logged
in one message to tie them together.

> That's not an indictment of the serial # approach, since (a) we don't
> have in-container audit yet and (b) we don't have c/r/migration of nested
> containers.  But it's worth considering whether we can solve the issue
> with serial #s, and, if not, whether we can solve it with any other
> approach.
> 
> I guess one approach to solve it would be to allow userspace to request
> a next serial #.  Which will immediately lead us to a namespace of serial
> #s (since the requested # might be lower than the last used one on the
> new host).

:P

> As you've said inode #s for /proc/self/ns/* probably aren't sufficiently
> unique, though perhaps we could attach a generation # for the sake of
> audit.  Then after a c/r/migration the generation # may be different,
> but we may have a better shot at at least using the same ino#.

A generation number is an interesting idea.  Would it get incremented
every time a namespace is c/r/migrated?  Or just if there is a conflict?

Same ino#?  Or same sn?

> > - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
