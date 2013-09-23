Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3IWJQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:16:50 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55271 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3IWJQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:16:48 -0400
Message-ID: <524006C4.3010006@linux.vnet.ibm.com>
Date: Mon, 23 Sep 2013 14:45:48 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Michael Ellerman <michael@ellerman.id.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michael Neuling <michael.neuling@au1.ibm.com>,
        svaidy@linux.vnet.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCH V2 0/6] perf: New conditional branch filter
References: <1377836690-32710-1-git-send-email-khandual@linux.vnet.ibm.com> <1378778772.25578.1.camel@concordia> <CABPqkBREXH5VUkULAsWvmpCer-s4SCxuof6LdqRO0i-iBOG8pA@mail.gmail.com>
In-Reply-To: <CABPqkBREXH5VUkULAsWvmpCer-s4SCxuof6LdqRO0i-iBOG8pA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092309-2674-0000-0000-00000AC19FA5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2013 12:25 PM, Stephane Eranian wrote:
> On Tue, Sep 10, 2013 at 4:06 AM, Michael Ellerman
> <michael@ellerman.id.au> wrote:
>> >
>> > On Fri, 2013-08-30 at 09:54 +0530, Anshuman Khandual wrote:
>>> > >       This patchset is the re-spin of the original branch stack sampling
>>> > > patchset which introduced new PERF_SAMPLE_BRANCH_COND filter. This patchset
>>> > > also enables SW based branch filtering support for PPC64 platforms which have
>>> > > branch stack sampling support. With this new enablement, the branch filter support
>>> > > for PPC64 platforms have been extended to include all these combinations discussed
>>> > > below with a sample test application program.
>> >
>> > ...
>> >
>>> > > Mixed filters
>>> > > -------------
>>> > > (6) perf record -e branch-misses:u -j any_call,any_ret ./cprog
>>> > > Error:
>>> > > The perf.data file has no samples!
>>> > >
>>> > > NOTE: As expected. The HW filters all the branches which are calls and SW tries to find return
>>> > > branches in that given set. Both the filters are mutually exclussive, so obviously no samples
>>> > > found in the end profile.
>> >
>> > The semantics of multiple filters is not clear to me. It could be an OR,
>> > or an AND. You have implemented AND, does that match existing behaviour
>> > on x86 for example?
>> >
> The semantic on the API is OR. AND does not make sense: CALL & RETURN?
> On x86, the HW filter is an OR (default: ALL, set bit to disable a
> type). I suspect
> it is similar on PPC.

Hey Stephane,

In POWER8 BHRB, we have got three HW PMU filters out of which we are trying
to use two of them PERF_SAMPLE_BRANCH_ANY_CALL and PERF_SAMPLE_BRANCH_COND
respectively.

(1) These filters are exclusive of each other and cannot be OR-ed with each other

(2) The SW filters are applied on the branch record set captured with BHRB
    which have the HW filters applied. So the working set is already reduced
    with the HW PMU filters. SW filter goes through the working set and figures
    out which one of them satisfy the SW filter criteria and gets picked up. The
    SW filter cannot find out branches records which matches the criteria outside
    of BHRB captured set. So we cannot OR the filters.

    This makes the combination of HW and SW filter inherently an "AND" not OR.

(3) But once we have captured the BHRB filtered data with HW PMU filter, multiple SW
    filters (if requested) can be applied either in OR or AND manner.

	It should be either like
		(1) (HW_FILTER_1) && (SW_FILTER_1) && (SW_FILTER_2)
	or like
		(2) (HW_FILTER_1) && (SW_FILTER_1 || SW_FILTER_2)

    NOTE: I admit that the current validate_instruction() function does not do
    either of them correctly. Will fix it in the next iteration.

(4) These combination of filters are not supported right now because

	(a) We are unable to process two HW PMU filters simultaneously
	(b) We have not worked on replacement SW filter for either of the HW filters

	(1) (HW_FILTER_1), (HW_FILTER_2)
	(2) (HW_FILTER_1), (HW_FILTER_2), (SW_FILTER_1)
	(3) (HW_FILTER_1), (HW_FILTER_2), (SW_FILTER_1), (SW_FILTER_2)

   How ever these combination of filters can be supported right now.

	(1) (HW_FILTER_1)
	(2) (HW_FILTER_2)

	(3) (SW_FILTER_1)
	(4) (SW_FILTER_2)
	(5) (SW_FILTER_1), (SW_FILTER_2)

	(6)  (HW_FILTER_1), (SW_FILTER_1)
	(7)  (HW_FILTER_1), (SW_FILTER_2)
	(8)  (HW_FILTER_1), (SW_FILTER_1), (SW_FILTER_2)
	(9)  (HW_FILTER_2), (SW_FILTER_1)
	(10) (HW_FILTER_2), (SW_FILTER_2)
	(11) (HW_FILTER_2), (SW_FILTER_1), (SW_FILTER_2)


Given the situation as explained here, which semantic would be better for single
HW and multiple SW filters. Accordingly validate_instruction() function will have
to be re-implemented. But I believe OR-ing the SW filters will be preferable.

	(1) (HW_FILTER_1) && (SW_FILTER_1) && (SW_FILTER_2)
	or
	(2) (HW_FILTER_1) && (SW_FILTER_1 || SW_FILTER_2)

Please let me know your inputs and suggestions on this. Thank you.

Regards
Anshuman

