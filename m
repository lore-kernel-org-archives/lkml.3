Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaBYDYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:24:48 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:48557 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbaBYDYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:24:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge@hallyn.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87ob28kqks.fsf_-_@xmission.com>
	<87txc0jbvt.fsf_-_@xmission.com>
	<20140218171708.GD4026@tucsk.piliscsaba.szeredi.hu>
Date: Mon, 24 Feb 2014 19:24:27 -0800
In-Reply-To: <20140218171708.GD4026@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 18 Feb 2014 18:17:08 +0100")
Message-ID: <87mwhfdgd0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/w1I7uHz5pfYLiFOrtEIBihjeRLVDXrtw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.1 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2646]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 05/11] vfs: Add a function to lazily unmount all mounts from any dentry.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Sat, Feb 15, 2014 at 01:37:26PM -0800, Eric W. Biederman wrote:
>> 
>> v2: Always drop the lock when exiting early.
>> v3: Make detach_mounts robust about freeing several
>>     mounts on the same mountpoint at one time, and remove
>>     the unneeded mnt_list list test.
>> v4: Document the purpose of detach_mounts and why new_mountpoint is
>>     safe to call.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederman@twitter.com>
>> ---
>>  fs/mount.h     |    2 ++
>>  fs/namespace.c |   39 +++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 41 insertions(+), 0 deletions(-)
>> 
>> diff --git a/fs/mount.h b/fs/mount.h
>> index 50a72d46e7a6..2b470f34e665 100644
>> --- a/fs/mount.h
>> +++ b/fs/mount.h
>> @@ -84,6 +84,8 @@ extern struct mount *__lookup_mnt_last(struct vfsmount *, struct dentry *);
>>  
>>  extern bool legitimize_mnt(struct vfsmount *, unsigned);
>>  
>> +extern void detach_mounts(struct dentry *dentry);
>> +
>>  static inline void get_mnt_ns(struct mnt_namespace *ns)
>>  {
>>  	atomic_inc(&ns->count);
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index 33db9e95bd5c..7abbf722ce18 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -1359,6 +1359,45 @@ static int do_umount(struct mount *mnt, int flags)
>>  	return retval;
>>  }
>>  
>> +/*
>> + * detach_mounts - lazily unmount all mounts on the specified dentry
>> + *
>> + * During unlink, rmdir, and d_drop it is possible to loose the path
>> + * to an existing mountpoint, and wind up leaking the mount.
>> + * detach_mounts allows lazily unmounting those mounts instead of
>> + * leaking them.
>> + * 
>> + * The caller may hold dentry->d_inode->i_mutex.
>> + */
>> +void detach_mounts(struct dentry *dentry)
>> +{
>> +	struct mountpoint *mp;
>> +	struct mount *mnt;
>> +
>> +	namespace_lock();
>> +	if (!d_mountpoint(dentry))
>> +		goto out_unlock;
>> +
>> +	/* 
>> +	 * The namespace lock and d_mountpoint being set guarantees
>> +	 * that new_mountpoint will just be a lookup of the existing
>> +	 * mountpoint structure.
>> +	 */
>> +	mp = new_mountpoint(dentry);
>
> Howabout a get_mountpoint(dentry) helper, that returns NULL if it turns out to
> be not a mountpoint?  And, as an added bonus, you can drop the comment above as
> well.

I hate to admit it but that is a nice change.   Especially as it allows
removing the d_mounpoint check inside of namespace_lock.  I still need a
cheak d_mounpoint check outside of namespace lock but inside it can go.

The first time I looked at doing that I missed something and the change
looked too awkward to be worth implementing :(

Eric
