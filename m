Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaIXQiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:38:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49880 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaIXQiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:38:00 -0400
Date: Wed, 24 Sep 2014 16:37:40 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: riya khanna <riyakhanna1983@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [lxc-devel] device namespaces
Message-ID: <20140924163740.GD3865@ubuntumail>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
 <87bnq5vcbl.fsf@x220.int.ebiederm.org>
 <CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isolation is provided by the devices cgroup.  You want something more
than isolation.

Quoting riya khanna (riyakhanna1983@gmail.com):
> My use case for having device namespaces is device isolation. Isn't what
> namespaces are there for (as I understand)? Not everything should be
> accessible (or even visible) from a container all the time (we have seen
> people come up with different use cases for this). However, bind-mounting
> takes away this flexibility. I agree that assigning fixed device numbers is
> clearly not a long-term solution. Emulation for safe and flexible
> multiplexing, like you suggested either using CUSE/FUSE or something like
> devpts, is what I'm exploring.
> 
> On Wed, Sep 24, 2014 at 12:04 AM, Eric W. Biederman <ebiederm@xmission.com>
> wrote:
> 
> > riya khanna <riyakhanna1983@gmail.com> writes:
> >
> > > (Please pardon multiple emails, artifact of merging all separate
> > conversations)
> > >
> > > Thanks for your feedback!
> > >
> > > Letting the kernel know about what devices a container could access
> > (based on
> > > device cgroups) and having devtmpfs in the kernel create device nodes
> > for a
> > > container that map to corresponding CUSE nodes is what I thought of. For
> > > example, "echo 29:0 > /proc/<pid>/devices" would prepare a virtual
> > framebuffer
> > > (based on real fb0 SCREENINFO properties) for this process provided
> > permissions
> > > allow this operation. To view the framebuffer, the CUSE based virtual
> > device
> > > would talk to the actual hardware. Since namespaces would have different
> > view of
> > > the underlying devices, "sysfs" has to made aware of this as well.
> > >
> > > Please let me know your inputs. Thanks again!
> >
> > The solution hugely depends on what you are trying to do with it.
> >
> > The situation today is that device nodes are slowly fading out.  In
> > another 20 years linux may not have any device nodes at all.
> >
> > Therefore the question becomes what are you trying to support.
> >
> > If it is just filtering of existing device nodes.  We can do a pretty
> > good approximation with bind mounts.
> >
> > If you want to emulate a device you can use normal fuse (not cuse).
> > As normal fuse file will support arbitrary ioctls.
> >
> > There are a few cases where it is desirable to emulate what devpts
> > does for allowing arbitrary users to creating virtual devices in the
> > kernel.  Loop devices in particular.
> >
> > Ultimately given the existence of device hotplug I don't see any call
> > for being able to create device nodes with well known device numbers
> > (fundamentally what a device namespace would be about).
> >
> > The conversation last year was about people wanting to multiplex devices
> > that don't have multiplexer support in the kernel.  If that is your
> > desire I think it is entirely reasonable to device type by device type
> > add support for multiplexing that device type to the kernel, or
> > potentially just use fuse or cuse to implement your multiplexer in
> > userspace but that has the potential to be unusably slow.
> >
> > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
