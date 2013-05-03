Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910Ab3ECJMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:12:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab3ECJMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:12:50 -0400
Message-ID: <51837F8C.4080801@redhat.com>
Date: Fri, 03 May 2013 11:12:44 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] swap: redirty page if page write fails on swap file
References: <516E918B.3050309@redhat.com> <516F3AA7.1000908@gmail.com> <5180C6C1.6010000@gmail.com>
In-Reply-To: <5180C6C1.6010000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 09:39 AM, Simon Jeons wrote:
> Ping, ;-)
> On 04/18/2013 08:13 AM, Simon Jeons wrote:
>> Hi Jerome,
>> On 04/17/2013 08:11 PM, Jerome Marchand wrote:
>>> Since commit 62c230b, swap_writepage() calls direct_IO on swap files.
>>> However, in that case page isn't redirtied if I/O fails, and is 
>>> therefore
>>> handled afterwards as if it has been successfully written to the swap
>>> file, leading to memory corruption when the page is eventually swapped
>>> back in.
>>> This patch sets the page dirty when direct_IO() fails. It fixes a memory
>>
>> If swapfile has related page cache which cached swapfile in memory? It 
>> is not necessary, correct?

I'm not sure I understand the question. What I can tell you is that it is 
necessary if the swapfile is located on a fs that uses swap_activate (only
NFS so far). Other swap file hasn't been impacted by commit 62c230b.

>>
>>> corruption that happened while using swap-over-NFS.
>>>
>>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>>> ---
>>>   mm/page_io.c |    2 ++
>>>   1 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/mm/page_io.c b/mm/page_io.c
>>> index 78eee32..04ca00d 100644
>>> --- a/mm/page_io.c
>>> +++ b/mm/page_io.c
>>> @@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct 
>>> writeback_control *wbc)
>>>           if (ret == PAGE_SIZE) {
>>>               count_vm_event(PSWPOUT);
>>>               ret = 0;
>>> +        } else {
>>> +            set_page_dirty(page);
>>>           }
>>>           return ret;
>>>       }
>>>
>>> -- 
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
> 

