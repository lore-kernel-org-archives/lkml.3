Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaEBUuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:50:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:50:08 -0400
Date: Fri, 2 May 2014 20:50:00 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 1/2] namespaces: give each namespace a serial number
Message-ID: <20140502204959.GE2631@ubuntumail>
References: <cover.1398176489.git.rgb@redhat.com>
 <be1358c6da51252cd79c51a51bb30bf157624ccd.1398176489.git.rgb@redhat.com>
 <20140501225116.GB25669@mail.hallyn.com>
 <20140502141530.GB24111@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140502141530.GB24111@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Richard Guy Briggs (rgb@redhat.com):
> On 14/05/02, Serge E. Hallyn wrote:
> > Quoting Richard Guy Briggs (rgb@redhat.com):
> > 
> > Most of this looks reasonable, but I'm curious about something,
> > 
> > > +/**
> > > + * ns_serial - compute a serial number for the namespace
> > > + *
> > > + * Compute a serial number for the namespace to uniquely identify it in
> > > + * audit records.
> > > + */
> > > +unsigned int ns_serial(void)
> > > +{
> > > +	static DEFINE_SPINLOCK(serial_lock);
> > > +	static unsigned int serial = 4; /* reserved for IPC, UTS, user, PID */
> > > +
> > > +	unsigned long flags;
> > > +	unsigned int ret;
> > > +
> > > +	spin_lock_irqsave(&serial_lock, flags);
> > > +	do {
> > > +		ret = ++serial;
> > > +	} while (unlikely(!ret));
> > 
> > Why exactly are you doing this?  Surely if serial is going to
> > wrap around we've got a bigger problem than just wanting go
> > bump one more time?
> 
> Thanks for catching this.
> The code was templated off audit_serial() which tries to solve a
> different problem and rolling it is much more likely.  I hadn't noticed
> that rollover protection.  However, I *had* thought of making it a long
> (which would be the same size on 32-bit arches, but larger on 64-bit)
> since a 64-bit system is more likely to roll it out of sheer speed and
> resource availability.  But perhaps a long long would be safer.

Sounds good, and perhaps a BUG_ON(!serial) for good measure.
