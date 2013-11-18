Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3KRPa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:30:27 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:40230 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3KRPaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <1384523146-9290-6-git-send-email-roberto.sassu@polito.it>
References: <1384523146-9290-1-git-send-email-roberto.sassu@polito.it>
	<1384523146-9290-6-git-send-email-roberto.sassu@polito.it>
Date: Mon, 18 Nov 2013 17:30:19 +0200
Message-ID: <CACE9dm9CjjLkv4oh7vpm=AiHSRfuouEkOrMaRpv3EA_c1_LO=A@mail.gmail.com>
Subject: Re: [PATCH 5/6] ima: do not include field length in template digest
 calc for ima template
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: linux-security-module@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-ima-devel@lists.sourceforge.net, Mimi Zohar <zohar@us.ibm.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, james.l.morris@oracle.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 3:45 PM, Roberto Sassu <roberto.sassu@polito.it> wrote:
> To maintain compatibility with userspace tools, the field length must not
> be included in the template digest calculation for the 'ima' template.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> ---
>  security/integrity/ima/ima.h        |  3 ++-
>  security/integrity/ima/ima_api.c    |  1 +
>  security/integrity/ima/ima_crypto.c | 20 ++++++++++++--------
>  3 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index bf03c6a..a21cf70 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -97,7 +97,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>                            const char *op, struct inode *inode,
>                            const unsigned char *filename);
>  int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
> -int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
> +int ima_calc_field_array_hash(struct ima_field_data *field_data,
> +                             struct ima_template_desc *desc, int num_fields,
>                               struct ima_digest_data *hash);
>  int __init ima_calc_boot_aggregate(struct ima_digest_data *hash);
>  void ima_add_violation(struct file *file, const unsigned char *filename,
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 0e75408..8037484 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -94,6 +94,7 @@ int ima_store_template(struct ima_template_entry *entry,
>                 /* this function uses default algo */
>                 hash.hdr.algo = HASH_ALGO_SHA1;
>                 result = ima_calc_field_array_hash(&entry->template_data[0],
> +                                                  entry->template_desc,
>                                                    num_fields, &hash.hdr);
>                 if (result < 0) {
>                         integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode,
> diff --git a/security/integrity/ima/ima_crypto.c b/security/integrity/ima/ima_crypto.c
> index e22708b..fdf60de 100644
> --- a/security/integrity/ima/ima_crypto.c
> +++ b/security/integrity/ima/ima_crypto.c
> @@ -140,6 +140,7 @@ int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash)
>   * Calculate the hash of template data
>   */
>  static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
> +                                        struct ima_template_desc *td,
>                                          int num_fields,
>                                          struct ima_digest_data *hash,
>                                          struct crypto_shash *tfm)
> @@ -160,12 +161,13 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>                 return rc;
>
>         for (i = 0; i < num_fields; i++) {
> -               rc = crypto_shash_update(&desc.shash,
> -                                        (const u8 *) &field_data[i].len,
> -                                        sizeof(field_data[i].len));
> -               if (rc)
> -                       break;
> -
> +               if (strcmp(td->name, IMA_TEMPLATE_IMA_NAME) != 0) {
> +                       rc = crypto_shash_update(&desc.shash,
> +                                               (const u8 *) &field_data[i].len,
> +                                               sizeof(field_data[i].len));
> +                       if (rc)
> +                               break;
> +               }

What was actually the point in including field length in the hash calculation?
Does it really make it cryptographically stronger?
If not then remove it at all...

- Dmitry


>                 rc = crypto_shash_update(&desc.shash, field_data[i].data,
>                                          field_data[i].len);
>                 if (rc)
> @@ -178,7 +180,8 @@ static int ima_calc_field_array_hash_tfm(struct ima_field_data *field_data,
>         return rc;
>  }
>
> -int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
> +int ima_calc_field_array_hash(struct ima_field_data *field_data,
> +                             struct ima_template_desc *desc, int num_fields,
>                               struct ima_digest_data *hash)
>  {
>         struct crypto_shash *tfm;
> @@ -188,7 +191,8 @@ int ima_calc_field_array_hash(struct ima_field_data *field_data, int num_fields,
>         if (IS_ERR(tfm))
>                 return PTR_ERR(tfm);
>
> -       rc = ima_calc_field_array_hash_tfm(field_data, num_fields, hash, tfm);
> +       rc = ima_calc_field_array_hash_tfm(field_data, desc, num_fields,
> +                                          hash, tfm);
>
>         ima_free_tfm(tfm);
>
> --
> 1.8.1.4
>



-- 
Thanks,
Dmitry
