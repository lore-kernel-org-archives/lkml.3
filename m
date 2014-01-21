Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaAUQvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:51:32 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:58648 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaAUQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:51:29 -0500
Message-ID: <52DEA58A.9050406@linaro.org>
Date: Tue, 21 Jan 2014 11:51:22 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 15/16] ARM: add uprobes support
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>  <1387166930-13182-16-git-send-email-dave.long@linaro.org> <1387564464.3404.106.camel@linaro1.home>
In-Reply-To: <1387564464.3404.106.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 13:34, Jon Medhurst (Tixy) wrote:
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Using Rabin Vincent's ARM uprobes patches as a base, enable uprobes
>> support on ARM.
>>
>> Caveats:
>>
>>   - Thumb is not supported
>>   - XOL abort/trap handling is not implemented
>
> I shall repeat my comment from version one of the patch...
>
> What are the consequences of this, e.g. is it possible for a probe to
> get stuck in an infinite loop of faulting? I hope there are no integrity
> issues for the kernel itself.
>
> Would be good if someone familiar with uprobes working could answer
> that.

Testing shows it does indeed get stuck continuously trapping. The 
process is killable.  Fortunately all the infrastructure is already 
there for fixing this.  I've patched the code to detect the trap and 
allow it to be processed, using the powerpc uprobes code as a model. 
The changes required are fairly small and entirely in the 
architecture-specific code.

As mentioned before, thumb support is a follow-on project.

> I've a few other comments...

[snip]

>
>
>> +const union decode_item uprobes_probes_actions[] = {
>> +	[PROBES_EMULATE_NONE] {.handler = probes_simulate_nop},
>
> There is a missing '=' in the line above. Interesting that GCC doesn't
> complain (I tried compiling this patch and it didn't).
>

That is indeed odd.  I have fixed it (my code, not the compiler).

[snip]

>> +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>> +{
>> +	void *addr;
>
> 'addr' is not used so this line can be deleted
>
>> +	probes_opcode_t opcode;
>> +
>> +	if (!auprobe->simulate)
>> +		return false;
>> +
>> +	addr = (void *) regs->ARM_pc;
>
> and so can this line ^^^

Fixed.

>
>> +	opcode = __mem_to_opcode_arm(*(unsigned int *) auprobe->insn);
>> +
>> +	auprobe->asi.insn_singlestep(opcode, &auprobe->asi, regs);
>> +
>> +	return true;
>> +}
>> +
>

Fixed.

> [rest of patch snipped]
>


-dl

