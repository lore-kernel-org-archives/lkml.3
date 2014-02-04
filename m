Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbaBDSxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:53:46 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:51067 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDSxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:53:43 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cong Wang <cwang@twopensource.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-mm@kvack.org
References: <87r47jsb2p.fsf@xmission.com>
	<CAHA+R7OLnrujsinNhwVvZyJDz+BrTxYmw0gWeSSyq+dJ2LF9qg@mail.gmail.com>
Date: Tue, 04 Feb 2014 10:53:35 -0800
In-Reply-To: <CAHA+R7OLnrujsinNhwVvZyJDz+BrTxYmw0gWeSSyq+dJ2LF9qg@mail.gmail.com>
	(Cong Wang's message of "Tue, 4 Feb 2014 10:25:33 -0800")
Message-ID: <878utqlnf4.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/AyhH6mJFyvxfMBe1PVyiIkmHhz2YXFZ8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cong Wang <cwang@twopensource.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] fdtable: Avoid triggering OOMs from alloc_fdmem
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <cwang@twopensource.com> writes:

> On Mon, Feb 3, 2014 at 9:26 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> diff --git a/fs/file.c b/fs/file.c
>> index 771578b33fb6..db25c2bdfe46 100644
>> --- a/fs/file.c
>> +++ b/fs/file.c
>> @@ -34,7 +34,7 @@ static void *alloc_fdmem(size_t size)
>>          * vmalloc() if the allocation size will be considered "large" by the VM.
>>          */
>>         if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
>> -               void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>> +               void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY);
>>                 if (data != NULL)
>>                         return data;
>>         }
>
> Or try again without __GFP_NORETRY like we do in nelink mmap?

I think I would much rather keep the current semantics of return -ENOMEM
and keep the problem localized then trigger a box wide OOM thank you
very much.


Retrying the kmalloc without __GFP_NORETRY is pointless.  If you are in
the unlikely 0.01% of the time when the kmalloc fails it is almost
certainly going to fail again.  Writing out_of_memory() as kmalloc()
is pointless and very confusing.

The vmalloc won't fail unless you are on a 32bit box.  So it isn't a
case that anyone has to deal with in practice.

Eric
