Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaGBTfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:35:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36351 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbaGBTf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:35:28 -0400
Message-ID: <1404329723.596.90.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 1/3] ima: use ahash API for file hash calculation
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Date: Wed, 02 Jul 2014 15:35:23 -0400
In-Reply-To: <CACE9dm-XF=NfsQcfS6urfZkmvomh=Ogu49b-kLR3wZZ+xFXgkA@mail.gmail.com>
References: <cover.1404245510.git.d.kasatkin@samsung.com>
	 <72d68808fd8db2b896a459b120f3e550e5f976c1.1404245510.git.d.kasatkin@samsung.com>
	 <1404319243.596.55.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm-XF=NfsQcfS6urfZkmvomh=Ogu49b-kLR3wZZ+xFXgkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070219-0928-0000-0000-0000032194A6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-02 at 21:20 +0300, Dmitry Kasatkin wrote: 
> On 2 July 2014 19:40, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Tue, 2014-07-01 at 23:12 +0300, Dmitry Kasatkin wrote:
> >> Async hash API allows to use HW acceleration for hash calculation.
> >> It may give significant performance gain or/and reduce power consumption,
> >> which might be very beneficial for battery powered devices.
> >>
> >> This patch introduces hash calculation using ahash API.
> >>
> >> ahash performance depends on data size and particular HW. Under certain
> >> limit, depending on the system, shash performance may be better.
> >>
> >> This patch defines 'ima_ahash' kernel parameter which can be used to
> >> define minimal file size to use with ahash. When file size is not set
> >> or smaller than defined by the parameter, shash will be used.
> >
> > Thank you for the updated patches. The changes should be listed here in
> > the patch description.
> >
> > I keep going back and forth as to whether the ahash routines should be
> > totally separate, as posted, from the shash routines.  Having separate
> > functions is very clear/clean, but there is quite a bit of code
> > duplication (eg. ima_calc_file_hash()/ima_calc_file_ahash(),
> > ima_free_tfm()/ima_free_atfm(), ima_alloc_tfm()/ima_alloc_atfm()).
> >
> > Soliciting comments ...
> >
> 
> I think what you say is a "pattern": alloc/calc/free.
> But the code uses different API mostly and there very small duplication...
> 
> In fact with this 'clean' separation we can have CONFIG_ option to
> ifdef the code ot have it in separate file for those who really want
> to make smallest kernel possible...

Ok, this is an acceptable reason.

thanks,

Mimi

> 
> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> >
> >> ---
> >>  Documentation/kernel-parameters.txt |   5 +
> >>  security/integrity/ima/ima_crypto.c | 185 +++++++++++++++++++++++++++++++++++-
> >>  2 files changed, 186 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> >> index 5a214a3..b406f5c 100644
> >> --- a/Documentation/kernel-parameters.txt
> >> +++ b/Documentation/kernel-parameters.txt
> >> @@ -1291,6 +1291,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >>       ihash_entries=  [KNL]
> >>                       Set number of hash buckets for inode cache.
> >>
> >> +     ima_ahash=      [IMA] Asynchronous hash usage parameters
> >> +                     Format: <min_file_size>
> >> +                     Set the minimal file size when use asynchronous hash.
> >> +                     If ima_ahash is not provided, ahash usage is disabled.
> >> +
> >>       ima_appraise=   [IMA] appraise integrity measurements
> >>                       Format: { "off" | "enforce" | "fix" }
> >>                       default: "enforce"
> >> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> >> index f82d1d7..5eb19b4 100644
> >> --- a/security/integrity/ima/ima_crypto.c
> >> +++ b/security/integrity/ima/ima_crypto.c
> >> @@ -25,7 +25,27 @@
> >>  #include <crypto/hash_info.h>
> >>  #include "ima.h"
> >>
> >> +
> >
> > Extra blank line not needed.
> >
> >> +struct ahash_completion {
> >> +     struct completion completion;
> >> +     int err;
> >> +};
> >> +
> >>  static struct crypto_shash *ima_shash_tfm;
> >> +static struct crypto_ahash *ima_ahash_tfm;
> >> +
> >> +/* minimal file size for ahash use */
> >> +static loff_t ima_ahash_size;
> >> +
> >> +static int __init ima_ahash_setup(char *str)
> >> +{
> >> +     int rc;
> >> +
> >> +     rc = kstrtoll(str, 10, &ima_ahash_size);
> >> +
> >> +     return !rc;
> >> +}
> >> +__setup("ima_ahash=", ima_ahash_setup);
> >>
> >>  /**
> >>   * ima_kernel_read - read file content
> >> @@ -93,9 +113,146 @@ static void ima_free_tfm(struct crypto_shash *tfm)
> >>               crypto_free_shash(tfm);
> >>  }
> >>
> >> -/*
> >> - * Calculate the MD5/SHA1 file digest
> >> - */
> >> +static struct crypto_ahash *ima_alloc_atfm(enum hash_algo algo)
> >> +{
> >> +     struct crypto_ahash *tfm = ima_ahash_tfm;
> >> +     int rc;
> >> +
> >> +     if ((algo != ima_hash_algo && algo < HASH_ALGO__LAST) || !tfm) {
> >> +             tfm = crypto_alloc_ahash(hash_algo_name[algo], 0, 0);
> >> +             if (!IS_ERR(tfm)) {
> >> +                     if (algo == ima_hash_algo)
> >> +                             ima_ahash_tfm = tfm;
> >> +             } else {
> >> +                     rc = PTR_ERR(tfm);
> >> +                     pr_err("Can not allocate %s (reason: %d)\n",
> >> +                            hash_algo_name[algo], rc);
> >> +             }
> >> +     }
> >> +     return tfm;
> >> +}
> >> +
> >> +static void ima_free_atfm(struct crypto_ahash *tfm)
> >> +{
> >> +     if (tfm != ima_ahash_tfm)
> >> +             crypto_free_ahash(tfm);
> >> +}
> >> +
> >> +static void ahash_complete(struct crypto_async_request *req, int err)
> >> +{
> >> +     struct ahash_completion *res = req->data;
> >> +
> >> +     if (err == -EINPROGRESS)
> >> +             return;
> >> +     res->err = err;
> >> +     complete(&res->completion);
> >> +}
> >> +
> >> +static int ahash_wait(int err, struct ahash_completion *res)
> >> +{
> >> +     switch (err) {
> >> +     case 0:
> >> +             break;
> >> +     case -EINPROGRESS:
> >> +     case -EBUSY:
> >> +             wait_for_completion(&res->completion);
> >> +             reinit_completion(&res->completion);
> >> +             err = res->err;
> >> +             /* fall through */
> >> +     default:
> >> +             pr_crit("ahash calculation failed: err: %d\n", err);
> >> +     }
> >> +
> >> +     return err;
> >> +}
> >> +
> >> +static int ima_calc_file_hash_atfm(struct file *file,
> >> +                                struct ima_digest_data *hash,
> >> +                                struct crypto_ahash *tfm)
> >> +{
> >> +     loff_t i_size, offset;
> >> +     char *rbuf;
> >> +     int rc, read = 0, rbuf_len;
> >> +     struct ahash_request *req;
> >> +     struct scatterlist sg[1];
> >> +     struct ahash_completion res;
> >> +
> >> +     hash->length = crypto_ahash_digestsize(tfm);
> >> +
> >> +     req = ahash_request_alloc(tfm, GFP_KERNEL);
> >> +     if (!req)
> >> +             return -ENOMEM;
> >> +
> >> +     init_completion(&res.completion);
> >> +     ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
> >> +                                CRYPTO_TFM_REQ_MAY_SLEEP,
> >> +                                ahash_complete, &res);
> >> +
> >> +     rc = ahash_wait(crypto_ahash_init(req), &res);
> >> +     if (rc)
> >> +             goto out1;
> >> +
> >> +     i_size = i_size_read(file_inode(file));
> >> +
> >> +     if (i_size == 0)
> >> +             goto out2;
> >> +
> >> +     rbuf = kzalloc(PAGE_SIZE, GFP_KERNEL);
> >> +     if (!rbuf) {
> >> +             rc = -ENOMEM;
> >> +             goto out1;
> >> +     }
> >> +
> >> +     if (!(file->f_mode & FMODE_READ)) {
> >> +             file->f_mode |= FMODE_READ;
> >> +             read = 1;
> >> +     }
> >> +
> >> +     for (offset = 0; offset < i_size; offset += rbuf_len) {
> >> +             rbuf_len = ima_kernel_read(file, offset, rbuf, PAGE_SIZE);
> >> +             if (rbuf_len < 0) {
> >> +                     rc = rbuf_len;
> >> +                     vi break;
> >> +             }
> >> +             if (rbuf_len == 0)
> >> +                     break;
> >> +
> >> +             sg_init_one(&sg[0], rbuf, rbuf_len);
> >> +             ahash_request_set_crypt(req, sg, NULL, rbuf_len);
> >> +
> >> +             rc = ahash_wait(crypto_ahash_update(req), &res);
> >> +             if (rc)
> >> +                     break;
> >> +     }
> >> +     if (read)
> >> +             file->f_mode &= ~FMODE_READ;
> >> +     kfree(rbuf);
> >> +out2:
> >> +     if (!rc) {
> >> +             ahash_request_set_crypt(req, NULL, hash->digest, 0);
> >> +             rc = ahash_wait(crypto_ahash_final(req), &res);
> >> +     }
> >> +out1:
> >> +     ahash_request_free(req);
> >> +     return rc;
> >> +}
> >> +
> >> +static int ima_calc_file_ahash(struct file *file, struct ima_digest_data *hash)
> >> +{
> >> +     struct crypto_ahash *tfm;
> >> +     int rc;
> >> +
> >> +     tfm = ima_alloc_atfm(hash->algo);
> >> +     if (IS_ERR(tfm))
> >> +             return PTR_ERR(tfm);
> >> +
> >> +     rc = ima_calc_file_hash_atfm(file, hash, tfm);
> >> +
> >> +     ima_free_atfm(tfm);
> >> +
> >> +     return rc;
> >> +}
> >> +
> >>  static int ima_calc_file_hash_tfm(struct file *file,
> >>                                 struct ima_digest_data *hash,
> >>                                 struct crypto_shash *tfm)
> >> @@ -156,7 +313,7 @@ out:
> >>       return rc;
> >>  }
> >>
> >> -int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >> +static int ima_calc_file_shash(struct file *file, struct ima_digest_data *hash)
> >>  {
> >>       struct crypto_shash *tfm;
> >>       int rc;
> >> @@ -172,6 +329,26 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >>       return rc;
> >>  }
> >>
> >> +int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
> >> +{
> >> +     loff_t i_size;
> >> +     int rc;
> >> +
> >> +     i_size = i_size_read(file_inode(file));
> >
> > Depending on the config options, i_size_read() does more than just
> > access the inode's i_size.   Instead of calling it again, perhaps it
> > should be passed to ima_calc_file_hash()/ahash().
> >
> 
> I thought about it.. Indeed let's make it like that.
> 
> 
> >> +
> >> +     /* shash is more efficient for small data
> >> +      * ahash performance depends on data size and particular HW
> >> +      * ima_ahash_size allows to specify the best value for the system
> >> +      */
> >
> > Function descriptions belong above the function, not inside.
> >
> 
> This is a comment to the code..
> 
> >> +     if (ima_ahash_size && i_size >= ima_ahash_size) {
> >> +             rc = ima_calc_file_ahash(file, hash);
> >> +             if (!rc)
> >> +                     return 0;
> >> +     }
> >> +     /* fallback to shash if ahash failed */
> >
> > Same here.
> >
> 
> Same here...
> 
> But sure it can move to function description...
> 
> > thanks,
> >
> > Mimi
> >
> >> +     return ima_calc_file_shash(file, hash);
> >> +}
> >> +
> >>  /*
> >>   * Calculate the hash of template data
> >>   */
> >
> >
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


