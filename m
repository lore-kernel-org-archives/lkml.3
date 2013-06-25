Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab3FYFtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:49:55 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:59033 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3FYFty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:49:54 -0400
Message-ID: <51C92F76.70507@linux.vnet.ibm.com>
Date: Tue, 25 Jun 2013 11:19:42 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>, jkenisto@linux.vnet.ibm.com,
        benh@kernel.crashing.org, ananth@in.ibm.com, mahesh@linux.vnet.ibm.com
Subject: Re: [PATCH] pstore: Fail to unlink if a driver has not defined pstore_erase
References: <20130624074453.24481.96622.stgit@aruna-ThinkPad-T420> <CAGXu5jJpQJCc5OU6M-CvyvLAMyOOb=pxDMh586deYADxff23hQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJpQJCc5OU6M-CvyvLAMyOOb=pxDMh586deYADxff23hQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062505-5564-0000-0000-00000880A833
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keek,

On Monday 24 June 2013 10:33 PM, Kees Cook wrote:
> On Mon, Jun 24, 2013 at 12:48 AM, Aruna Balakrishnaiah
> <aruna@linux.vnet.ibm.com> wrote:
>> pstore_erase is used to erase the record from the persistent store.
>> So if a driver has not defined pstore_erase callback return
>> -EINVAL instead of unlinking a file as deleting the file without
>> erasing its record in persistent store will give a wrong impression
>> to customers.
> This is probably true -- I originally liked the idea of being able to
> clean up the entries, regardless of their storage state, but you're
> probably right. They shouldn't be deleted unless they can _actually_
> be deleted.
>
> So, I support this change, but I think the return needs to be
> different. EINVAL isn't listed, for example, in unlink(2)'s man-page.
> Perhaps EROFS, EACCESS, or EPERM?

The filesystem (pstore) has privileges to unlink the file but only if the
callback function is defined. Since the filesystem has privileges I didn't
consider these error codes (EROFS, EACCESS or EPERM).

In the case where callback function is not defined unlinking the file would
be an invalid operation and hence EINVAL.

Since unlink(2) man page does not have EINVAL listed, I feel going with
EPERM will make more sense.


>
> -Kees
>
>> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
>> ---
>>   fs/pstore/inode.c |    2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
>> index e4bcb2c..fa6339a 100644
>> --- a/fs/pstore/inode.c
>> +++ b/fs/pstore/inode.c
>> @@ -178,6 +178,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
>>          if (p->psi->erase)
>>                  p->psi->erase(p->type, p->id, p->count,
>>                                dentry->d_inode->i_ctime, p->psi);
>> +       else
>> +               return -EINVAL;
>>
>>          return simple_unlink(dir, dentry);
>>   }
>>
>
>
> --
> Kees Cook
> Chrome OS Security
>

