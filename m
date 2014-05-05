Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbaEEVvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 17:51:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56228 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885AbaEEVvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 17:51:40 -0400
Message-ID: <1399326698.2164.47.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 0/2] namespaces: log namespaces per task
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, eparis@redhat.com, sgrubb@redhat.com,
        ebiederm@xmission.com
Date: Mon, 05 May 2014 14:51:38 -0700
In-Reply-To: <20140505214818.GC6867@madcap2.tricolour.ca>
References: <cover.1398176489.git.rgb@redhat.com>
	 <1399154328.2505.29.camel@dabdike.int.hansenpartnership.com>
	 <20140505034814.GA27548@mail.hallyn.com>
	 <20140505214818.GC6867@madcap2.tricolour.ca>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 17:48 -0400, Richard Guy Briggs wrote:
> On 14/05/05, Serge E. Hallyn wrote:
> > Quoting James Bottomley (James.Bottomley@HansenPartnership.com):
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
> > > 
> > > Reading between the lines, I think your goal is to correlate audit
> > > information across a container migration, right?  Ideally the management
> > > system should be able to cough up an audit trail for a container
> > > wherever it's running and however many times it's been migrated?
> > > 
> > > In that case, I think your idea of a numeric serial number in a dense
> > > range is wrong.  Because the range is dense you're obviously never going
> > > to be able to use the same serial number across a migration.  However,
> > 
> > Ah, but I was being silly before, we can actually address this pretty
> > simply.  If we just (for instance) add
> > /proc/self/ns/{ic,mnt,net,pid,user,uts}_seq containing the serial number
> > for the relevant ns for the task, then criu can dump this info at
> > checkpoint.  Then at restart it can dump an audit message per task and
> > ns saying old_serial=%x,new_serial=%x.  That way the audit log reader
> > can if it cares keep track.
> 
> This is the sort of idea I had in mind...

OK, but I don't understand then why you need a serial number.  There are
plenty of things we preserve across a migration, like namespace name for
instance.  Could you explain what function it performs because I think I
might be missing something.

Thanks,

James


> > -serge
> > 
> > (Another, more heavyweight approach would be to track all ns hierarchies
> > and make the serial numbers per-namespace-instance.  So my container's
> > pidns serial might be 0x2, and if it clones a new pidns that would be
> > "(0x2,0x1)" on the host, or just 0x1 inside the container.  But we don't
> > need that if the simple userspace approach suffices)
> 
> This sounds manageable...
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545



