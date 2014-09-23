Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbaIWWac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:30:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52812 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbaIWWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:30:30 -0400
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
Date: Tue, 23 Sep 2014 15:29:57 -0700
In-Reply-To: <20140911181034.GA58733@ubuntu-hedt> (Seth Forshee's message of
	"Thu, 11 Sep 2014 13:10:34 -0500")
Message-ID: <87d2am3r8a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18vEUFnGGWEp0k12F/PbeOXF4F9MQii5Ek=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3509]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
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

> On Wed, Sep 10, 2014 at 11:42:12AM -0500, Seth Forshee wrote:
>> On Wed, Sep 10, 2014 at 06:21:55PM +0200, Serge E. Hallyn wrote:
>> > Quoting Seth Forshee (seth.forshee@canonical.com):
>> > > On Tue, Sep 02, 2014 at 10:44:53AM -0500, Seth Forshee wrote:
>> > > > Another issue mentioned by Eric was what to use for i_[ug]id if the ids
>> > > > from userspace don't map into the user namespace, which is going to be a
>> > > > problem for any other filesystems which become mountable from user
>> > > > namespaces as well. We discussed a few options for addressing this, the
>> > > > most promising of which seems to be either using INVALID_[UG]ID for
>> > > > these inodes or creating vfs-wide "nobody" ids for this purpose. After
>> > > > thinking about it for a while I'm favoring using the invalid ids, but
>> > > > I'm hoping to solicit some more feedback.
>> > > > 
>> > > > For now these patches are using invalid ids if the user doesn't map into
>> > > > the namespace. I went through the vfs code and found one place where
>> > > > this could be handled better (addressed in patch 1 of the series). The
>> > > > only other issue I found was that currently no one, not even root, can
>> > > > change onwership of such inodes, but I suspect we can find a way around
>> > > > this.
>> > > 
>> > > I started playing around with using -2 as a global nobody id. The
>> > > changes below (made on top of this series) are working fine in light
>> > > testing. I'm still not sure about the security implications of doing
>> > > this though. Possibly the nobody id should be removed from init_user_ns
>> > > to prevent any use of the id to gain unauthroized access to such files.
>> > > Thoughts?
>> > 
>> > Can you explain the downsides of just using -1?  What are we able to do
>> > (as a fuse-in-container user) when we use -2 that we can't do when it
>> > uses -1?
>> 
>> The thing that happens with -1 is that checks like
>> capable_wrt_inode_uidgid() always fail on those inodes because
>> INVALID_UID isn't ever mapped into any namespace, even if you're
>> system-wide root. If we use a real id this check would at least pass in
>> init_user_ns, assuming that we don't have to remove -2 from init_user_ns
>> for security reasons.
>> 
>> Or we could modify these checks so that CAP_SYS_ADMIN always gets
>> permission or something like that, which might be the better way to go.
>
> This ought to do (untested as of yet). I think I like this best, but I'm
> also interested in hearing what Eric has to say.

So thinking about this and staring at fuse a little more I don't like
the approach of mapping bad uids into INVALID_UID in the case of fuse.

What scares me is that we are looking at a very uncommon case that no
one will test much.  And depending for security on a very subtle
interpretation of semantics that only matter when someone is attacking
us seems scary to me.

For fuse at least I would assume that any time a file shows up with a
uid that doesn't map, and we map it to INVALID_UID I would assume it is
the work of a hostile user.  It could be a misconfiguration but it is a
broken action on the part of the filesystem in either case.

Therefore given that a bad uid can only occur as a result of accidental
or hostile action can we please call make_bad_inode in those cases?  And
thus always return -EIO.

That way no one needs to consider what happens if we cache bad data or
we try to use bad data, and it is an easy position to retreat from
if it happens that we need to do something different.

Eric
