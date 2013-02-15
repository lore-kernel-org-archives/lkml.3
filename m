Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3BOCIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 21:08:17 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57615 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BOCIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 21:08:16 -0500
Message-ID: <511D9890.1040900@acm.org>
Date: Thu, 14 Feb 2013 20:08:16 -0600
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        Corey Minyard <cminyard@mvista.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Move console redirect to pid namespace
References: <1360376920-30824-1-git-send-email-minyard@acm.org> <20130209191409.643c3d7f@neptune.home> <87r4kkuj4o.fsf@xmission.com>
In-Reply-To: <87r4kkuj4o.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 01:08 PM, Eric W. Biederman wrote:
> Bruno Prémont <bonbons@linux-vserver.org> writes:
>
>> CCing containers list
>>
>> On Fri, 08 February 2013 minyard@acm.org wrote:
>>> From: Corey Minyard <cminyard@mvista.com>
>>>
>>> The console redirect - ioctl(fd, TIOCCONS) - is not in a namespace,
>>> thus a container can do a redirect and grab all the I/O on the host
>>> and all container consoles.
>>>
>>> This change puts the redirect in the pid namespace.
>>>
>>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>>> ---
>>>
>>> I'm pretty sure this patch is not correct, but I'm not quite sure the
>>> best way to fix this.  I'm not 100% sure that the pid namespace is the
>>> right place, but it seemed the most reasonable of all the choices.  The
>>> other obvious choice is the mount namespace, but it didn't seem as good
>>> a fit.
>> With recent changes, tying it to init user namespace might even be
>> better.
> With recent changes this is tied to the initial user namespace.  So the
> simple solution to this and so many other similiar security problems is
> to run your container in a user namespace.
>
> The permission check currently is capable(CAP_SYS_ADMIN) which requires
> the caller to have the CAP_SYS_ADMIN in the initial user namespace.

I'm not sure I follow.  Are these changes in k.org, or in another 
repository someplace?

>
> Is there a desire to have TIOCCONS not just fail in a container but to
> have TIOCCONS work in a container specific way?

Well, my desire is for the host console to work properly if a container 
uses TIOCCONS :-).  It seems to me that the most consistent way to 
handle this is to have TIOCCONS in a container redirect the container's 
console.

>
>>> The other problem is that I don't think you can call fput() from
>>> destroy_pid_namespace().  That can be called from interrupt context,
>>> and I don't think fput() is safe there.  I know it's not safe in 3.4
>>> with the RT patch applied.  However, the only way I've come up with to
>>> fix it is to add a workqueue, and that seems a bit heavy for this.
> Actually getting destroy_pid_namespace out of interrupt context wouldn't
> be the worst thing in the world.

I would agree, but it would still require something like a workqueue.  
Is there a better mechanism?

-corey
