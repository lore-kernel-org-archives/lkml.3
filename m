Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab3JHVXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 17:23:20 -0400
Received: from www.sr71.net ([198.145.64.142]:51372 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab3JHVXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 17:23:17 -0400
Message-ID: <525477A4.5060504@sr71.net>
Date: Tue, 08 Oct 2013 14:22:44 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 1/2] vmsplice: unmap gifted pages for recipient
References: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com> <1381177293-27125-2-git-send-email-rcj@linux.vnet.ibm.com> <52542F53.4020807@sr71.net> <20131008194819.GB6129@linux.vnet.ibm.com>
In-Reply-To: <20131008194819.GB6129@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2013 12:48 PM, Robert Jennings wrote:
> * Dave Hansen (dave@sr71.net) wrote:
>> On 10/07/2013 01:21 PM, Robert C Jennings wrote:
>>> +					} else {
>>> +						if (vma)
>>> +							zap_page_range(vma,
>>> +								user_start,
>>> +								(user_end -
>>> +								 user_start),
>>> +								NULL);
>>> +						vma = find_vma_intersection(
>>> +								current->mm,
>>> +								useraddr,
>>> +								(useraddr +
>>> +								 PAGE_SIZE));
>>> +						if (!IS_ERR_OR_NULL(vma)) {
>>> +							user_start = useraddr;
>>> +							user_end = (useraddr +
>>> +								    PAGE_SIZE);
>>> +						} else
>>> +							vma = NULL;
>>> +					}
>>
>> This is pretty unspeakably hideous.  Was there truly no better way to do
>> this?
> 
> I was hoping to find a better way to coalesce pipe buffers and zap
> entire VMAs (and it needs better documentation but your argument is with
> structure and I agree). I would love suggestions for improving this but
> that is not to say that I've abandoned it; I'm still looking for ways
> to make this cleaner.

Doing the VMA search each and every time seems a bit silly.  Do one
find_vma(), the look at the _end_ virtual address of the VMA.  You can
continue to collect your set of zap_page_range() addresses as long as
you do not hit the end of that address range.

If and only if you hit the end of the vma, do the zap_page_range(), and
then look up the VMA again.

Storing the .useraddr still seems odd to me, and you haven't fully
explained why you're doing it or how it is safe, or why you store both
virtual addresses and file locations in it.
