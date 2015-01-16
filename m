Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbbAPUm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 15:42:26 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54081 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbbAPUmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 15:42:25 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: Issue with 'lib/vsprintf.c: don't try to fix pointer wrap-around'
Organization: D03
References: <20150116162357.GA10859@phnom.home.cmpxchg.org>
	<20150116122404.e82eb86b5c46afdd0d00df1d@linux-foundation.org>
X-Hashcash: 1:20:150116:hannes@cmpxchg.org::8HIc5soRr5frtk8o:00000000000000000000000000000000000000000004n9t
X-Hashcash: 1:20:150116:linux-kernel@vger.kernel.org::GDVHlnQgtc/uwRG5:000000000000000000000000000000000BP8N
X-Hashcash: 1:20:150116:akpm@linux-foundation.org::BXFd7Mi0FSvM8wsJ:000000000000000000000000000000000000AiQF
Date: Fri, 16 Jan 2015 21:42:21 +0100
In-Reply-To: <20150116122404.e82eb86b5c46afdd0d00df1d@linux-foundation.org>
	(Andrew Morton's message of "Fri, 16 Jan 2015 12:24:04 -0800")
Message-ID: <87mw5izccy.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16 2015, Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 16 Jan 2015 11:23:57 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> Hi Rasmus,
>> 
>> I have trouble booting my test machine with this patch in -mm:
>> 
>> commit bb2e066c6943e62e9650bb129f416dacf138f8b1
>> Author: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Date:   Wed Jan 14 01:00:44 2015 +0000
>> 
>>     lib/vsprintf.c: don't try to fix pointer wrap-around
>>     
>>     Actual kernel buffers can't wrap into the user address space.  If someone
>>     manages to pass a buf/size combination that wraps, it is most likely due
>>     to a bug in the caller.  Instead of trying to fix it by using a smaller
>>     part of the buffer, bail out.
>>     
>>     Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>     Cc: Jiri Kosina <jkosina@suse.cz>
>>     Cc: Randy Dunlap <rdunlap@infradead.org>
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> 
>> After I get "Loading bzImage-new... ok" from the bootloader, the
>> serial console remains quiet.
>> 
>> A WARN_ON_ONCE() inside vsnprintf() looks like it would deadlock
>> instantly when triggering this overflow from printk(), no?
>
> Dammit, I was starting at that printk, ended up deciding it was OK,
> didn't think about deadlocks.  logbuf_lock and recursion_bug, for a
> start...
>
> I'll drop the patch.

Good, because the bug is in my brain. I think the cause may be a sprintf
or vsprintf call that doesn't actually print what it is supposed to,
since they pass INT_MAX for size, and that can of course easily cause
buf+size to wrap-around (it is basically guaranteed on 32 bit).

Sorry about this. Thanks for reporting, Johannes.

Rasmus
