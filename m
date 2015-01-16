Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbbAPRD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:03:29 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:15254 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbbAPRD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:03:27 -0500
Message-ID: <54B9445C.4070800@akamai.com>
Date: Fri, 16 Jan 2015 12:03:24 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>, Jason Baron <jbaron@akamai.com>
CC: akpm@linux-foundation.org, famz@redhat.com, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 5/5] epoll: introduce epoll connected components (remove
 the epmutex)
References: <cover.1421337657.git.jbaron@akamai.com> <f0053e978dfddd6fa9a5c72c69d9353d219fc4b9.1421337657.git.jbaron@akamai.com> <20150115231051.GA24252@dcvr.yhbt.net>
In-Reply-To: <20150115231051.GA24252@dcvr.yhbt.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 06:10 PM, Eric Wong wrote:
> Jason Baron <jbaron@akamai.com> wrote:
>> I've done a bit of performance evaluation on a dual socket, 10 core, hyper
>> threading enabled box: Intel(R) Xeon(R) CPU E5-2650 v3 @ 2.30GHz. For the
>> simple epfdN->epfdN->pipefdN topology case where each thread has its
>> own unique files and is doing EPOLL_CTL_ADD and EPOLL_CTL_DEL on the pipefd,
>> I see an almost 300% improvement. This is obviously a very contrived case,
>> but shows the motivation for this patch.
> Any improvements for non-contrived cases? :)

I plan to do some more testing and will post performance findings...

>> +++ b/include/linux/fs.h
>> @@ -835,6 +835,9 @@ struct file {
>>  	/* Used by fs/eventpoll.c to link all the hooks to this file */
>>  	struct list_head	f_ep_links;
>>  	struct list_head	f_tfile_llink;
>> +	/* connected component */
>> +	struct list_head	f_ep_cc_link;
>> +	struct ep_cc __rcu	*f_ep_cc;
>>  #endif /* #ifdef CONFIG_EPOLL */
> This size increase worries me.  Perhaps this can be a separately
> allocated struct to avoid penalizing non-epoll users?

Agreed. That was why I marked this RFC. I was planning to try and shrink
some of the lists to singly-linked lists. But I think breaking it out as 'file_eventpoll'
is a good suggestion. We could simply just always allocate it for an epfd,
and then just allocate it for a 'regular' struct file on the first EPOLL_CTL_ADD.
That would actually result in a net shrinkage of the 'struct file' by 3 pointers from
where we are today. So I think that would be nice.

Thanks,

-Jason
