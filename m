Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbaD2HCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 03:02:23 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33364 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551AbaD2HCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 03:02:22 -0400
Message-ID: <535F4E10.2020300@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2014 12:30:32 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: mikey@neuling.org, avagin@openvz.org, oleg@redhat.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        roland@redhat.com
Subject: Re: [PATCH 0/3] Add new ptrace request macros on PowerPC
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com> <533BD922.4070009@linux.vnet.ibm.com>
In-Reply-To: <533BD922.4070009@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042907-5564-0000-0000-00000D67C560
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 03:02 PM, Anshuman Khandual wrote:
> On 04/02/2014 12:32 PM, Anshuman Khandual wrote:
>> 	This patch series adds new ELF note sections which are used to
>> create new ptrace request macros for various transactional memory and
>> miscellaneous registers on PowerPC. Please find the test case exploiting
>> the new ptrace request macros and it's results on a POWER8 system.
>>
>> RFC: https://lkml.org/lkml/2014/4/1/292
>>
>> ============================== Results ==============================
>> -------TM specific SPR------
>> TM TFHAR: 100009dc
>> TM TEXASR: de000001ac000001
>> TM TFIAR: c00000000003f386
>> TM CH ORIG_MSR: 900000050000f032
>> TM CH TAR: 6
>> TM CH PPR: c000000000000
>> TM CH DSCR: 1
>> -------TM checkpointed GPR-----
>> TM CH GPR[0]: 1000097c
>> TM CH GPR[1]: 5
>> TM CH GPR[2]: 6
>> TM CH GPR[7]: 1
>> TM CH NIP: 100009dc
>> TM CH LINK: 1000097c
>> TM CH CCR: 22000422
>> -------TM running GPR-----
>> TM RN GPR[0]: 1000097c
>> TM RN GPR[1]: 7
>> TM RN GPR[2]: 8
>> TM RN GPR[7]: 5
>> TM RN NIP: 100009fc
>> TM RN LINK: 1000097c
>> TM RN CCR: 2000422
>> -------TM running FPR-----
>> TM RN FPR[0]: 1002d3a3780
>> TM RN FPR[1]: 7
>> TM RN FPR[2]: 8
>> TM RN FPSCR: 0
>> -------TM checkpointed FPR-----
>> TM CH FPR[0]: 1002d3a3780
>> TM CH FPR[1]: 5
>> TM CH FPR[2]: 6
>> TM CH FPSCR: 0
>> -------Running miscellaneous registers-------
> TM RN DSCR: 0
> 
> There is a problem in here which I forgot to mention. The running DSCR value
> comes from thread->dscr component of the target process. While we are inside the
> transaction (which is the case here as we are stuck at "b ." instruction and
> have not reached TEND) thread->dscr should have the running value of the DSCR
> register at that point of time. Here we expect the DSCR value to be 5 instead
> of 0 as shown in the output above. During the tests when I moved the "b ." after
> TEND, the thread->dscr gets the value of 5 while all check pointed reg values are
> thrown away. I believe there is some problem in the way thread->dscr context
> is saved away inside the TM section. Will look into this problem further and
> keep informed.

Reason behind this inconsistent DSCR register value is because of the following commit
where the kernel reverts the DSCR register into a default value to avoid running with
the user set value for a long time, thus preventing any potential performance degradation.
Same reason applies to the PPR register as well. So its not a problem but an expected
behaviour.

commit e9bdc3d6143d1c4b8d8ce5231fc958268331f983
Author: Michael Neuling <mikey@neuling.org>
Date:   Thu Sep 26 13:29:09 2013 +1000

    powerpc/tm: Switch out userspace PPR and DSCR sooner

    When we do a treclaim or trecheckpoint we end up running with userspace
    PPR and DSCR values.  Currently we don't do anything special to avoid
    running with user values which could cause a severe performance
    degradation.

    This patch moves the PPR and DSCR save and restore around treclaim and
    trecheckpoint so that we run with user values for a much shorter period.
    More care is taken with the PPR as it's impact is greater than the DSCR.

    This is similar to user exceptions, where we run HTM_MEDIUM early to
    ensure that we don't run with a userspace PPR values in the kernel.

