Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaA3BYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 20:24:35 -0500
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:58122 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751724AbaA3BYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 20:24:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:7652:7875:7903:8660:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12679:12740:13069:13148:13230:13311:13357,0,RBL:no
X-HE-Tag: wrist80_a581d58ab630
X-Filterd-Recvd-Size: 2797
Message-ID: <1391045068.2422.30.camel@joe-AO722>
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
From: Joe Perches <joe@perches.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Wed, 29 Jan 2014 17:24:28 -0800
In-Reply-To: <alpine.LRH.2.02.1401291956510.8304@file01.intranet.prod.int.rdu2.redhat.com>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
	 <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
	 <alpine.LRH.2.02.1401291956510.8304@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 19:58 -0500, Mikulas Patocka wrote:
> On Wed, 29 Jan 2014, Sebastian Capella wrote:
> > kstrimdup will duplicate and trim spaces from the passed in
> > null terminated string.  This is useful for strings coming from
> > sysfs that often include trailing whitespace due to user input. 
[]
> > diff --git a/mm/util.c b/mm/util.c
[]
> >  /**
> > + * kstrimdup - Trim and copy a %NUL terminated string.
> > + * @s: the string to trim and duplicate
> > + * @gfp: the GFP mask used in the kmalloc() call when allocating memory
> > + *
> > + * Returns an address, which the caller must kfree, containing
> > + * a duplicate of the passed string with leading and/or trailing
> > + * whitespace (as defined by isspace) removed.
> 
> It doesn't remove leading whitespace. To remove them, you need to do
> 
> char *p = strim(ret);
> memmove(ret, p, strlen(p) + 1);
[]
> > + */
> > +char *kstrimdup(const char *s, gfp_t gfp)
> > +{
> > +	char *ret = kstrdup(skip_spaces(s), gfp);
> > +
> > +	if (ret)
> > +		strim(ret);
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(kstrimdup);

Why not minimize the malloc length too?

maybe something like:

char *kstrimdup(const char *s, gfp_t gfp)
{
	char *buf;
	const char *begin = skip_spaces(s);
	size_t len = strlen(begin);

	while (len && isspace(begin[len - 1]))
		len--;

	buf = kmalloc_track_caller(len + 1, gfp);
	if (!buf)
		return NULL;

	memcpy(buf, begin, len);
	buf[len] = 0;

	return buf;
}


