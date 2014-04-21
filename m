Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDUU0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:26:54 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52839 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754445AbaDUU0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:26:52 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        len.brown@intel.com,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/power/hibernate.c: be sure of 'start' is not bigger than 'stop'
Date: Mon, 21 Apr 2014 22:43:10 +0200
Message-ID: <1597133.Gff7RjtQZQ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140421200930.GA9880@amd.pavel.ucw.cz>
References: <53551FCB.3030109@gmail.com> <20140421200930.GA9880@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 10:09:30 PM Pavel Machek wrote:
> On Mon 2014-04-21 21:40:27, Chen Gang wrote:
> > For do_div(), it need 'u64' type, which means the outside must be sure
> > of 'start' is not bigger than 'stop', or it will report warning.
> > 
> > The related warning (with allmodconfig for unicore32):
> > 
> >     CC      kernel/power/hibernate.o
> >   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
> >   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
> > 
> > Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> 
> >  {
> > -	s64 elapsed_centisecs64;
> > +	u64 elapsed_centisecs64;
> >  	int centisecs;
> >  	int k;
> >  	int kps;
> >  
> >  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> > +	if ((s64)elapsed_centisecs64 < 0) {
> > +		printk(KERN_ERR "PM: stop: %llu < start %llu\n",
> > +			timeval_to_ns(stop), timeval_to_ns(start));
> > +		return;
> > +	}
> >  	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
> >  	centisecs = elapsed_centisecs64;
> >  	if (centisecs == 0)
> 
> Quite a lot of code to shut up warning in mostly debugging
> function... is there alternative method of shutting it up? Have you
> seen < 0 values in wild?

No, I don't think so.  This is a purely theoretical problem that never
happens in practice, because all of the callers do the right thing.

Rafael 

