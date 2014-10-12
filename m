Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbaJLSSt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:18:49 -0400
Received: from smtprelay0129.hostedemail.com ([216.40.44.129]:50170 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752545AbaJLSSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:18:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:7652:8603:10004:10400:10471:10848:11026:11232:11658:11914:12043:12438:12517:12519:12555:12740:13069:13161:13229:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bulb52_86862c181aa48
X-Filterd-Recvd-Size: 2341
Message-ID: <1413137923.22149.27.camel@joe-AO725>
Subject: Re: [PATCH] target: iscsi: iscsi_target_tpg.c:  Cleaning up
 possible size overwriting in conjunction with sprintf
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>,
        Thomas Glanzmann <thomas@glanzmann.de>,
        Christophe Vu-Brugier <cvubrugier@yahoo.fr>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 12 Oct 2014 11:18:43 -0700
In-Reply-To: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1413136558-20790-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-12 at 19:55 +0200, Rickard Strandqvist wrote:
> Changed same snprintf and sprintf to strlcpy and strlcat.
> This will guarantee that the string size is not overwritten,
> and they are significantly faster than sprintf also.

I don't disagree with the change, but I think the changelog is
misleading.

strlcpy(ptr, ...) then strlcat(ptr, ...) does not use the known
length of the first copied string and is generally not faster than
ptr += snprintf(ptr, ...) then sprintf(ptr,...)

And a couple slightly unrelated bits:

> diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
> index c3cb5c1..6fc8bfe 100644
> --- a/drivers/target/iscsi/iscsi_target_tpg.c
> +++ b/drivers/target/iscsi/iscsi_target_tpg.c
> @@ -608,7 +608,6 @@ int iscsit_tpg_set_initiator_node_queue_depth(
>  int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)

This function could be made static and the prototype removed from
the .h file if it is moved above its one caller in this file.

>  {
>  	unsigned char buf1[256], buf2[256], *none = NULL;

Moderately large stack use here.


