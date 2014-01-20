Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaATX6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:58:24 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44015 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751937AbaATX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:58:22 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 18:58:22 EST
X-Sasl-enc: L9rwTjEXrZLEF1/CU15Lg6WMoQnnvOrlGuavrbTp/Bj5 1390261853
Message-ID: <52DDB65D.9060300@signal11.us>
Date: Mon, 20 Jan 2014 18:50:53 -0500
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: Deadlock in do_page_fault() on ARM (old kernel)
References: <52D73220.3030108@signal11.us> <20140117134646.GL27282@n2100.arm.linux.org.uk> <52D9D16C.9080501@signal11.us> <20140118012034.GM27282@n2100.arm.linux.org.uk>
In-Reply-To: <20140118012034.GM27282@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 08:20 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 17, 2014 at 07:57:16PM -0500, Alan Ott wrote:
>> On 01/17/2014 08:46 AM, Russell King - ARM Linux wrote:
>>> My suspicion therefore is that some other thread must have died while
>>> holding the mmap_sem, so there's probably a kernel oops earlier...
>>> that's my best guess at the moment without seeing the full backtrace.
>> There's no oops that I'm able to see.
>>
>> Each of the tasks which lockdep reports as "holding" mmap_sem are
>> blocking for it. If some other task had taken it and then crashed, I
>> assume lockdep would list the crashed task as also holding the resource
>> in the printout.
> My point is this:
>
> - the five (or six) threads which are trying to take the mmap_sem in
>    read-mode in the fault handler are all blocked on it - they haven't
>    taken the lock, which will only happen because there's a pending writer.
> - of these in your original post, there are two which faulted from
>    __copy_to_user_std().  __copy_to_user_std() doesn't take the mmap_sem -
>    this is the non-uaccess-with-memcpy path.
> - the pending writers are the two threads in sys_mmap_pgoff(), both of
>    which are blocked waiting to gain the write lock.
> - there are no *other* threads holding the mmap_sem lock.

Yes, all true. I don't remember why I started looking at the memcpy() case.

> So... there's a question here how we got into this state - and frankly
> I don't know.  What I do see from your latest dump is that there's two
> unknown modules there - something called rcu2m and another called
> buttoms, and there are two threads inside ioctls there.  Both have
> faulted from the function at 0xc0d2a394 (which won't appear in the
> backtrace, but is most likely __copy_to_user_std.)

Yes, there are a handful of out-of-tree modules.

> So, in the absence of you saying anything about there being any preceding
> oopses, my conclusion now is that one of those modules is taking the
> mmap_sem itself, and is the culpret inducing this deadlock.

Yes, I came to that as well. I had checked for the presence of mmap_sem 
in the sources of the out-of-tree modules and didn't see it. However, 
upon closer inspection, my grep-fu failed me as there were some backward 
symlinks I didn't account for. TI's cmemk module _is_ taking out 
mmap_sem. I wish I had seen this days ago. That's my new investigation path.

> Note that your dump ([2]) in your reply was just the hung task detector
> printing out the stacktrace for a few tasks, not the full all-threads
> stack dump which I was expecting.

Yes, in a misguided attempt to keep the SNR high, I didn't include the 
full dump, but only what I thought was the interesting part. I did 
another capture and the full dump is at [1] .

> So I'm pulling out these conclusions from the very little information
> you're supplying.

I appreciate it. Thank you for taking the time to reply.

Alan.

[1] 
http://www.signal11.us/~alan/stack_dump_all_tasks_with_frame_pointers.txt

