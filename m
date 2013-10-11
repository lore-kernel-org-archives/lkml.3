Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab3JKDeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 23:34:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43244 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3JKDeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 23:34:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ryan Mallon <rmallon@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        eldad@fogrefinery.com, Jiri Kosina <jkosina@suse.cz>,
        jgunthorpe@obsidianresearch.com,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        George Spelvin <linux@horizon.com>,
        "kernel-hardening\@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <5255D023.2030907@gmail.com> <1381356014.2050.28.camel@joe-AO722>
	<5255D2FD.6050705@gmail.com> <1381356861.2050.33.camel@joe-AO722>
	<5255D7D4.8050204@gmail.com> <1381358030.2050.36.camel@joe-AO722>
	<5255DBD8.30005@gmail.com> <1381360187.2050.44.camel@joe-AO722>
	<87pprck0q7.fsf@xmission.com> <52576E32.1050700@gmail.com>
Date: Thu, 10 Oct 2013 20:34:01 -0700
In-Reply-To: <52576E32.1050700@gmail.com> (Ryan Mallon's message of "Fri, 11
	Oct 2013 14:19:14 +1100")
Message-ID: <87txgoh45y.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19f9EVkj/Czs/X6o97HJyCTYwCVCxGtqyw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1354]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ryan Mallon <rmallon@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3a] vsprintf: Check real user/group id for %pK
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan Mallon <rmallon@gmail.com> writes:

> On 11/10/13 13:20, Eric W. Biederman wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>>> Some setuid binaries will allow reading of files which have read
>>> permission by the real user id. This is problematic with files which
>>> use %pK because the file access permission is checked at open() time,
>>> but the kptr_restrict setting is checked at read() time. If a setuid
>>> binary opens a %pK file as an unprivileged user, and then elevates
>>> permissions before reading the file, then kernel pointer values may be
>>> leaked.
>>>
>>> This happens for example with the setuid pppd application on Ubuntu
>>> 12.04:
>>>
>>>   $ head -1 /proc/kallsyms
>>>   00000000 T startup_32
>>>
>>>   $ pppd file /proc/kallsyms
>>>   pppd: In file /proc/kallsyms: unrecognized option 'c1000000'
>>>
>>> This will only leak the pointer value from the first line, but other
>>> setuid binaries may leak more information.
>>>
>>> Fix this by adding a check that in addition to the current process
>>> having CAP_SYSLOG, that effective user and group ids are equal to the
>>> real ids. If a setuid binary reads the contents of a file which uses
>>> %pK then the pointer values will be printed as NULL if the real user
>>> is unprivileged.
>>>
>>> Update the sysctl documentation to reflect the changes, and also
>>> correct the documentation to state the kptr_restrict=0 is the default.
>> 
>> Sigh.  This is all wrong.  The only correct thing to test is
>> file->f_cred.  Aka the capabilities of the program that opened the
>> file.
>> 
>> Which means that the interface to %pK in the case of kptr_restrict is
>> broken as it has no way to be passed the information it needs to make
>> a sensible decision.
>
> Would it make sense to add a struct file * to struct seq_file and set
> that in seq_open? Then the capability check can be done against
> seq->file.

It would make most sense to do the capability check at open time,
and cache the result.  Doing it generically so that seq_printf could
still use %pK doesn't sound wrong, but it does sound convoluted.

Eric

