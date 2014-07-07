Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaGGUnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 16:43:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:62821 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbaGGUnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 16:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,620,1400050800"; 
   d="scan'208";a="539900669"
Message-ID: <53BB0673.8020604@intel.com>
Date: Mon, 07 Jul 2014 13:43:31 -0700
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
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Kees Cook <kees@outflux.net>
Subject: Re: [PATCH v3 1/3] mm: introduce fincore()
References: <1404756006-23794-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1404756006-23794-2-git-send-email-n-horiguchi@ah.jp.nec.com> <53BAEE95.50807@intel.com> <20140707202108.GA5031@nhori.bos.redhat.com>
In-Reply-To: <20140707202108.GA5031@nhori.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 01:21 PM, Naoya Horiguchi wrote:
> On Mon, Jul 07, 2014 at 12:01:41PM -0700, Dave Hansen wrote:
>> But, is this trying to do too many things at once?  Do we have solid use
>> cases spelled out for each of these modes?  Have we thought out how they
>> will be used in practice?
> 
> tools/vm/page-types.c will be an in-kernel user after this base code is
> accepted. The idea of doing fincore() thing comes up during the discussion
> with Konstantin over file cache mode of this tool.
> pfn and page flag are needed there, so I think it's one clear usecase.

I'm going to take that as a no. :)

The whole FINCORE_PGOFF vs. FINCORE_BMAP issue is something that will
come up in practice.  We just don't have the interfaces for an end user
to pick which one they want to use.
>> Is it really right to say this is going to be 8 bytes?  Would we want it
>> to share types with something else, like be an loff_t?
> 
> Could you elaborate it more?

We specify file offsets in other system calls, like the lseek family.  I
was just thinking that this type should match up with those calls since
they are expressing the same data type with the same ranges and limitations.

>>> + * - FINCORE_PFN:
>>> + *     stores pfn, using 8 bytes.
>>
>> These are all an unprivileged operations from what I can tell.  I know
>> we're going to a lot of trouble to hide kernel addresses from being seen
>> in userspace.  This seems like it would be undesirable for the folks
>> that care about not leaking kernel addresses, especially for
>> unprivileged users.
>>
>> This would essentially tell userspace where in the kernel's address
>> space some user-controlled data will be.
> 
> OK, so this and FINCORE_PAGEFLAGS will be limited for privileged users.

Then I'd just question their usefulness outside of a debugging
environment, especially when you can get at them in other (more
roundabout) ways in a debugging environment.

This is really looking to me like two system calls.  The bitmap-based
one, and another more extensible one.  I don't think there's any harm in
having two system calls, especially when they're trying to glue together
two disparate interfaces.

