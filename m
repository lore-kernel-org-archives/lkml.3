Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaHEXCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:02:34 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43177 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaHEXCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:02:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <20140805131758.3afa6b0b@notabene.brown>
	<CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
	<20140805051439.GQ18016@ZenIV.linux.org.uk>
Date: Tue, 05 Aug 2014 15:58:37 -0700
In-Reply-To: <20140805051439.GQ18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 5 Aug 2014 06:14:39 +0100")
Message-ID: <87ha1qwnky.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19P43rk0FitjkiNb0SkMoLO8gf0D8oeS8Y=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4962]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: Is lockref_get_not_zero() really correct in dget_parent()
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Speaking of bogosities, apparently nobody has noticed that automagical
> turning BSD process accounting off upon r/o remounts of the filesystem
> hosting the log got broken several years ago.  Suppose we find an opened
> log when remounting.  OK, it gets closed, which means filp_close(...).
> Which means that actual closing that sucker will happen just before we
> return to userland.  Return with -EBUSY, since the filesystem still has
> a file opened for write when we get around to checking that...
>
> I have kinda-sorta fixes for that (basically, restoring the situation we
> used to have before delayed fput() and being damn careful about avoiding
> deadlocks), but I would really love to just rip that idiocy out.  IOW,
> just let it fail with -EBUSY in such cases, same as for any other write-opened
> file on that fs.
>
> That, BTW, is the most painful part of the acct series, so being able to
> drop it would be very nice.  Comments?

Long ago in this discucssion someone mentioned that fedora and related
distro's don't have (or at least didn't have) code to close the
accounting files before unmount during shutdown.  I just checked the
debain acct package and it very clearly turns off accounting before
unmount (so debian should not care).

So the practical test is will returning -EBUSY cause fedora based
distro's it fail to unmount filesystems cleanly (looking at the code
and postualting bsd process accounting being left on) I think such
a change will cause such systems to fail to unmount their filesystems
on shutdown/reboot and cause problems because of that.

Eric
