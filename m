Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbaGWK55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 06:57:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43715 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbaGWK5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 06:57:53 -0400
Date: Wed, 23 Jul 2014 12:57:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140723105750.GB22675@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
 <20140722103443.GV30979@8bytes.org>
 <20140722105812.GB9814@amd.pavel.ucw.cz>
 <20140722121022.GA31450@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722121022.GA31450@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2014-07-22 14:10:22, Joerg Roedel wrote:
> On Tue, Jul 22, 2014 at 12:58:12PM +0200, Pavel Machek wrote:
> > On Tue 2014-07-22 12:34:44, Joerg Roedel wrote:
> > > On Tue, Jul 22, 2014 at 02:41:29AM +0200, Rafael J. Wysocki wrote:
> > > > It looks like some specific need motivated the Joerg's work, however,
> > > > so let's just not dismiss the use case lightly without knowing it.
> > > 
> > > The motivation was to optimize the data structures for machines with
> > > large amounts of RAM without penalizing average machines. On a 12TB
> > > machine you are close to 100000 pages just for one bitmap. Scanning
> > > through that linearly to find a given bit just doesnt scale anymore in
> > > this case.
> > 
> > Can you produce backtrace where 12TB machine spends time during boot
> > with resume= parameter but no suspend image?
> > 
> > AFAICT swsusp_check() does not play with bitmaps.
> 
> I can ask for a backtrace, I currently don't have one. But I have
> perf-data for this case. It also shows that it spends most of its time
> with bitmap operations:
> 
> ~# time perf record /usr/sbin/resume $sdev
> resume: libgcrypt version: 1.5.0
> [ perf record: Woken up 12 times to write data ]
> [ perf record: Captured and wrote 2.882 MB perf.data (~125898
samples) ]

Aha, but that's the userland code... suspend package, resume.c: 

        dev = open(snapshot_dev_name, O_WRONLY);
        if (dev < 0) {
                error = ENOENT;
                goto Free;
        }

        resume_dev = open_resume_dev(resume_dev_name, &swsusp_header);
        if (resume_dev == -ENOMEDIUM) {
                error = 0;
                goto Close;
        } else if (resume_dev < 0) {
                error = -resume_dev;
                goto Close;
        }

What your probably want to do is open_resume_dev first, and only
open(snapshot_dev_name...) if it finds correct signature.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
