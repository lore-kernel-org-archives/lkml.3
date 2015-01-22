Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbbAVW3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:29:30 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:40686 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804AbbAVW30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:29:26 -0500
X-Cam-AntiVirus: no malware found
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <54C179B4.4020905@citrix.com>
Date: Thu, 22 Jan 2015 22:29:08 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>
CC: "Luis R. Rodriguez" <mcgrof@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v3 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421893039-426-1-git-send-email-mcgrof@do-not-panic.com> <1421893039-426-3-git-send-email-mcgrof@do-not-panic.com> <54C0E3F2.9050201@citrix.com> <20150122085649.7dc79541@grimm.local.home> <20150122183913.GO17887@wotan.suse.de> <20150122151657.287fe29b@gandalf.local.home> <CALCETrU+B_8C2-1+gEQ20wrL+0A6G0XTQ4wAnWuewKc=Pei5Qg@mail.gmail.com> <20150122153707.4625878b@gandalf.local.home> <CALCETrUTekrhz=tXF=bAn1wuZBA+Kh+CgU+USwx--hNALvR5Mw@mail.gmail.com>
In-Reply-To: <CALCETrUTekrhz=tXF=bAn1wuZBA+Kh+CgU+USwx--hNALvR5Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2015 20:58, Andy Lutomirski wrote:
> On Thu, Jan 22, 2015 at 12:37 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> On Thu, 22 Jan 2015 12:24:47 -0800
>> Andy Lutomirski <luto@amacapital.net> wrote:
>>
>>>> Also, please remove the "notrace", because function tracing goes an
>>>> extra step to not require RCU being visible. The only thing you get
>>>> with notrace is not being able to trace an otherwise traceable function.
>>>>
>>> Is this also true for kprobes?  And can kprobes nest inside function
>>> tracing hooks?
>> No, kprobes are a bit more fragile than function tracing or tracepoints.
>>
>> And nothing should nest inside a function hook (except for interrupts,
>> they are fine).
>>
> But kprobes do nest inside interrupts, right?
>
>>> The other issue, above and beyond RCU, is that we can't let kprobes
>>> run on the int3 stack.  If Xen upcalls can happen when interrupts are
>>> off, then we may need this protection to prevent that type of
>>> recursion.  (This will be much less scary in 3.20, because userspace
>>> int3 instructions will no longer execute on the int3 stack.)
>> Does this execute between the start of the int3 interrupt handler and
>> the call of do_int3()?
> I doubt it.
>
> The thing I worry about is that, if do_int3 nests inside itself by any
> means (e.g. int3 sends a signal, scheduling for whatever reason
> (really shouldn't happen, but I haven't looked that hard)), then we're
> completely hosed -- the inner int3 will overwrite the outer int3's
> stack frame.  Since I have no idea what Xen upcalls do, I don't know
> whether they can fire inside do_int3.

The upcall is the "you have a virtual interrupt pending" signal and
should behave exactly like an external interrupt.  The exception frame
will appear to have interrupted the correct vcpu context, despite actual
trip via Xen.

Exceptions are handled as per native, with the xen_write_idt_entry()
PVOP taking care of registering the entry point with Xen, rather than
filling in a real IDT entry.

~Andrew
