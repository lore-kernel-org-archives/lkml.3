Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3KHBrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 20:47:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754473Ab3KHBrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 20:47:43 -0500
Date: Thu, 7 Nov 2013 20:49:48 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: Re: [PATCH linux-next] cifs: Use data structures to compute NTLMv2
 response offsets
Message-ID: <20131107204948.512b383e@corrin.poochiereds.net>
In-Reply-To: <1383867657-110399-1-git-send-email-tim.gardner@canonical.com>
References: <1383867657-110399-1-git-send-email-tim.gardner@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  7 Nov 2013 16:40:57 -0700
Tim Gardner <tim.gardner@canonical.com> wrote:

> A bit of cleanup plus some gratuitous variable renaming. I think using
> structures instead of numeric offsets makes this code much more
> understandable.
> 
> Also added a comment about current time range expected by
> the server.
> 
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Steve French <sfrench@samba.org>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> 
> The comment about time of day needing to be within 5 minutes is important (to me
> at least). I spent the best part of a week thinking I had endian issues on powerpc
> when in truth I was just too stupid to notice that the clock
> was not updated. Danged embedded platforms...
> 
> checkpatch has some problems with this patch regarding attribute packed, but I chose
> to remain consistent with existing code.
> 
> WARNING: __packed is preferred over __attribute__((packed))
> #141: FILE: fs/cifs/cifspdu.h:705:
> +	    } __attribute__((packed)) challenge;
> 
> WARNING: __packed is preferred over __attribute__((packed))
> #142: FILE: fs/cifs/cifspdu.h:706:
> +	} __attribute__((packed));
> 
> total: 0 errors, 2 warnings, 99 lines checked
> 
> Tested on cifs-2.6 for-linus (c481e9feee78c6ce1ba0a1c8c892049f6514f6cf) by mounting
> to iOS 10.8 and Win 8.0 Pro.
> 
> rtg
> 
>  fs/cifs/cifsencrypt.c |   40 ++++++++++++++++++++++++----------------
>  fs/cifs/cifspdu.h     |    8 +++++++-
>  2 files changed, 31 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index fc6f4f3..4934347 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -548,7 +548,13 @@ static int
>  CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>  {
>  	int rc;
> -	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
> +	struct ntlmv2_resp *ntlmv2 = (struct ntlmv2_resp *)
> +	    (ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +	unsigned int hash_len;
> +
> +	/* The MD5 hash starts at challenge_key.key */
> +	hash_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE +
> +		offsetof(struct ntlmv2_resp, challenge.key[0]));
>  
>  	if (!ses->server->secmech.sdeschmacmd5) {
>  		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
> @@ -556,7 +562,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>  	}
>  
>  	rc = crypto_shash_setkey(ses->server->secmech.hmacmd5,
> -				ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
> +				 ntlmv2_hash, CIFS_HMAC_MD5_HASH_SIZE);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not set NTLMV2 Hash as a key\n",
>  			 __func__);
> @@ -570,20 +576,21 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
>  	}
>  
>  	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
> -		memcpy(ses->auth_key.response + offset,
> -			ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
> +		memcpy(ntlmv2->challenge.key,
> +		       ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>  	else
> -		memcpy(ses->auth_key.response + offset,
> -			ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
> +		memcpy(ntlmv2->challenge.key,
> +		       ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
>  	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> -		ses->auth_key.response + offset, ses->auth_key.len - offset);
> +				 ntlmv2->challenge.key, hash_len);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
>  		return rc;
>  	}
>  
> +	/* Note that the MD5 digest over writes anon.challenge_key.key */
>  	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
> -		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> +				ntlmv2->ntlmv2_hash);
>  	if (rc)
>  		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
>  
> @@ -627,7 +634,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  	int rc;
>  	int baselen;
>  	unsigned int tilen;
> -	struct ntlmv2_resp *buf;
> +	struct ntlmv2_resp *ntlmv2;
>  	char ntlmv2_hash[16];
>  	unsigned char *tiblob = NULL; /* target info blob */
>  
> @@ -660,13 +667,14 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  	}
>  	ses->auth_key.len += baselen;
>  
> -	buf = (struct ntlmv2_resp *)
> +	ntlmv2 = (struct ntlmv2_resp *)
>  			(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> -	buf->blob_signature = cpu_to_le32(0x00000101);
> -	buf->reserved = 0;
> -	buf->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
> -	get_random_bytes(&buf->client_chal, sizeof(buf->client_chal));
> -	buf->reserved2 = 0;
> +	ntlmv2->blob_signature = cpu_to_le32(0x00000101);
> +	ntlmv2->reserved = 0;
> +	/* Must be within 5 minutes of the server */
> +	ntlmv2->time = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
> +	get_random_bytes(&ntlmv2->client_chal, sizeof(ntlmv2->client_chal));
> +	ntlmv2->reserved2 = 0;
>  
>  	memcpy(ses->auth_key.response + baselen, tiblob, tilen);
>  
> @@ -706,7 +714,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
>  	}
>  
>  	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
> -		ses->auth_key.response + CIFS_SESS_KEY_SIZE,
> +		ntlmv2->ntlmv2_hash,
>  		CIFS_HMAC_MD5_HASH_SIZE);
>  	if (rc) {
>  		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index 9e5ee34..33df36e 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -697,7 +697,13 @@ struct ntlmssp2_name {
>  } __attribute__((packed));
>  
>  struct ntlmv2_resp {
> -	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
> +	union {
> +	    char ntlmv2_hash[CIFS_ENCPWD_SIZE];
> +	    struct {
> +		__u8 reserved[8];
> +		__u8 key[CIFS_SERVER_CHALLENGE_SIZE];
> +	    } __attribute__((packed)) challenge;
> +	} __attribute__((packed));
>  	__le32 blob_signature;
>  	__u32  reserved;
>  	__le64  time;

(cc'ing Shirish since he wrote most of this code...)

Nice cleanup, I like it.

Acked-by: Jeff Layton <jlayton@redhat.com>
