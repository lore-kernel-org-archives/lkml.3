Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342AbaDQVYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:24:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52240 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaDQVYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:24:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Fengguang Wu <fengguang.wu@intel.com>, tytso@mit.edu
References: <87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
	<87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
	<87ppkhc4pp.fsf@x220.int.ebiederm.org>
	<87ha5r3emw.fsf_-_@x220.int.ebiederm.org>
	<20140417202237.GA18016@ZenIV.linux.org.uk>
Date: Thu, 17 Apr 2014 14:23:27 -0700
In-Reply-To: <20140417202237.GA18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 17 Apr 2014 21:22:37 +0100")
Message-ID: <87tx9rwsz4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/FpimoCUbo006MBEIgsCjnsNdy1WtiM1o=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3723]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: Re: [GIT PULL] Detaching mounts on unlink for 3.15
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Have you tried to profile something like umount -l on a large mount tree?
> You variant causes a shitstorm of
> 	schedule work
> 	switch to workqueue
> 	do actual fs shutdown
> 	wake umount(8) up
> 	get through wait_for_completion()
> for every bleeding vfsmount in there.  And no, it's *not* guaranteed to
> be dominated by fs shutdown time.  Here's the case where it definitely
> won't be:
> 	mkdir /tmp/a
> 	mount --rbind / /tmp/a
> 	umount -l /tmp/a
>
> All vfsmounts involved are killed off with no fs shutdown.  And that's
> *not* a rare case - exit of the last process in namespace is very likely
> to look that way too.
>
> That's far too heavy.

The typically system has about 12 mounts and no mount namespaces.
Making umount of any kind a rare case.

Al my apologies for not picking your favorite solution and in choosing
not to audit every call to mntput in the tree this week I have made an
uncommon case slower.

These bug fixes are important, the code is correct, and it is
technically straight forward to remove the wait in mntput in most
cases.

I am very frustrated that when given lots of opportunities to look at
and comment on my code it is hard to get you to engage and comment
unless I send a pull request to Linus.

This last objection really looks to be a case of perfection getting in
the way of the good.

Eric

