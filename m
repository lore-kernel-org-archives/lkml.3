Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3JUKrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 06:47:04 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:55458 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3JUKrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 06:47:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAFkjPTkKeEFmVWoPFXhAkBwwO67M1K-c1Q2OUvajSArTSgrFvg@mail.gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
	<1380411144-9236-5-git-send-email-geyslan@gmail.com>
	<CAFkjPTkKeEFmVWoPFXhAkBwwO67M1K-c1Q2OUvajSArTSgrFvg@mail.gmail.com>
Date: Mon, 21 Oct 2013 08:47:01 -0200
Message-ID: <CAGG-pUSHj5uumz01mReeD+gpg--fkZCS18gMbW2FBjmufjcEDg@mail.gmail.com>
Subject: Re: [PATCH] 9p: fix return value in case of error in v9fs_fid_xattr_set
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: rminnich@sandia.gov, Latchesar Ionkov <lucho@ionkov.net>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At first, thanks for reply.

2013/10/20 Eric Van Hensbergen <ericvh@gmail.com>:
> On Sat, Sep 28, 2013 at 6:32 PM, Geyslan G. Bem <geyslan@gmail.com> wrote:
>>
>> In case of error in the p9_client_write, the function v9fs_fid_xattr_set
>> should return its negative value, what was never being done.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  fs/9p/xattr.c | 9 ++++-----
>>  1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/9p/xattr.c b/fs/9p/xattr.c
>> index 3c28cdf..0788388 100644
>> --- a/fs/9p/xattr.c
>> +++ b/fs/9p/xattr.c
>> @@ -149,11 +149,10 @@ int v9fs_fid_xattr_set(struct p9_fid *fid, const
>> char *name,
>>                         write_count = value_len;
>>                 write_count = p9_client_write(fid, ((char *)value)+offset,
>>                                         NULL, offset, write_count);
>> -               if (write_count < 0) {
>> -                       /* error in xattr write */
>> -                       retval = write_count;
>> -                       break;
>> -               }
>> +               /* error in xattr write */
>> +               if (write_count < 0)
>> +                       return write_count;
>> +
>>
>
>
> So, I'm convinced that there's a problem here, but I think the solution in
> the patch is incomplete.  Simply returning wouldn't clunk the fid.  I think
> the right approach is likely to keep the break, clunk and return an error if
> either the p9_client_write or the p9_client_clunk fails.
>
> I suppose you could make a claim that v9fs_fid_xattr_set shouldn't be
> clunking the fid -- but considering it's cloned the fid in its function
> body, it does seem like it shoudl also be cleaning up after itself.
>

Right. I'll centralize the exiting assuring that fid will be clunked
in case of fails.

>     -eric
>
>
>       -eric
>
