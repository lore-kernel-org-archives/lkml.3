Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaEFX5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 19:57:32 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:34028 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbaEFX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 19:57:30 -0400
Message-ID: <1399420647.11967.24.camel@dabdike>
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, ebiederm@xmission.com
Date: Tue, 06 May 2014 16:57:27 -0700
In-Reply-To: <20140506214129.GC15100@madcap2.tricolour.ca>
References: <cover.1398176489.git.rgb@redhat.com>
	 <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
	 <20140505034814.GA27548@mail.hallyn.com>
	 <20140505214818.GC6867@madcap2.tricolour.ca>
	 <1399326698.2164.47.camel@dabdike.int.hansenpartnership.com>
	 <20140505222758.GA6508@ubuntumail>
	 <1399329001.2164.56.camel@dabdike.int.hansenpartnership.com>
	 <20140505223638.GB6508@ubuntumail>
	 <a09ed85b-d6ef-4472-853b-84057d5957c2@email.android.com>
	 <20140506214129.GC15100@madcap2.tricolour.ca>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 17:41 -0400, Richard Guy Briggs wrote:
> On 14/05/05, James Bottomley wrote:
> > On May 5, 2014 3:36:38 PM PDT, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> > >Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > >> On Mon, 2014-05-05 at 22:27 +0000, Serge Hallyn wrote:
> > >> > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
> > >> > > On Mon, 2014-05-05 at 17:48 -0400, Richard Guy Briggs wrote:
> > >> > > > On 14/05/05, Serge E. Hallyn wrote:
> > >> > > > > Quoting James Bottomley
> > >(James.Bottomley@HansenPartnership.com):
> > >> > > > > > On Tue, 2014-04-22 at 14:12 -0400, Richard Guy Briggs
> > >wrote:
> > >> > > > > > > Questions:
> > >> > > > > > > Is there a way to link serial numbers of namespaces
> > >involved in migration of a
> > >> > > > > > > container to another kernel?  (I had a brief look at
> > >CRIU.)  Is there a unique
> > >> > > > > > > identifier for each running instance of a kernel?  Or at
> > >least some identifier
> > >> > > > > > > within the container migration realm?
> > >> > > > > > 
> > >> > > > > > Are you asking for a way of distinguishing an migrated
> > >container from an
> > >> > > > > > unmigrated one?  The answer is pretty much "no" because the
> > >job of
> > >> > > > > > migration is to restore to the same state as much as
> > >possible.
> > >> > > > > > 
> > >> > > > > > Reading between the lines, I think your goal is to
> > >correlate audit
> > >> > > > > > information across a container migration, right?  Ideally
> > >the management
> > >> > > > > > system should be able to cough up an audit trail for a
> > >container
> > >> > > > > > wherever it's running and however many times it's been
> > >migrated?
> > >> > > > > > 
> > >> > > > > > In that case, I think your idea of a numeric serial number
> > >in a dense
> > >> > > > > > range is wrong.  Because the range is dense you're
> > >obviously never going
> > >> > > > > > to be able to use the same serial number across a
> > >migration.  However,
> > >> > > > > 
> > >> > > > > Ah, but I was being silly before, we can actually address
> > >this pretty
> > >> > > > > simply.  If we just (for instance) add
> > >> > > > > /proc/self/ns/{ic,mnt,net,pid,user,uts}_seq containing the
> > >serial number
> > >> > > > > for the relevant ns for the task, then criu can dump this
> > >info at
> > >> > > > > checkpoint.  Then at restart it can dump an audit message per
> > >task and
> > >> > > > > ns saying old_serial=%x,new_serial=%x.  That way the audit
> > >log reader
> > >> > > > > can if it cares keep track.
> > >> > > > 
> > >> > > > This is the sort of idea I had in mind...
> > >> > > 
> > >> > > OK, but I don't understand then why you need a serial number. 
> > >There are
> > >> > > plenty of things we preserve across a migration, like namespace
> > >name for
> > >> > > instance.  Could you explain what function it performs because I
> > >think I
> > >> > > might be missing something.
> > >> > 
> > >> > We're looking ahead to a time when audit is namespaced, and a
> > >container
> > >> > can keep its own audit logs (without limiting what the host audits
> > >of
> > >> > course).  So if a container is auditing suspicious activity by some
> > >> > task in a sub-namesapce, then the whole parent container gets
> > >migrated,
> > >> > after migration we want to continue being able to correlate the
> > >namespaces.
> > >> > 
> > >> > We're also looking at audit trails on a host that is up for years. 
> > >We
> > >> > would like every namespace to be uniquely logged there.  That is
> > >why
> > >> > inode #s on /proc/self/ns/* are not sufficient, unless we add a
> > >generation
> > >> > # (which would end more complicated, not less, than a serial #).
> > >> 
> > >> Right, but when the contaner has an audit namespace, that namespace
> > >has
> > >> a name,
> > >
> > >What ns has a name?
> > 
> > The netns for instance.
> > 
> > >  The audit ns can be tied to 50 pid namespaces, and
> > >we
> > >want to log which pidns is responsible for something.
> > >
> > >If you mean the pidns has a name, that's the problem...  it does not,
> > >it
> > >only has a inode # which may later be re-use.
> > 
> > I still think there's a miscommunication somewhere: I believe you just
> > need a stable id to tie the audit to, so why not just give the audit
> > namespace a name like net?  The id would then be durable across
> > migrations.
> 
> Audit does not have its own namespace (yet).

So it would make the most sense to do this if audit were a separately
attachable capability the orchestrator would like to control.  I'm not
sure about that so I'll consider some use cases below.

>   That idea is being
> considered, but we would prefer to avoid it if it makes sense to tie it
> in with an existing namespace.  The pid and user namespaces, being
> heierarchical seem to make the most sense so far, but we are proceeding
> very carefully to avoid creating a security nightmare in the process.

pid ns might be.  You need that on almost everything that runs in an OS
like container, but it might not be present for an application.  For an
IaaS container, it doesn't much matter: we attache every namespace.  For
application type containers, it depends.  The lightest weight container
setup is the containerised apache one where you have a shared web
hosting service and you spawn the apache thread into a task cgroup
connected to a mount namespace ... do you need to audit that?  Probably
not; apache has reasonable logging on its own.

The next class of applications is discrete service ones ... annoying
apps that try to bind to 0.0.0.0; you containerise them by placing them
in a net namespace only with their own net device.  Mostly you trust
them to run, you just want to restrict their IP attachment.  Do you want
to audit these ... possibly.

Then there's the fully containerised applications, mostly used for
multi-tenant services.  These often have a net name space (separate IP
devices), a mount namespace (separate data stores) they may have a pid
namespace and they might have a user one (but probably only if the
application needs to run as root) .. they probably need auditing.

Finally, of course, there's the full OS containers with one of every
namespace and cgroup going ... they'll want to appear to run their own
audit daemon (although we can make it a dummy and just pull it into the
host).

> >From the kernel's perspective, none of the namespaces have a name.  A
> container concept of a group of namespaces may have been assigned one,
> but that isn't apparent to the layer that is logging this information.

That's why an audit namespace with a settable prefix looks potentially
interesting: the orchestration system decides what stuff it cares about
being audited separately and slaps it into its own audit namespace.
Stuff you don't care about you leave to the host audit (no separate ns).
It also gets you out of trying to decide which other namespace should be
paired with audit, because now it's fully configurable.

> > >> which CRIU would migrate, so why not use that name for the
> > >> log .. no need for numbers (unless you make the name a number, of
> > >> course)?
> 
> There would certainly need to be a way to tie these namespace
> identifiers to container names in log messages.

Right, and coming from a company that produces orchestration systems all
we really care about is "what's coming out of this entity fred I
configured up yesterday", so we don't care about labelling the
individual namespaces and cgroups, we do care which of them correspond
to fred.  I suppose there are other use cases, though, and I just didn't
notice when people described them.

James


