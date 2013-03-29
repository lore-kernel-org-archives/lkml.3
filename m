Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3C2CWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 22:22:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54704 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab3C2CWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 22:22:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: mtk.manpages@gmail.com
Cc: Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, luto@amacapital.net
References: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
Date: Thu, 28 Mar 2013 19:21:51 -0700
In-Reply-To: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
	(Michael Kerrisk's message of "Wed, 27 Mar 2013 22:26:07 +0100")
Message-ID: <87ehez2beo.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/wOOugqmEK/F0z0gXsU4k5jgjoEGWov48=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;mtk.manpages@gmail.com
X-Spam-Relay-Country: 
Subject: Re: For review (v2): user_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Over the last little while I have been working to correct a design
oversight in user namespaces, that probably needs to be documented
somewhere, and the fixes for the worst of the oversight have been
merged.

The problem was I forgot to consider what when there are shared
resources and root uses things like chroot and mounts as access policy
controls, and not as a mechanism to prevent the gaining of privilege.

This has led to the realization that the root directory is one of the
privileged identifiers that is controlled by the user namespace.

So now there is a restriction that user namespaces can not be created
if you are chrooted.

Beyond that there are restrictions on what you can do in a mount
namespace created inside a user namespace.  Read-only bind mounts
may not be remounted to read-write.   The mqueue filesystem may only be
mounted if you have CAP_SYS_ADMIN over it's ipc namespace.  proc and
sysfs may only be mounted if they are already somewhere in the mount
namespace.

There is a remaining open question on what to allow in the context of
unmounting and bind mounts.  In the normal case unmounting something is
safe because mounts almost always happen on an empty directory.  The
only significant case that I can think of where this is different are
union mounts and union filesystems.  However the general principle of
following the restrictions of the root user makes suggests that unmounts
should not happen.

In the grand scheme of things these are small little things but they are
details we need to get right so that enabling user namespaces is no
worse that adding any other feature to the kernel.  In the worst case
just adding more attack surface for the bad guys, but not a matter of
risk semantically.

Eric
