Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242Ab3BMSN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:13:29 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:39715 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3BMSNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:13:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>
References: <87pq38wimv.fsf@xmission.com>
	<1353415420-5457-1-git-send-email-ebiederm@xmission.com>
	<1353415420-5457-10-git-send-email-ebiederm@xmission.com>
	<20121120235524.GK2591@dastard> <20121121195246.GN2822@localhost>
Date: Wed, 13 Feb 2013 10:13:16 -0800
In-Reply-To: <20121121195246.GN2822@localhost> (Joel Becker's message of "Wed,
	21 Nov 2012 11:52:47 -0800")
Message-ID: <87obfoxetf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Is/axwCqbO4gYUKZzaNXnEB6Rab7cg/E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0835]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Dave Chinner <david@fromorbit.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH RFC 10/12] userns: Convert xfs to use kuid/kgid/kprojid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Becker <jlbec@evilplan.org> writes:

> On Wed, Nov 21, 2012 at 10:55:24AM +1100, Dave Chinner wrote:
>> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> > index 2778258..3656b88 100644
>> > --- a/fs/xfs/xfs_inode.c
>> > +++ b/fs/xfs/xfs_inode.c
>> > @@ -570,11 +570,12 @@ xfs_dinode_from_disk(
>> >  	to->di_version = from ->di_version;
>> >  	to->di_format = from->di_format;
>> >  	to->di_onlink = be16_to_cpu(from->di_onlink);
>> > -	to->di_uid = be32_to_cpu(from->di_uid);
>> > -	to->di_gid = be32_to_cpu(from->di_gid);
>> > +	to->di_uid = make_kuid(&init_user_ns, be32_to_cpu(from->di_uid));
>> > +	to->di_gid = make_kgid(&init_user_ns, be32_to_cpu(from->di_gid));
>> 
>> You can't do this, because the incore inode structure is written
>> directly to the log. This is effectively an on-disk format change.
>
> 	Yeah, I don't get this either.  Over in ocfs2, you do the
> correct thing, translating at the boundary from ocfs2_dinode to struct
> inode.

This is the boundary.  The crazy thing is that is that xfs appears to
directly write their incore inode structure into their journal.  I had
missed the journal reference the first time through and simply assumed
since this is where the disk inode to the incore inode coversion
happened that the weird scary comment in the xfs header file was wrong.

I would have no problems with not converting those uids and gids except
they are used directly in comparisons against current_fsuid so it really
isn't ok to not convert those values.

I wish that incore structure was managed more like the lvb in ocfs2.
Even though it is cached in core it is first converted into a specific
byte order and then shoved into a character array.  Keeping anyone from
getting any funny ideas about using those values directly.

I have sent my xfs changes back to the drawing board and am
concentrating on getting my conversions for the rest of the filesystems
merged.  When I get the time I will come back to xfs.  xfs is a very
peculiar filesystem.

Eric
