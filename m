Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJSAVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 20:21:14 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43358 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaJSAVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 20:21:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: David Drysdale <drysdale@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Meredydd Luff <meredydd@senatehouse.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        X86 ML <x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
References: <1401975635-6162-1-git-send-email-drysdale@google.com>
	<CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
Date: Sat, 18 Oct 2014 17:20:29 -0700
In-Reply-To: <CALCETrVraoD+r4zxBoGd+BV5P275AXcRV_R00SSr8fjQzRHnUg@mail.gmail.com>
	(Andy Lutomirski's message of "Fri, 17 Oct 2014 14:45:03 -0700")
Message-ID: <87zjcszz8y.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19z8q10MGSjPxG7ZbeS71BOFUF/z3/xfnU=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 694 ms - load_scoreonly_sql: 0.08 (0.0%),
	signal_user_changed: 4.6 (0.7%), b_tie_ro: 3.3 (0.5%), parse: 1.16 (0.2%),
	extract_message_metadata: 15 (2.2%), get_uri_detail_list: 2.8 (0.4%),
	tests_pri_-1000: 6 (0.9%), tests_pri_-950: 1.35 (0.2%), tests_pri_-900: 1.16
	(0.2%), tests_pri_-400: 27 (3.9%), check_bayes: 26 (3.7%), b_tokenize: 8
	(1.1%), b_tok_get_all: 10 (1.4%), b_comp_prob: 3.2 (0.5%), b_tok_touch_all:
	2.6 (0.4%), b_finish: 0.87 (0.1%), tests_pri_0: 626 (90.1%), tests_pri_500: 8
	(1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv4 RESEND 0/3] syscalls,x86: Add execveat() system call
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> [Added Eric Biederman, since I think your tree might be a reasonable
> route forward for these patches.]
>
> On Thu, Jun 5, 2014 at 6:40 AM, David Drysdale <drysdale@google.com> wrote:
>> Resending, adding cc:linux-api.
>>
>> Also, it may help to add a little more background -- this patch is
>> needed as a (small) part of implementing Capsicum in the Linux kernel.
>>
>> Capsicum is a security framework that has been present in FreeBSD since
>> version 9.0 (Jan 2012), and is based on concepts from object-capability
>> security [1].
>>
>> One of the features of Capsicum is capability mode, which locks down
>> access to global namespaces such as the filesystem hierarchy.  In
>> capability mode, /proc is thus inaccessible and so fexecve(3) doesn't
>> work -- hence the need for a kernel-space
>
> I just found myself wanting this syscall for another reason: injecting
> programs into sandboxes or otherwise heavily locked-down namespaces.
>
> For example, I want to be able to reliably do something like nsenter
> --namespace-flags-here toybox sh.  Toybox's shell is unusual in that
> it is more or less fully functional, so this should Just Work (tm),
> except that the toybox binary might not exist in the namespace being
> entered.  If execveat were available, I could rig nsenter or a similar
> tool to open it with O_CLOEXEC, enter the namespace, and then call
> execveat.
>
> Is there any reason that these patches can't be merged more or less as
> is for 3.19?

Yes.  There is a silliness in how it implements fexecve.  The fexecve
case should be use the empty string "" not a NULL pointer to indication
that.  That change will then harmonize execveat with the other ...at
system calls and simplify the code and remove a special case.  I believe
using the empty string "" requires implementing the AT_EMPTY_PATH flag.

For sandboxes execveat seems to make a great deal of sense.  I can
get the same functionality by passing in a directory file descriptor
calling fchdir and execve so this should not introduce any new security
holes.  And using the final file descriptor removes a race.

AT_SYMLINK_NOFOLLOW seems to have some limited utility as well, although
for exec I don't know what problems it can solve.

Until I am done moving I won't have time to pick this up, and the code
clearly needs another revision but I will be happy to work to see that
we get a sane execveat implemented.

Eric

p.s.  I don't believe there are any namespaces issues where doing
something with execveat flags make sense.


