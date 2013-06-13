Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259Ab3FMIBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 04:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab3FMIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 04:01:20 -0400
Message-ID: <51B97C1A.8000302@redhat.com>
Date: Thu, 13 Jun 2013 10:00:26 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, erdnetdev@gmail.com, bhutchings@solarflare.com,
        andi@firstfloor.org, hpa@zytor.com, eilong@broadcom.com,
        or.gerlitz@gmail.com, amirv@mellanox.com, eliezer@tamir.org.il
Subject: Re: [PATCH net-next 1/2] net: remove NET_LL_RX_POLL config menue
References: <20130611142415.17879.75569.stgit@ladj378.jer.intel.com> <20130611142428.17879.33582.stgit@ladj378.jer.intel.com> <20130612.151205.1822920389019274346.davem@davemloft.net> <20130612190103.1545e310@nehalam.linuxnetplumber.net> <51B92ACE.7000307@linux.intel.com>
In-Reply-To: <51B92ACE.7000307@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 04:13 AM, Eliezer Tamir wrote:
> On 13/06/2013 05:01, Stephen Hemminger wrote:
>> On Wed, 12 Jun 2013 15:12:05 -0700 (PDT)
>> David Miller <davem@davemloft.net> wrote:
>>
>>> From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>>> Date: Tue, 11 Jun 2013 17:24:28 +0300
>>>
>>>>       depends on X86_TSC
>>>
>>> Wait a second, I didn't notice this before.  There needs to be a better
>>> way to test for the accuracy you need, or if the issue is lack of a proper
>>> API for cycle counter reading, fix that rather than add ugly arch
>>> specific dependencies to generic networking code.
>>
>> This should be sched_clock(), rather than direct TSC access.
>> Also any code using TSC or sched_clock has to be carefully audited to deal with
>> clocks running at different rates on different CPU's. Basically value is only
>> meaning full on same CPU.
>
> OK,
>
> If we covert to sched_clock(), would adding a define such as HAVE_HIGH_PRECISION_CLOCK to architectures that have both a high precision clock and a 64 bit cycles_t be a good solution?
>
> (if not any other suggestion?)

Hm, probably cpu_clock() and similar might be better, since they use
sched_clock() in the background when !CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
(meaning when sched_clock() provides synchronized highres time source from
the architecture), and, quoting ....

  Otherwise it tries to create a semi stable clock from a mixture of other
  clocks, including:

   - GTOD (clock monotomic)
   - sched_clock()
   - explicit idle events

But yeah, it needs to be evaluated regarding the drift between CPUs in
general.

Then, eventually, you could get rid of the entire NET_LL_RX_POLL config
option plus related ifdefs in the code and have it built-in in general?
