Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaFRTg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:36:28 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:46872 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbaFRTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:36:27 -0400
From: Paul Moore <paul@paul-moore.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] selinux: simple cleanup for cond_read_node()
Date: Wed, 18 Jun 2014 15:36:22 -0400
Message-ID: <1719649.5PAcuqR8Pm@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.5-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1402762742-2808-1-git-send-email-namhyung@kernel.org>
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 15, 2014 01:19:01 AM Namhyung Kim wrote:
> The node->cur_state and len can be read in a single call of next_entry().
> And setting len before reading is a dead write so can be eliminated.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  security/selinux/ss/conditional.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/security/selinux/ss/conditional.c
> b/security/selinux/ss/conditional.c index 377d148e7157..4766a38fae9a 100644
> --- a/security/selinux/ss/conditional.c
> +++ b/security/selinux/ss/conditional.c
> @@ -402,19 +402,14 @@ static int cond_read_node(struct policydb *p, struct
> cond_node *node, void *fp) int rc;
>  	struct cond_expr *expr = NULL, *last = NULL;
> 
> -	rc = next_entry(buf, fp, sizeof(u32));
> +	rc = next_entry(buf, fp, sizeof(buf));

This is a bit nit-picky, but how about using "sizeof(u32) * 2"?  It is more 
consistent with the rest of the function and helps underscore that we are 
reading two 32-bit values.

Assuming you're okay with the change I can fix it up when I apply the patch.

>  	if (rc)
>  		return rc;
> 
>  	node->cur_state = le32_to_cpu(buf[0]);
> 
> -	len = 0;
> -	rc = next_entry(buf, fp, sizeof(u32));
> -	if (rc)
> -		return rc;
> -
>  	/* expr */
> -	len = le32_to_cpu(buf[0]);
> +	len = le32_to_cpu(buf[1]);
> 
>  	for (i = 0; i < len; i++) {
>  		rc = next_entry(buf, fp, sizeof(u32) * 2);

-- 
paul moore
www.paul-moore.com

