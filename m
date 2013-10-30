Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3J3OvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 10:51:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754291Ab3J3OvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:51:24 -0400
References: <1383126294-28793-1-git-send-email-cxie@redhat.com> <1383126294-28793-2-git-send-email-cxie@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D388F@USINDEM103.corp.hds.com>
User-agent: mu4e 0.9.9.5; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Madper Xie <cxie@redhat.com>, "tony.luck\@intel.com" <tony.luck@intel.com>,
        "keescook\@chromium.org" <keescook@chromium.org>,
        "ccross\@android.com" <ccross@android.com>,
        "anton\@enomsg.org" <anton@enomsg.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bbboson\@gmail.com" <bbboson@gmail.com>
Subject: Re: [PATCH 1/2] pstore: avoid incorrectly mark entry as duplicate
In-reply-to: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9D388F@USINDEM103.corp.hds.com>
Date: Wed, 30 Oct 2013 22:51:07 +0800
Message-ID: <87txfyhkx0.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


seiji.aguchi@hds.com writes:

>> -----Original Message-----
>> From: Madper Xie [mailto:cxie@redhat.com]
>> Sent: Wednesday, October 30, 2013 5:45 AM
>> To: tony.luck@intel.com; keescook@chromium.org; ccross@android.com; anton@enomsg.org; Seiji Aguchi
>> Cc: linux-efi@vger.kernel.org; linux-kernel@vger.kernel.org; bbboson@gmail.com; Madper Xie
>> Subject: [PATCH 1/2] pstore: avoid incorrectly mark entry as duplicate
>> 
>> From: Madper Xie <bbboson@gmail.com>
>> 
>> pstore try to find duplicate entries by check both ID, type and psi.
>> They are not really enough for efi backend. dumped vars always have
>> the same type, psi and ID. like follows:
>> dump-type0-9-1-1382511508-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>> dump-type0-9-1-1382515661-C-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>> 
>> The "duplicate" entries won't appear in pstorefs. And a complain will be
>> print -- pstore: failed to load 76 record(s) from 'efi'
>> So I add two more checks: timespec and count.
>> 
>> Signed-off-by: Madper Xie <cxie@redhat.com>
>
> Looks good to me.
> Acked-by: Seiji Aguchi <seiji.aguchi@hds.com>
>
> But, this patch has to be tested by other backend drivers like erst and ramoops.
> In my understanding, erst has supported to log multiple events.
> So, I'm interested why the same error hasn't happened in the other drivers.
>
> Seiji
Thanks for your review. I'll try to test other backends. :-)
>
>> ---
>>  fs/pstore/inode.c | 6 +++++-
>>  1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
>> index 1282384..0ae994c 100644
>> --- a/fs/pstore/inode.c
>> +++ b/fs/pstore/inode.c
>> @@ -47,6 +47,7 @@ static LIST_HEAD(allpstore);
>>  struct pstore_private {
>>  	struct list_head list;
>>  	struct pstore_info *psi;
>> +	struct timespec time;
>>  	enum pstore_type_id type;
>>  	u64	id;
>>  	int	count;
>> @@ -290,7 +291,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>>  	list_for_each_entry(pos, &allpstore, list) {
>>  		if (pos->type == type &&
>>  		    pos->id == id &&
>> -		    pos->psi == psi) {
>> +		    pos->psi == psi &&
>> +		    pos->count == count &&
>> +		    !timespec_compare(&pos->time, &time)) {
>>  			rc = -EEXIST;
>>  			break;
>>  		}
>> @@ -312,6 +315,7 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
>>  	private->id = id;
>>  	private->count = count;
>>  	private->psi = psi;
>> +	memcpy(&private->time, &time, sizeof(struct timespec));
>> 
>>  	switch (type) {
>>  	case PSTORE_TYPE_DMESG:
>> --
>> 1.8.4.2


-- 
Best,
Madper Xie.
