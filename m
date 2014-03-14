Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237AbaCNVFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 17:05:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472AbaCNVFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 17:05:22 -0400
Date: Fri, 14 Mar 2014 22:04:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pppd service crash in linux-3.13.6
Message-ID: <20140314210456.GA19032@redhat.com>
References: <531A37FF.4000509@totakura.in> <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com> <20140314192346.GA14823@redhat.com> <53236662.3020707@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53236662.3020707@hurleysoftware.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, Peter Hurley wrote:
>
> On 03/14/2014 03:23 PM, Oleg Nesterov wrote:
>> On 03/14, Peter Hurley wrote:
>>>
> Yes, cgroup_release_agent() is the work function that is scheduled.
>
>>> which requires both namespace and tty facilities.
>>
>> Hmm... why?
>>
>> The exiting task obviously can't exec. The only way to spawn a userspace
>> process is call_usermodehelper(), it should work just fine, no?
>
> You're correct, in the immediate sense that the user command exec'd will
> not inherit open file descriptors.
>
> But what if it expects to be able to find the intact children of
> the foreground process group, and can't because the controlling tty
> has already been torn down and all the children already sent SIGHUP.

Which group/tty ? call_usermodehelper() asks the workqueue thread
to kthread_create/exec. See also below...

> Or what if the user command expects to find and join the user namespace
> of the dying process but now it's already been freed?

But it can't even know who called call_usermodehelper(). Besides,
cgroup_release_agent() uses UMH_WAIT_EXEC, so the caller can continue
and disappear completely before the usermode process has any chance
to do something.

Oleg.

