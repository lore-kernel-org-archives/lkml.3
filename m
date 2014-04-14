Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaDNHkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:10 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35742 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaDNHjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:39:17 -0400
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
References: <87sipmbe8x.fsf@x220.int.ebiederm.org>
	<20140409175322.GZ18016@ZenIV.linux.org.uk>
	<20140409182830.GA18016@ZenIV.linux.org.uk>
	<87txa286fu.fsf@x220.int.ebiederm.org>
	<87fvlm860e.fsf_-_@x220.int.ebiederm.org>
	<20140409232423.GB18016@ZenIV.linux.org.uk>
	<87lhva5h4k.fsf@x220.int.ebiederm.org>
	<20140413053956.GM18016@ZenIV.linux.org.uk>
	<87zjjp3e7w.fsf@x220.int.ebiederm.org>
	<87ppkl1xb7.fsf@x220.int.ebiederm.org>
	<20140413215242.GP18016@ZenIV.linux.org.uk>
Date: Mon, 14 Apr 2014 00:38:47 -0700
In-Reply-To: <20140413215242.GP18016@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 13 Apr 2014 22:52:42 +0100")
Message-ID: <87y4z8uzqw.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/dnu0HMSlrKQqPhhlVT0gAqvgeAvKDTfM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1642]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
Subject: [RFC][PATCH 0/4] No I/O from mntput
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a lot of ways we could approach this, and I sat down and wrote
the simplest variant I could think of, so hopefully there are not silly
bugs that get overlooked.

The code move all cleanup from mntput that would do filesystem I/O into
work queues.

The code waits in mntput for that I/O to complete if we wait today.

The code has been tested and it works, and it succeeds in running
deactivate_super in a stack from with just short of 7500 bytes free.
7500 bytes should be enough for anybody!

I want to double check that I am using work queues correctly, they used
to be deadlock prone, and sleep on everything before I commit to a final
version but this version is probably good enough.

I may be going overboard in the case where we auto close BSD accounting
files, but at this point I figure better safe than sorry. 

Eric W. Biederman (4):
      vfs: Remove useless loop in mntput_no_expire
      vfs: Move autoclose of BSD accounting into a work queue
      vfs: In mntput run deactivate_super on a shallow stack.
      vfs: Block intuitively in the case of BSD accounting files

 fs/mount.h     | 14 +++++++++++---
 fs/namespace.c | 43 +++++++++++++++++++++++++++++++++++--------
 kernel/acct.c  | 25 ++++++++++++++++++++-----
 3 files changed, 66 insertions(+), 16 deletions(-)

