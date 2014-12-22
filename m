Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbaLVPyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:54:15 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:36159 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaLVPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:54:13 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "davej \@mail.xmission.com\>\> Dave Jones" <davej@redhat.com>
References: <54982C98.9070806@oracle.com>
	<CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>
Date: Mon, 22 Dec 2014 09:51:45 -0600
In-Reply-To: <CAPAsAGzHyx=9oy7ZFdL3dERrKR3or_PiDqm_chbDRvx+c3ZHPg@mail.gmail.com>
	(Andrey Ryabinin's message of "Mon, 22 Dec 2014 19:31:27 +0400")
Message-ID: <87oaqvd6ni.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+b9pl1mMI0iFARfkjMixSHH3Z+isVjHOk=
X-SA-Exim-Connect-IP: 97.121.85.189
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andrey Ryabinin <ryabinin.a.a@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 303 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.8 (0.9%), b_tie_ro: 1.92 (0.6%), parse: 0.94 (0.3%),
	extract_message_metadata: 16 (5.3%), get_uri_detail_list: 2.0 (0.7%),
	tests_pri_-1000: 4.5 (1.5%), tests_pri_-950: 1.13 (0.4%), tests_pri_-900:
	0.90 (0.3%), tests_pri_-400: 21 (7.1%), check_bayes: 20 (6.7%), b_tokenize:
	4.9 (1.6%), b_tok_get_all: 7 (2.5%), b_comp_prob: 1.97 (0.6%),
	b_tok_touch_all: 2.5 (0.8%), b_finish: 0.57 (0.2%), tests_pri_0: 248 (81.7%),
	tests_pri_500: 3.5 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: fs: proc: gpf in find_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Ryabinin <ryabinin.a.a@gmail.com> writes:

> 2014-12-22 17:37 GMT+03:00 Sasha Levin <sasha.levin@oracle.com>:
>> Hi all,
>>
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel, I've stumbled on the following spew:
>>
>> [ 2015.960381] general protection fault: 0000 [#1] PREEMPT SMP KASAN
>
> Actually this is NULL-ptr dereference. Since you are using kasan with
> inline instrumentation
> NULL-ptr deref transforms into GPF.
>
>
>> [ 2015.970534] RAX: 0000000000000000 RBX: ffff88000003a960 RCX: 0000000000000073
>> [ 2015.970534] RDX: 1ffff10101c8f3c4 RSI: 0000000000000000 RDI: ffff88080e479e20
>> [ 2015.970534] RBP: ffff88080e477a28 R08: 0000000000000066 R09: 0000000000000073
>> [ 2015.970534] R10: ffffda0017d55630 R11: dfffe90000000000 R12: ffff88005fc644b8
>> [ 2015.970534] R13: dfffe90000000000 R14: ffffffff92464884 R15: 0000000000000000
>
> [...]
>
>> All code
>> ========
>>    0:   e8 03 42 80 3c          callq  0x3c804208
>>    5:   28 00                   sub    %al,(%rax)
>>    7:   0f 85 ff 01 00 00       jne    0x20c
>>    d:   4c 8b 7b 18             mov    0x18(%rbx),%r15
>>   11:   4d 85 ff                test   %r15,%r15
>>   14:   0f 84 de 01 00 00       je     0x1f8
>>   1a:   41 f6 c7 07             test   $0x7,%r15b
>>   1e:   0f 85 d4 01 00 00       jne    0x1f8
>>   24:   4c 89 f8                mov    %r15,%rax
>>   27:   48 c1 e8 03             shr    $0x3,%rax
>>   2b:*  42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)               <-- trapping instruction
>
> Three commands above are result of KASAN's instrumentation.
> They check shadow for address in %r15:
>      if (*((%r15 >> 3) + kasan_shadow_offset)
>
>
>>   30:   0f 85 b5 01 00 00       jne    0x1eb
>>   36:   4d 8b 37                mov    (%r15),%r14
>
> And here is memory access, that KASAN checking.

Then frankly I suspect this is a KASAN bug.

These two instructions:
>>   11:   4d 85 ff                test   %r15,%r15
>>   14:   0f 84 de 01 00 00       je     0x1f8

Should prevent a NULL %r15 value from ever reaching the trapping
instruction.

What other horrible things does KASAN do to the machine code?

Eric
