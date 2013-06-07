Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab3FGSK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:10:28 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:64983 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756741Ab3FGSK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:10:26 -0400
X-TM-IMSS-Message-ID: <7f42f21c000036fb@nsa.gov>
Message-ID: <51B221F1.7090504@tycho.nsa.gov>
Date: Fri, 07 Jun 2013 14:09:53 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>
CC: James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2 1/2] SELinux: reduce overhead of mls_level_isvalid()
 function call
References: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1370466902-21144-1-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 05:15 PM, Waiman Long wrote:
> diff --git a/security/selinux/ss/ebitmap.c b/security/selinux/ss/ebitmap.c
> index 30f119b..100b3e6 100644
> --- a/security/selinux/ss/ebitmap.c
> +++ b/security/selinux/ss/ebitmap.c
> @@ -213,7 +213,12 @@ netlbl_import_failure:
>   }
>   #endif /* CONFIG_NETLABEL */
>
> -int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
> +/*
> + * Check to see if all the bits set in e2 are also set in e1. Optionally,
> + * if last_e2bit is non-zero, the highest set bit in e2 cannot exceed
> + * last_e2bit.
> + */
> +int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2, u32 last_e2bit)
>   {
>   	struct ebitmap_node *n1, *n2;
>   	int i;
> @@ -223,6 +228,33 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
>
>   	n1 = e1->node;
>   	n2 = e2->node;
> +	if (last_e2bit) {
> +		while (n1 && n2 && (n1->startbit <= n2->startbit)) {
> +			int lastsetbit = -1;
> +
> +			if (n1->startbit < n2->startbit) {
> +				n1 = n1->next;
> +				continue;
> +			}
> +			for (i = EBITMAP_UNIT_NUMS - 1; i >= 0; i--) {
> +				if (!n2->maps[i])
> +					continue;
> +				if ((n1->maps[i] & n2->maps[i]) != n2->maps[i])
> +					return 0;
> +				if (lastsetbit < 0)
> +					lastsetbit = n2->startbit +
> +						     i * EBITMAP_UNIT_SIZE +
> +						     __fls(n2->maps[i]);
> +			}
> +			if ((lastsetbit >= 0) && (lastsetbit > last_e2bit))
> +				return 0;
> +
> +			n1 = n1->next;
> +			n2 = n2->next;
> +		}
> +		goto done;
> +	}
> +

Can't you unify this logic with the nearly identical logic below?

>   	while (n1 && n2 && (n1->startbit <= n2->startbit)) {
>   		if (n1->startbit < n2->startbit) {
>   			n1 = n1->next;
> @@ -237,6 +269,7 @@ int ebitmap_contains(struct ebitmap *e1, struct ebitmap *e2)
>   		n2 = n2->next;
>   	}
>
> +done:
>   	if (n2)
>   		return 0;
>

