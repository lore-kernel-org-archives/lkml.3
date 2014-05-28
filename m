Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaE1IGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:06:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:33812 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbaE1IGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:06:02 -0400
Message-ID: <53859873.9070603@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 13:34:03 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [V6 00/11] perf: New conditional branch filter
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com> <CABPqkBS+3N6PW0wJr3xnvpF4zinZM7+iwFWzwS7BDm-LTkam5Q@mail.gmail.com>
In-Reply-To: <CABPqkBS+3N6PW0wJr3xnvpF4zinZM7+iwFWzwS7BDm-LTkam5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052808-5564-0000-0000-00000DF6044D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 05:39 PM, Stephane Eranian wrote:
> I have been looking at those patches and ran some tests.
> And I found a few issues so far.
> 
> I am running:
> $ perf record -j any_ret -e cycles:u test_program
> $ perf report -D
> 
> Most entries are okay and match the filter, however some do not make sense:
> 
> 3642586996762 0x15d0 [0x108]: PERF_RECORD_SAMPLE(IP, 2): 17921/17921:
> 0x10001170 period: 613678 addr: 0
> .... branch stack: nr:9
> .....  0: 00000000100011cc -> 0000000010000e38
> .....  1: 0000000010001150 -> 00000000100011bc
> .....  2: 0000000010001208 -> 0000000010000e38
> .....  3: 0000000010001160 -> 00000000100011f8
> .....  4: 00000000100011cc -> 0000000010000e38
> .....  5: 0000000010001150 -> 00000000100011bc
> .....  6: 0000000010001208 -> 0000000010000e38
> .....  7: 0000000010001160 -> 00000000100011f8
> .....  8: 0000000000000000 -> 0000000010001160
> ^^^^^^
> Entry 8 does not make sense, unless 0x0 is a valid return branch
> instruction address.
> If an address is invalid, the whole entry needs to be eliminated. It
> is okay to have
> less than the max number of entries supported by HW.

Hey Stephane,

Okay. The same behaviour is also reflected in the test results what I have
shared in the patchset. Here is that section.

(3) perf record -j any_ret -e branch-misses:u ./cprog

# Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
# ........  .......  ....................  .....................  ....................  .....................
#
    15.61%    cprog  [unknown]             [.] 00000000           cprog                 [.] sw_3_1           
     6.28%    cprog  cprog                 [.] symbol2            cprog                 [.] hw_1_2           
     6.28%    cprog  cprog                 [.] ctr_addr           cprog                 [.] sw_4_1           
     6.26%    cprog  cprog                 [.] success_3_1_3      cprog                 [.] sw_3_1           
     6.24%    cprog  cprog                 [.] symbol1            cprog                 [.] hw_1_1           
     6.24%    cprog  cprog                 [.] sw_4_2             cprog                 [.] callme           
     6.21%    cprog  [unknown]             [.] 00000000           cprog                 [.] callme           
     6.19%    cprog  cprog                 [.] lr_addr            cprog                 [.] sw_4_2           
     3.16%    cprog  cprog                 [.] hw_1_2             cprog                 [.] callme           
     3.15%    cprog  cprog                 [.] success_3_1_1      cprog                 [.] sw_3_1           
     3.15%    cprog  cprog                 [.] sw_4_1             cprog                 [.] callme           
     3.14%    cprog  cprog                 [.] callme             cprog                 [.] main             
     3.13%    cprog  cprog                 [.] hw_1_1             cprog                 [.] callme

So a lot of samples above have 0x0 as the "from" address. This originates from the code
section here inside the function "power_pmu_bhrb_read", where we hit two back to back
target addresses. So we zero out the from address for the first target address and re-read
the second address over again. So thats how we get zero as the from address. This is how the
HW capture the samples. I was reluctant to drop these samples but I agree that these kind of
samples can be dropped if we need to.

if (val & BHRB_TARGET) {
	/* Shouldn't have two targets in a
	   row.. Reset index and try again */
	r_index--;
	addr = 0;
}

> I also had cases where monitoring only at the user level, got me
> branch addresses in the
> 0xc0000000...... range. My test program is linked statically.
> 

Thats weird. I would need more information and details on this. BTW
what is the system you are running on ? Could you please share the
/proc/cpuinfo details of the same ?

> when eliminating the bogus entries, my tests yielded only return
> branch instruction addresses
> which is good. Will run more tests.

Sure. Thanks for the tests and comments.

