Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934580AbaKMWML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:12:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933765AbaKMWMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:12:09 -0500
From: Paul Moore <pmoore@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        eparis@parisplace.org
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Date: Thu, 13 Nov 2014 17:12:06 -0500
Message-ID: <1745832.tbkjBzSGxr@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.2 (Linux/3.16.7-gentoo; KDE/4.14.2; x86_64; ; )
In-Reply-To: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 13, 2014 03:29:10 PM Richard Guy Briggs wrote:
> The version field defined in the audit status structure was found to have
> limitations in terms of its expressibility of features supported.  This is
> distict from the get/set features call to be able to command those features
> that are present.
> 
> Converting this field from a version number to a feature bitmap will allow
> distributions to selectively backport and support certain features and will
> allow upstream to be able to deprecate features in the future.  It will
> allow userspace clients to first query the kernel for which features are
> actually present and supported.  Currently, EINVAL is returned rather than
> EOPNOTSUP, which isn't helpful in determining if there was an error in the
> command, or if it simply isn't supported yet.  Past features are not
> represented by this bitmap, but their use may be converted to EOPNOTSUP if
> needed in the future.
> 
> Since "version" is too generic to convert with a #define, use a union in the
> struct status, introducing the member "feature_bitmap" unionized with
> "version".
> 
> Convert existing AUDIT_VERSION_* macros over to AUDIT_FEATURE_BITMAP*
> counterparts, leaving the former for backwards compatibility.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/uapi/linux/audit.h |   17 +++++++++++++----
>  kernel/audit.c             |    2 +-
>  2 files changed, 14 insertions(+), 5 deletions(-)

Looks good for the most part, just a naming nit pick and a question about the 
deprecated AUDIT_VERSION_* defines; see below ...

> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index 4d100c8..74aa584 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -322,9 +322,15 @@ enum {
>  #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
>  #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
> 
> -#define AUDIT_VERSION_BACKLOG_LIMIT	1
> -#define AUDIT_VERSION_BACKLOG_WAIT_TIME	2
> -#define AUDIT_VERSION_LATEST AUDIT_VERSION_BACKLOG_WAIT_TIME
> +#define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
> +#define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
> +#define AUDIT_FEATURE_BITMAP ( AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT | \
> +				                AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME )

How about AUDIT_FEATURE_BIMAP_ALL instead of just AUDIT_FEATURE_BITMAP?

> +/* deprecated: AUDIT_VERSION_* */
> +#define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP
> +#define AUDIT_VERSION_BACKLOG_LIMIT	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT
> +#define AUDIT_VERSION_BACKLOG_WAIT_TIME
> ...                                AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME

So what terrible things happen to userspace if AUDIT_VERSION_BACKLOG_WAIT_TIME 
becomes 0x03 instead of 0x02?

-- 
paul moore
security and virtualization @ redhat

