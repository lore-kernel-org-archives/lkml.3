Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759843Ab3IDTdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:33:14 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:3220 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab3IDTdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:33:13 -0400
Message-ID: <52278AEC.2020307@hp.com>
Date: Wed, 04 Sep 2013 15:33:00 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] dcache: Translating dentry into pathname without taking
 rename_lock
References: <1378321523-40893-1-git-send-email-Waiman.Long@hp.com> <20130904191104.GK13318@ZenIV.linux.org.uk>
In-Reply-To: <20130904191104.GK13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 03:11 PM, Al Viro wrote:
> On Wed, Sep 04, 2013 at 03:05:23PM -0400, Waiman Long wrote:
>>
>>   static int prepend_name(char **buffer, int *buflen, struct qstr *name)
>>   {
>> -	return prepend(buffer, buflen, name->name, name->len);
>> +	/*
>> +	 * With RCU path tracing, it may race with rename. Use
>> +	 * ACCESS_ONCE() to make sure that it is either the old or
>> +	 * the new name pointer. The length does not really matter as
>> +	 * the sequence number check will eventually catch any ongoing
>> +	 * rename operation.
>> +	 */
>> +	const char *dname = ACCESS_ONCE(name->name);
>> +	int   dlen = name->len;
>> +
>> +	if (unlikely(!dname || !dlen))
>> +		return -EINVAL;
>> +	return prepend(buffer, buflen, dname, dlen);
> NAK.  A race with d_move() can very well leave you with dname pointing into
> an object of length smaller than dlen.  You *can* copy it byte-by-byte
> and rely on NUL-termination, but you can't rely on length being accurate -
> not without having excluded d_move().

I have thought about that. But if a d_move() is going on, the string in 
the buffer will be discarded as the sequence number will change. So 
whether or not it have embedded null byte shouldn't matter. That is why 
I didn't add code to do byte-by-byte copy at this first patch. I can add 
code to do that if you think it is safer to do so.

Regards,
Longman
