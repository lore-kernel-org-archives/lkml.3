Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbaAXNm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:42:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaAXNmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:42:55 -0500
Message-ID: <52E26DDD.90702@redhat.com>
Date: Fri, 24 Jan 2014 14:42:53 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: fix locking bug in __dentry_path()
References: <1390558886-4152-1-git-send-email-dvlasenk@redhat.com> <20140124122409.GT10323@ZenIV.linux.org.uk>
In-Reply-To: <20140124122409.GT10323@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2014 01:24 PM, Al Viro wrote:
> On Fri, Jan 24, 2014 at 11:21:26AM +0100, Denys Vlasenko wrote:
>> If given buffer size is zero, we forget to rcu_read_unlock()
>> on error path.
> 
> Er...  Where could we ever get called with size zero?  IOW, the
> real question is whether that check makes any sense.  If nothing
> else, a much more obvious fix (again, assuming there is a call
> chain that could have triggered that in the first place), would
> be to take that
>         if (buflen < 1)
>                 goto Elong;
> on the very top of __dentry_path().  Note that buflen never
> change, so this check could bloody well be handled once - and
> earlier.

Yes. In fact the check is buggier than I thought:

        prepend(&end, &len, "\0", 1);
        if (buflen < 1)
                goto Elong;
        /* Get '/' right */
        retval = end-1;
        *retval = '/';   <=== !!!

It should be "buflen < 2". With buflen == 1, we touch buffer[-1].

> But again, the callers shouldn't be calling it that
> way...

I'll add a check in d_path() and post another patch.
I assume the assertion should be 'size >= 2', since
path "" should never be produced anyway, the shortest path
is "/"?

-- 
vda


