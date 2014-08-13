Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750914AbaHMEWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 00:22:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49233 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaHMEWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 00:22:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kenton@sandstorm.io
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
	<53EAD180.4010906@amacapital.net>
Date: Tue, 12 Aug 2014 21:17:30 -0700
In-Reply-To: <53EAD180.4010906@amacapital.net> (Andy Lutomirski's message of
	"Tue, 12 Aug 2014 19:46:24 -0700")
Message-ID: <87sil1nhut.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19ThRxG7eJNby+a4FYu0cOE50f2It6h1MQ=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3241]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On 08/05/2014 05:57 PM, Eric W. Biederman wrote:
>
> Sorry for catching this late.  I think this fix is likely to
> unnecessarily break valid userspace due to an odd interaction.

The code is correct and safe (no security issues), but yes a blind
remount might hit a snag.

If you can find a userspace application that matters I might care
that a security fix breaks it.

I think you have made a point that several more filesystems might
be ok to not set nodev on (because we can not do anything to create
device nodes on those filesystems).  I personally would prefer the much
more paranoid approach of only allowing device nodes on a unprivileged
mount if we have audited all of the code paths and know it is safe
for device nodes to appear there.

I don't actually think anyone cares ad remounts of filesystems like
tmpfs, mqueue, sysfs, proc, ramfs are all quite rare.  Blind remounts
are even rare.  The normal userspace utilities look at the appropriate
version of /proc/mounts on remount.

These are not filesystems that a blind remount will likely be applied
to.

Furthermore there is work underway to prepare patches to allow
"mount --bind -ro" to work as expected.  That will further reduce
the pressure from blind remounts.

If there is an actual regression of actual code I am happy to deal
with it.  But having the MNT_NODEV on those mounts has been the case
for a long time now and is not new (no regression).  This change just
closed the security hole that allowed nodev to be removed.  And that
security hole we need to have fixed.

Eric

