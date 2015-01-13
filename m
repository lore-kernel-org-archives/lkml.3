Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbbAMFdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:33:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:41774 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbbAMFds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:33:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511364464"
Message-ID: <54B4AE24.6030906@linux.intel.com>
Date: Tue, 13 Jan 2015 13:33:24 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: namespace: Simplify function commit_tree()
References: <1421125686-23765-1-git-send-email-jiang.liu@linux.intel.com> <20150113052801.GH22149@ZenIV.linux.org.uk>
In-Reply-To: <20150113052801.GH22149@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/13 13:28, Al Viro wrote:
> On Tue, Jan 13, 2015 at 01:08:06PM +0800, Jiang Liu wrote:
>> Simplify function commit_tree() in fs/namespace.c, it also improves code
>> readability.
> 
> Huh?
> 
>>  static void commit_tree(struct mount *mnt, struct mount *shadows)
>>  {
>>  	struct mount *parent = mnt->mnt_parent;
>> -	struct mount *m;
>> -	LIST_HEAD(head);
>>  	struct mnt_namespace *n = parent->mnt_ns;
>>  
>>  	BUG_ON(parent == mnt);
>> -
>> -	list_add_tail(&head, &mnt->mnt_list);
>> -	list_for_each_entry(m, &head, mnt_list)
>> -		m->mnt_ns = n;
>> -
>> -	list_splice(&head, n->list.prev);
>> -
>> +	mnt->mnt_ns = n;
>> +	list_add_tail(&mnt->mnt_list, &n->list);
> 
> And who will set ->mnt_ns on other mounts reachable via ->mnt_list from mnt?
> Not to mention putting them on n->list...
> 
> What you seem to have missed is that list_add_tail(&head, &mnt->mnt_list)
> is not the same thing as list_add_tail(&mnt->mnt_list, &head).  We are
> not ripping mnt->mnt_list from whatever list it was on and insert it into
> a previously empty one in head.  We take an unanchored cyclic list (all
> elements being some_mnt->mnt_list) and anchor it at head, then go through
> all elements of the original list and move them all at once into the
> end of n->list.
Hi Al,
	Sorry for the noise, didn't realized that mnt->mnt_list anchors
a whole list:(
Regards!
Gerry
