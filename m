Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaKKPiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:38:16 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48722 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKKPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:38:14 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com>
	<1414013060-137148-3-git-send-email-seth.forshee@canonical.com>
	<20141111140454.GD333@tucsk>
Date: Tue, 11 Nov 2014 09:37:10 -0600
In-Reply-To: <20141111140454.GD333@tucsk> (Miklos Szeredi's message of "Tue,
	11 Nov 2014 15:04:54 +0100")
Message-ID: <87mw7xd9zt.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+8oBC+u4iIVl4/8M2L/MKasar64LlJl3w=
X-SA-Exim-Connect-IP: 67.3.195.30
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4965]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.2 T_XMDrugObfuBody_14 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
X-Spam-Timing: total 374 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.5 (0.9%), b_tie_ro: 2.5 (0.7%), parse: 0.95 (0.3%),
	extract_message_metadata: 16 (4.2%), get_uri_detail_list: 3.1 (0.8%),
	tests_pri_-1000: 5 (1.3%), tests_pri_-950: 1.32 (0.4%), tests_pri_-900: 1.08
	(0.3%), tests_pri_-400: 23 (6.2%), check_bayes: 22 (5.9%), b_tokenize: 7
	(1.8%), b_tok_get_all: 8 (2.2%), b_comp_prob: 2.5 (0.7%), b_tok_touch_all:
	2.4 (0.6%), b_finish: 0.63 (0.2%), tests_pri_0: 316 (84.4%), tests_pri_500:
	4.1 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v5 2/4] fuse: Support fuse filesystems outside of init_user_ns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Wed, Oct 22, 2014 at 04:24:18PM -0500, Seth Forshee wrote:
>> Update fuse to translate uids and gids to/from the user namspace
>> of the process servicing requests on /dev/fuse. Any ids which do
>> not map into the namespace will result in errors. inodes will
>> also be marked bad when unmappable ids are received from
>> userspace.
>
> Okay.
>
>> Due to security concerns the namespace used should be fixed,
>> otherwise a user might be able to gain elevated privileges or
>> influence processes that the user would otherwise be unable to
>> manipulate. Thus the namespace of the mounting process is used
>> for all translations, and this namespace is required to be the
>> same as the one in use when /dev/fuse was opened.
>
> Maybe I'm being dense, but can someone give a concrete example of such an
> attack?

There are two variants of things at play here.

There is the classic if you don't freeze your context at open time when
you pass that file descriptor to another process unexpected things can
happen.  

An essentially harmless but extremely confusing example is what happens
to a partial read when it stops halfway through a uid value and the next
read on the same file descriptor is from a process in a different user
namespace.  Which uid value should be returned to userspace.

If the kernel is just reporting values all that happens is confusion
with a correct implementation.  Confusion however is a breeding ground
for little unexpected behaviors that trigger bugs in the code.

If the kernel is reading values things can get ugly.  As root in a user
a namespace I am allowed to call setuid and setgid to any uid or gid
that is mapped into my user namespace but no others.

Now if I am in a nefarious mood I can create a unprivileged user
namespace, open /dev/fuse and mount a fuse filesystem.  Pass the file
descriptor to /dev/fuse to a processes that is in the default user
namespace (and thus can use any uid/gid).   With that file desctipor
report that there is a setuid 0 exectuable on that file system.

The version of fuse in these patches has two different defenses against
that kind of nefariousness.  The first defense restrictions /dev/fuse
to speak the uids and gids that the opener of /dev/fuse has in their
user namespace.  The second defense restricts who can access a fuse file
system by requiring them to be in the user namespace of the opener of
/dev/fuse and the mounter of the fuse filesystem.

I find the first defense stronger and easier to analyze.  If non-sense
uids can't get past fuse into the vfs we simply don't have to worry
about them.

I hope that helps.

> That might also help me understand how exactly user/pid namespaces work...

The idea of user/pid namespaces is to translate uid, gids and pids at
the edge of userspace into a kernel internal form that can be use
everywhere.  In this case we get into the subtlties of which
translations make sense.

> Patch otherwise looks okay.

Eric

