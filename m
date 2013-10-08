Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808Ab3JHUgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:36:02 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56288 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab3JHUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:35:56 -0400
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
	<87li281wx6.fsf_-_@xmission.com> <87a9io1wu1.fsf_-_@xmission.com>
	<20131008135648.GH14242@tucsk.piliscsaba.szeredi.hu>
Date: Tue, 08 Oct 2013 13:32:53 -0700
In-Reply-To: <20131008135648.GH14242@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 8 Oct 2013 15:56:48 +0200")
Message-ID: <87fvsby03u.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18fq71i12FoymvZ6IeLHYbtX9v6/C1D5IA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0122]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [RFC][PATCH 2/3] vfs: Add a function to lazily unmount all mounts from any dentry.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Fri, Oct 04, 2013 at 03:43:18PM -0700, Eric W. Biederman wrote:
>> 
>> +void detach_mounts(struct dentry *dentry)
>> +{
>> +	struct mount *mnt, *next;
>> +	struct mountpoint *mp;
>> +
>> +	namespace_lock();
>> +	if (!d_mountpoint(dentry)) {
>> +		namespace_unlock();
>> +		return;
>> +	}
>> +	mp = new_mountpoint(dentry);
>> +	if (IS_ERR(mp)) {
>> +		return;
>> +	}
>> +	br_write_lock(&vfsmount_lock);
>> +	list_for_each_entry_safe(mnt, next, &mp->m_list, mnt_mp_list) {
>
> I don't think list_for_each_entry_safe is actually safe enough here.  Because
> propageted umounts will likely remove other mounts from the same mountpoint as
> well.  Doing it with "while (!list_empty(&mp->m_list))" should be better, and
> AFAICS it will always make progress.

Thanks I will take a look.  But on the surface that logic sounds
correct.

Eric
