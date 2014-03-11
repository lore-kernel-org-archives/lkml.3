Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaCKVmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 17:42:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbaCKVmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 17:42:19 -0400
Date: Tue, 11 Mar 2014 22:42:16 +0100
From: Jan Kara <jack@suse.cz>
To: David Turner <novalis@novalis.org>
Cc: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Inotify leaks file descriptors.
Message-ID: <20140311214216.GA17702@quack.suse.cz>
References: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daed65ee080e4cc417c87f34af8447f2.squirrel@webmail.novalis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-03-14 14:09:18, David Turner wrote:
> I apologize for the slightly convoluted reproduction steps here,
> but I was not easily able to find a simpler test case in the
> time that I had available.
> 
> First, you'll need Facebook's watchman:
> https://github.com/facebook/watchman
> 
> Build and install it.  Then run the attached Python script.
> After a few hundred lines, you'll start to see errors of the form
> inotify_init error: Too many open files.  That could just
> indicate that watchman is leaking, but I think that's not what's
> going on, because killing watchman does not fix the problem.
  Since opening other files clearly works, what is likely leaking somewhere
is 'inotify_devs' counter - that's a counter of inotify instances per user.
And that leak is likely happening because we leak a fsnotify group
reference count somewhere. Why that happens isn't clear to me but the
refcounting isn't quite simple so some bug seems possible. I guess I'll try
to reproduce this and see.

								Hpnza

> To demonstrate, kill the python script, then kill watchman.
> Then run tail -f /etc/hosts.  You'll get "tail: inotify cannot be
> used, reverting to polling: Too many open files" (you may need to
> run a few tails to see the error).  In fact, the only way I have
> found to get back to normal is to reboot.
> 
> I tried increasing the ulimit to 10000 (from the default 1024).
> The error still happens, but it seems to take a bit longer.
> 
> I have tried on a couple of Ubuntu kernels:
> 
> Linux version 3.11.0-17-generic (buildd@toyol) (gcc version 4.6.3
> (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #31~precise1-Ubuntu SMP Tue Feb 4
> 21:25:43 UTC 2014
> 
> And Ubuntu's 3.8.0-36-generic (it's not running right now so I can't give
> the full version).
> 
> I've also tried a stock kernel built from source (in a virtualbox):
> 
> Linux version 3.13.5 (dturner@dturner-virtualbox) (gcc version 4.8.1
> (Ubuntu/Linaro 4.8.1-10ubuntu8) ) #1 SMP Mon Mar 3 20:41:51 EST 2014
> 
> I get the error on all of these.
> There is no output in dmesg.
> 
> I was running these tests on ext4 filesystems:
> (for the Ubuntu kernels)
> /dev/mapper/stross--vg-root on / type ext4 (rw,errors=remount-ro)
> (for the stock kernel, in the virtualbox)
> /dev/sda1 on / type ext4 (rw,errors=remount-ro)
> 
> Please let me know if you need any more information.
> 
> FWIW, I did find this bug while googling, but it was on older kernels and
> was allegedly fixed:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1101666
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
