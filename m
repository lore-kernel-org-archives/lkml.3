Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaDYPRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:17:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39626 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaDYPRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:17:20 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-38-535a7c7d04fc
Message-id: <535A7CB9.6010000@samsung.com>
Date: Fri, 25 Apr 2014 18:18:17 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, jmorris@namei.org, roberto.sassu@polito.it,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/20] ima: path based policy loading interface
References: <cover.1398259638.git.d.kasatkin@samsung.com>
 <0f525fc369d224f149dec6606467109c9cd7e735.1398259638.git.d.kasatkin@samsung.com>
 <1398373439.3395.82.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1398373439.3395.82.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsVy+t/xa7q1NVHBBoceWVm8a/rNYrFu/WIm
	i8u75rBZfOh5xGbxctc3dotPKyYxO7B5PDi0mcWj53uyx+mVxR7v911l8/i8SS6ANYrLJiU1
	J7MstUjfLoErY9HmvSwFa/Qr/p36wtzAOFWti5GTQ0LAROLYo82sELaYxIV769m6GLk4hASW
	Mkoc+fmbBcJpZJI4/vEXK4Qzi1Fixbtn7CAtvAJaEvvfrGAGsVkEVCW+/X/HBGKzCehJbGj+
	AVYjKhAhca/xMCtEvaDEj8n3WEBsEQFNiWOtHxlBhjILdDFKXH56DGyQsICzxKbfX6G2nWSU
	aPr0HmwSp4C7xIcbnWBFzALqEpPmLYKy5SU2r3kLZgsBXdG9di0bxEOKEqcnn2OewCg8C8ny
	WUjaZyFpX8DIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJE6+7mBceszqEKMAB6MSD+8K
	o8hgIdbEsuLK3EOMEhzMSiK81/KjgoV4UxIrq1KL8uOLSnNSiw8xMnFwSjUwKq/qEdrqqF/l
	LMoav9nkgfIpQ/YDazTPi5pdXSc32Wbega+sR+/E/zrEduL5te3WP6ZzGmxadHDlysqOBSdS
	7XIPNDesPzvx/oY9U3Mcy8zte1h5NzpVruh+Y6LcVrfMMHNKgS2X6qzz/arrMh9ZmjN0Ldw9
	h9Gk0du/IDzhUlbNvIoXL3LklViKMxINtZiLihMBpAXKf3ECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 00:03, Mimi Zohar wrote:
> On Wed, 2014-04-23 at 16:30 +0300, Dmitry Kasatkin wrote: 
>> Currently policy is loaded by writing policy content to
>> '<securityfs>/ima/policy' file.
>>
>> This patch extends policy loading meachanism with possibility
>> to load signed policy using a path to the policy.
>> Policy signature must be available in the <policy>.sig file.
> Assuming (big assumption) you're permitted to open the policy file from
> the kernel, why are you verifying the signature inline based on a .sig?
> Shouldn't this be a new integrity/security hook?

What kind of hook do you mean?

Actually I was considering 2 approaches.

1. Introduce additional IMA function similar to ima_module_check() and
then retrieve verification status OK+sig
That would be using normal measurement code.
This requires anyway to open file from the kernel.
But it would be a bit tricky to move policy and signature together and
does not work with auto-generated initramfs
images on the distros as they do not have xattrs...

2. Read policy to the buffer as it is needed anyway and then just verify
the signature.
This was just simple enough as initial thought to implement.
Easy to copy policy and works with initramfs.


- Dmitry

> thanks,
>
> Mimi
>
>> Policy can be loaded like:
>> echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy
>>
>> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> ---
>>  security/integrity/ima/Kconfig      | 13 +++++++
>>  security/integrity/ima/ima.h        |  9 +++++
>>  security/integrity/ima/ima_fs.c     |  2 +-
>>  security/integrity/ima/ima_policy.c | 74 +++++++++++++++++++++++++++++++++++++
>>  4 files changed, 97 insertions(+), 1 deletion(-)
>>
>> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
>> index 5474c47..465cef4 100644
>> --- a/security/integrity/ima/Kconfig
>> +++ b/security/integrity/ima/Kconfig
>> @@ -140,3 +140,16 @@ config IMA_LOAD_X509
>>  	help
>>  	   This option enables X509 certificate loading from the kernel
>>  	   to the '_ima' trusted keyring.
>> +
>> +config IMA_POLICY_LOADER
>> +	bool "Path based policy loading interface"
>> +	depends on IMA_TRUSTED_KEYRING
>> +	default n
>> +	help
>> +	  This option enables path based signed policy loading interface.
>> +	  Policy signature must be provided in the <policy>.sig file
>> +	  along with the policy. When this option is enabled, kernel
>> +	  tries to load default policy from /etc/ima_policy.
>> +
>> +	  Loading policy is like:
>> +	  echo /etc/ima/ima_policy > /sys/kernel/security/ima/policy
>> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
>> index 3b90b60..f2722bb 100644
>> --- a/security/integrity/ima/ima.h
>> +++ b/security/integrity/ima/ima.h
>> @@ -170,6 +170,15 @@ bool ima_default_policy(void);
>>  ssize_t ima_parse_add_rule(char *);
>>  void ima_delete_rules(void);
>>
>> +#ifdef CONFIG_IMA_POLICY_LOADER
>> +ssize_t ima_read_policy(char *path);
>> +#else
>> +static inline ssize_t ima_read_policy(char *data)
>> +{
>> +	return ima_parse_add_rule(data);
>> +}
>> +#endif
>> +
>>  /* Appraise integrity measurements */
>>  #define IMA_APPRAISE_ENFORCE	0x01
>>  #define IMA_APPRAISE_FIX	0x02
>> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
>> index 34ae5f2..bde7a0e 100644
>> --- a/security/integrity/ima/ima_fs.c
>> +++ b/security/integrity/ima/ima_fs.c
>> @@ -273,7 +273,7 @@ static ssize_t ima_write_policy(struct file *file, const char __user *buf,
>>  	if (copy_from_user(data, buf, datalen))
>>  		goto out;
>>
>> -	result = ima_parse_add_rule(data);
>> +	result = ima_read_policy(data);
>>  out:
>>  	if (result < 0)
>>  		valid_policy = 0;
>> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
>> index b24e7d1..c6da801 100644
>> --- a/security/integrity/ima/ima_policy.c
>> +++ b/security/integrity/ima/ima_policy.c
>> @@ -17,6 +17,9 @@
>>  #include <linux/parser.h>
>>  #include <linux/slab.h>
>>  #include <linux/genhd.h>
>> +#ifdef CONFIG_IMA_POLICY_LOADER
>> +#include <linux/file.h>
>> +#endif
>>
>>  #include "ima.h"
>>
>> @@ -747,3 +750,74 @@ void ima_delete_rules(void)
>>  	}
>>  	mutex_unlock(&ima_rules_mutex);
>>  }
>> +
>> +#ifdef CONFIG_IMA_POLICY_LOADER
>> +
>> +ssize_t ima_read_policy(char *path)
>> +{
>> +	char *data, *datap, *sig;
>> +	int rc, psize, pathlen = strlen(path);
>> +	char *p, *sigpath;
>> +	struct {
>> +		struct ima_digest_data hdr;
>> +		char digest[IMA_MAX_DIGEST_SIZE];
>> +	} hash;
>> +
>> +	if (path[0] != '/')
>> +		return ima_parse_add_rule(path);
>> +
>> +	/* remove \n */
>> +	datap = path;
>> +	strsep(&datap, "\n");
>> +
>> +	/* we always want signature? */
>> +	sigpath = __getname();
>> +	if (!sigpath)
>> +		return -ENOMEM;
>> +
>> +	rc = integrity_read_file(path, &data);
>> +	if (rc < 0)
>> +		goto free_path;
>> +
>> +	psize = rc;
>> +	datap = data;
>> +
>> +	sprintf(sigpath, "%s.sig", path);
>> +	/* we always want signature? */
>> +	rc = integrity_read_file(sigpath, &sig);
>> +	if (rc < 0)
>> +		goto free_data;
>> +
>> +	hash.hdr.algo = ima_hash_algo;
>> +	ima_get_hash_algo((void *)sig, rc, &hash.hdr);
>> +	ima_calc_buffer_hash(data, psize, &hash.hdr);
>> +	rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>> +				     (const char *)sig, rc,
>> +				     hash.hdr.digest, hash.hdr.length);
>> +	if (rc) {
>> +		pr_err("integrity_digsig_verify() = %d\n", rc);
>> +		goto free_sig;
>> +	}
>> +
>> +	while (psize > 0 && (p = strsep(&datap, "\n"))) {
>> +		pr_debug("rule: %s\n", p);
>> +		rc = ima_parse_add_rule(p);
>> +		if (rc < 0)
>> +			break;
>> +		psize -= rc;
>> +	}
>> +free_sig:
>> +	kfree(sig);
>> +free_data:
>> +	kfree(data);
>> +free_path:
>> +	__putname(sigpath);
>> +	if (rc < 0)
>> +		return rc;
>> +	else if (psize)
>> +		return -EINVAL;
>> +	else
>> +		return pathlen;
>> +}
>> +
>> +#endif
>
>

