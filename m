Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbbALO3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:29:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbbALO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:29:47 -0500
Date: Mon, 12 Jan 2015 15:28:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pratyush Anand <panand@redhat.com>
Cc: tixy@linaro.org, linux@arm.linux.org.uk, ananth@in.ibm.com,
        sandeepa.prabhu@linaro.org, catalin.marinas@arm.com,
        will.deacon@arm.com, linux-kernel@vger.kernel.org,
        anil.s.keshavamurthy@intel.com, masami.hiramatsu.pt@hitachi.com,
        wcohen@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 8/8] ARM64: Add uprobe support
Message-ID: <20150112142812.GB25914@redhat.com>
References: <cover.1420038188.git.panand@redhat.com> <0694af6935f9c6873ef8d25ad51630a40a74a116.1420038188.git.panand@redhat.com> <20150109175936.GB13161@redhat.com> <54B355FA.60702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B355FA.60702@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12, Pratyush Anand wrote:
>
>
> On Friday 09 January 2015 11:29 PM, Oleg Nesterov wrote:
>> On 12/31, Pratyush Anand wrote:
>>>
>>> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>>> +		unsigned long addr)
>>> +{
>>> +	probe_opcode_t insn;
>>> +
>>> +	insn = *(probe_opcode_t *)(&auprobe->insn[0]);
>>> +
>>> +	switch (arm_probe_decode_insn(insn, &auprobe->ainsn)) {
>>> +	case INSN_REJECTED:
>>> +		return -EINVAL;
>>> +
>>> +	case INSN_GOOD_NO_SLOT:
>>> +		auprobe->simulate = true;
>>> +		if (auprobe->ainsn.prepare)
>>> +			auprobe->ainsn.prepare(insn, &auprobe->ainsn);
>>> +		break;
>>> +
>>> +	case INSN_GOOD:
>>> +	default:
>>> +		break;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>
>> forgot to mention... shouldn't it also check IS_ALIGNED(addr, AARCH64_INSN_SIZE) ?
>>
>> I do not know if unaligned insn address is valid on arm64 or not, but please
>
> AARCH64 instructions are always of fixed lenght ie 4 bytes. I do not see
> possibility of addr being unaligned. Please let me know, if I am missing
> something.

A user can write any offset into uprobe_events, and the generic code doesn't
check it is aligned.

>> note that at least it should not cross the page boundary, set_swbp() needs to
>> write AARCH64_INSN_SIZE == UPROBE_SWBP_INSN bytes and it assumes that this
>> should fit the single page.
>
> So, again I do not see the possibility of crossing of page boundary for
> any instruction address.

See above. So yes, it should really check IS_ALIGNED(AARCH64_INSN_SIZE).

Oleg.

