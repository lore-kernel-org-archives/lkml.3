Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaEBOPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbaEBOPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:15:39 -0400
Date: Fri, 2 May 2014 10:15:30 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        eparis@redhat.com, sgrubb@redhat.com, ebiederm@xmission.com
Subject: Re: [PATCH 1/2] namespaces: give each namespace a serial number
Message-ID: <20140502141530.GB24111@madcap2.tricolour.ca>
References: <cover.1398176489.git.rgb@redhat.com>
 <be1358c6da51252cd79c51a51bb30bf157624ccd.1398176489.git.rgb@redhat.com>
 <20140501225116.GB25669@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501225116.GB25669@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/02, Serge E. Hallyn wrote:
> Quoting Richard Guy Briggs (rgb@redhat.com):
> 
> Most of this looks reasonable, but I'm curious about something,
> 
> > +/**
> > + * ns_serial - compute a serial number for the namespace
> > + *
> > + * Compute a serial number for the namespace to uniquely identify it in
> > + * audit records.
> > + */
> > +unsigned int ns_serial(void)
> > +{
> > +	static DEFINE_SPINLOCK(serial_lock);
> > +	static unsigned int serial = 4; /* reserved for IPC, UTS, user, PID */
> > +
> > +	unsigned long flags;
> > +	unsigned int ret;
> > +
> > +	spin_lock_irqsave(&serial_lock, flags);
> > +	do {
> > +		ret = ++serial;
> > +	} while (unlikely(!ret));
> 
> Why exactly are you doing this?  Surely if serial is going to
> wrap around we've got a bigger problem than just wanting go
> bump one more time?

Thanks for catching this.
The code was templated off audit_serial() which tries to solve a
different problem and rolling it is much more likely.  I hadn't noticed
that rollover protection.  However, I *had* thought of making it a long
(which would be the same size on 32-bit arches, but larger on 64-bit)
since a 64-bit system is more likely to roll it out of sheer speed and
resource availability.  But perhaps a long long would be safer.

> > +	spin_unlock_irqrestore(&serial_lock, flags);
> > +
> > +	return ret;
> > +}

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
