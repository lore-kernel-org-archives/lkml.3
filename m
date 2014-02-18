Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaBRV2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:28:51 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:43767 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBRV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:28:49 -0500
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
	<8761ogkqhl.fsf_-_@xmission.com>
	<20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 18 Feb 2014 13:28:36 -0800
In-Reply-To: <20140218171252.GC4026@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 18 Feb 2014 18:12:52 +0100")
Message-ID: <87ha7wrtyz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18XcxEOcqnaXa6CyCUErwf7wEDKIecS17I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  2.9 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0024]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 03/11] vfs: Don't allow overwriting mounts in the current mount namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index 22e536705c45..6dc23614d44d 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -631,6 +631,41 @@ struct vfsmount *lookup_mnt(struct path *path)
>>  	return m;
>>  }
>>  
>> +/*
>> + * __is_local_mountpoint - Test to see if dentry is a mountpoint in the
>> + *                         current mount namespace.
>> + *
>> + * The common case is dentries are not mountpoints at all and that
>> + * test is handled inline.  For the slow case when we are actually
>> + * dealing with a mountpoint of some kind, walk through all of the
>> + * mounts in the current mount namespace and test to see if the dentry
>> + * is a mountpoint.
>> + *
>> + * The mount_hashtable is not usable in the context because we
>> + * need to identify all mounts that may be in the current mount
>> + * namespace not just a mount that happens to have some specified
>> + * parent mount.
>> + */
>> +int __is_local_mountpoint(struct dentry *dentry)
>
> Minor nit: return value of any is_* function is either true or false, so why not
> declare it bool?

Because I am working on the core of the kernel and C compilers do weird
things with bool variables (storing them in bytes...).  I expected a
type that the C compiler does not do weird things with would be more
readily received on a path whose performance people are interested in.

>> +{
>> +	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
>> +	struct mount *mnt;
>> +	int is_covered = 0;
>
> And the same for this var.
>
>> +
>> +	if (!d_mountpoint(dentry))
>> +		goto out;
>> +
>> +	down_read(&namespace_sem);
>> +	list_for_each_entry(mnt, &ns->list, mnt_list) {
>> +		is_covered = (mnt->mnt_mountpoint == dentry);
>> +		if (is_covered)
>> +			break;
>> +	}
>> +	up_read(&namespace_sem);
>> +out:
>> +	return is_covered;
>> +}
>> +
>>  static struct mountpoint *new_mountpoint(struct dentry *dentry)
>>  {
>>  	struct list_head *chain = mountpoint_hashtable + hash(NULL, dentry);
>> -- 
>> 1.7.5.4

Eric
