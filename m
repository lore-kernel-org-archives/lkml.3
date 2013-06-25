Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab3FYR36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:29:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13737 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3FYR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:29:56 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=XqNnylozy48A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pkicDPhlfI0A:10 a=BGf8bPz3N2gvz31O2KkA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372181394.18733.222.camel@gandalf.local.home>
Subject: Re: frequent softlockups with 3.10rc6.
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Date: Tue, 25 Jun 2013 13:29:54 -0400
In-Reply-To: <1372180890.18733.217.camel@gandalf.local.home>
References: <20130623143634.GA2000@redhat.com>
	 <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com>
	 <20130624020014.GB12811@redhat.com> <20130624143928.GA20659@redhat.com>
	 <1372085549.18733.162.camel@gandalf.local.home>
	 <20130624160012.GB5993@redhat.com>
	 <1372091079.18733.168.camel@gandalf.local.home>
	 <20130624165140.GB8572@redhat.com>
	 <1372093476.18733.170.camel@gandalf.local.home>
	 <20130625165556.GA16170@redhat.com>
	 <1372180890.18733.217.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 13:21 -0400, Steven Rostedt wrote:
> On Tue, 2013-06-25 at 12:55 -0400, Dave Jones wrote:
> 
> > While I've been spinning wheels trying to reproduce that softlockup bug,
> > On another machine I've been refining my list-walk debug patch.
> > I added an ugly "ok, the ringbuffer is playing games with lower two bits" special case.
> > 
> > But what the hell is going on here ?
> > 
> > next->prev should be prev (ffff88023c6cdd18), but was 00ffff88023c6cdd. (next=ffff880243288001).

Ah you didn't handle the bit set case. I just noticed "00" in
00ffff88023c6cdd. To test this, you really need to do a "next & ~3", to
clear the pointer.

Perhaps its best to have just a "raw_list_for_each" that doesn't do any
check, and have the ring buffer use that instead. The
rb_head_page_deactivate() is usually followed by an integrity check
anyway.

-- Steve


