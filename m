Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaEaUJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 16:09:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:57593 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaEaUJE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 16:09:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vasily Kulikov <segoon@openwall.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        containers@lists.linux-foundation.org,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <1401272683-1659-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<5385DA19.2060008@parallels.com> <20140528182824.GA5057@cachalot>
	<53863889.9080509@parallels.com> <20140529055954.GA10354@cachalot>
	<5386F8EA.8050501@parallels.com> <20140529111236.GA14576@cachalot>
	<53871A92.9000004@parallels.com> <20140529115946.GA19889@cachalot>
	<53872DAD.1070502@parallels.com> <20140531060713.GA5315@cachalot>
Date: Sat, 31 May 2014 13:08:01 -0700
In-Reply-To: <20140531060713.GA5315@cachalot> (Vasily Kulikov's message of
	"Sat, 31 May 2014 10:07:13 +0400")
Message-ID: <87egz9lnj2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19qG5JnsrTdHEpaeDoVCcDznBsRDe2gC+k=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vasily Kulikov <segoon@openwall.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] /proc/pid/status: show all sets of pid according to ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Kulikov <segoon@openwall.com> writes:

> On Thu, May 29, 2014 at 16:53 +0400, Pavel Emelyanov wrote:
>> On 05/29/2014 03:59 PM, Vasily Kulikov wrote:
>> > On Thu, May 29, 2014 at 15:31 +0400, Pavel Emelyanov wrote:
>> >> On 05/29/2014 03:12 PM, Vasily Kulikov wrote:
>> >>> On Thu, May 29, 2014 at 13:07 +0400, Pavel Emelyanov wrote:
>> >>>> On 05/29/2014 09:59 AM, Vasily Kulikov wrote:
>> >>>>> On Wed, May 28, 2014 at 23:27 +0400, Pavel Emelyanov wrote:
>> >>>>> ] We need a direct method of getting the pid inside containers.
>> >>>>> ] If some issues occurred inside container guest, host user
>> >>>>> ] could not know which process is in trouble just by guest pid:
>> >>>>> ] the users of container guest only knew the pid inside containers.
>> >>>>> ] This will bring obstacle for trouble shooting.
>> >>>>>
>> >>>>> A new syscall might complicate trouble shooting by admin.
>> >>>>
>> >>>> Pure syscall -- yes. What if we teach the ps and top utilities to show additional
>> >>>> info? I think that would help.
>> >>>
>> >>> I like the idea with low level non-shell API which can be used by
>> >>> utility like ps (or implementation of a new tool to work with complex
>> >>> namespace hierarchies).  It should fit for troublesooting.  Then there
>> >>> should be no reason to implement two different APIs for observation from
>> >>> shell via FS and from applications.
>> >>
>> >> Maybe we can reuse the existing kcmp() system call? We would have to store
>> >> the collected pid values in some hash/tree anyway, and kcmp() provides us
>> >> good comparing function for doing this.
>> >>
>> >> Like we can call kcmp(pid1, pid2, KCMP_PID, nsfd1, nsfd2) which will mean
>> >> "Are tasks with pid1 in namespace pointed by nsfd1 and with pid2 in namespace
>> >> nsfd2 the same?"
>> >>
>> >> What do you think?
>> > 
>> > kcmp() is not needed, just compare inode numbers:
>> > 
>> >     # ls -il /proc/{43,self}/ns/mnt
>> >     208182 lrwxrwxrwx 1 root root 0 мая   29 15:52 /proc/43/ns/mnt -> mnt:[4026531856]
>> >     216556 lrwxrwxrwx 1 root root 0 мая   29 15:57 /proc/self/ns/mnt -> mnt:[4026531840]
>> 
>> But that's for comparing the namespaces, while I'm proposing the kcmp to
>> check for PIDs.
>
> Hm, right.
>
> What about the following solution: export global process ID (PID in
> init ns) which is visible inside of any namespace.  Then you can compare
> numbers regardless in what namespace you are.

Which then defeats the point of having pid namespaces in the first
place.

How do you get that same global pid after you have migrated your
container?

Eric

