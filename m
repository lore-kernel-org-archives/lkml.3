Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaGONkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 09:40:35 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:45638 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751713AbaGONkd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 09:40:33 -0400
Date: Tue, 15 Jul 2014 09:40:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr =?UTF-8?B?TWzDoWRlaw==?= <pmladek@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ring-buffer: Race when writing and swapping cpu
 buffer in parallel
Message-ID: <20140715094030.4b3c6314@gandalf.local.home>
In-Reply-To: <20140715090712.GI6774@pathway.suse.cz>
References: <1405348378-10370-1-git-send-email-pmladek@suse.cz>
	<20140714120840.1fb65a7d@gandalf.local.home>
	<20140715090712.GI6774@pathway.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 11:07:35 +0200
Petr Mládek <pmladek@suse.cz> wrote:

 
> Just to be sure. Should I remove RING_BUFFER_ALLOW_SWAP config
> option completely?

No. Just that one #if block. The per cpu swap is still a bit icky in my
humble opinion, and should stay a config for now.

> 
> > Although your above comment is wrong. We can most
> > definitely be in the middle of a swap operation. You forget that
> > tracing is NMI safe.
> > 
> > But the swap does disable tracing, then if a NMI were to preempt the
> > swap, it will either be outside the critical part where it is still safe
> > to perform the trace or it will be where the swap is happening and the
> > tracing will be disabled.
> 
> I probably did not use precise enough sentence. I wanted to explain
> why we do not check for "cpu_buffer->record_disabled" here. I added
> this test in the 1st version of the patch but then I realized that it
> was not needed.
> 
> As you say, there are two possibilities when swap is interrupted by
> NMI. Either it is outside of the critical section and then the write is
> completed before we continue with swapping. Or the interrupt is inside
> the critical section and then the nested write fails early in
> ring_buffer_write() or ring_buffer_lock_reserve() before this
> code is called.
> 
> A better comment might be:
> 
> 	* Note that we will never be in the middle of a swap critical
> 	* section here. If the swapping is interrupted when recording
> 	* is disabled, the nested write will fail earlier in
> 	* ring_buffer_write() or ring_buffer_lock_reserve().
> 	*/
> 
> 
> Note that I am still learning about the preferred practice with comments inside
> the kernel code. I have spent a lot of time trying to understand the
> ring buffer. I think that more comments like this would have
> helped me to get the picture faster. Another possibility would be to
> create Documentation/trace/ring-buffer.txt.

Well there is a Documentation/trace/ring-buffer-design.txt doc ;-)

> 
> I have more notes here. Let me know if I should cook up some patches
> that would extend the ring buffer documentation according to my
> experience.

I have no problems with adding documentation to the code.

-- Steve

