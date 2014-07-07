Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaGGWec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:34:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:18963 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbaGGWeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,621,1400050800"; 
   d="scan'208";a="539941493"
Message-ID: <53BB205E.5080801@intel.com>
Date: Mon, 07 Jul 2014 15:34:06 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        Andres Freund <andres@2ndquadrant.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH v3 3/3] man2/fincore.2: document general description about
 fincore(2)
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-4-git-send-email-n-horiguchi@ah.jp.nec.com> <53BAF01C.8010700@intel.com> <20140707205956.GB5031@nhori.bos.redhat.com>
In-Reply-To: <20140707205956.GB5031@nhori.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 01:59 PM, Naoya Horiguchi wrote:
> On Mon, Jul 07, 2014 at 12:08:12PM -0700, Dave Hansen wrote:
>> On 07/07/2014 11:00 AM, Naoya Horiguchi wrote:
>>> +.SH RETURN VALUE
>>> +On success,
>>> +.BR fincore ()
>>> +returns 0.
>>> +On error, \-1 is returned, and
>>> +.I errno
>>> +is set appropriately.
>>
>> Is this accurate?  From reading the syscall itself, it looked like it
>> did this:
>>
>>> + * Return value is the number of pages whose data is stored in fc->buffer.
>>> + */
>>> +static long do_fincore(struct fincore_control *fc, int nr_pages)
>>
>> and:
>>
>>> +SYSCALL_DEFINE6(fincore, int, fd, loff_t, start, long, nr_pages,
>> ...
>>> +	while (fc.nr_pages > 0) {
>>> +		memset(fc.buffer, 0, fc.buffer_size);
>>> +		ret = do_fincore(&fc, min(step, fc.nr_pages));
>>> +		/* Reached the end of the file */
>>> +		if (ret == 0)
>>> +			break;
>>> +		if (ret < 0)
>>> +			break;
>> ...
>>> +	}
>> ...
>>> +	return ret;
>>> +}
>>
>> Which seems that for a given loop of do_fincore(), you might end up
>> returning the result of that *single* iteration of do_fincore() instead
>> of the aggregate of the entire syscall.
>>
>> So, it can return <0 on failure, 0 on success, or also an essentially
>> random >0 number on success too.
> 
> We don't break this while loop if do_fincore() returned a positive value
> unless copy_to_user() fails. And in that case ret is set to -EFAULT.
> So I think sys_fincore() never returns a positive value.

OK, that makes sense as I'm reading it again.

>> Why not just use the return value for something useful instead of
>> hacking in the extras->nr_entries stuff?
> 
> Hmm, I got the opposite complaint previously, where we shouldn't
> interpret the return value differently depending on the flag.
> And I'd like to keep the extra argument for future extensibility.
> For example, if we want to collect pages only with a specific
> set of page flags, this extra argument will be necessary.

Couldn't it simply be the number of elements that it wrote in to the
buffer, or even the number of bytes?

