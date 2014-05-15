Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaEOGcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:32:21 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34753 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbaEOGcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:32:20 -0400
Message-ID: <1400135537.5175.136.camel@marge.simpson.net>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 15 May 2014 08:32:17 +0200
In-Reply-To: <20140515060515.GB5539@mtj.dyndns.org>
References: <537384B9.5090907@suse.cz> <20140514151501.GA24142@suse.cz>
	 <20140514163238.GA15690@htj.dyndns.org>
	 <1400126037.5175.55.camel@marge.simpson.net>
	 <20140515040608.GA3825@htj.dyndns.org>
	 <1400129178.5175.82.camel@marge.simpson.net>
	 <20140515045011.GB3825@htj.dyndns.org>
	 <1400130262.5175.93.camel@marge.simpson.net>
	 <20140515050915.GA5539@mtj.dyndns.org>
	 <1400131949.5175.114.camel@marge.simpson.net>
	 <20140515060515.GB5539@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 02:05 -0400, Tejun Heo wrote:

> I'm not sure how much weight I can put on the specific use case.  Even
> with the direct control that the user thought to have previously, the
> use case was ripe with possibilities of breakage from any number of
> reasons.  For example, there are driver paths which bounce to async
> execution on IO exceptions (doesn't have to be hard errors) and setups
> like the above would easily lock out exception handling and how's the
> setup gonna work when the filesystems have to use dynamic pool of
> workers as btrfs does?

Oh yeah, this case isn't about _real_ realtime at all, it's just about
unmanageable priority inversion.  With hack, any/all kthreads spawning
will start life at the priority the user specified, so as long as he
doesn't prioritize userspace above that, he can do whatever evil deeds
he sees fit, and box will function as expected.
> The identified problem in the above case is allowing the kernel to
> make reasonable forward progress even when RT processes don't concede
> CPU cycles.

Not only, but yeah, mostly.

>   If that is a use case that needs to be supported, we
> better engineer an appropriate solution for that.  Such solution
> doesn't necessarily have to be advanced either.

My solution isn't the least bit sophisticated.  Dirt simple is usually
best anyway, and is enough for the cases I've encountered.

>   Maybe all that's
> necessary is marking the async mechanisms involved in IO path as such
> (we already need to mark all workqueues involved in memory reclaim
> path anyway) and provide a mechanism to make all of them RT when
> directed.  It might be simple but still would be a concious
> engineering decision.

You could do all singing/dancing PI boost thingy like RCU, but
personally, I hate that, disable it. 

> I think the point I'm trying to make is that it isn't possible to
> continue improving and maintaining the kernel with blanket
> restrictions on internal details.  If certain things shouldn't be
> done, we better find out the specific reasons; otherwise, it's
> impossible to weight the pros and cons of different options and make a
> reasonable choice or to find out ways to accomodate those restrictions
> while still achieving the original goals.
> 
> Anyways, we're getting slightly off-topic and it seems like we'll have
> to agree to disagree.

Hey, we agree! :)

-Mike

