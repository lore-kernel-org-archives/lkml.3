Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3FFLdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932592Ab3FFLdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:33:18 -0400
Date: Thu, 6 Jun 2013 14:33:06 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 1/1] kvm/vmx: Add a tracepoint write_tsc_offset
Message-ID: <20130606113305.GB4725@redhat.com>
References: <20130604083616.22713.24922.stgit@yunodevel>
 <20130604083619.22713.25360.stgit@yunodevel>
 <20130606002322.GA24351@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130606002322.GA24351@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 09:23:22PM -0300, Marcelo Tosatti wrote:
> On Tue, Jun 04, 2013 at 05:36:19PM +0900, Yoshihiro YUNOMAE wrote:
> > Add a tracepoint write_tsc_offset for tracing TSC offset change.
> > We want to merge ftrace's trace data of guest OSs and the host OS using
> > TSC for timestamp in chronological order. We need "TSC offset" values for
> > each guest when merge those because the TSC value on a guest is always the
> > host TSC plus guest's TSC offset. If we get the TSC offset values, we can
> > calculate the host TSC value for each guest events from the TSC offset and
> > the event TSC value. The host TSC values of the guest events are used when we
> > want to merge trace data of guests and the host in chronological order.
> > (Note: the trace_clock of both the host and the guest must be set x86-tsc in
> > this case)
> > 
> > TSC offset is stored in the VMCS by vmx_write_tsc_offset() or
> > vmx_adjust_tsc_offset(). KVM executes the former function when a guest boots.
> > The latter function is executed when kvm clock is updated. Only host can read
> > TSC offset value from VMCS, so a host needs to output TSC offset value
> > when TSC offset is changed.
> > 
> > Since the TSC offset is not often changed, it could be overwritten by other
> > frequent events while tracing. To avoid that, I recommend to use a special
> > instance for getting this event:
> > 
> > 1. set a instance before booting a guest
> >  # cd /sys/kernel/debug/tracing/instances
> >  # mkdir tsc_offset
> >  # cd tsc_offset
> >  # echo x86-tsc > trace_clock
> >  # echo 1 > events/kvm/kvm_write_tsc_offset/enable
> > 
> > 2. boot a guest
> > 
> > Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > Cc: Gleb Natapov <gleb@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > ---
> >  arch/x86/kvm/trace.h |   18 ++++++++++++++++++
> >  arch/x86/kvm/vmx.c   |    3 +++
> >  arch/x86/kvm/x86.c   |    1 +
> >  3 files changed, 22 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index fe5e00e..9c22e39 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -815,6 +815,24 @@ TRACE_EVENT(kvm_track_tsc,
> >  		  __print_symbolic(__entry->host_clock, host_clocks))
> >  );
> >  
> > +TRACE_EVENT(kvm_write_tsc_offset,
> > +	TP_PROTO(__u64 previous_tsc_offset, __u64 next_tsc_offset),
> > +	TP_ARGS(previous_tsc_offset, next_tsc_offset),
> > +
> > +	TP_STRUCT__entry(
> > +		__field(	__u64,	previous_tsc_offset		)
> > +		__field(	__u64,	next_tsc_offset			)
> > +	),
> > +
> > +	TP_fast_assign(
> > +		__entry->previous_tsc_offset	= previous_tsc_offset;
> > +		__entry->next_tsc_offset	= next_tsc_offset;
> > +	),
> > +
> > +	TP_printk("previous=%llu next=%llu",
> > +		  __entry->previous_tsc_offset, __entry->next_tsc_offset)
> > +);
> > +
> 
> Yoshihiro YUNOMAE,
> 
> 1) Why is previous_tsc_offset necessary?
> 
> 2) The TSC offset traces should include vcpu number, so that its
> possible to correlate traces of SMP guests (the tool should use
> the individual vcpu tsc offsets when converting guests trace).
> 
Why PID is not enough? No other trace, except kvm_entry, outputs vcpu id.

> 3) Please add traces for svm.c.

--
			Gleb.
