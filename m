Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaFCRrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaFCRru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:47:50 -0400
Date: Tue, 3 Jun 2014 17:47:45 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC] Per-user namespace process accounting
Message-ID: <20140603174745.GM9714@ubuntumail>
References: <5386D58D.2080809@1h.com>
 <87tx88nbko.fsf@x220.int.ebiederm.org>
 <53870EAA.4060101@1h.com>
 <20140529153232.GB9714@ubuntumail>
 <538DFF72.7000209@parallels.com>
 <20140603172631.GL9714@ubuntumail>
 <538E0848.6060900@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538E0848.6060900@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pavel Emelyanov (xemul@parallels.com):
> On 06/03/2014 09:26 PM, Serge Hallyn wrote:
> > Quoting Pavel Emelyanov (xemul@parallels.com):
> >> On 05/29/2014 07:32 PM, Serge Hallyn wrote:
> >>> Quoting Marian Marinov (mm@1h.com):
> >>>> -----BEGIN PGP SIGNED MESSAGE-----
> >>>> Hash: SHA1
> >>>>
> >>>> On 05/29/2014 01:06 PM, Eric W. Biederman wrote:
> >>>>> Marian Marinov <mm@1h.com> writes:
> >>>>>
> >>>>>> Hello,
> >>>>>>
> >>>>>> I have the following proposition.
> >>>>>>
> >>>>>> Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that
> >>>>>> multiple containers in different user namespaces share the process counters.
> >>>>>
> >>>>> That is deliberate.
> >>>>
> >>>> And I understand that very well ;)
> >>>>
> >>>>>
> >>>>>> So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any 
> >>>>>> processes with ist own UID 99.
> >>>>>>
> >>>>>> I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps,
> >>>>>> but this brings another problem.
> >>>>>>
> >>>>>> We are provisioning the containers from a template. The template has a lot of files 500k and more. And chowning
> >>>>>> these causes a lot of I/O and also slows down provisioning considerably.
> >>>>>>
> >>>>>> The other problem is that when we migrate one container from one host machine to another the IDs may be already
> >>>>>> in use on the new machine and we need to chown all the files again.
> >>>>>
> >>>>> You should have the same uid allocations for all machines in your fleet as much as possible.   That has been true
> >>>>> ever since NFS was invented and is not new here.  You can avoid the cost of chowning if you untar your files inside
> >>>>> of your user namespace.  You can have different maps per machine if you are crazy enough to do that.  You can even
> >>>>> have shared uids that you use to share files between containers as long as none of those files is setuid.  And map
> >>>>> those shared files to some kind of nobody user in your user namespace.
> >>>>
> >>>> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new containers is
> >>>> extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes it can be done and no, I
> >>>> do not believe we should go backwards.
> >>>>
> >>>> We do not share filesystems between containers, we offer them block devices.
> >>>
> >>> Yes, this is a real nuisance for openstack style deployments.
> >>>
> >>> One nice solution to this imo would be a very thin stackable filesystem
> >>> which does uid shifting, or, better yet, a non-stackable way of shifting
> >>> uids at mount.
> >>
> >> I vote for non-stackable way too. Maybe on generic VFS level so that filesystems 
> >> don't bother with it. From what I've seen, even simple stacking is quite a challenge.
> > 
> > Do you have any ideas for how to go about it?  It seems like we'd have
> > to have separate inodes per mapping for each file, which is why of
> > course stacking seems "natural" here.
> 
> I was thinking about "lightweight mapping" which is simple shifting. Since
> we're trying to make this co-work with user-ns mappings, simple uid/gid shift
> should be enough. Please, correct me if I'm wrong.
> 
> If I'm not, then it looks to be enough to have two per-sb or per-mnt values
> for uid and gid shift. Per-mnt for now looks more promising, since container's
> FS may be just a bind-mount from shared disk.

per-sb would work.  per-mnt would as you say be nicer, but I don't see how it
can be done since parts of the vfs which get inodes but no mnt information
would not be able to figure out the shifts.

> > Trying to catch the uid/gid at every kernel-userspace crossing seems
> > like a design regression from the current userns approach.  I suppose we
> > could continue in the kuid theme and introduce a iiud/igid for the
> > in-kernel inode uid/gid owners.  Then allow a user privileged in some
> > ns to create a new mount associated with a different mapping for any
> > ids over which he is privileged.
> 
> User-space crossing? From my point of view it would be enough if we just turn
> uid/gid read from disk (well, from whenever FS gets them) into uids, that would
> match the user-ns's ones, this sould cover the VFS layer and related syscalls
> only, which is, IIRC stat-s family and chown.
> 
> Ouch, and the whole quota engine :\
> 
> Thanks,
> Pavel
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers
