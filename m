Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaDBJeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 05:34:10 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58442 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbaDBJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 05:34:06 -0400
Message-ID: <533BD922.4070009@linux.vnet.ibm.com>
Date: Wed, 02 Apr 2014 15:02:18 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, avagin@openvz.org,
        oleg@redhat.com, roland@redhat.com, mikey@neuling.org,
        benh@kernel.crashing.org
Subject: Re: [PATCH 0/3] Add new ptrace request macros on PowerPC
References: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
In-Reply-To: <1396422144-11032-1-git-send-email-khandual@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040209-8878-0000-0000-00000B998199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 12:32 PM, Anshuman Khandual wrote:
> 	This patch series adds new ELF note sections which are used to
> create new ptrace request macros for various transactional memory and
> miscellaneous registers on PowerPC. Please find the test case exploiting
> the new ptrace request macros and it's results on a POWER8 system.
> 
> RFC: https://lkml.org/lkml/2014/4/1/292
> 
> ============================== Results ==============================
> -------TM specific SPR------
> TM TFHAR: 100009dc
> TM TEXASR: de000001ac000001
> TM TFIAR: c00000000003f386
> TM CH ORIG_MSR: 900000050000f032
> TM CH TAR: 6
> TM CH PPR: c000000000000
> TM CH DSCR: 1
> -------TM checkpointed GPR-----
> TM CH GPR[0]: 1000097c
> TM CH GPR[1]: 5
> TM CH GPR[2]: 6
> TM CH GPR[7]: 1
> TM CH NIP: 100009dc
> TM CH LINK: 1000097c
> TM CH CCR: 22000422
> -------TM running GPR-----
> TM RN GPR[0]: 1000097c
> TM RN GPR[1]: 7
> TM RN GPR[2]: 8
> TM RN GPR[7]: 5
> TM RN NIP: 100009fc
> TM RN LINK: 1000097c
> TM RN CCR: 2000422
> -------TM running FPR-----
> TM RN FPR[0]: 1002d3a3780
> TM RN FPR[1]: 7
> TM RN FPR[2]: 8
> TM RN FPSCR: 0
> -------TM checkpointed FPR-----
> TM CH FPR[0]: 1002d3a3780
> TM CH FPR[1]: 5
> TM CH FPR[2]: 6
> TM CH FPSCR: 0
> -------Running miscellaneous registers-------
TM RN DSCR: 0

There is a problem in here which I forgot to mention. The running DSCR value
comes from thread->dscr component of the target process. While we are inside the
transaction (which is the case here as we are stuck at "b ." instruction and
have not reached TEND) thread->dscr should have the running value of the DSCR
register at that point of time. Here we expect the DSCR value to be 5 instead
of 0 as shown in the output above. During the tests when I moved the "b ." after
TEND, the thread->dscr gets the value of 5 while all check pointed reg values are
thrown away. I believe there is some problem in the way thread->dscr context
is saved away inside the TM section. Will look into this problem further and
keep informed.

