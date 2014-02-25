Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaBYUeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 15:34:14 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51902 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbaBYUeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 15:34:10 -0500
Message-ID: <530CFE30.70803@linux.vnet.ibm.com>
Date: Tue, 25 Feb 2014 12:33:52 -0800
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] perf: add PMU_RANGE_ATTR() helper for use by
 sw-like pmus
References: <20140225033326.135BB2C0227@ozlabs.org>
In-Reply-To: <20140225033326.135BB2C0227@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022520-1542-0000-0000-0000069C7CEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2014 07:33 PM, Michael Ellerman wrote:
> On Fri, 2014-14-02 at 22:02:05 UTC, Cody P Schafer wrote:
>> Add PMU_RANGE_ATTR() and PMU_RANGE_RESV() (for reserved areas) which
>> generate functions to extract the relevent bits from
>> event->attr.config{,1,2} for use by sw-like pmus where the
>> 'config{,1,2}' values don't map directly to hardware registers.
>>
>> Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
>> ---
>>   include/linux/perf_event.h | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index e56b07f..2702e91 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -871,4 +871,21 @@ _name##_show(struct device *dev,					\
>>   									\
>>   static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
>>
>> +#define PMU_RANGE_ATTR(name, attr_var, bit_start, bit_end)		\
>> +PMU_FORMAT_ATTR(name, #attr_var ":" #bit_start "-" #bit_end);		\
>> +PMU_RANGE_RESV(name, attr_var, bit_start, bit_end)
>> +
>> +#define PMU_RANGE_RESV(name, attr_var, bit_start, bit_end)		\
>> +static u64 event_get_##name##_max(void)					\
>> +{									\
>> +	int bits = (bit_end) - (bit_start) + 1;				\
>> +	return ((0x1ULL << (bits - 1ULL)) - 1ULL) |			\
>> +		(0xFULL << (bits - 4ULL));				\
>> +}									\
>> +static u64 event_get_##name(struct perf_event *event)			\
>> +{									\
>> +	return (event->attr.attr_var >> (bit_start)) &			\
>> +		event_get_##name##_max();				\
>> +}
>
> I still don't like the names.
>
> EVENT_GETTER_AND_FORMAT()

EVENT_RANGE()

I'd prefer to describe the intended usage rather than what is generated 
both in case we change some of the specifics later, and to provide 
additional information to the developers beyond what a simple code 
reading gives.

> EVENT_RESERVED()

Sure. The PMU_* naming was just based on the PMU_FORMAT_ATTR() naming, 
so I kept it for continuity with the existing API. Maybe 
EVENT_RANGE_RESERVED() would be more appropriate?

> ?
>
> It's not clear to me the max routine is useful in general. Can't we just do:
>
>> +#define EVENT_RESERVED(name, attr_var, bit_start, bit_end)		\
>> +static u64 event_get_##name(struct perf_event *event)		\
>> +{									\
>> +	return (event->attr.attr_var >> (bit_start)) &			\
>> +		((0x1ULL << ((bit_end) - (bit_start) + 1)) - 1ULL);	\
>> +}

I use event_get_*_max() for some checking of parameters in event_init(). 
Having it lets me avoid specifying the maximum explicitly (0x7ffff = 
0-19, for example). Specifying it explicitly would mean we'd have the 
bit width of the field in question encoded in two places instead of one, 
and I'd prefer to avoid unneeded duplication.

