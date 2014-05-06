Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaEFODa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:03:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753731AbaEFOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:03:29 -0400
Date: Tue, 6 May 2014 10:03:20 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
Message-ID: <20140506140320.GG6867@madcap2.tricolour.ca>
References: <cover.1398176489.git.rgb@redhat.com>
 <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
 <20140505214424.GB6867@madcap2.tricolour.ca>
 <20140506033308.GE6508@ubuntumail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506033308.GE6508@ubuntumail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/06, Serge Hallyn wrote:
> Quoting Richard Guy Briggs (rgb@redhat.com):
> > On 14/05/03, James Bottomley wrote:
> > > On Tue, 2014-04-22 at 14:12 -0400, Richard Guy Briggs wrote:
> > > > Questions:
> > > > Is there a way to link serial numbers of namespaces involved in migration of a
> > > > container to another kernel?  (I had a brief look at CRIU.)  Is there a unique
> > > > identifier for each running instance of a kernel?  Or at least some identifier
> > > > within the container migration realm?
> > > 
> > > Are you asking for a way of distinguishing an migrated container from an
> > > unmigrated one?  The answer is pretty much "no" because the job of
> > > migration is to restore to the same state as much as possible.
> > 
> > I hadn't thought to distinguish a migrated container from an unmigrated
> > one, but rather I'm more interested in the underlying namespaces.  The
> > use of a generation number to identify a migrated namespace may be
> > useful along with the logging to tie them together.
> > 
> > > Reading between the lines, I think your goal is to correlate audit
> > > information across a container migration, right?  Ideally the management
> > > system should be able to cough up an audit trail for a container
> > > wherever it's running and however many times it's been migrated?
> > 
> > The original intent was to track the underlying namespaces themselves.
> > This sounds like another layer on top of that which sounds useful but
> > that I had not yet considered.
> > 
> > But yes, that sounds like a good eventual goal.
> 
> Right and we don't need that now, all *I* wanted to convince myself of
> was that a serial # as you were using it was not going to be a roadlbock
> to that, since once we introduce a serial #, we're stuck with that as
> user-space facing api.

Understood.  If a container gets migrated somewhere along with its
namespace, the namespace elsewhere is going to have a new serial number,
but the migration log is going to hopefully show both serial numbers.
If that container gets migrated back, the supporting namespace will get
yet a new serial number, with its log trail connecting the previous
remote one.  Those logs can be used by a higher layer audit aggregator
to piece together those log crumbs.

The serial number was intended to be an alternative to the inode numbers
which had the issues of needing a qualifying device number accompanying
it, plus the reservation that that inode number could change in the
future to solve unforseen technical problems.  I saw no other stable
identifiers common to all namespace types with which I could work.

Containers may have their own names, but I didn't see any consistent way
to identify namespace instances.

> > > In that case, I think your idea of a numeric serial number in a dense
> > > range is wrong.  Because the range is dense you're obviously never going
> > > to be able to use the same serial number across a migration.  However,
> > > if you look at all the management systems for containers, they all have
> > > a concept of some unique ID per container, be it name, UUID or even
> > > GUID.  I suspect it's that you should be using to tag the audit trail
> > > with.
> > 
> > That does sound potentially useful but for the fact that several
> > containers could share one or more types of namespaces.
> > 
> > Would logging just a container ID be sufficient for audit purposes?  I'm
> > going to have to dig a bit to understand that one because I was unaware
> > each container had a unique ID.
> 
> They don't :)

Ok, so I'd be looking in vain...

> > I did originally consider a UUID/GUID for namespaces.
> 
> So I think that apart from resending to address the serial # overflow
> comment, I'm happy to ack the patches.  Then we probably need to convicne
> Eric that we're not torturing kittens.

I've already fixed the overflow issues.  I'll resend with the fixes.

This patch pair was intended to sort out some of my understanding of the
problem I perceived, and has helped me understand there are other layers
that need work too to make it useful, but this is a good base.

A subsequent piece would be to expose that serial number in the proc
filesystem.

> -serge

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
