Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaEMSpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbaEMSpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:45:03 -0400
Message-ID: <1400006695.5967.5.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH V2 1/6] namespaces: assign each namespace instance a
 serial number
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, ebiederm@xmission.com, serge@hallyn.com
Date: Tue, 13 May 2014 14:44:55 -0400
In-Reply-To: <1399995045.5967.3.camel@flatline.rdu.redhat.com>
References: <cover.1399681022.git.rgb@redhat.com>
	 <f34b584ffed2538176f9a366e25bb98c531fb70f.1399681022.git.rgb@redhat.com>
	 <1399734119.3558.16.camel@localhost>
	 <20140513143925.GD27560@madcap2.tricolour.ca>
	 <20140513151316.GE27560@madcap2.tricolour.ca>
	 <1399995045.5967.3.camel@flatline.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 11:30 -0400, Eric Paris wrote:
> On Tue, 2014-05-13 at 11:13 -0400, Richard Guy Briggs wrote:
> > On 14/05/13, Richard Guy Briggs wrote:
> > > On 14/05/10, Eric Paris wrote:
> > > > On Fri, 2014-05-09 at 20:27 -0400, Richard Guy Briggs wrote:
> > > > > Generate and assign a serial number per namespace instance since boot.
> > > > > 
> > > > > Use a serial number per namespace (unique across one boot of one kernel)
> > > > > instead of the inode number (which is claimed to have had the right to change
> > > > > reserved and is not necessarily unique if there is more than one proc fs) to
> > > > > uniquely identify it per kernel boot.
> > > > > 
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > > ---
> > > > 
> > > > > +/**
> > > > > + * ns_serial - compute a serial number for the namespace
> > > > > + *
> > > > > + * Compute a serial number for the namespace to uniquely identify it in
> > > > > + * audit records.
> > > > > + */
> > > > > +unsigned long long ns_serial(void)
> > > > > +{
> > > > > +	static DEFINE_SPINLOCK(serial_lock);
> > > > > +	static unsigned long long serial = 4; /* reserved for IPC, UTS, user, PID */
> > > > > +	unsigned long flags;
> > > > > +
> > > > > +	spin_lock_irqsave(&serial_lock, flags);
> > > > > +	++serial;
> > > > > +	spin_unlock_irqrestore(&serial_lock, flags);
> > > > > +	BUG_ON(!serial);
> > > > > +
> > > > > +	return serial;
> > > > > +}
> > > > > +
> > > > >  static inline struct nsproxy *create_nsproxy(void)
> > > > >  {
> > > > >  	struct nsproxy *nsproxy;
> > > > 
> > > > atomic64_t instead of doing it yourself?
> > > 
> > > I'm willing to switch to atomic64_*.  Thanks for pointing out its
> > > existence.
> > 
> > Same would then go for using atomic_t in audit_serial().
> 
> Yup, moving to an atomic in audit_serial() looks like a good idea to me.

Talking with steve on irc, neither of us see a need for the double
increment quirk if the serial wraps back to 0.  Nothing wrong with 0, it
is a number.

-Eric

