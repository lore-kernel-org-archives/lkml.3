Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaIXRK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:10:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:42393 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaIXRK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:10:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
	<20140910123525.GA29064@ubuntu-hedt>
	<20140910162155.GA7748@mail.hallyn.com>
	<20140910164212.GA32587@ubuntu-hedt>
	<20140911181034.GA58733@ubuntu-hedt>
	<87d2am3r8a.fsf@x220.int.ebiederm.org>
	<20140924132925.GA48721@ubuntu-hedt>
Date: Wed, 24 Sep 2014 10:10:02 -0700
In-Reply-To: <20140924132925.GA48721@ubuntu-hedt> (Seth Forshee's message of
	"Wed, 24 Sep 2014 08:29:25 -0500")
Message-ID: <87y4t9ndw5.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19MOnWcEf4WCpmiglhriIN5bhXpPs8gUT8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3128]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2 0/3] fuse: Add support for mounts from pid/user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> On Tue, Sep 23, 2014 at 03:29:57PM -0700, Eric W. Biederman wrote:
>> 
>> So thinking about this and staring at fuse a little more I don't like
>> the approach of mapping bad uids into INVALID_UID in the case of fuse.
>> 
>> What scares me is that we are looking at a very uncommon case that no
>> one will test much.  And depending for security on a very subtle
>> interpretation of semantics that only matter when someone is attacking
>> us seems scary to me.
>> 
>> For fuse at least I would assume that any time a file shows up with a
>> uid that doesn't map, and we map it to INVALID_UID I would assume it is
>> the work of a hostile user.  It could be a misconfiguration but it is a
>> broken action on the part of the filesystem in either case.
>> 
>> Therefore given that a bad uid can only occur as a result of accidental
>> or hostile action can we please call make_bad_inode in those cases?  And
>> thus always return -EIO.
>> 
>> That way no one needs to consider what happens if we cache bad data or
>> we try to use bad data, and it is an easy position to retreat from
>> if it happens that we need to do something different.
>
> One thing I don't understand is why you're qualifying these statements
> to be limited to fuse. Normal filesystems will have to deal with the
> same problem if/when they are made mountable from user namespaces; is
> this concern not valid there? Or would you advocate the same behavior
> for normal filesystems as well? Otherwise it seems like we're just
> putting off dealing with it for a while.

I am qualifying them with fuse so that my thinking is concrete.  I
believe my thinking generalizes to all filesystems, but I there may be
cases I have not considered that are different.

> I'd prefer for the mounts to be as useful as possible when the fs
> contains ids that don't map into the namespace, but it's also difficult
> to argue against taking the more restricted approach at first and
> loosening up if needed. So I guess I'm okay with returning -EIO to start
> out.

What bugs me the most about making the mounts as useful as possible is
that it makes an assumption about why the uids are corrupt.

I look at the situtation and I make a different assumption that the most
likely reasons for the uids to be corrupt is someone being malicious.
Being as useful as possible when someone is being malicious feels like
a recipe for the malicious user to exploit your generousity.

So in summary I see:
- Low utility in being able to manipulate files with bad uids.
- Bad uids are mostly likely malicious action.
- make_bad_inode is trivial to analyze.
- No impediments to change if I am wrong.

So unless there is a compelling case, right now I would recommend
returning -EIO initially.   That allows us to concentrate on the easier
parts of this and it leaves the changes only in fuse.

I have no problems revisiting this later and in fact I am half persuaded
we should, but simultaneously dealing working on both fuse and the
generic problem of how to handle files with bad uids and gids seems
too much to analyze and digest all at once.

Eric
