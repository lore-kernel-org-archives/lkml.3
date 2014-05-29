Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbaE2Pcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:32:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40608 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932764AbaE2Pcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:32:42 -0400
Date: Thu, 29 May 2014 15:32:32 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Marian Marinov <mm@1h.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>
Subject: Re: [RFC] Per-user namespace process accounting
Message-ID: <20140529153232.GB9714@ubuntumail>
References: <5386D58D.2080809@1h.com>
 <87tx88nbko.fsf@x220.int.ebiederm.org>
 <53870EAA.4060101@1h.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53870EAA.4060101@1h.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Marian Marinov (mm@1h.com):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 05/29/2014 01:06 PM, Eric W. Biederman wrote:
> > Marian Marinov <mm@1h.com> writes:
> > 
> >> Hello,
> >> 
> >> I have the following proposition.
> >> 
> >> Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that
> >> multiple containers in different user namespaces share the process counters.
> > 
> > That is deliberate.
> 
> And I understand that very well ;)
> 
> > 
> >> So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any 
> >> processes with ist own UID 99.
> >> 
> >> I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps,
> >> but this brings another problem.
> >> 
> >> We are provisioning the containers from a template. The template has a lot of files 500k and more. And chowning
> >> these causes a lot of I/O and also slows down provisioning considerably.
> >> 
> >> The other problem is that when we migrate one container from one host machine to another the IDs may be already
> >> in use on the new machine and we need to chown all the files again.
> > 
> > You should have the same uid allocations for all machines in your fleet as much as possible.   That has been true
> > ever since NFS was invented and is not new here.  You can avoid the cost of chowning if you untar your files inside
> > of your user namespace.  You can have different maps per machine if you are crazy enough to do that.  You can even
> > have shared uids that you use to share files between containers as long as none of those files is setuid.  And map
> > those shared files to some kind of nobody user in your user namespace.
> 
> We are not using NFS. We are using a shared block storage that offers us snapshots. So provisioning new containers is
> extremely cheep and fast. Comparing that with untar is comparing a race car with Smart. Yes it can be done and no, I
> do not believe we should go backwards.
> 
> We do not share filesystems between containers, we offer them block devices.

Yes, this is a real nuisance for openstack style deployments.

One nice solution to this imo would be a very thin stackable filesystem
which does uid shifting, or, better yet, a non-stackable way of shifting
uids at mount.
