Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348Ab3BOEXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 23:23:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48638 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735Ab3BOEXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 23:23:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: minyard@acm.org
Cc: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Corey Minyard <cminyard@mvista.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <1360376920-30824-1-git-send-email-minyard@acm.org>
	<20130209191409.643c3d7f@neptune.home> <87r4kkuj4o.fsf@xmission.com>
	<511D9890.1040900@acm.org>
Date: Thu, 14 Feb 2013 20:23:31 -0800
In-Reply-To: <511D9890.1040900@acm.org> (Corey Minyard's message of "Thu, 14
	Feb 2013 20:08:16 -0600")
Message-ID: <87d2w29pdo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19x4GFt8AMPTTKXzffSCHsTixq0hfl19hQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;minyard@acm.org
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Move console redirect to pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard <tcminyard@gmail.com> writes:

> On 02/13/2013 01:08 PM, Eric W. Biederman wrote:
>> Bruno Prémont <bonbons@linux-vserver.org> writes:
>>
>>> CCing containers list
>>>
>>> On Fri, 08 February 2013 minyard@acm.org wrote:
>>>> From: Corey Minyard <cminyard@mvista.com>
>>>>
>>>> The console redirect - ioctl(fd, TIOCCONS) - is not in a namespace,
>>>> thus a container can do a redirect and grab all the I/O on the host
>>>> and all container consoles.
>>>>
>>>> This change puts the redirect in the pid namespace.
>>>>
>>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>>> ---
>>>>
>>>> I'm pretty sure this patch is not correct, but I'm not quite sure the
>>>> best way to fix this.  I'm not 100% sure that the pid namespace is the
>>>> right place, but it seemed the most reasonable of all the choices.  The
>>>> other obvious choice is the mount namespace, but it didn't seem as good
>>>> a fit.
>>> With recent changes, tying it to init user namespace might even be
>>> better.
>> With recent changes this is tied to the initial user namespace.  So the
>> simple solution to this and so many other similiar security problems is
>> to run your container in a user namespace.
>>
>> The permission check currently is capable(CAP_SYS_ADMIN) which requires
>> the caller to have the CAP_SYS_ADMIN in the initial user namespace.
>
> I'm not sure I follow.  Are these changes in k.org, or in another
> repository someplace?

In k.org. 3.7 would work. 3.8-rcX would work even better.

root in a user namespace does not have permission to call TIOCCONS.

>> Is there a desire to have TIOCCONS not just fail in a container but to
>> have TIOCCONS work in a container specific way?
>
> Well, my desire is for the host console to work properly if a
> container uses TIOCCONS :-).  It seems to me that the most consistent
> way to handle this is to have TIOCCONS in a container redirect the
> container's console.

Last I looked people were creating a regulary pty and using that in
/dev/ for their containers.  So the emperical evidence is that TIOCCONS
is not needed.  What case are you looking at that needs TIOCCONS?

If there is good cause we can make TIOCCONS work but we need a
compelling case beyond root in a container can do bad things.

>>>> The other problem is that I don't think you can call fput() from
>>>> destroy_pid_namespace().  That can be called from interrupt context,
>>>> and I don't think fput() is safe there.  I know it's not safe in 3.4
>>>> with the RT patch applied.  However, the only way I've come up with to
>>>> fix it is to add a workqueue, and that seems a bit heavy for this.
>> Actually getting destroy_pid_namespace out of interrupt context wouldn't
>> be the worst thing in the world.
>
> I would agree, but it would still require something like a workqueue.
> Is there a better mechanism?

It might be as simple as finding all of the put_pids and moving them out
of spin_lock critical sections.  I don't know that we drop pids in
actual interrupt context.

Eric

