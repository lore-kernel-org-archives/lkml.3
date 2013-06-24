Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab3FXQYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:24:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3FXQYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:24:43 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=_8eStoSJC8uCCLy31LIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372091079.18733.168.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Mon, 24 Jun 2013 12:24:39 -0400
In-Reply-To: <20130624160012.GB5993@redhat.com>
References: <20130621195949.GA15519@redhat.com>
	 <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com>
	 <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com>
	 <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com>
	 <20130624020014.GB12811@redhat.com> <20130624143928.GA20659@redhat.com>
	 <1372085549.18733.162.camel@gandalf.local.home>
	 <20130624160012.GB5993@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 12:00 -0400, Dave Jones wrote:
> On Mon, Jun 24, 2013 at 10:52:29AM -0400, Steven Rostedt wrote:
>  
>  > > >  check_list_nodes corruption. next->prev should be prev (ffff88023b8a1a08), but was 00ffff88023b8a1a. (next=ffff880243288001).
>  > > 
>  > > Can't find "check_list_nodes" in lib/list_debug.c or elsewhere...
>  > > 
>  > > >   [<ffffffff816e467d>] dump_stack+0x19/0x1b
>  > > >   [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
>  > > >   [<ffffffff8104a12c>] warn_slowpath_fmt+0x4c/0x50
>  > > >   [<ffffffff81112c61>] rb_head_page_deactivate.isra.39+0x61/0x80
>  > > 
>  > > How? rb_list_head_clear() just modifies list->next directly.
>  > > 
>  > > > hopefully despite that it'll actually function as intended.
>  > > 
>  > > Yes ;)
>  > 
>  > I'm curious to what happened.
> 
> Ah, this is the first victim of my new 'check sanity of nodes during list walks' patch.
> It's doing the same prev->next next->prev checking as list_add and friends.
> I'm looking at getting it into shape for a 3.12 merge after some other preparatory patches
> go into 3.11

OK, and you may need to make an exception for the ring buffer. To do a
lockless swap out of the reader page for one of the pages in the buffer,
it uses the 2 LSB as flags. Notice the "next=ffff880243288001", that "1"
is a flag that states the next page is the "header" page (next to be
read). We use cmpxchg to update the pages to handle races between the
reader and writer.

In fact, the above code is done on reset of the ring buffer, where we
clear those bits:

	list_for_each(hd, cpu_buffer->pages)
		rb_list_head_clear(hd);

The function that was flagged, was the one going through and clearing
the bits.

It seems that your new tool is failing due to this trick.

-- Steve


