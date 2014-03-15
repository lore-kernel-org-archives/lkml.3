Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaCOMtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 08:49:42 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:32821 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755368AbaCOMtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 08:49:40 -0400
Message-ID: <53244C61.5090508@hurleysoftware.com>
Date: Sat, 15 Mar 2014 08:49:37 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pppd service crash in linux-3.13.6
References: <531A37FF.4000509@totakura.in> <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com> <20140314192346.GA14823@redhat.com> <53236662.3020707@hurleysoftware.com> <20140314210456.GA19032@redhat.com>
In-Reply-To: <20140314210456.GA19032@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 05:04 PM, Oleg Nesterov wrote:
> On 03/14, Peter Hurley wrote:
>> On 03/14/2014 03:23 PM, Oleg Nesterov wrote:
>>> On 03/14, Peter Hurley wrote:
>>>>
>> Yes, cgroup_release_agent() is the work function that is scheduled.
>>
>>>> which requires both namespace and tty facilities.
>>>
>>> Hmm... why?
>>>
>>> The exiting task obviously can't exec. The only way to spawn a userspace
>>> process is call_usermodehelper(), it should work just fine, no?
>>
>> You're correct, in the immediate sense that the user command exec'd will
>> not inherit open file descriptors.
>>
>> But what if it expects to be able to find the intact children of
>> the foreground process group, and can't because the controlling tty
>> has already been torn down and all the children already sent SIGHUP.
>
> Which group/tty ? call_usermodehelper() asks the workqueue thread
> to kthread_create/exec. See also below...
>
>> Or what if the user command expects to find and join the user namespace
>> of the dying process but now it's already been freed?
>
> But it can't even know who called call_usermodehelper(). Besides,
> cgroup_release_agent() uses UMH_WAIT_EXEC, so the caller can continue
> and disappear completely before the usermode process has any chance
> to do something.

I'm just hypothesizing potential breakage, since the order of teardown
is sensitive to changes, and I didn't do a complete audit of all the
possibilities.

If you feel strongly about moving disassociate_tty(), I won't object.

Regards,
Peter Hurley


