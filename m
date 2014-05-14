Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaENO7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 10:59:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48776 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716AbaENO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 10:59:11 -0400
Message-ID: <537384B9.5090907@suse.cz>
Date: Wed, 14 May 2014 16:59:05 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz> <1398868249-26169-10-git-send-email-jslaby@suse.cz> <20140501142414.GA31611@htj.dyndns.org> <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz> <20140501210242.GA28948@mtj.dyndns.org> <20140501210943.GB28948@mtj.dyndns.org>
In-Reply-To: <20140501210943.GB28948@mtj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 05/01/2014 11:09 PM, Tejun Heo wrote:
> On Thu, May 01, 2014 at 05:02:42PM -0400, Tejun Heo wrote:
>> Hello, Jiri.
>>
>> On Thu, May 01, 2014 at 10:17:44PM +0200, Jiri Kosina wrote:
>>> I agree that this expectation might really somewhat implicit and is not 
>>> probably properly documented anywhere. The basic observation is "whenever 
>>> kthread_should_stop() is being called, all data structures are in a 
>>> consistent state and don't need any further updates in order to achieve 
>>> consistency, because we can exit the loop immediately here", as 
>>> kthread_should_stop() is the very last thing every freezable kernel thread 
>>
>> But kthread_should_stop() doesn't necessarily imply that "we can exit
>> the loop *immediately*" at all.  It just indicates that it should
>> terminate in finite amount of time.  I don't think it'd be too
> 
> Just a bit of addition.  Please note that kthread_should_stop(), along
> with the freezer test, is actually trickier than it seems.  It's very
> easy to write code which works most of the time but misses wake up
> from kill when the timing is just right (or wrong).  It should be
> interlocked with set_current_state() and other related queueing data
> structure accesses.  This was several years ago but when I audited
> most kthread users in kernel, especially in combination with the
> freezer test which also has similar requirement, surprising percentage
> of users (at least several tens of pct) were getting it slightly
> wrong, so kthread_should_stop() really isn't used as "we can exit
> *immediately*".  It just isn't that simple.

I see the worst case scenario. (For curious readers, it is for example
this kthread body:
while (1) {
  some_paired_call(); /* invokes pre-patched code */
  if (kthread_should_stop()) { /* kgraft switches to the new code */
    its_paired_function(); /* invokes patched code (wrong) */
    break;
  }
  its_paired_function(); /* the same (wrong) */
})

What to do with that now? We have come up with a couple possibilities.
Would you consider try_to_freeze() a good state-defining function? As it
is called when a kthread expects weird things can happen, it should be
safe to switch to the patched version in our opinion.

The other possibility is to patch every kthread loop (~300) and insert
kgr_task_safe() semi-manually at some proper place.

Or if you have any other suggestions we would appreciate that?

thanks,
-- 
js
suse labs
