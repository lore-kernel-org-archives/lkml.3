Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaGBNeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:34:14 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:23038 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBNeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:34:11 -0400
Message-ID: <53B40A4F.7060102@imgtec.com>
Date: Wed, 2 Jul 2014 14:34:07 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Subject: Re: [RFA][PATCH 23/27] metag: ftrace: Remove check of obsolete variable
 function_trace_stop
References: <20140626165221.736847419@goodmis.org>	<20140626165853.049120840@goodmis.org> <20140626133848.0567e365@gandalf.local.home>
In-Reply-To: <20140626133848.0567e365@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/06/14 18:38, Steven Rostedt wrote:
> On Thu, 26 Jun 2014 12:52:44 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
>> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>>
>> Nothing sets function_trace_stop to disable function tracing anymore.
>> Remove the check for it in the arch code.
>>
>> [ Please test this on your arch ]
> 
> From the cover letter, you were not Cc'd on.
> 
> Anyway, as there is no more reason to set function_trace_stop it is time
> to remove it. Unfortunately it's in several archs in assembly. Most of
> the assembly looks rather straight forward and I removed them myself.
> But I was only able to compile test them (for archs: arm64, metag, and
> microblaze I do not have my cross tools set up for them and did not
> even compile test it). But I would really love it if people can
> download their patch and test it out. You only need the patches that go
> against your arch and to really test it, also include the patch titled: 
> 
>  ftrace: Remove check for HAVE_FUNCTION_TRACE_MCOUNT_TEST
> 
> Otherwise your arch patch will call the list op that still does the
> check. That is, if you want to test suspend and resume on your arch.
> 
> As you may see, there are patches to the ftrace infrastructure that
> depend on the arch patches being implemented. I removed the
> functionality from the infrastructure, then removed it from the archs,
> and then finally removed the existence of the function_trace_stop
> variable, which would cause the archs to fail to compile if that were
> to go first.
> 
> If you can test your arch and give me your acked-by, I would appreciate
> it. Otherwise, if you need this to go through your tree, I would ask you
> to set up a dedicated branch that I can pull from to keep this order
> intact.
> 

This patch is pretty much the inverse of the original patch that added
it, so looks good to me (and it didn't seem to break anything).

So, for both this patch and the "ftrace: Remove check for
HAVE_FUNCTION_TRACE_MCOUNT_TEST" one:

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> -- Steve
> 
>>
>> Cc: James Hogan <james.hogan@imgtec.com>
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  arch/metag/Kconfig              |  1 -
>>  arch/metag/kernel/ftrace_stub.S | 14 --------------
>>  2 files changed, 15 deletions(-)
>>
>> diff --git a/arch/metag/Kconfig b/arch/metag/Kconfig
>> index 499b7610eaaf..0b389a81c43a 100644
>> --- a/arch/metag/Kconfig
>> +++ b/arch/metag/Kconfig
>> @@ -13,7 +13,6 @@ config METAG
>>  	select HAVE_DYNAMIC_FTRACE
>>  	select HAVE_FTRACE_MCOUNT_RECORD
>>  	select HAVE_FUNCTION_TRACER
>> -	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
>>  	select HAVE_KERNEL_BZIP2
>>  	select HAVE_KERNEL_GZIP
>>  	select HAVE_KERNEL_LZO
>> diff --git a/arch/metag/kernel/ftrace_stub.S b/arch/metag/kernel/ftrace_stub.S
>> index e70bff745bdd..3acc288217c0 100644
>> --- a/arch/metag/kernel/ftrace_stub.S
>> +++ b/arch/metag/kernel/ftrace_stub.S
>> @@ -16,13 +16,6 @@ _mcount_wrapper:
>>  	.global _ftrace_caller
>>  	.type	_ftrace_caller,function
>>  _ftrace_caller:
>> -	MOVT    D0Re0,#HI(_function_trace_stop)
>> -	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
>> -	GETD	D0Re0,[D0Re0]
>> -	CMP	D0Re0,#0
>> -	BEQ	$Lcall_stub
>> -	MOV	PC,D0.4
>> -$Lcall_stub:
>>  	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
>>  	MOV     D1Ar1, D0.4
>>  	MOV     D0Ar2, D1RtP
>> @@ -42,13 +35,6 @@ _ftrace_call:
>>  	.global	_mcount_wrapper
>>  	.type	_mcount_wrapper,function
>>  _mcount_wrapper:
>> -	MOVT    D0Re0,#HI(_function_trace_stop)
>> -	ADD	D0Re0,D0Re0,#LO(_function_trace_stop)
>> -	GETD	D0Re0,[D0Re0]
>> -	CMP	D0Re0,#0
>> -	BEQ	$Lcall_mcount
>> -	MOV	PC,D0.4
>> -$Lcall_mcount:
>>  	MSETL   [A0StP], D0Ar6, D0Ar4, D0Ar2, D0.4
>>  	MOV     D1Ar1, D0.4
>>  	MOV     D0Ar2, D1RtP
> 
