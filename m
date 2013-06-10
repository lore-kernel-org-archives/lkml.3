Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3FJU27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:28:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3FJU25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:28:57 -0400
Date: Mon, 10 Jun 2013 17:28:23 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: [PATCH V2 1/1] kvm/vmx: Add a tracepoint write_tsc_offset
Message-ID: <20130610202823.GC31409@amt.cnet>
References: <20130604083616.22713.24922.stgit@yunodevel>
 <20130604083619.22713.25360.stgit@yunodevel>
 <20130606002322.GA24351@amt.cnet>
 <20130606113305.GB4725@redhat.com>
 <51B16E0E.5020208@hitachi.com>
 <20130609111442.GP4725@redhat.com>
 <51B59CC2.3060707@hitachi.com>
 <20130610100505.GB4725@redhat.com>
 <20130610140424.GA25632@amt.cnet>
 <20130610163834.GG29022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610163834.GG29022@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 07:38:34PM +0300, Gleb Natapov wrote:
> > Guest traces contain vcpu number and not pid (because guest is unaware
> > of host PID).
> > 
> No, guest trace is just a regular ftrace done inside a guest. It contains
> guest's PIDs which is useless for host. 

# tracer: nop
#
# entries-in-buffer/entries-written: 5333/5333   #P:4
#
#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |

Traces contain CPU ID.

> I do not know how exactly guest traces are transfered to a host, if
> each vcpu buffer is transfered separately host can figure out what
> trace entry belong to which vcpu based on what buffer the trace is in.
> But the information about what buffer belongs to which vcpu id should
> be transfered to a host somehow too.
> 
> > > >                                                 However, when we
> > > > focus on output data of the write_tsc_offset event, it is difficult to
> > > > directly understand contents of the data if vcpu number information is
> > > > not included. So, including the information is useful, I think.
> > > > 
> > > How your tool does it now?
> > 
> > It merges guest trace with host trace (by converting the TSC timestamp 
> > in the guest trace to host TSC using tsc_offset information).
> > 
> I mean how it does it now without vcpu id. The answer is that it works
> for only one vcpu now.

Yes.

> > By not recording vcpu ID in the tsc_offset trace, it is necessary to
> > supply the tool with PID<->VCPU_id tuples for translation (so its an
> > additional step required, and it makes trace merge impossible
> > if the information is not available).
> The tool needs PID<->VCPU_id tuples to do the merging of any trace
> entry. Without that it does not know how to interpret entry timestamps
> (which offset to use). Apparently it will get this information from
> vmentry trace point. What is so special about tsc_offset tracing that
> it needs to contain vcpuid by itself.

If the tsc_offset tracepoint contains vcpu ID, its possible to lookup
guest trace entry (which contains CPU ID), and match on that.

Without that, PID<->VCPU_id tuples are necessary. Yes?

