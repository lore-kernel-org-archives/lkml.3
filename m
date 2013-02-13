Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab3BMTId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:08:33 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43441 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758662Ab3BMTIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:08:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bruno =?utf-8?Q?Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Corey Minyard <minyard@acm.org>, Corey Minyard <cminyard@mvista.com>,
        containers@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <1360376920-30824-1-git-send-email-minyard@acm.org>
	<20130209191409.643c3d7f@neptune.home>
Date: Wed, 13 Feb 2013 11:08:23 -0800
In-Reply-To: <20130209191409.643c3d7f@neptune.home> ("Bruno \=\?utf-8\?Q\?Pr\?\=
 \=\?utf-8\?Q\?\=C3\=A9mont\=22's\?\= message
	of "Sat, 9 Feb 2013 19:14:09 +0100")
Message-ID: <87r4kkuj4o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/OsnvEJPHlhbFBq3FGvI99J7i7dhwHaKA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?;Bruno Pr=c3=a9mont <bonbons@linux-vserver.org>?=
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Move console redirect to pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont <bonbons@linux-vserver.org> writes:

> CCing containers list
>
> On Fri, 08 February 2013 minyard@acm.org wrote:
>> From: Corey Minyard <cminyard@mvista.com>
>> 
>> The console redirect - ioctl(fd, TIOCCONS) - is not in a namespace,
>> thus a container can do a redirect and grab all the I/O on the host
>> and all container consoles.
>> 
>> This change puts the redirect in the pid namespace.
>> 
>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>> ---
>> 
>> I'm pretty sure this patch is not correct, but I'm not quite sure the
>> best way to fix this.  I'm not 100% sure that the pid namespace is the
>> right place, but it seemed the most reasonable of all the choices.  The
>> other obvious choice is the mount namespace, but it didn't seem as good
>> a fit.
>
> With recent changes, tying it to init user namespace might even be
> better.

With recent changes this is tied to the initial user namespace.  So the
simple solution to this and so many other similiar security problems is
to run your container in a user namespace.

The permission check currently is capable(CAP_SYS_ADMIN) which requires
the caller to have the CAP_SYS_ADMIN in the initial user namespace.

Is there a desire to have TIOCCONS not just fail in a container but to
have TIOCCONS work in a container specific way?

>> The other problem is that I don't think you can call fput() from
>> destroy_pid_namespace().  That can be called from interrupt context,
>> and I don't think fput() is safe there.  I know it's not safe in 3.4
>> with the RT patch applied.  However, the only way I've come up with to
>> fix it is to add a workqueue, and that seems a bit heavy for this.

Actually getting destroy_pid_namespace out of interrupt context wouldn't
be the worst thing in the world.

Eric
