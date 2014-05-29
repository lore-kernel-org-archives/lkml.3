Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaE2KHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 06:07:31 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35878 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaE2KH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 06:07:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Marian Marinov <mm@1h.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <5386D58D.2080809@1h.com>
Date: Thu, 29 May 2014 03:06:31 -0700
In-Reply-To: <5386D58D.2080809@1h.com> (Marian Marinov's message of "Thu, 29
	May 2014 09:37:01 +0300")
Message-ID: <87tx88nbko.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18X/b/jf5bcFkcAsTTLQKOVbO82mN06SnE=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Marian Marinov <mm@1h.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC] Per-user namespace process accounting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marian Marinov <mm@1h.com> writes:

> Hello,
>
> I have the following proposition.
>
> Number of currently running processes is accounted at the root user namespace. The problem I'm facing is that multiple
> containers in different user namespaces share the process counters.

That is deliberate.

> So if containerX runs 100 with UID 99, containerY should have NPROC limit of above 100 in order to execute any
> processes with ist own UID 99.
>
> I know that some of you will tell me that I should not provision all of my containers with the same UID/GID maps, but
> this brings another problem.
>
> We are provisioning the containers from a template. The template has a lot of files 500k and more. And chowning these
> causes a lot of I/O and also slows down provisioning considerably.
>
> The other problem is that when we migrate one container from one host machine to another the IDs may be already in use
> on the new machine and we need to chown all the files again.

You should have the same uid allocations for all machines in your fleet
as much as possible.   That has been true ever since NFS was invented
and is not new here.  You can avoid the cost of chowning if you untar
your files inside of your user namespace.  You can have different maps
per machine if you are crazy enough to do that.  You can even have
shared uids that you use to share files between containers as long as
none of those files is setuid.  And map those shared files to some kind
of nobody user in your user namespace.

> Finally if we use different UID/GID maps we can not do live migration to another node because the UIDs may be already
> in use.
>
> So I'm proposing one hack modifying unshare_userns() to allocate new user_struct for the cred that is created for the
> first task creating the user_ns and free it in exit_creds().

I do not like the idea of having user_structs be per user namespace, and
deliberately made the code not work that way.

> Can you please comment on that?

I have been pondering having some recursive resources limits that are
per user namespace and if all you are worried about are process counts
that might work.  I don't honestly know what makes sense at the moment.

Eric
