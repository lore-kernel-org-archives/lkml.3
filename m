Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200Ab3E3Euw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 00:50:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab3E3Euq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 00:50:46 -0400
Date: Wed, 29 May 2013 21:50:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
Message-Id: <20130529215005.c91c75de.akpm@linux-foundation.org>
In-Reply-To: <1369872829.22004.129.camel@joe-AO722>
References: <519BC066.5080600@acm.org>
	<20130529160150.f0a498d188dc790d018200e9@linux-foundation.org>
	<1369869467.22004.122.camel@joe-AO722>
	<20130529163813.5f637f04.akpm@linux-foundation.org>
	<1369872829.22004.129.camel@joe-AO722>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013 17:13:49 -0700 Joe Perches <joe@perches.com> wrote:

> On Wed, 2013-05-29 at 16:38 -0700, Andrew Morton wrote:
> > On Wed, 29 May 2013 16:17:47 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > >   We could perhaps have a checkpatch rule
> > > > which looks for comparisons against jiffes (and any other
> > > > time-measuring variables we can detect)
> > > 
> > > other variables like?
> > 
> > Grepping for time_after finds a bunch.  There's no real pattern to it though.
> 
> get_jiffies_64() should probably be added as
> another test too.
> 
> Also, these might be wrong:
> 
> arch/arm/kernel/smp_twd.c:              while (get_jiffies_64() < waitjiffies)
> arch/arm/kernel/smp_twd.c:              while (get_jiffies_64() < waitjiffies)
> fs/fuse/dir.c:  else if (fuse_dentry_time(entry) < get_jiffies_64()) {
> fs/fuse/dir.c:  if (fi->i_time < get_jiffies_64()) {
> fs/fuse/dir.c:          if (fi->i_time < get_jiffies_64()) {
> 

Yup.  Normally a 64-bit jiffy will wrap around shortly after the heat
death of the universe, but

a) it's derived from jiffies, which we evilly cause to wrap after 5
   minutes uptime and

b) it's derived from jiffies, which is 32-bit on 32-bit and hence
   wraps every 49 days (HZ=1000).

