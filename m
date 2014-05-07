Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaEGRyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:54:50 -0400
Received: from smtprelay0236.hostedemail.com ([216.40.44.236]:60611 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751074AbaEGRyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:54:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3871:4321:5007:7652:7904:9010:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hall47_29db2e3bd7055
X-Filterd-Recvd-Size: 1945
Message-ID: <1399485286.2911.9.camel@joe-AO725>
Subject: Re: [PATCH 1/1] kernel/kprobes.c: convert printk to pr_foo()
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        akpm <akpm@linux-foundation.org>
Date: Wed, 07 May 2014 10:54:46 -0700
In-Reply-To: <20140506191205.49ca307736c06fa89c6b19cc@skynet.be>
References: <20140506191205.49ca307736c06fa89c6b19cc@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-06 at 19:12 +0200, Fabian Frederick wrote:

> diff --git a/kernel/kprobes.c b/kernel/kprobes.c
[]
> @@ -1385,7 +1387,7 @@ static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
>  	if (p != ap) {
>  		list_for_each_entry_rcu(list_p, &ap->list, list)
>  			if (list_p == p)
> -			/* kprobe p is a valid probe */
> +				/* kprobe p is a valid probe */
>  				goto valid;
>  		return NULL;
>  	}

Perhaps this would be more readable as:

	/* Make sure p is a valid probe */
	if (p != ap) {
		list_for_each_entry_rcu(list_p, &ap->list, list) {
			if (list_p == p)
				goto valid;
		}
		return NULL;
	}

or maybe the function could be written
without the goto. something like:

static struct kprobe *__get_valid_kprobe(struct kprobe *p)
{
	struct kprobe *ap, *list_p;

	ap = get_kprobe(p->addr);
	if (unlikely(!ap))
		return NULL;

	if (p == ap)
		return ap;

	/* Make sure p is a valid probe */
	list_for_each_entry_rcu(list_p, &ap->list, list) {
		if (list_p == p)
			return ap;
	}

	return NULL;
}


