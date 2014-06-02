Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbaFBM7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:59:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46985 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaFBM7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:59:06 -0400
MIME-Version: 1.0
In-Reply-To: <53859873.9070603@linux.vnet.ibm.com>
References: <1399280953-31442-1-git-send-email-khandual@linux.vnet.ibm.com>
	<CABPqkBS+3N6PW0wJr3xnvpF4zinZM7+iwFWzwS7BDm-LTkam5Q@mail.gmail.com>
	<53859873.9070603@linux.vnet.ibm.com>
Date: Mon, 2 Jun 2014 14:59:04 +0200
Message-ID: <CABPqkBSmuMth4KmdLw7Nigf5uQREQJ+xL=42xV9c8FjR2VPO5g@mail.gmail.com>
Subject: Re: [V6 00/11] perf: New conditional branch filter
From: Stephane Eranian <eranian@google.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Linux PPC dev <linuxppc-dev@ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 10:04 AM, Anshuman Khandual
<khandual@linux.vnet.ibm.com> wrote:
> On 05/27/2014 05:39 PM, Stephane Eranian wrote:
>> I have been looking at those patches and ran some tests.
>> And I found a few issues so far.
>>
>> I am running:
>> $ perf record -j any_ret -e cycles:u test_program
>> $ perf report -D
>>
>> Most entries are okay and match the filter, however some do not make sense:
>>
>> 3642586996762 0x15d0 [0x108]: PERF_RECORD_SAMPLE(IP, 2): 17921/17921:
>> 0x10001170 period: 613678 addr: 0
>> .... branch stack: nr:9
>> .....  0: 00000000100011cc -> 0000000010000e38
>> .....  1: 0000000010001150 -> 00000000100011bc
>> .....  2: 0000000010001208 -> 0000000010000e38
>> .....  3: 0000000010001160 -> 00000000100011f8
>> .....  4: 00000000100011cc -> 0000000010000e38
>> .....  5: 0000000010001150 -> 00000000100011bc
>> .....  6: 0000000010001208 -> 0000000010000e38
>> .....  7: 0000000010001160 -> 00000000100011f8
>> .....  8: 0000000000000000 -> 0000000010001160
>> ^^^^^^
>> Entry 8 does not make sense, unless 0x0 is a valid return branch
>> instruction address.
>> If an address is invalid, the whole entry needs to be eliminated. It
>> is okay to have
>> less than the max number of entries supported by HW.
>
> Hey Stephane,
>
> Okay. The same behaviour is also reflected in the test results what I have
> shared in the patchset. Here is that section.
>
> (3) perf record -j any_ret -e branch-misses:u ./cprog
>
> # Overhead  Command  Source Shared Object          Source Symbol  Target Shared Object          Target Symbol
> # ........  .......  ....................  .....................  ....................  .....................
> #
>     15.61%    cprog  [unknown]             [.] 00000000           cprog                 [.] sw_3_1
>      6.28%    cprog  cprog                 [.] symbol2            cprog                 [.] hw_1_2
>      6.28%    cprog  cprog                 [.] ctr_addr           cprog                 [.] sw_4_1
>      6.26%    cprog  cprog                 [.] success_3_1_3      cprog                 [.] sw_3_1
>      6.24%    cprog  cprog                 [.] symbol1            cprog                 [.] hw_1_1
>      6.24%    cprog  cprog                 [.] sw_4_2             cprog                 [.] callme
>      6.21%    cprog  [unknown]             [.] 00000000           cprog                 [.] callme
>      6.19%    cprog  cprog                 [.] lr_addr            cprog                 [.] sw_4_2
>      3.16%    cprog  cprog                 [.] hw_1_2             cprog                 [.] callme
>      3.15%    cprog  cprog                 [.] success_3_1_1      cprog                 [.] sw_3_1
>      3.15%    cprog  cprog                 [.] sw_4_1             cprog                 [.] callme
>      3.14%    cprog  cprog                 [.] callme             cprog                 [.] main
>      3.13%    cprog  cprog                 [.] hw_1_1             cprog                 [.] callme
>
> So a lot of samples above have 0x0 as the "from" address. This originates from the code
> section here inside the function "power_pmu_bhrb_read", where we hit two back to back

Could you explain the back-to-back case a bit more here?
Back-to-back returns to me means something like:

int foo()
{
  ...
   return bar();
}

int bar()
{
  return 0;
}

Not counting the leaf optimization here, bar return to foo which
immediately returns: 2 back-2-back returns.
Is that the case you're talking about here?

> target addresses. So we zero out the from address for the first target address and re-read
> the second address over again. So thats how we get zero as the from address. This is how the
> HW capture the samples. I was reluctant to drop these samples but I agree that these kind of
> samples can be dropped if we need to.
>
I think we need to make it as simple as possible for tools, i.e.,
avoid having to decode the
disassembly to figure out what happened. Here address 0 is not exploitable.

> if (val & BHRB_TARGET) {
>         /* Shouldn't have two targets in a
>            row.. Reset index and try again */
>         r_index--;
>         addr = 0;
> }
