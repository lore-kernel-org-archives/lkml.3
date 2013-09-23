Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3IWPps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:45:48 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:49629 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab3IWPpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:45:47 -0400
Message-ID: <5240622A.5010305@akamai.com>
Date: Mon, 23 Sep 2013 11:45:46 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: Jason Baron <jbaron@akamai.com>, Nathan Zimmer <nzimmer@sgi.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] eventpoll: Move a kmem_cache_alloc and kmem_cache_free
References: <1379087642-131349-1-git-send-email-nzimmer@sgi.com> <5239FA69.8030202@akamai.com> <20130922204137.GA1612@dcvr.yhbt.net>
In-Reply-To: <20130922204137.GA1612@dcvr.yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2013 04:41 PM, Eric Wong wrote:
> Jason Baron <jbaron@akamai.com> wrote:
>>     epoll: reduce usage of global 'epmutex' lock
>>
>>     Epoll file descriptors that are 1 link from a wakeup source and
>>     are not nested within other epoll descriptors, or pointing to
>>     other epoll descriptors, don't need to check for loop creation or
>>     the creation of wakeup storms. Because of this we can avoid taking
>>     the global 'epmutex' in these cases. This state for the epoll file
>>     descriptor is marked as 'EVENTPOLL_BASIC'. Once the epoll file
>>     descriptor is attached to another epoll file descriptor it is
>>     labeled as 'EVENTPOLL_COMPLEX', and full loop checking and wakeup
>>     storm creation are checked using the the global 'epmutex'. It does
>>     not transition back. Hopefully, this is a common usecase...
> 
> Cool.  I was thinking about doing the same thing down the line (for
> EPOLL_CTL_ADD, too)
> 
>> @@ -166,6 +167,14 @@ struct epitem {
>>  
>>  	/* The structure that describe the interested events and the source fd */
>>  	struct epoll_event event;
>> +
>> +	/* TODO: really necessary? */
>> +	int on_list;
> 
> There's some things we can overload to avoid increasing epitem size
> (.ep, .ffd.fd, ...), so on_list should be unnecessary.

Even with 'on_list' the size of 'epitem' stayed at 128 bytes. Not sure if
there are certain compile options though that can move it over that you
are concerned about...so I think that change is ok.

The biggest hack here was using 'struct rb_node' instead of a proper
'struct rcu_head', so as not to increase the size of epitem. I think this
is safe and I've added build time checks to ensure that 'struct rb_node'
is never smaller than 'struct rcu_head'. But its rather hacky. I will
probably break this change out separately when I re-post so it can be
reviewed independently...

Thanks,

-Jason
