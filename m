Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3FJQiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:38:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3FJQit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:38:49 -0400
Date: Mon, 10 Jun 2013 19:38:34 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: [PATCH V2 1/1] kvm/vmx: Add a tracepoint write_tsc_offset
Message-ID: <20130610163834.GG29022@redhat.com>
References: <20130604083616.22713.24922.stgit@yunodevel>
 <20130604083619.22713.25360.stgit@yunodevel>
 <20130606002322.GA24351@amt.cnet>
 <20130606113305.GB4725@redhat.com>
 <51B16E0E.5020208@hitachi.com>
 <20130609111442.GP4725@redhat.com>
 <51B59CC2.3060707@hitachi.com>
 <20130610100505.GB4725@redhat.com>
 <20130610140424.GA25632@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610140424.GA25632@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:04:24AM -0300, Marcelo Tosatti wrote:
> On Mon, Jun 10, 2013 at 01:05:05PM +0300, Gleb Natapov wrote:
> > On Mon, Jun 10, 2013 at 06:30:42PM +0900, Yoshihiro YUNOMAE wrote:
> > > Hi Gleb,
> > > 
> > > (2013/06/09 20:14), Gleb Natapov wrote:
> > > >On Fri, Jun 07, 2013 at 02:22:22PM +0900, Yoshihiro YUNOMAE wrote:
> > > >>(2013/06/06 20:33), Gleb Natapov wrote:
> > > >>>On Wed, Jun 05, 2013 at 09:23:22PM -0300, Marcelo Tosatti wrote:
> > > >>>>On Tue, Jun 04, 2013 at 05:36:19PM +0900, Yoshihiro YUNOMAE wrote:
> > > >>>>>Add a tracepoint write_tsc_offset for tracing TSC offset change.
> > > >>>>>We want to merge ftrace's trace data of guest OSs and the host OS using
> > > >>>>>TSC for timestamp in chronological order. We need "TSC offset" values for
> > > >>>>>each guest when merge those because the TSC value on a guest is always the
> > > >>>>>host TSC plus guest's TSC offset. If we get the TSC offset values, we can
> > > >>>>>calculate the host TSC value for each guest events from the TSC offset and
> > > >>>>>the event TSC value. The host TSC values of the guest events are used when we
> > > >>>>>want to merge trace data of guests and the host in chronological order.
> > > >>>>>(Note: the trace_clock of both the host and the guest must be set x86-tsc in
> > > >>>>>this case)
> > > >>>>>
> > > >>>>>TSC offset is stored in the VMCS by vmx_write_tsc_offset() or
> > > >>>>>vmx_adjust_tsc_offset(). KVM executes the former function when a guest boots.
> > > >>>>>The latter function is executed when kvm clock is updated. Only host can read
> > > >>>>>TSC offset value from VMCS, so a host needs to output TSC offset value
> > > >>>>>when TSC offset is changed.
> > > >>>>>
> > > >>>>>Since the TSC offset is not often changed, it could be overwritten by other
> > > >>>>>frequent events while tracing. To avoid that, I recommend to use a special
> > > >>>>>instance for getting this event:
> > > >>>>>
> > > >>>>>1. set a instance before booting a guest
> > > >>>>>  # cd /sys/kernel/debug/tracing/instances
> > > >>>>>  # mkdir tsc_offset
> > > >>>>>  # cd tsc_offset
> > > >>>>>  # echo x86-tsc > trace_clock
> > > >>>>>  # echo 1 > events/kvm/kvm_write_tsc_offset/enable
> > > >>>>>
> > > >>>>>2. boot a guest
> > > >>>>>
> > > >>>>>Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> > > >>>>>Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > >>>>>Cc: Gleb Natapov <gleb@redhat.com>
> > > >>>>>Cc: Thomas Gleixner <tglx@linutronix.de>
> > > >>>>>Cc: Ingo Molnar <mingo@redhat.com>
> > > >>>>>Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > >>>>>---
> > > >>>>>  arch/x86/kvm/trace.h |   18 ++++++++++++++++++
> > > >>>>>  arch/x86/kvm/vmx.c   |    3 +++
> > > >>>>>  arch/x86/kvm/x86.c   |    1 +
> > > >>>>>  3 files changed, 22 insertions(+)
> > > >>>>>
> > > >>>>>diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > > >>>>>index fe5e00e..9c22e39 100644
> > > >>>>>--- a/arch/x86/kvm/trace.h
> > > >>>>>+++ b/arch/x86/kvm/trace.h
> > > >>>>>@@ -815,6 +815,24 @@ TRACE_EVENT(kvm_track_tsc,
> > > >>>>>  		  __print_symbolic(__entry->host_clock, host_clocks))
> > > >>>>>  );
> > > >>>>>
> > > >>>>>+TRACE_EVENT(kvm_write_tsc_offset,
> > > >>>>>+	TP_PROTO(__u64 previous_tsc_offset, __u64 next_tsc_offset),
> > > >>>>>+	TP_ARGS(previous_tsc_offset, next_tsc_offset),
> > > >>>>>+
> > > >>>>>+	TP_STRUCT__entry(
> > > >>>>>+		__field(	__u64,	previous_tsc_offset		)
> > > >>>>>+		__field(	__u64,	next_tsc_offset			)
> > > >>>>>+	),
> > > >>>>>+
> > > >>>>>+	TP_fast_assign(
> > > >>>>>+		__entry->previous_tsc_offset	= previous_tsc_offset;
> > > >>>>>+		__entry->next_tsc_offset	= next_tsc_offset;
> > > >>>>>+	),
> > > >>>>>+
> > > >>>>>+	TP_printk("previous=%llu next=%llu",
> > > >>>>>+		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
> > > >>>>>+);
> > > >>>>>+
> > > >>>>
> > > >>>>Yoshihiro YUNOMAE,
> > > >>>>
> > > >>>>1) Why is previous_tsc_offset necessary?
> > > >>
> > > >>I was considering the situations where we did not enable
> > > >>kvm_write_tsc_offset event before booting a guest or where we did not
> > > >>use multiple buffers. Here, we will need another new I/F to get current
> > > >>TSC offset of a given VCPU. For example, if kvm_write_tsc_offset is not
> > > >>included in the host's trace data, we get the current TSC offset from
> > > >>the new I/F and apply it to all guest events. On the other hand, if
> > > >>kvm_write_tsc_offset event appears more than once, we apply the
> > > >>previous offset to guest events before the first TSC offset change.
> > > >>
> > > >>Since we support only for using multiple buffers now, we don't need to
> > > >>record previous TSC offset at this time. But I'm conscious that we have
> > > >>to change the format of kvm_write_tsc_offset event when we support
> > > >>those situations.
> > > >>
> > > >>>>2) The TSC offset traces should include vcpu number, so that its
> > > >>>>possible to correlate traces of SMP guests (the tool should use
> > > >>>>the individual vcpu tsc offsets when converting guests trace).
> > > >>>>
> > > >>>Why PID is not enough? No other trace, except kvm_entry, outputs vcpu id.
> > > >>
> > > >>As Gleb mentioned, a tool can understand TSC offset for each vcpu from
> > > >>PID and vcpu number of kvm_entry. IMO, that is indirect way, so I would
> > > >>be better off including vcpu number.
> > > >>
> > > >But doesn't the tool operates on vcpu's PID for all other events. I mean to
> > > >figure out what vcpu an event belongs too during merge. Why tsc offset
> > > >event is different?
> > > 
> > > In vcpu_load()@virt/kvm/kvm_main.c, it seems that PID of the vcpu thread
> > > can be changed. Are you familiar with this situation?
> > Recommended way of using KVM API is to have dedicated thread per vcpu
> > and this is how all known userspace implementations use it, but having
> > one thread drive several vcpus (not simultaneously obviously) also
> > works, but not recommended.
> > 
> > > If the situation can be occurred, outputting vcpu number is better, I
> > > think. If not occurred, as you say, we will be able to merge those data
> > > without vcpu number in write_tsc_offset event.
> > The thing is that all other traces that you want to merge do not contain
> > vcpu number, only pid, so if the situation occurs how do you merge the
> > data?
> 
> Guest traces contain vcpu number and not pid (because guest is unaware
> of host PID).
> 
No, guest trace is just a regular ftrace done inside a guest. It contains
guest's PIDs which is useless for host. I do not know how exactly guest
traces are transfered to a host, if each vcpu buffer is transfered
separately host can figure out what trace entry belong to which vcpu
based on what buffer the trace is in. But the information about what
buffer belongs to which vcpu id should be transfered to a host somehow
too.

> > >                                                 However, when we
> > > focus on output data of the write_tsc_offset event, it is difficult to
> > > directly understand contents of the data if vcpu number information is
> > > not included. So, including the information is useful, I think.
> > > 
> > How your tool does it now?
> 
> It merges guest trace with host trace (by converting the TSC timestamp 
> in the guest trace to host TSC using tsc_offset information).
> 
I mean how it does it now without vcpu id. The answer is that it works
for only one vcpu now.

> By not recording vcpu ID in the tsc_offset trace, it is necessary to
> supply the tool with PID<->VCPU_id tuples for translation (so its an
> additional step required, and it makes trace merge impossible
> if the information is not available).
The tool needs PID<->VCPU_id tuples to do the merging of any trace
entry. Without that it does not know how to interpret entry timestamps
(which offset to use). Apparently it will get this information from
vmentry trace point. What is so special about tsc_offset tracing that
it needs to contain vcpuid by itself.

--
			Gleb.
