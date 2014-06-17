Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153AbaFQOm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:42:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49136 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932870AbaFQOm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:42:56 -0400
Message-ID: <1403016160.27991.1.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 01/24] kobject: return actual error on
 kset_create_and_add
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: gregkh@linuxfoundation.org, Christoph Lameter <cl@gentwo.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        benh@kernel.crashing.org, paulus@samba.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, stefanr@s5r6.in-berlin.de, joro@8bytes.org,
        jejb@parisc-linux.org, deller@gmx.de, bhelgaas@google.com, clm@fb.com,
        Josef Bacik <jbacik@fb.com>, swhiteho@redhat.com, bharrosh@panasas.com,
        bhalevy@primarydata.com, ccaulfie@redhat.com, teigland@redhat.com,
        "Theodore Ts'o" <tytso@mit.edu>, adilger.kernel@dilger.ca,
        jaegeuk@kernel.org, cm224.lee@samsung.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        casey@schaufler-ca.com, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 17 Jun 2014 07:42:40 -0700
In-Reply-To: <53A04FF7.5050900@oracle.com>
References: <53A04FF7.5050900@oracle.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 22:25 +0800, Jeff Liu wrote:
> From: Jie Liu <jeff.liu@oracle.com>
> 
> It's better to return the actual error rather than NULL because
> kset_register() can failed due to other reasons.
> 
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: Benny Halevy <bhalevy@primarydata.com>
> Cc: Christine Caulfield <ccaulfie@redhat.com>
> Cc: David Teigland <teigland@redhat.com>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: Changman Lee <cm224.lee@samsung.com>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <jlbec@evilplan.org>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  lib/kobject.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 58751bb..538c617 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -919,11 +919,11 @@ struct kset *kset_create_and_add(const char *name,
>  
>  	kset = kset_create(name, uevent_ops, parent_kobj);
>  	if (!kset)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	error = kset_register(kset);
>  	if (error) {
>  		kfree(kset);
> -		return NULL;
> +		return ERR_PTR(error);
>  	}
>  	return kset;
>  }

This patch series isn't bisectable.  When changing an error signal from
NULL to non-NULL, you have to do it as one patch, otherwise if a
bisection lands in here we'll get error returns from all our kobject
kset code and the kernel won't boot.

It's fine if you're sending it out as 24 patches for review, but it has
to be applied as a single one.

James


