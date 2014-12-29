Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaL2BJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:09:48 -0500
Received: from mail-qc0-f171.google.com ([209.85.216.171]:54500 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaL2BJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:09:47 -0500
Message-ID: <54A0A9D5.2010804@hurleysoftware.com>
Date: Sun, 28 Dec 2014 20:09:41 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Ma, Xindong" <xindong.ma@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "ionut.m.alexa@gmail.com" <ionut.m.alexa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>,
        "Sun, Zhonghua" <zhonghua.sun@intel.com>
Subject: Re: [PATCH] move exit_task_work() before exit_fs().
References: <1419579926-28512-1-git-send-email-xindong.ma@intel.com> <20141226173849.GA9460@redhat.com> <3917C05D9F83184EAA45CE249FF1B1DD0266FC53@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <3917C05D9F83184EAA45CE249FF1B1DD0266FC53@SHSMSX103.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2014 07:58 PM, Ma, Xindong wrote:
>>
>> On 12/26, Leon Ma wrote:
>>>
>>> We encountered following panic. The scenario is the process is exiting
>>> and executing its task work. When closing dev node, the driver
>>> triggers a firmware reload according to device status. Because task->fs is
>> set to NULL in exit_fs(), panic happens.
>>
>> I think this should be fixed somewhere else...
> Yes, for this panic, I also think driver is not perfect and need a fix. But kernel should not add the limitation like this...
>>
>>> Task work is a common interface, we should not limite the resource the
>> user will utilize.
>>
>> Exactly. And note that with this patch exit_mm()..disassociate_ctty() paths
>> can't use task works.
> I don't get this. Currently disassociate_ctty() is also called after exit_mm() and exit_task_work(). My patch didn't change this.

??

742-	if (group_dead)
743:		disassociate_ctty(1);
744-	exit_task_namespaces(tsk);
745-	exit_task_work(tsk);
746-	exit_thread();

>> Not to mention that this patch moves exit_files() up, even before exit_mm(),
>> without any explanation.
> Moving exit_files() up is because exit_files() closes files and add tasks to task works.
>>
>> Add Al. May be we can move exit_fs() down after exit_task_work(), I dunno,
>> but to me it would be better to change the driver.
>>
> I'm OK with this suggestion to fix this issue. I'm not sure whether in the future task work users will access other resources and expose other issues.
> 

