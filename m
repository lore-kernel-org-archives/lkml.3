Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbaD3ISE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 04:18:04 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:43222 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaD3ISA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 04:18:00 -0400
Message-ID: <5360B14D.8000902@linux.vnet.ibm.com>
Date: Wed, 30 Apr 2014 13:46:13 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Linux PPC dev <linuxppc-dev@ozlabs.org>, linux-kernel@vger.kernel.org,
        avagin@openvz.org, roland@redhat.com, oleg@redhat.com
Subject: Re: [PATCH 0/3] Add new ptrace request macros on PowerPC
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <533BD922.4070009@linux.vnet.ibm.com> <535F4E10.2020300@linux.vnet.ibm.com> <CAEjGV6yi5YY95tM-HY4akN4BGXGn4chA8_sCaqvWx3HPSu2V3w@mail.gmail.com> <535F5BDE.2030309@linux.vnet.ibm.com> <CAEjGV6y8MRiCfRBtWjNfrwKMccROEAJw2rPVc_u+r=tAo2EcHQ@mail.gmail.com> <535F997B.3000500@linux.vnet.ibm.com> <20730.1398817745@ale.ozlabs.ibm.com>
In-Reply-To: <20730.1398817745@ale.ozlabs.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14043008-4790-0000-0000-00000127E415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 05:59 AM, Michael Neuling wrote:
> Anshuman Khandual <khandual@linux.vnet.ibm.com> wrote:
> 
>> On 04/29/2014 01:52 PM, Michael Neuling wrote:
>>> That's not what that patch does. It shouldn't make any user visible changes
>>> to DSCR or PPR.
>>
>> It may not when it runs uninterrupted but after the tracee process has
>> stopped, thread.dscr reflects the default DSCR value as mentioned
>> before. This can be proved by changing the "dscr_default" value in
>> arch/powerpc/sysfs.c file.
> 
> The intention with DSCR is that if the user changes the DSCR, the kernel
> should always save/restore it.  If you are seeing something else, then
> that is a bug.  Anton has a test case for this here:
> 
>   http://ozlabs.org/~anton/junkcode/dscr_explicit_test.c
> 
> If that is failing, then there is a bug that we need to fix.
> 

Anton's above DSCR test passed.

> The PPR is the same, except that the kernel can change it over a
> syscall.
> 
>>> Over syscall PPR and DSCR may change.
> 
> Sorry, this should be only PPR.  DSCR shouldn't change over a syscall,
> at least that's the intention.
> 
>>> Depending on your test case, that may
>>> be your problem.
>>
>> I would guess when the tracee process stops for ptrace analysis, tm_reclaim or
>> tm_recheckpoint path might be crossed which is causing this dscr_default value
>> to go into thread_struct.
> 
> That shouldn't happen.  If that's happening, it's a bug.

I would believe this is happening. Also after reverting the commit
e9bdc3d6143d1c4b8d8ce5231, thread.dscr reflects the same value as that
of thread.tm_dscr which is the check pointed DSCR register value just
before the transaction started. So even the NIP has moved passed the point
where the user changes DSCR inside the transaction, thread.dscr is unable
to capture that latest value. But thread.dscr must contain the latest user
changed value of DSCR which is definitely not happening here. So there is
a problem we need to fix. 


