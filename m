Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934938AbaKNBBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 20:01:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933409AbaKNBBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 20:01:53 -0500
Date: Thu, 13 Nov 2014 20:01:45 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        eparis@parisplace.org, pmoore@redhat.com
Subject: Re: [PATCH] audit: convert status version to a feature bitmap
Message-ID: <20141114010145.GA5960@madcap2.tricolour.ca>
References: <a98e3f45dbffd086c872f249b650b405f5cb8d2c.1415909269.git.rgb@redhat.com>
 <1415911097.4223.13.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415911097.4223.13.camel@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/13, Joe Perches wrote:
> On Thu, 2014-11-13 at 15:29 -0500, Richard Guy Briggs wrote:
> > The version field defined in the audit status structure was found to have
> > limitations in terms of its expressibility of features supported.  This is
> > distict from the get/set features call to be able to command those features
> > that are present.
> > 
> > Converting this field from a version number to a feature bitmap will allow
> > distributions to selectively backport and support certain features and will
> > allow upstream to be able to deprecate features in the future.  It will allow
> > userspace clients to first query the kernel for which features are actually
> > present and supported.  Currently, EINVAL is returned rather than EOPNOTSUP,
> > which isn't helpful in determining if there was an error in the command, or if
> > it simply isn't supported yet.  Past features are not represented by this
> > bitmap, but their use may be converted to EOPNOTSUP if needed in the future.
> 
> Maybe use DECLARE_BITMAP instead of u32 and test_bit/set_bit

I don't think so.  I'd like to code to be readable...  I certainly don't
need the overhead of test/set_bit.  That doesn't look appropriate for
anything in include/uapi/.

> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> 
> > @@ -322,9 +322,15 @@ enum {
> >  #define AUDIT_STATUS_BACKLOG_LIMIT	0x0010
> >  #define AUDIT_STATUS_BACKLOG_WAIT_TIME	0x0020
> >  
> > -#define AUDIT_VERSION_BACKLOG_LIMIT	1
> > -#define AUDIT_VERSION_BACKLOG_WAIT_TIME	2
> > -#define AUDIT_VERSION_LATEST AUDIT_VERSION_BACKLOG_WAIT_TIME
> > +#define AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT	0x00000001
> > +#define AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME	0x00000002
> > +#define AUDIT_FEATURE_BITMAP (	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT     | \
> > +				AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME   )
> > +
> > +/* deprecated: AUDIT_VERSION_* */
> > +#define AUDIT_VERSION_LATEST 		AUDIT_FEATURE_BITMAP
> > +#define AUDIT_VERSION_BACKLOG_LIMIT	AUDIT_FEATURE_BITMAP_BACKLOG_LIMIT
> > +#define AUDIT_VERSION_BACKLOG_WAIT_TIME	AUDIT_FEATURE_BITMAP_BACKLOG_WAIT_TIME
> >  
> >  				/* Failure-to-log actions */
> >  #define AUDIT_FAIL_SILENT	0
> > @@ -403,7 +409,10 @@ struct audit_status {
> >  	__u32		backlog_limit;	/* waiting messages limit */
> >  	__u32		lost;		/* messages lost */
> >  	__u32		backlog;	/* messages waiting in queue */
> > -	__u32		version;	/* audit api version number */
> > +	union {
> > +		__u32	version;	/* deprecated: audit api version num */
> > +		__u32	feature_bitmap;	/* bitmap of kernel audit features */
> > +	};
> >  	__u32		backlog_wait_time;/* message queue wait timeout */
> >  };
> >  
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 8ee4508..c9d0e30 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -842,7 +842,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >  		s.backlog_limit		= audit_backlog_limit;
> >  		s.lost			= atomic_read(&audit_lost);
> >  		s.backlog		= skb_queue_len(&audit_skb_queue);
> > -		s.version		= AUDIT_VERSION_LATEST;
> > +		s.feature_bitmap	= AUDIT_FEATURE_BITMAP;
> >  		s.backlog_wait_time	= audit_backlog_wait_time;
> >  		audit_send_reply(skb, seq, AUDIT_GET, 0, 0, &s, sizeof(s));
> >  		break;

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
