Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaARBUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 20:20:52 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:40590 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752041AbaARBUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 20:20:40 -0500
Date: Sat, 18 Jan 2014 01:20:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alan Ott <alan@signal11.us>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: Deadlock in do_page_fault() on ARM (old kernel)
Message-ID: <20140118012034.GM27282@n2100.arm.linux.org.uk>
References: <52D73220.3030108@signal11.us> <20140117134646.GL27282@n2100.arm.linux.org.uk> <52D9D16C.9080501@signal11.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D9D16C.9080501@signal11.us>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 07:57:16PM -0500, Alan Ott wrote:
> On 01/17/2014 08:46 AM, Russell King - ARM Linux wrote:
>> My suspicion therefore is that some other thread must have died while
>> holding the mmap_sem, so there's probably a kernel oops earlier...
>> that's my best guess at the moment without seeing the full backtrace.
>
> There's no oops that I'm able to see.
>
> Each of the tasks which lockdep reports as "holding" mmap_sem are  
> blocking for it. If some other task had taken it and then crashed, I  
> assume lockdep would list the crashed task as also holding the resource  
> in the printout.

My point is this:

- the five (or six) threads which are trying to take the mmap_sem in
  read-mode in the fault handler are all blocked on it - they haven't
  taken the lock, which will only happen because there's a pending writer.
- of these in your original post, there are two which faulted from
  __copy_to_user_std().  __copy_to_user_std() doesn't take the mmap_sem -
  this is the non-uaccess-with-memcpy path.
- the pending writers are the two threads in sys_mmap_pgoff(), both of
  which are blocked waiting to gain the write lock.
- there are no *other* threads holding the mmap_sem lock.

So... there's a question here how we got into this state - and frankly
I don't know.  What I do see from your latest dump is that there's two
unknown modules there - something called rcu2m and another called
buttoms, and there are two threads inside ioctls there.  Both have
faulted from the function at 0xc0d2a394 (which won't appear in the
backtrace, but is most likely __copy_to_user_std.)

So, in the absence of you saying anything about there being any preceding
oopses, my conclusion now is that one of those modules is taking the
mmap_sem itself, and is the culpret inducing this deadlock.

Note that your dump ([2]) in your reply was just the hung task detector
printing out the stacktrace for a few tasks, not the full all-threads
stack dump which I was expecting.

So I'm pulling out these conclusions from the very little information
you're supplying.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
