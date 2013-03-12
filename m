Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab3CLUeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:34:24 -0400
Received: from longford.logfs.org ([213.229.74.203]:58663 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab3CLUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:34:22 -0400
Date: Tue, 12 Mar 2013 15:09:55 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: pipe_release oops.
Message-ID: <20130312190955.GB19035@logfs.org>
References: <CA+55aFwDYocNRjSCJk1PYw0MFy7dpKf1yMMEiePP--=ewQcX6A@mail.gmail.com>
 <20130307213819.GB19543@redhat.com>
 <CA+55aFx424SX6S1zFegVaMZ_BkeZctDKCN6eYCLFfaJDKRVG9g@mail.gmail.com>
 <20130307220333.GA31039@redhat.com>
 <20130307223610.GA2494@redhat.com>
 <CA+55aFzdPaFQROzFhz-v1Qn=3aDP=4uGTiOJxR26cR91uJHxyg@mail.gmail.com>
 <20130308145306.GA24085@redhat.com>
 <CA+55aFzwOnRnp2B09fKjt8hd9tOCv44H482z1QpCnYc2mywnpA@mail.gmail.com>
 <20130308182648.GA25175@logfs.org>
 <20130310233318.GC21522@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130310233318.GC21522@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 March 2013 23:33:18 +0000, Al Viro wrote:
> On Fri, Mar 08, 2013 at 01:26:49PM -0500, J??rn Engel wrote:
> 
> > +	files_cookie = async_schedule(exit_files_async, tsk);
> >  	exit_mm(tsk);
> >  
> >  	if (group_dead)
> > @@ -990,7 +998,7 @@ void do_exit(long code)
> >  
> >  	exit_sem(tsk);
> >  	exit_shm(tsk);
> > -	exit_files(tsk);
> > +	async_synchronize_cookie(files_cookie);
> 
> That doesn't do what you seem to think it's doing.  It does *not* wait
> for the completion of that sucker's execution - only the ones scheduled
> before it.  IOW, your exit_files_async() might very well be executed
> *after* do_exit() completes and tsk gets reused.

Indeed.  Maybe async_barrier() would have been a less dangerous name
in the presence of people like me.  Oh well!

I have kernel/async.c on my list anyway.  We've had a number of cases
where a single bad scsi device turned the "do the scanning
asynchronously" idea into a "make completely unrelated stuff
synchonously wait for a broken disk" reality.

Thanks for spotting this!

Jörn

--
The cheapest, fastest and most reliable components of a computer
system are those that aren't there.
-- Gordon Bell, DEC labratories
