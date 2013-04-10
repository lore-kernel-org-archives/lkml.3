Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937322Ab3DJKky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:40:54 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56370 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3DJKkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:40:52 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        kernel-hardening@lists.openwall.com,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
References: <20130408224328.GA17641@www.outflux.net>
	<51634935.9010905@zytor.com> <877gkc596d.fsf@xmission.com>
	<20130410095716.GF24443@gmail.com>
Date: Wed, 10 Apr 2013 03:40:33 -0700
In-Reply-To: <20130410095716.GF24443@gmail.com> (Ingo Molnar's message of
	"Wed, 10 Apr 2013 11:57:16 +0200")
Message-ID: <87sj2yzn1a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX184UBvStsrjzUdD6I5NX+waJejGFrYpl8w=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.7 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] x86: make IDT read-only
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@kernel.org> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> "H. Peter Anvin" <hpa@zytor.com> writes:
>> 
>> > On 04/08/2013 03:43 PM, Kees Cook wrote:
>> >> This makes the IDT unconditionally read-only. This primarily removes
>> >> the IDT from being a target for arbitrary memory write attacks. It has
>> >> an added benefit of also not leaking (via the "sidt" instruction) the
>> >> kernel base offset, if it has been relocated.
>> >> 
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> Cc: Eric Northup <digitaleric@google.com>
>> >
>> > Also, tglx: does this interfere with your per-cpu IDT efforts?
>> 
>> Given that we don't change any IDT entries why would anyone want a
>> per-cpu IDT?  The cache lines should easily be shared accross all
>> processors.
>
> That's true iif they are cached.
>
> If not then it's a remote DRAM access cache miss for all CPUs except the node that 
> holds that memory.
>
>> Or are there some giant NUMA machines that trigger cache misses when accessing 
>> the IDT and the penalty for pulling the cache line across the NUMA fabric is 
>> prohibitive?
>
> IDT accesses for pure userspace execution are pretty rare. So we are not just 
> talking about huge NUMA machines here but about ordinary NUMA machines taking a 
> remote cache miss hit for the first IRQ or other IDT-accessing operation they do 
> after some cache-intense user-space processing.
>
> It's a small effect, but it exists and improving it would be
> legitimate.

If the effect is measurable I agree it is a legitimate optimization.  At
one point there was a suggestion to make the code in the IDT vectors
differ based on the which interrupt was registed.  While that can also
reduce cache misses that can get hairy very quickly, and of course that
would require read-write IDTs.

My only practical concern with duplicating the IDT tables per cpu is (a)
there are generic idt handlers that remain unduplicated reducing the
benefit and this is essentially the same optimization as making the
entire kernel text per cpu which last time it was examined was not an
optimization worth making.  So I wonder if just a subset of the
optimization is worth making.

Eric
