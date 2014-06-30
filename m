Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaF3Vnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:43:53 -0400
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:59276 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbaF3Vnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:43:52 -0400
Message-ID: <53B1DA16.5060208@akamai.com>
Date: Mon, 30 Jun 2014 17:43:50 -0400
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "andi@firstfloor.org" <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH 0/3] static keys: fix test/set races
References: <cover.1372457176.git.jbaron@akamai.com> <20140623222802.4900881c@gandalf.local.home>
In-Reply-To: <20140623222802.4900881c@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

I took a closer look at this, and I'm thinking now that its simpler to
just take the &inode->i_mutex in sched_feat_write(), surrounding the
test/set jump_label call. It should be about 3 lines :)

I started re-working this with the patches in this series and it just
seemed like a lot of code for only 1 current use-case. (The udp case
doesn't appear to disable the branch and thus is not racy.)

So I've swung back to what Ingo originally said - I can test/post the
suggested 3-line patch, unless there are other thoughts...

Thanks,

-Jason

On 06/23/2014 10:28 PM, Steven Rostedt wrote:
> 
> Cleaning out my INBOX I found this patch series. It seems to have been
> forgotten about. It ended up with Ingo and Peter agreeing with the way
> things should be done and I thought Jason was going to send an update.
> But that seems to never have happened.
> 
> Does this patch series still look legit? Should we pursue it?
> 
> -- Steve
> 
> On Fri, 28 Jun 2013 22:30:28 +0000 (GMT)
> jbaron@akamai.com wrote:
> 
>> Hi,
>>
>> As pointed out by Andi Kleen, some static key users can be racy because they
>> check the value of the key->enabled, and then subsequently update the branch
>> direction. A number of call sites have 'higher' level locking that avoids this
>> race, but the usage in the scheduler features does not. See:
>> http://lkml.indiana.edu/hypermail/linux/kernel/1304.2/01655.html
>>
>> Thus, introduce a new API that does the check and set under the
>> 'jump_label_mutex'. This should also allow to simplify call sites a bit.
>>
>> Users of static keys should use either the inc/dec or the set_true/set_false
>> API.
>>
>> Thanks,
>>
>> -Jason
>>
>>
>> Jason Baron (3):
>>   static_keys: Add a static_key_slow_set_true()/false() interface
>>   sched: fix static keys race in sched_feat
>>   udp: make use of static_key_slow_set_true() interface
>>
>>  Documentation/static-keys.txt |    8 ++++++++
>>  include/linux/jump_label.h    |   30 ++++++++++++++++++++++++++++++
>>  kernel/jump_label.c           |   40 ++++++++++++++++++++++++++++++++++++++++
>>  kernel/sched/core.c           |   12 +++++-------
>>  kernel/sched/sched.h          |   10 +++++-----
>>  net/ipv4/udp.c                |    9 ++++-----
>>  net/ipv6/udp.c                |    9 ++++-----
>>  7 files changed, 96 insertions(+), 22 deletions(-)
>>
> 

