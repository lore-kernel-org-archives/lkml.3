Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750813Ab3IXE2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:28:43 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16054 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IXE2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:28:42 -0400
X-Spam-Score: -100.7
Message-ID: <524114B8.3070903@asianux.com>
Date: Tue, 24 Sep 2013 12:27:36 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org> <52410A40.1000304@asianux.com> <20130924040601.GA31575@mtj.dyndns.org>
In-Reply-To: <20130924040601.GA31575@mtj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 12:06 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Sep 24, 2013 at 11:42:56AM +0800, Chen Gang wrote:
>> Hmm... can user be permitted to call other system call (e.g. getgroups)
>> before call groups_alloc()? (may the user space already give check, but
>> for our kernel, we can not only depend on their checking).
> 
> I don't think so.
> 
>> According to group_alloc() and setgroups() usage in kernel source code,
>> 'group_info' may be not set if kernel/process is running (although user
>> space may be sure "if kernel is running, 'group_info' must be set").
>>
>> The below is the proof for "kernel itself can not be sure 'group_info'
>> must be set during kernel/process is running", please check, thanks.
> ..
>> The related conclusion:
>>
>>   during kernel startup or process creation, kernel does not intend to set 'group_info'.
> 
> No, this is not a proof or any meaningful conclusion.  This is just
> some random suspicions combined with supposedly related grep output.
> 

For real world, /sbin/init will call setgroups, so user space 'help'
kernel itself to protect this issue, but I think, we don't only depend
on the user space help checking.

The proof is below:

  [root@gchenlinux tmp]# grep setgroups /sbin/*
  Binary file /sbin/init matches
  Binary file /sbin/rpc.statd matches
  Binary file /sbin/rsyslogd matches
  Binary file /sbin/runuser matches

>From reading kernel source code, kernel itself does not intend to set
'group_info', it is triggered by user space or another kernel mode
sub-systems.


>> In extern function groups_search (which also called by export function
>> in_group_p and in_egroup_p), it checks "if 'cred->group_info' is NULL".
>>
>> So "kernel/groups.c" have 9 extern/export/system-call functions, and
>> 4/9 notice about "if 'cred->group_info' is NULL" (e.g. groups_alloc,
>> groups_search, in_group_p, in_egroup_p).
>>
>> So for API self-consistency, all of extern/export/system-call functions
>> need notice about it.
> 
> I'm afraid this isn't useful.  If you want to change the code, you
> actually need to understand what's going on.  "this seems weird to me"
> is a good starting point but you need to go way beyond that to
> actually make changes.
> 

If some of APIs check the related parameters, but the other not, this
interface must assume some usage condition from the callers which
callers can break out (although the callers may not break out, now).

> Thanks.
> 


-- 
Chen Gang
