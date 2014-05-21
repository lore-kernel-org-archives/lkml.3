Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaEUJih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:38:37 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63218 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaEUJie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:38:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4d-537c7416b9f4
Message-id: <537C7420.3010303@samsung.com>
Date: Wed, 21 May 2014 18:38:40 +0900
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "J. R. Okajima" <hooanon05g@gmail.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] ima: audit log files opened with O_DIRECT flag
References: <1399926266.6471.25.camel@dhcp-9-2-203-236.watson.ibm.com>
 <1399937259.25932.1.camel@dhcp-9-2-203-236.watson.ibm.com>
 <30700.1399965547@jrobl>
 <1400533578.8244.9.camel@dhcp-9-2-203-236.watson.ibm.com>
In-reply-to: <1400533578.8244.9.camel@dhcp-9-2-203-236.watson.ibm.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Originating-IP: [106.210.244.194]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xq7piJTXBBo17OCzO97WyWVzeNYfN
	4kPPIzaL83+Ps1p8WjGJ2YHVY+esu+weDw5tZvH4vEnOY9OTt0wBLFFcNimpOZllqUX6dglc
	GbN7l7EV7NGr2PT5OFsD42nVLkZODgkBE4lXs0+wQdhiEhfurQeyuTiEBJYyStzffgrKaWSS
	WL38MitIlZDAHEaJ7adTQWxeAS2JQ5dvMoPYLAKqEju/LwWrYRPQk9jQ/IO9i5GDQ1QgQuLx
	BSGIckGJH5PvsYCERQSCJXq+MoGMZxaYzCixY9kbFpAaYQE3iccHdrNC7L3FKHHq3jNGkAQn
	UKJpYwvYpcwC6hKT5i1ihrDlJTavecsMcZuqRPfatVDfKEtcfrmdZQKj8Cwku2chaZ+FpH0B
	I/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCI+LKDcfExq0OMAhyMSjy8Alerg4VYE8uK
	K3MPMUpwMCuJ8H4vrAkW4k1JrKxKLcqPLyrNSS0+xMjEwSnVwBhnfrvRlFfN2az5+IuahWcv
	r1Kdcch++/c1ttfXrbd6W/P1vq1gru1KceGS15z+Z33OhKw5PfuYaFVDRFVquuBsL6aqqCss
	23r6ru1m3LST6XFj+P2QuC9TH6a15fV72DxfZXuiXuvk66JIafkv2pOuijHte3qkTVfRa3XN
	1FSVzzMNSk9tna/EUpyRaKjFXFScCADgDeDfZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/05/14 06:06, Mimi Zohar wrote:
> Files are measured or appraised based on the IMA policy.  When a
> file, in policy, is opened with the O_DIRECT flag, a deadlock
> occurs.
>
> The first attempt at resolving this lockdep temporarily removed the
> O_DIRECT flag and restored it, after calculating the hash.  The
> second attempt introduced the O_DIRECT_HAVELOCK flag. Based on this
> flag, do_blockdev_direct_IO() would skip taking the i_mutex a second
> time.  The third attempt, by Dmitry Kasatkin, resolves the i_mutex
> locking issue, by re-introducing the IMA mutex, but uncovered
> another problem.  Reading a file with O_DIRECT flag set, writes
> directly to userspace pages.  A second patch allocates a user-space
> like memory.  This works for all IMA hooks, except ima_file_free(),
> which is called on __fput() to recalculate the file hash.
>
> Until this last issue is addressed, do not 'collect' the
> measurement for measuring, appraising, or auditing files opened
> with the O_DIRECT flag set.  Based on policy, permit or deny file
> access.  This patch defines a new IMA policy rule option named
> 'permit_directio'.  Policy rules could be defined, based on LSM
> or other criteria, to permit specific applications to open files
> with the O_DIRECT flag set.
>
> Changelog v1:
> - permit or deny file access based IMA policy rules
>
> Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Acked-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

> ---
>  Documentation/ABI/testing/ima_policy |  2 +-
>  security/integrity/ima/ima_api.c     | 10 +++++++++-
>  security/integrity/ima/ima_main.c    |  5 ++++-
>  security/integrity/ima/ima_policy.c  |  6 +++++-
>  security/integrity/integrity.h       |  1 +
>  5 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
> index f1c5cc9..4c3efe4 100644
> --- a/Documentation/ABI/testing/ima_policy
> +++ b/Documentation/ABI/testing/ima_policy
> @@ -23,7 +23,7 @@ Description:
>  				 [fowner]]
>  			lsm:	[[subj_user=] [subj_role=] [subj_type=]
>  				 [obj_user=] [obj_role=] [obj_type=]]
> -			option:	[[appraise_type=]]
> +			option:	[[appraise_type=]] [permit_directio]
>  
>  		base: 	func:= [BPRM_CHECK][MMAP_CHECK][FILE_CHECK][MODULE_CHECK]
>  			mask:= [MAY_READ] [MAY_WRITE] [MAY_APPEND] [MAY_EXEC]
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index ba9e4d7..d719978 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -199,6 +199,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>  			    struct evm_ima_xattr_data **xattr_value,
>  			    int *xattr_len)
>  {
> +	const char *audit_cause = "failed";
>  	struct inode *inode = file_inode(file);
>  	const char *filename = file->f_dentry->d_name.name;
>  	int result = 0;
> @@ -213,6 +214,12 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>  	if (!(iint->flags & IMA_COLLECTED)) {
>  		u64 i_version = file_inode(file)->i_version;
>  
> +		if (file->f_flags & O_DIRECT) {
> +			audit_cause = "failed(directio)";
> +			result = -EACCES;
> +			goto out;
> +		}
> +	
>  		/* use default hash algorithm */
>  		hash.hdr.algo = ima_hash_algo;
>  
> @@ -233,9 +240,10 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>  				result = -ENOMEM;
>  		}
>  	}
> +out:
>  	if (result)
>  		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode,
> -				    filename, "collect_data", "failed",
> +				    filename, "collect_data", audit_cause,
>  				    result, 0);
>  	return result;
>  }
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 52ac6cf..27ab5df 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -214,8 +214,11 @@ static int process_measurement(struct file *file, const char *filename,
>  		xattr_ptr = &xattr_value;
>  
>  	rc = ima_collect_measurement(iint, file, xattr_ptr, &xattr_len);
> -	if (rc != 0)
> +	if (rc != 0) {
> +		if (file->f_flags & O_DIRECT)
> +		     rc = (iint->flags & IMA_PERMIT_DIRECTIO) ? 0 : -EACCES;
>  		goto out_digsig;
> +	}
>  
>  	pathname = filename ?: ima_d_path(&file->f_path, &pathbuf);
>  
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 93873a4..40a7488 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -353,7 +353,7 @@ enum {
>  	Opt_obj_user, Opt_obj_role, Opt_obj_type,
>  	Opt_subj_user, Opt_subj_role, Opt_subj_type,
>  	Opt_func, Opt_mask, Opt_fsmagic, Opt_uid, Opt_fowner,
> -	Opt_appraise_type, Opt_fsuuid
> +	Opt_appraise_type, Opt_fsuuid, Opt_permit_directio
>  };
>  
>  static match_table_t policy_tokens = {
> @@ -375,6 +375,7 @@ static match_table_t policy_tokens = {
>  	{Opt_uid, "uid=%s"},
>  	{Opt_fowner, "fowner=%s"},
>  	{Opt_appraise_type, "appraise_type=%s"},
> +	{Opt_permit_directio, "permit_directio"},
>  	{Opt_err, NULL}
>  };
>  
> @@ -622,6 +623,9 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  			else
>  				result = -EINVAL;
>  			break;
> +		case Opt_permit_directio:
> +			entry->flags |= IMA_PERMIT_DIRECTIO;
> +			break;
>  		case Opt_err:
>  			ima_log_string(ab, "UNKNOWN", p);
>  			result = -EINVAL;
> diff --git a/security/integrity/integrity.h b/security/integrity/integrity.h
> index 2fb5e53..33c0a70 100644
> --- a/security/integrity/integrity.h
> +++ b/security/integrity/integrity.h
> @@ -30,6 +30,7 @@
>  #define IMA_ACTION_FLAGS	0xff000000
>  #define IMA_DIGSIG		0x01000000
>  #define IMA_DIGSIG_REQUIRED	0x02000000
> +#define IMA_PERMIT_DIRECTIO	0x04000000
>  
>  #define IMA_DO_MASK		(IMA_MEASURE | IMA_APPRAISE | IMA_AUDIT | \
>  				 IMA_APPRAISE_SUBMASK)

