Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaJCSNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 14:13:45 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:46983 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJCSNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 14:13:43 -0400
Message-ID: <542EE753.20005@kernel.dk>
Date: Fri, 03 Oct 2014 12:13:39 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org
CC: Benjamin LaHaise <bcrl@kvack.org>, Zach Brown <zab@zabbo.net>,
        Jeff Moyer <jmoyer@redhat.com>, Slava Pestov <sp@daterainc.com>
Subject: Re: [PATCH] aio: Fix return code of io_submit() (RFC)
References: <1412359693-2535-1-git-send-email-kmo@daterainc.com>
In-Reply-To: <1412359693-2535-1-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-03 12:08, Kent Overstreet wrote:
> io_submit() could return -EAGAIN on memory allocation failure when it should
> really have been returning -ENOMEM. This could confuse applications (i.e. fio)
> since -EAGAIN means "too many requests outstanding, wait until completions have
> been reaped" and if the application actually was tracking outstanding
> completions this wouldn't make a lot of sense.
>
> NOTE:
>
> the man page seems to imply that the current behaviour (-EAGAIN on allocation
> failure) has always been the case. I don't think it makes a lot of sense, but
> this should probably be discussed more widely in case applications have somehow
> come to rely on the current behaviour...

We can't really feasibly fix this, is my worry. Fio does track the 
pending requests and does not get into a getevents() forever wait if it 
gets -EAGAIN on submission. But before the fix, it would loop forever in 
submission in -EAGAIN.

How are applications supposed to deal with ENOMEM? I think the answer 
here is that they can't, it would be a fatal condition. AIO must provide 
isn't own guarantee of progress, with a mempool or similar.


-- 
Jens Axboe

