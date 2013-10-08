Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3JHUey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:34:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55518 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3JHUeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:34:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, Rob Landley <rob@landley.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<87a9kkax0j.fsf@xmission.com>
	<CAJfpeguv+7giYNpAuXE9Ja_9BEwB0-fZBVgRSeVqpzSXgQYZ6Q@mail.gmail.com>
	<8761v7h2pt.fsf@tw-ebiederman.twitter.com>
	<CAJfpegtT7y-1HhbEVAMKkdQugTG_w7G_epGtQHGvQLpcZB5FVA@mail.gmail.com>
	<87li281wx6.fsf_-_@xmission.com> <87fvsg1wv6.fsf_-_@xmission.com>
	<20131008134453.GG14242@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 08 Oct 2013 13:31:45 -0700
In-Reply-To: <20131008134453.GG14242@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 8 Oct 2013 15:44:53 +0200")
Message-ID: <87li23y05q.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+wuGYIVd97zIDVXW7oN+gatWMDAPh4RCI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0287]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 1/3] vfs: Keep a list of mounts on a mount point
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

>> @@ -691,6 +693,7 @@ static void detach_mnt(struct mount *mnt, struct path *old_path)
>>  	list_del_init(&mnt->mnt_hash);
>>  	put_mountpoint(mnt->mnt_mp);
>>  	mnt->mnt_mp = NULL;
>> +	list_del_init(&mnt->mnt_mp_list);
>
> Should be done *before* put_mountpoint(), for obvious reasons.
>
> And a BUG_ON(!list_empty(&mp->m_list)) in put_mountpoint() for good measure (and
> no, WARN_ON() is not better here, since use-after-free is definitely worse than
> a BUG).

Good point.  I will take a look at making this change shortly and repost
the patches.


>>  }
>>  
>>  /*
>> @@ -705,6 +708,7 @@ void mnt_set_mountpoint(struct mount *mnt,
>>  	child_mnt->mnt_mountpoint = dget(mp->m_dentry);
>>  	child_mnt->mnt_parent = mnt;
>>  	child_mnt->mnt_mp = mp;
>> +	list_add_tail(&child_mnt->mnt_mp_list, &mp->m_list);
>>  }
>>  
>>  /*
>> @@ -1193,6 +1197,7 @@ void umount_tree(struct mount *mnt, int propagate)
>>  			p->mnt_parent->mnt_ghosts++;
>>  			put_mountpoint(p->mnt_mp);
>>  			p->mnt_mp = NULL;
>> +			list_del_init(&mnt->mnt_mp_list);
>
> Ditto.
>
>>  		}
>>  		change_mnt_propagation(p, MS_PRIVATE);
>>  	}
>> -- 
>> 1.7.5.4
>> 
