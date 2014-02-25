Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaBYABo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 19:01:44 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57065 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBYABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 19:01:42 -0500
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
	<87eh34jbsl.fsf_-_@xmission.com>
	<20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu>
Date: Mon, 24 Feb 2014 16:01:29 -0800
In-Reply-To: <20140218174053.GE4026@tucsk.piliscsaba.szeredi.hu> (Miklos
	Szeredi's message of "Tue, 18 Feb 2014 18:40:53 +0100")
Message-ID: <87y510dpra.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18eInVeFUNxEMiMsm5pDGKrSqzBrmrp4NA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.5 XMGappySubj_01 Very gappy subject
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 08/11] vfs: Merge check_submounts_and_drop and d_invalidate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Sat, Feb 15, 2014 at 01:39:22PM -0800, Eric W. Biederman wrote:
>> 
>> Now that d_invalidate is the only caller of check_submounts_and_drop,
>> expand check_submounts_and_drop inline in d_invalidate.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/dcache.c            |   55 +++++++++++++++++++----------------------------
>>  include/linux/dcache.h |    1 -
>>  2 files changed, 22 insertions(+), 34 deletions(-)
>> 
>> diff --git a/fs/dcache.c b/fs/dcache.c
>> index 27585b1dd6f1..5b41205cbf33 100644
>> --- a/fs/dcache.c
>> +++ b/fs/dcache.c

>> -int check_submounts_and_drop(struct dentry *dentry)
>> +int d_invalidate(struct dentry *dentry)
>>  {
>>  	int ret = 0;
>>  
>> +	/*
>> +	 * If it's already been dropped, return OK.
>> +	 */
>> +	spin_lock(&dentry->d_lock);
>> +	if (d_unhashed(dentry)) {
>> +		spin_unlock(&dentry->d_lock);
>> +		return 0;
>> +	}
>> +	spin_unlock(&dentry->d_lock);
>> +
>>  	/* Negative dentries can be dropped without further checks */
>>  	if (!dentry->d_inode) {
>>  		d_drop(dentry);
>
>
> You can optimize this by including the negative check within the above d_locked
> region and calling __d_drop() instead.

For this patch just moving the code and not changing it is the corret
thing to do because it helps with review and understanding the code.

There are two ways I could see going with optimizing the preamble.
Simply dropping the d_lock from around the d_unhashed test as a pointer
dereference should be atomic, and the test is racy against
d_materialise_unique. (We don't always hold the parent
directories inode mutex when d_invalidate is called).  So the d_lock
buys us very little.  Alternatively we could move the work into the
d_walk callbacks.

That kind of optimization deserves it's own patch that can be reviewed
independently.

Eric
