Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3BRBZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:25:54 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:58751 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab3BRBZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:25:52 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Ben Myers <bpm@sgi.com>,
        linux-fsdevel@vger.kernel.org
References: <87pq38wimv.fsf@xmission.com>
	<1353415420-5457-1-git-send-email-ebiederm@xmission.com>
	<1353415420-5457-10-git-send-email-ebiederm@xmission.com>
	<20121120235524.GK2591@dastard> <20121121195246.GN2822@localhost>
	<87obfoxetf.fsf@xmission.com> <20130214021908.GJ26694@dastard>
Date: Sun, 17 Feb 2013 17:25:43 -0800
In-Reply-To: <20130214021908.GJ26694@dastard> (Dave Chinner's message of "Thu,
	14 Feb 2013 13:19:08 +1100")
Message-ID: <87621qpg4o.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/E5YBqMpnsLwM4EW17sO7oqHKdby8Xuco=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0003]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Dave Chinner <david@fromorbit.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Wed, Feb 13, 2013 at 10:13:16AM -0800, Eric W. Biederman wrote:
>
>> The crazy thing is that is that xfs appears to
>> directly write their incore inode structure into their journal. 
>
> Off topic, but it's actually a very sane thing to do. It's called
> logical object logging, as opposed to physical logging like ext3/4
> and ocfs2 use. XFS uses a combination of logical logging
> (superblock, dquots, inodes) and physical logging (via buffers).

Not putting your structures in disk-endian before putting them on-disk
seems silly.  As far as I can tell if you switch endianness of the
machine accessing your xfs filesystem and have to do a log recover
it won't work because a lot of the log entries will appear corrupted.

It also seems silly to require your in-memory structure to be binary
compatibile with your log when you immediately copy that structure to
another buffer when it comes time to queue a version of it to put into
the log.

The fact that you sometimes need to allocate memory and make a copy so
you can stuff your data into the logvec whose only purpose is to then
copy the data a second time seems silly and wasteful.

Logical logging itself seems reasonable.  I just find the implementation
in xfs odd.

It looks like with a few little changes xfs could retain backwards
compatibility with today, remove extra memory copies, and completely
decouple the format of the in-core structures with the format of the
on-disk structures.  Allowing scary comments to be removed.

Eric
