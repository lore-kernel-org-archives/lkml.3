Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860Ab3IGAqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 20:46:40 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:59060 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab3IGAqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:46:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130907002959.GN3853@boyd>
References: <20130813220227.GA20160@www.outflux.net>
	<20130907002959.GN3853@boyd>
Date: Fri, 6 Sep 2013 17:46:38 -0700
X-Google-Sender-Auth: wYrnuOSyKNT6JVECFC-RxVS8aKQ
Message-ID: <CAGXu5jK3edvm9Xn3e-Nxv6ruGUMniqv2k61kdAfSB0Xg0eqH_Q@mail.gmail.com>
Subject: Re: [PATCH] ecryptfs: avoid ctx initialization race
From: Kees Cook <keescook@chromium.org>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ecryptfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 6, 2013 at 5:30 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
> On 2013-08-13 15:02:27, Kees Cook wrote:
>> It might be possible for two callers to race the mutex lock after the
>> NULL ctx check. Instead, move the lock above the check so there isn't
>> the possibility of leaking a crypto ctx. Additionally, report the full
>> algo name when failing.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> Thanks, Kees!
>
> I've pushed this to my next branch and it'll be included in a pull
> request early next week.
>
> I made one small change to this patch. See below.
>
>> ---
>>  fs/ecryptfs/crypto.c |   11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
>> index d107576..c134346 100644
>> --- a/fs/ecryptfs/crypto.c
>> +++ b/fs/ecryptfs/crypto.c
>> @@ -618,27 +618,28 @@ int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat)
>>                       "key_size_bits = [%zd]\n",
>>                       crypt_stat->cipher, (int)strlen(crypt_stat->cipher),
>>                       crypt_stat->key_size << 3);
>> +     mutex_lock(&crypt_stat->cs_tfm_mutex);
>>       if (crypt_stat->tfm) {
>>               rc = 0;
>> -             goto out;
>> +             goto out_unlock;
>>       }
>> -     mutex_lock(&crypt_stat->cs_tfm_mutex);
>>       rc = ecryptfs_crypto_api_algify_cipher_name(&full_alg_name,
>>                                                   crypt_stat->cipher, "cbc");
>>       if (rc)
>>               goto out_unlock;
>>       crypt_stat->tfm = crypto_alloc_ablkcipher(full_alg_name, 0, 0);
>> -     kfree(full_alg_name);
>>       if (IS_ERR(crypt_stat->tfm)) {
>>               rc = PTR_ERR(crypt_stat->tfm);
>>               crypt_stat->tfm = NULL;
>>               ecryptfs_printk(KERN_ERR, "cryptfs: init_crypt_ctx(): "
>>                               "Error initializing cipher [%s]\n",
>> -                             crypt_stat->cipher);
>> -             goto out_unlock;
>> +                             full_alg_name);
>> +             goto out_free;
>>       }
>>       crypto_ablkcipher_set_flags(crypt_stat->tfm, CRYPTO_TFM_REQ_WEAK_KEY);
>>       rc = 0;
>> +out_free:
>> +     kfree(full_alg_name);
>>  out_unlock:
>>       mutex_unlock(&crypt_stat->cs_tfm_mutex);
>>  out:
>
> The out label is no longer used. I removed it when I committed this
> patch.

Ah! Yes, good call. Thanks,

-Kees


-- 
Kees Cook
Chrome OS Security
