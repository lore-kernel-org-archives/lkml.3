Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbaEFOuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:50:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39030 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEFOut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:50:49 -0400
Date: Tue, 6 May 2014 14:50:42 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
Message-ID: <20140506145042.GH6508@ubuntumail>
References: <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
 <20140505034814.GA27548@mail.hallyn.com>
 <20140505214818.GC6867@madcap2.tricolour.ca>
 <1399326698.2164.47.camel@dabdike.int.hansenpartnership.com>
 <20140505222758.GA6508@ubuntumail>
 <1399329001.2164.56.camel@dabdike.int.hansenpartnership.com>
 <20140505223638.GB6508@ubuntumail>
 <a09ed85b-d6ef-4472-853b-84057d5957c2@email.android.com>
 <20140506032732.GD6508@ubuntumail>
 <1399352350.2164.91.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399352350.2164.91.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> On Tue, 2014-05-06 at 03:27 +0000, Serge Hallyn wrote:
> > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > > >> Right, but when the contaner has an audit namespace, that namespace
> > > >has
> > > >> a name,
> > > >
> > > >What ns has a name?
> > > 
> > > The netns for instance.
> > 
> > And what is its name?
> 
> As I think you know ip netns list will show you all of them.  The way

Ah.  Now I see, thanks :)  I never actually use that feature (other
than when debugging how mounts propagation affects how that's implemented)
which is why it completely did not occur to me that this might be what you
meant.

However these names are (a) not in the kernel, (b) not unique per-boot,
and (c) not applicable to other namespaces (without more userspace
tweaking).  So these are not a substitute for what Richard is proposing.

> they're applied is via mapped files in /var/run/netns/ which hold the
> names.
> 
> >   The only name I know that we could log in an
> > audit message is the /proc/self/ns/net inode number (which does not
> > suffice)
> 
> OK, so I think this is the confusion: You're thinking the container
> itself doesn't know what name the namespace has been given by the
> system, all it knows is the inode number corresponding to a file which
> it may or may not be able to see, right?  I'm thinking that the system
> that set up the container gave those files names and usually they're the
> same name for all the namespaces.  The point is that the orchestration
> system (whatever set up the container) will be responsible for the
> migration.  It will be the thing that has a unique handle for the
> container.

(Several things to reply to there but I'll pick just one,)

We are not looking for a unique name for a container, that's far too
coarse.  Within that container there may be many daemons which have
unshared their own namespaces, i.e. cgmanager unshared a mntns,
vsftpd unshared a netns, etc.  We want the namespace identified in
the audit messages.  We want, within an audit record for a system
boot, for each namespace to be *uniquely* identified.  I don't know
how many people are still doing capp/lspp type installs, but that's
the level I'm thinking at for this.  It's not syslog, it's audit.

> The handle is usually ascii representable, either a human
> readable name or some uuid/guid.  It's that handle that we should be
> using to prefix the audit message, so when you set up an audit
> namespace, it gets supplied with a prefix string corresponding to the
> well known name for the container.  This is the string we'd preserve
> across migration as part of the audit namespace state ... so the audit
> messages all correlate to the container wherever it's migrated to; no
> need to do complex tracking of changes to serial numbers.
> 
> > > >  The audit ns can be tied to 50 pid namespaces, and
> > > >we
> > > >want to log which pidns is responsible for something.
> > > >
> > > >If you mean the pidns has a name, that's the problem...  it does not,
> > > >it
> > > >only has a inode # which may later be re-use.
> > > 
> > > I still think there's a miscommunication somewhere: I believe you just need a stable id to tie the audit to, so why not just give the audit namespace a name like net?  The id would then be durable across migrations.
> > 
> > Maybe this is where we're confusing each other - I'm not talking
> > about giving the audit ns a name.  I'm talking about being able to
> > identify the other namespaces inside an audit message.  In a way
> > that (a) is unique across bare metals' entire uptime, and (b)
> > can be tracked across migrations.
> 
> OK, so that is different from what I'm thinking.  I'm thinking unique
> name for migrateable entity, you want a unique name for each component
> of the migrateable entity?  My instinct still tells me the orchestration
> system is going to have a unique identifier for each different sub
> container.
> 
> However, I have to point out that a serial number isn't what you want
> either if you really mean bare metal.  We do a lot of deployments where
> the containers run in a hypervisor, there the serial numbers won't be
> unique per box (only per vm) and we'll have to do vm correlation
> separately.  whereas a scheme which allows the orchestration system to
> supply the names would still be unique in that situation.
> 
> James
> 
> 
