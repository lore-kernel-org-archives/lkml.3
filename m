Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047AbaKMUiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:38:22 -0500
Received: from smtprelay0211.hostedemail.com ([216.40.44.211]:57598 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932684AbaKMUiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:38:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2899:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6261:7903:8660:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740:13019:13095:13138:13148:13149:13230:13231:14096:14097:21063:21080:21094,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bells81_e54cebe94360
X-Filterd-Recvd-Size: 3928
Message-ID: <1415911097.4223.13.camel@perches.com>
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
From: Joe Perches <joe@perches.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        eparis@parisplace.org, pmoore@redhat.com
Date: Thu, 13 Nov 2014 12:38:17 -0800
In-Reply-To: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 15:29 -0500, Richard Guy Briggs wrote:
> The version field defined in the audit status structure was found to have
> limitations in terms of its expressibility of features supported.  This is
> distict from the get/set features call to be able to command those features
> that are present.
> 
> Converting this field from a version number to a feature bitmap will allow
> distributions to selectively backport and support certain features and will
> allow upstream to be able to deprecate features in the future.  It will allow
> userspace clients to first query the kernel for which features are actually
> present and supported.  Currently, EINVAL is returned rather than EOPNOTSUP,
> which isn't helpful in determining if there was an error in the command, or if
> it simply isn't supported yet.  Past features are not represented by this
> bitmap, but their use may be converted to EOPNOTSUP if needed in the future.

Maybe use DECLARE_BITMAP instead of u32 and test_bit/set_bit

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h

> @@ -322,9 +322,15 @@ enum {
>  #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
>  #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
>  
> -#define AUDIT_VERSION_BACKLOG_LIMIT	1
> -#define AUDIT_VERSION_BACKLOG_WAIT_TIME	2
> -#define AUDIT_VERSION_LATEST AUDIT_VERSION_BACKLOG_WAIT_TIME
> +#define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
> +#define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
> +#define AUDIT_FEATURE_BITMAP (	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT     | \
> +				AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME   )
> +
> +/* deprecated: AUDIT_VERSION_* */
> +#define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP
> +#define AUDIT_VERSION_BACKLOG_LIMIT	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT
> +#define AUDIT_VERSION_BACKLOG_WAIT_TIME	AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME
>  
>  				/* Failure-to-log actions */
>  #define AUDIT_FAIL_SILENT	0
> @@ -403,7 +409,10 @@ struct audit_status {
>  	__u32		backlog_limit;	/* waiting messages limit */
>  	__u32		lost;		/* messages lost */
>  	__u32		backlog;	/* messages waiting in queue */
> -	__u32		version;	/* audit api version number */
> +	union {
> +		__u32	version;	/* deprecated: audit api version num */
> +		__u32	feature_bitmap;	/* bitmap of kernel audit features */
> +	};
>  	__u32		backlog_wait_time;/* message queue wait timeout */
>  };
>  
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 8ee4508..c9d0e30 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -842,7 +842,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  		s.backlog_limit		= audit_backlog_limit;
>  		s.lost			= atomic_read(&audit_lost);
>  		s.backlog		= skb_queue_len(&audit_skb_queue);
> -		s.version		= AUDIT_VERSION_LATEST;
> +		s.feature_bitmap	= AUDIT_FEATURE_BITMAP;
>  		s.backlog_wait_time	= audit_backlog_wait_time;
>  		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
>  		break;



