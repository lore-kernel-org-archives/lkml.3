Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaI3CPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:15:32 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43081 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199AbaI3CPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:15:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Andrey Wagin <avagin@gmail.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <87lhp12a2i.fsf@x220.int.ebiederm.org>
	<CALCETrXGojRGtT1B2Aib7m54j8T+LsnCOin_GL93-BWf-eSPkA@mail.gmail.com>
Date: Mon, 29 Sep 2014 19:15:02 -0700
In-Reply-To: <CALCETrXGojRGtT1B2Aib7m54j8T+LsnCOin_GL93-BWf-eSPkA@mail.gmail.com>
	(Andy Lutomirski's message of "Mon, 29 Sep 2014 18:28:00 -0700")
Message-ID: <87oatxzwex.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18vItPRMtvq7bwvxoEGKh8h4O619IAbgdI=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4915]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2541 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 3.4 (0.1%), b_tie_ro: 2.4 (0.1%), parse: 1.23 (0.0%),
	extract_message_metadata: 30 (1.2%), get_uri_detail_list: 2.6 (0.1%),
	tests_pri_-1000: 14 (0.5%), tests_pri_-950: 2.1 (0.1%), tests_pri_-900: 1.64
	(0.1%), tests_pri_-400: 29 (1.1%), check_bayes: 27 (1.1%), b_tokenize: 11
	(0.4%), b_tok_get_all: 7 (0.3%), b_comp_prob: 3.8 (0.2%), b_tok_touch_all:
	2.0 (0.1%), b_finish: 0.79 (0.0%), tests_pri_0: 2449 (96.4%), tests_pri_500:
	7 (0.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] umount.2: Correct the description of MNT_DETACH
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Mon, Sep 29, 2014 at 6:04 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> I recently realized that I had been reasoning improperly about what
>> umount(MNT_DETACH) did based on an insufficient description in
>> the umount.2 man page, that matched my intuition but not the
>> implementation.
>>
>> When there are no submounts MNT_DETACH is essentially harmless to
>> applications.  Where there are submounts MNT_DETACH changes what
>> is visible to applications using the detach directories.
>>
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>> ---
>>  man2/umount.2 | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/man2/umount.2 b/man2/umount.2
>> index 5ff88152c738..aea39d8306fe 100644
>> --- a/man2/umount.2
>> +++ b/man2/umount.2
>> @@ -66,9 +66,10 @@ This can cause data loss.
>>  (Only for NFS mounts.)
>>  .TP
>>  .BR MNT_DETACH " (since Linux 2.4.11)"
>> -Perform a lazy unmount: make the mount point unavailable for
>> -new accesses, and actually perform the unmount when the mount point
>> -ceases to be busy.
>> +Perform a lazy unmount: make the mount point unavailable for new
>> +accesses, immediately disconnect the filesystem and all filesystems
>> +mounted below it from each other and from the mount table, and
>> +actually perform the unmount when the mount point ceases to be busy.
>
> Want to add something like:
>
> MNT_DETACH on a shared mount will propagate unmount events to its peer
> group.  That means that recursively bind mounting a shared mount and
> then unmounting that recursive bind mount will unmount all submounts
> of the original mount.  This behavior can be avoided by remounting a
> directory with MS_REC | MS_PRIVATE before unmounting it.

Make that any unmount on a shared mount that will propogate unmount
events to it's peer group.

Eric

