Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaHHWPS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:15:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35035 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaHHWPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:15:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20140808185732.GA760@redhat.com>
	<87d2caod0g.fsf@x220.int.ebiederm.org>
Date: Fri, 08 Aug 2014 15:11:16 -0700
In-Reply-To: <87d2caod0g.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Fri, 08 Aug 2014 15:03:11 -0700")
Message-ID: <87mwbemy2j.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18KcSi2hbYzKJSzMZGe9BJBaHz4asKOhp4=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] introduce proc_inode->pid_entry
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Oleg Nesterov <oleg@redhat.com> writes:
>
>> Hello,
>>
>> Obviously not for inclusion. The patches are horrible, break task_nommu.c,
>> untested, etc. Only to explain what I mean and discuss the intent, at least.
>> On top of recent /proc/pid/*maps* cleanups I sent.
>>
>> To me it looks a bit annoying that task_mmu.c needs 6 seq_operations's and
>> 6 file_operations's to handle /proc/pid/*maps*. And _only_ because ->show()
>> differs.
>>
>> Eric, et al, what do you think? At least something like 1-3 looks like a
>> good cleanup imho. And afaics we can do more cleanups on top.
>
>
> I see where you are getting annoyed.
>
> Taking a quick look at task_mmu.c  It looks like the tgid vs pid logic
> to decided which stack or stacks to display is simply incorrect.
>
> tgid vs pid is all about do we perform the per thread group rollups or
> not.  Because we have /proc/<tid>/ directories that need the rollups
> but are per thread.
>
> At a practical level moving pid_entry into the proc inode is ugly
> especially for the hack that is is_tgid_pid_entry.
>
> That test could be implemented more easily by looking at the parent
> directories inode operations and seeing if they are
> proc_root_inode_operations.
>
> Similarly you can get the names out of the dentry, although comparing
> on the dentry name feels like a real hack.
>
> Given where you are starting I think tack_mmu.c code that decides
> when/which stack deserves a serious audit.

On a slightly larger scale it is probably about time to step back
and look at /proc and see what structural cleanups can be done.

Since last time I was looking deeply a bunch of work has been done in
the automount area, and it would be ever so nice if /proc/<pid>/net
because an automount.

Similarly /proc/sys/ really needs to become at least a symlink into
/proc/<pid>/sys and quite possibly an automount itself.

And arguably it would be nice to split /proc/<pid> from /proc generic,
so we would actually have a pure proc.

Shrug. At least if those are ideas worth thinking about and some of them
have the potential to cleanup some nasty interactions with the vfs.

Eric

